import 'dart:convert';

import 'package:ark/base/nav_key.dart';
import 'package:ark/bean/base/base_list_entity.dart';
import 'package:ark/bean/base/error_entity.dart';
import 'package:ark/common/api_constant.dart';
import 'package:ark/common/common.dart';
import 'package:ark/net/http_method.dart';
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
import '../bean/base/base_entity.dart';
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
      contentType: Headers.formUrlEncodedContentType,
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

  // 请求，返回参数为 T
  // method：请求方法，NWMethod.POST等
  // path：请求地址
  // params：请求参数
  // success：请求成功回调
  // error：请求失败回调
  Future request(HttpMethod method, String path,
      {dynamic params,
      Map<String, dynamic> queryParameters,
      bool isList = false,
      Function(Map<String, dynamic>) success,
      Function(List<dynamic>) successList,
      Function(ErrorEntity) error}) async {
    try {
      Response response = await _dio.request(path,
          data: params,
          queryParameters: queryParameters,
          options: Options(method: HttpMethodValues[method]));
      if (response != null) {
//        print('查看返回结果：${response.data}');
        Map<String, dynamic> jsonString = parseData(response.data.toString());
        int code = jsonString['code'];
        if (code == 0) {
          Map<String, dynamic> responseData = jsonString['data'];
          int status = responseData['status'];
          String message;
          try{
            message= responseData['message'];
          }catch (e){
            message= json.encode(responseData['message']);
          }

          switch (status) {

            /// 软登录
            case Constant.CODE_999:
            case Constant.CODE_998:
            case Constant.CODE_997:
              Toast.show(message);
//              _onSoftLogin(message);
              break;

            /// 强制登录 todo 有问题
            case Constant.CODE_995:
              NavigatorUtils.push(NavKey.navKey.currentContext, Routers.login);
              break;
            case Constant.CODE_SUCCESS:
              if (isList) {
                successList(responseData['resultObj']);
              } else {
                success(responseData['resultObj']);
              }
              break;
            default:
              Toast.show(message);
              break;
          }
        }
      } else {
        error(ErrorEntity(status: -1, message: "未知错误"));
      }
    } on DioError catch (e) {
      error(createErrorEntity(e));
    }
  }


  Future homeRequest(HttpMethod method, String path,BuildContext context,
      {dynamic params,
        Map<String, dynamic> queryParameters,
        bool isList = false,
        Function(Map<String, dynamic>) success,
        Function(List<dynamic>) successList,
        Function(ErrorEntity) error}) async {
    try {
      Response response = await _dio.request(path,
          data: params,
          queryParameters: queryParameters,
          options: Options(method: HttpMethodValues[method]));
      if (response != null) {
//        print('查看返回结果：${response.data}');
        Map<String, dynamic> json = parseData(response.data.toString());
        int code = json['code'];
        if (code == 0) {
          Map<String, dynamic> responseData = json['data'];
          int status = responseData['status'];
          String message = responseData['message'];
          switch (status) {

          /// 软登录
            case Constant.CODE_999:
            case Constant.CODE_998:
            case Constant.CODE_997:
              Toast.show(message);
              _onSoftLogin(message,context);
              break;

          /// 强制登录 todo 有问题
            case Constant.CODE_995:
              NavigatorUtils.push(NavKey.navKey.currentContext, Routers.login);
              break;
            case Constant.CODE_SUCCESS:
              if (isList) {
                successList(responseData['resultObj']);
              } else {
                success(responseData['resultObj']);
              }
              break;
            default:
              Toast.show(message);
              break;
          }
        }
      } else {
        error(ErrorEntity(status: -1, message: "未知错误"));
      }
    } on DioError catch (e) {
//      error(createErrorEntity(e));
      Toast.show(createErrorEntity(e).message);
    }
  }

  // 请求，返回参数为 List
  // method：请求方法，NWMethod.POST等
  // path：请求地址
  // params：请求参数
  // success：请求成功回调
  // error：请求失败回调
  Future requestList<T>(HttpMethod method, String path,
      {Map params,
      Function(List<T>) success,
      Function(ErrorEntity) error}) async {
    try {
      Response response = await _dio.request(path,
          queryParameters: params,
          options: Options(method: HttpMethodValues[method]));
      if (response != null) {
        BaseListEntity entity = BaseListEntity<T>.fromJson(response.data);
        if (entity.code == 0) {
          success(entity.data);
        } else {
          error(ErrorEntity(status: entity.code, message: entity.message));
        }
      } else {
        error(ErrorEntity(status: -1, message: "未知错误"));
      }
    } on DioError catch (e) {
      error(createErrorEntity(e));
    }
  }

  // 错误信息
  ErrorEntity createErrorEntity(DioError error) {
    switch (error.type) {
      case DioErrorType.CANCEL:
        {
          return ErrorEntity(status: -1, message: "请求取消");
        }
        break;
      case DioErrorType.CONNECT_TIMEOUT:
        {
          return ErrorEntity(status: -1, message: "连接超时");
        }
        break;
      case DioErrorType.SEND_TIMEOUT:
        {
          return ErrorEntity(status: -1, message: "请求超时");
        }
        break;
      case DioErrorType.RECEIVE_TIMEOUT:
        {
          return ErrorEntity(status: -1, message: "响应超时");
        }
        break;
      case DioErrorType.RESPONSE:
        {
          try {
            int errCode = error.response.statusCode;
            String errMsg = error.response.statusMessage;
            return ErrorEntity(status: errCode, message: errMsg);
          } on Exception catch (_) {
            return ErrorEntity(status: -1, message: "未知错误");
          }
        }
        break;
      default:
        {
          return ErrorEntity(status: -1, message: error.message);
        }
    }
  }

  // 数据返回格式统一，统一处理异常
  Future<T> _parseResponse<T>(String method, String url,
      {dynamic data,
      Map<String, dynamic> queryParameters,
      CancelToken cancelToken,
      Options options}) async {
    var response = await _dio.request(url,
        data: data,
        queryParameters: queryParameters,
        options: _checkOptions(method, options),
        cancelToken: cancelToken);
//    try {
//      /// 集成测试无法使用 isolate
//      Map<String, dynamic> _map = Constant.isTest
//          ? parseData(response.data.toString())
//          : await compute(parseData, response.data.toString());
//      return BaseEntity.fromJson(_map);
//      // return _map;
//    } catch (e) {
//      print(e);
//      return BaseEntity(ExceptionHandle.parse_error, '数据解析错误', null);
//    }
    print('返回结果：${json.decode(response.data)}');
    return json.decode(data);
  }

  Options _checkOptions(method, options) {
    if (options == null) {
      options = new Options();
    }
    options.method = method;
    return options;
  }

