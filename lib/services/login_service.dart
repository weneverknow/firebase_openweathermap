import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  static late SharedPreferences _preferences;

  static Future initSharedPreferences() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<String?> getPhoneNumber() async {
    //_preferences = await initSharedPreferences();
    await initSharedPreferences();
    String? phone = _preferences.getString('phone-user');
    return phone;
  }

  static Future<String?> getUserPin() async {
    //_preferences = await initSharedPreferences();
    await initSharedPreferences();
    String? phone = _preferences.getString('pin-user');
    return phone;
  }

  static Future saveMember({String? phone, String? pin}) async {
    await initSharedPreferences();
    if (phone != null) {
      _preferences.setString("phone-user", phone);
    }
    if (pin != null) {
      _preferences.setString("pin-user", pin);
    }
    return true;
  }

  static Future removePin() async {
    await initSharedPreferences();
    _preferences.remove("pin-user");
  }
}
