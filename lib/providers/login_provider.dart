import 'package:firebase_app/home_screen.dart';
import 'package:firebase_app/models/member.dart';
import 'package:firebase_app/providers/member_provider.dart';
import 'package:firebase_app/providers/registration_provider.dart';
import 'package:firebase_app/services/registration_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/login_service.dart';

class LoginProvider extends ChangeNotifier {
  int currentIndex = -1;
  TextEditingController? currentPin;
  bool isLoginSuccess = true;
  bool isLoading = false;
  String errMessage = "";
  Member? member;

  setMember(Member member) {
    this.member = member;
    notifyListeners();
  }

  setValuePin(BuildContext context, String text,
      {List<TextEditingController>? controller}) {
    if (currentIndex < 5) {
      currentIndex += 1;
      currentPin = controller?[currentIndex];
      currentPin!.text = text;
    }
    notifyListeners();
    if (currentIndex == 5) {
      print('process execute');
      changeLoading();
      process(controller!, context);
    }
  }

  changeLoading() async {
    isLoading = true;
    notifyListeners();
  }

  process(List<TextEditingController> controllers, BuildContext context) async {
    final phone = await LoginService.getPhoneNumber();
    String pin = "";
    for (var item in controllers) {
      pin += item.text;
    }
    print("phone $phone");
    isLoginSuccess = phone != null;
    if (!isLoginSuccess) {
      errMessage = "You are not registered.";
    }
    if (isLoginSuccess) {
      final memberPin = await LoginService.getUserPin();
      print("pin $pin");
      print("memberPin $memberPin");
      isLoginSuccess = pin == memberPin;
      if (!isLoginSuccess) {
        errMessage = "You insert wrong pin.";
      }
    }

    await Future.delayed(const Duration(seconds: 2));
    isLoading = false;
    if (isLoginSuccess) {
      final dataMember = await RegistrationService.getUser(phone!);
      //MemberProvider().member = dataMember;
      member = dataMember;

      RegistrationProvider().getSms = false;
    }
    notifyListeners();
    failureLogin();
    if (isLoginSuccess) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()));
    }
  }

  logout() async {
    currentIndex = -1;
    currentPin = null;
    notifyListeners();
  }

  failureLogin() async {
    await Future.delayed(const Duration(seconds: 2));
    isLoginSuccess = true;
    notifyListeners();
  }

  clear() {
    currentIndex = -1;
    currentPin = null;
  }
}
