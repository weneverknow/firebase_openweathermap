import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class ProfileProvider extends ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController pinController1 = TextEditingController();
  TextEditingController pinController2 = TextEditingController();

  bool isLoading = false;

  changeLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  setNameController(String val) {
    nameController.text = val;
    notifyListeners();
  }
}
