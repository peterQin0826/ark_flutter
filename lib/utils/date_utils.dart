
import 'package:common_utils/common_utils.dart';

class DateUtils{

  static String formatDateMsByMS(int milliseconds){
    return DateUtil.formatDateMs(milliseconds, format: 'mm:ss');
  }

  static String formatDateMsByYMD(int milliseconds){
    return DateUtil.formatDateMs(milliseconds, format: 'yyyy/MM/dd');
  }

  static String formatDateMsByYMDHM(int milliseconds){
    return DateUtil.formatDateMs(milliseconds*1000, format: 'yyyy/MM/dd HH:mm');
  }


}