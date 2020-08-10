import 'package:ark/common/api_constant.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'log_utils.dart';

class ImageUtils {
  static ImageProvider getAssetImage(String name, {String format: 'png'}) {
    return AssetImage(getImgPath(name, format: format));
  }

  static String getImgPath(String name, {String format: 'png'}) {
    return 'assets/images/$name.$format';
  }

  static ImageProvider getImageProvider(String imageUrl,
      {String holderImg: 'none'}) {
    if (TextUtil.isEmpty(imageUrl)) {
      return AssetImage(getImgPath(holderImg));
    }
    return CachedNetworkImageProvider(imageUrl,
        errorListener: () => Log.e("图片加载失败！"));
  }

  /// 获取网络图片地址
  static String getImgUrl(String url) {
    if (!TextUtil.isEmpty(url)) {
      if (!(url.contains("<") && url.contains(">"))) {
        return url;
      } else {
        List<String> str = url.split(">");
        String id = str[1];
        return ApiConstant.IMAGE_URL + id;
      }
    }
    return "";
  }

  static String getFileResource(String name){
    if (name.contains("docx") || name.contains("doc") || name.contains("wps")) {
      return 'file_doc';
    } else if (name.contains("pdf")) {
      return 'file_pdf';
    } else if (name.contains("ppt") || name.contains("pptx")) {
      return 'file_ppt';
    } else if (name.contains("xls") || name.contains("xlsx")) {
      return 'file_excel';
    } else if (name.contains("txt") || name.contains("csv")) {
      return 'file_txt';
    } else if (name.contains("jpg") || name.contains("bmp") || name.contains("gif")
        || name.contains("jpe") || name.contains("jpeg")) {
      return 'file_img';
    } else if (name.contains("mp3") || name.contains("wma") || name.contains("wav")) {
      return 'file_music';
    } else if (name.contains("rm") || name.contains("rmvb") || name.contains("mp4")
        || name.contains("flash") || name.contains("avi")) {
      return 'file_video';
    } else if (name.contains("rar") || name.contains("zip")) {
      return 'file_zip';
    } else if (name.contains("dwg") || name.contains("dxf") || name.contains("dwt")) {
      return 'file_cad';
    } else if (name.contains("shp") || name.contains("shx") || name.contains("dbf") || name.contains("tiff")) {
      return 'file_gis';
    } else if (name.contains("htm") || name.contains("html") || name.contains("chm") || name.contains("asp")) {
      return 'file_html';
    } else if (name.contains("orc")) {
      return 'file_orc';
    } else {
      return 'file_unknow';
    }
  }
}
