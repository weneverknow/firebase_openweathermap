import 'package:firebase_app/models/member.dart';
import 'package:flutter/foundation.dart';

class RegistrationProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _getSms = false;
  String _verificationId = "";
  String _token = "";
  Member? _member;
  String? _imageUrl;

  Member? get member => _member;
  String get token => _token;
  String get verificationId => _verificationId;
  bool get getSms => _getSms;
  bool get isLoading => _isLoading;
  set member(Member? member) {
    _member = member;
    notifyListeners();
  }

  set token(String val) {
    _token = val;
    notifyListeners();
  }

  set verificationId(String val) {
    _verificationId = val;
    notifyListeners();
  }

  set getSms(bool val) {
    _getSms = val;
    notifyListeners();
  }

  set isLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }
}
