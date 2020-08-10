import 'package:flutter/cupertino.dart';

class BaseModel with ChangeNotifier {
  bool isLoading = false;

  void loading(bool loading) {
    this.isLoading = loading;
    notifyListeners();
  }
}