//  Future requestNetwork<T>(Method method, String url,
//      {Function(T t) onSuccess,
//      Function(List<T> list) onSuccessList,
//      Function(int code, String msg) onError,
//      dynamic params,
//      Map<String, dynamic> queryParameters,
//      CancelToken cancelToken,
//      Options options,
//      bool isList: false}) {
//    String m = _getRequestMethod(method);
//    return _request<T>(m, url,
//            data: params,
//            queryParameters: queryParameters,
//            options: options,
//            cancelToken: cancelToken)
//        .then((BaseEntity<T> result) {
//      if (result.status == 0) {
//        if (isList) {
//          if (onSuccessList != null) {
//            onSuccessList(result.listData);
//          }
//        } else {
//          if (onSuccess != null) {
//            onSuccess(result.resultObj);
//          }
//        }
//      } else {
//        _onError(result.status, result.message, onError);
//      }
//    }, onError: (e, _) {
//      _cancelLogPrint(e, url);
//      NetError error = ExceptionHandle.handleException(e);
//      _onError(error.code, error.msg, onError);
//    });
//  }

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

    Observable.fromFuture(_parseResponse<T>(m, url,
            data: params,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken))
        .asBroadcastStream()
        .listen((result) {
      print('秦晓鹏=========>${result}');
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

  Widget _onSoftLogin(String msg, BuildContext context) {
    print('软登录 失败回调');
    showDialog(context: context,
    builder: (context){
      return AlertDialog(
        content: Text(msg),
        actions: <Widget>[
          FlatButton(
            child: Text('取消'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('确定'),
            onPressed: () {
              Navigator.of(context).pop(true);
              NavigatorUtils.push(context, Routers.login);
            },
          )
        ],
      );
    });
  }
}

Map<String, dynamic> parseData(String data) {
  return json.decode(data);
}

enum Method { get, post, put, patch, delete, head }
