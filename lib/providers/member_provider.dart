import 'package:firebase_app/models/member.dart';
import 'package:flutter/foundation.dart';

class MemberProvider extends ChangeNotifier {
  Member? _member;

  Member? get member => _member;
  set member(Member? val) {
    _member = val;
    notifyListeners();
  }
}
