import 'dart:convert';

import 'package:ark/base/nav_key.dart';
import 'package:ark/common/api_constant.dart';
import 'package:ark/common/common.dart';
import 'package:ark/routers/fluro_navigator.dart';
import 'package:ark/routers/routers.dart';
import 'package:ark/utils/log_utils.dart';
import 'package:ark/utils/toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:rxdart/rxdart.dart';
import 'base_entity.dart';
import 'error_handle.dart';
import 'intercept.dart';

class DioUtils {
  static final DioUtils _singleton = DioUtils._internal();

  static DioUtils get instance => DioUtils();

  factory DioUtils() {
    return _singleton;
  }

  static Dio _dio;

  Dio getDio() {
    return _dio;
  }

  DioUtils._internal() {
    var options = BaseOptions(
      connectTimeout: 15000,
      receiveTimeout: 15000,
      responseType: ResponseType.plain,
      validateStatus: (status) {
        // 不使用http状态码判断状态，使用AdapterInterceptor来处理（适用于标准REST风格）
        return true;
      },
      baseUrl: ApiConstant.HOST,
    );
    _dio = Dio(options);

    /// 统一添加身份验证请求头
    _dio.interceptors.add(AuthInterceptor());
//    /// 刷新Token
//    _dio.interceptors.add(TokenInterceptor());
    /// 打印Log(生产模式去除)
    if (!Constant.inProduction) {
      _dio.interceptors.add(LoggingInterceptor());
    }

    /// 适配数据(根据自己的数据结构，可自行选择添加)
    _dio.interceptors.add(AdapterInterceptor());
  }

  // 数据返回格式统一，统一处理异常
  Future<BaseEntity<T>> _request<T>(String method, String url,
      {dynamic data,
      Map<String, dynamic> queryParameters,
      CancelToken cancelToken,
      Options options}) async {
    var response = await _dio.request(url,
        data: data,
        queryParameters: queryParameters,
        options: _checkOptions(method, options),
        cancelToken: cancelToken);
    try {
      /// 集成测试无法使用 isolate
      Map<String, dynamic> _map = Constant.isTest
          ? parseData(response.data.toString())
          : await compute(parseData, response.data.toString());
      return BaseEntity.fromJson(_map);
      // return _map;
    } catch (e) {
      print(e);
      return BaseEntity(ExceptionHandle.parse_error, '数据解析错误', null);
    }
  }

  Options _checkOptions(method, options) {
    if (options == null) {
      options = new Options();
    }
    options.method = method;
    return options;
  }

  Future requestNetwork<T>(Method method, String url,
      {Function(T t) onSuccess,
      Function(List<T> list) onSuccessList,
      Function(int code, String msg) onError,
      dynamic params,
      Map<String, dynamic> queryParameters,
      CancelToken cancelToken,
      Options options,
      bool isList: false}) {
    String m = _getRequestMethod(method);
    return _request<T>(m, url,
            data: params,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken)
        .then((BaseEntity<T> result) {
      if (result.status == 0) {
        if (isList) {
          if (onSuccessList != null) {
            onSuccessList(result.listData);
          }
        } else {
          if (onSuccess != null) {
            onSuccess(result.resultObj);
          }
        }
      } else {
        _onError(result.status, result.message, onError);
      }
    }, onError: (e, _) {
      _cancelLogPrint(e, url);
      NetError error = ExceptionHandle.handleException(e);
      _onError(error.code, error.msg, onError);
    });
  }

  /// 统一处理(onSuccess返回T对象，onSuccessList返回List<T>)
  asyncRequestNetwork<T>(Method method, String url,
      {Function(T t) onSuccess,
      Function(List<T> list) onSuccessList,
      Function(int code, String msg) onError,
      dynamic params,
      Map<String, dynamic> queryParameters,
      CancelToken cancelToken,
      Options options,
      bool isList: false}) {
    String m = _getRequestMethod(method);
    Observable.fromFuture(_request<T>(m,  url,
            data: params,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken))
        .asBroadcastStream()
        .listen((result) {
      switch (result.status) {

        /// 软登录
        case Constant.CODE_999:
        case Constant.CODE_998:
        case Constant.CODE_997:
          _onSoftLogin(result.message);
          break;

        /// 强制登录 todo 有问题
        case Constant.CODE_995:
          NavigatorUtils.push(NavKey.navKey.currentContext, Routers.login);
          break;
        case Constant.CODE_SUCCESS:
          if (isList) {
            if (onSuccessList != null) {
              onSuccessList(result.listData);
            }
          } else {
            if (onSuccess != null) {
              onSuccess(result.resultObj);
            }
          }
          break;
        default:
          _onError(result.status, result.message, onError);
          _onSoftLogin('失败回调');
//          NavigatorUtils.push(NavKey.navKey.currentContext, Routers.login);
          break;
      }
    }, onError: (e) {
      _cancelLogPrint(e, url);
      NetError error = ExceptionHandle.handleException(e);
      _onError(error.code, error.msg, onError);
    });
  }

  _cancelLogPrint(dynamic e, String url) {
    if (e is DioError && CancelToken.isCancel(e)) {
      Log.e('取消请求接口： $url');
    }
  }

  _onError(int code, String msg, Function(int code, String mag) onError) {
    if (code == null) {
      code = ExceptionHandle.unknown_error;
      msg = '未知异常';
    }
    Log.e('接口请求异常： code: $code, mag: $msg');
    Toast.show('msg: $msg');
    if (onError != null) {
      onError(code, msg);
    }
  }

  String _getRequestMethod(Method method) {
    String m;
    switch (method) {
      case Method.get:
        m = 'GET';
        break;
      case Method.post:
        m = 'POST';
        break;
      case Method.put:
        m = 'PUT';
        break;
      case Method.patch:
        m = 'PATCH';
        break;
      case Method.delete:
        m = 'DELETE';
        break;
      case Method.head:
        m = 'HEAD';
        break;
    }
    return m;
  }

  Widget _onSoftLogin(String msg) {
    print('软登录 失败回调');
    return AlertDialog(
      title: Text("提示"),
      content: Text(msg),
      actions: <Widget>[
        FlatButton(
          child: Text('取消'),
          onPressed: () {
            Navigator.of(NavKey.navKey.currentContext).pop();
          },
        ),
        FlatButton(
          child: Text('确定'),
          onPressed: () {
            NavigatorUtils.push(NavKey.navKey.currentContext, Routers.login);
            Navigator.of(NavKey.navKey.currentContext).pop(true);
          },
        )
      ],
    );
  }
}

Map<String, dynamic> parseData(String data) {
  return json.decode(data);
}

enum Method { get, post, put, patch, delete, head }
