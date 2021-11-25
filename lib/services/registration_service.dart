import 'dart:io';

import 'package:firebase_app/models/member.dart';
import 'package:firebase_app/providers/login_provider.dart';
import 'package:firebase_app/providers/member_provider.dart';
import 'package:firebase_app/providers/registration_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class RegistrationService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future sendPhoneNumber(String phone,
      {required Function(PhoneAuthCredential) verificationCompleted,
      required Function(FirebaseAuthException) verificationFailed,
      required Function(String, int?) codeSent,
      required Function(String) codeAutoRetrievalTimeout}) async {
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: "+62$phone",
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<Member?> signInWithPhoneNumber(
      {required String phone,
      required String smsCode,
      required String verificationId}) async {
    Member? member;
    try {
      AuthCredential authCredential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      UserCredential userCredential =
          await _auth.signInWithCredential(authCredential);
      User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        member = Member(
          phone: phone,
          verificationId: verificationId,
          pin: smsCode,
          firebaseUserId: firebaseUser.uid,
        );
        await saveMember(member); //save to firestore
//        LoginProvider().member = member; //save member to provider/state
        LoginService.saveMember(phone: phone, pin: smsCode); //save cache
        final anyData = await getUser(phone);
        if (anyData != null) {
          member =
              member.copyWith(imageUrl: anyData.imageUrl, name: anyData.name);
        }
      }

      return member;
    } catch (e) {
      throw "error: " + e.toString();
    }
  }

  static Future saveMember(Member member) async {
    try {
      CollectionReference collection = firestore.collection('member');
      final existingUser = await getUser(member.phone);
      if (existingUser == null) {
        await collection
            .add({
              'firebaseUserId': member.firebaseUserId,
              'phone': member.phone,
              'pin': member.pin,
              'verificationId': member.verificationId,
              'name': member.name,
              'imageUrl': member.imageUrl
            })
            .then((value) => print('member added'))
            .catchError((error) => print('error $error'));
      } else {
        await collection
            .doc(existingUser.id)
            .set({
              'pin': member.pin,
            }, SetOptions(merge: true))
            .then((value) => print("member updated"))
            .catchError((error) => print("error $error"));
      }
    } catch (e) {
      throw 'Error: $e';
    }
  }

  static Future<bool> updatePin(String phone, String pin) async {
    try {
      CollectionReference _collection = firestore.collection('member');
      final existingUser = await getUser(phone);
      bool isSuccess = false;
      if (existingUser != null) {
        await _collection
            .doc(existingUser.id)
            .set({'pin': pin}, SetOptions(merge: true)).then((value) {
          isSuccess = true;
          LoginService.saveMember(pin: pin);
        });
      }
      return isSuccess;
    } catch (e) {
      throw 'Error $e';
    }
  }

  static Future<bool> updateMemberName(String phone, String name) async {
    try {
      CollectionReference _collection = firestore.collection('member');
      final existingUser = await getUser(phone);
      bool isSuccess = false;
      if (existingUser != null) {
        await _collection
            .doc(existingUser.id)
            .set({'name': name}, SetOptions(merge: true))
            .then((value) => isSuccess = true)
            .catchError((error) => isSuccess = false);
      }
      return isSuccess;
    } catch (e) {
      throw 'Error: $e';
    }
  }

  static Future<Member?> getUser(String phone) async {
    try {
      CollectionReference _collection = firestore.collection('member');
      QuerySnapshot? querySnapshot =
          await _collection.where('phone', isEqualTo: phone).get();
      //print(querySnapshot.docs.map((item) => null))
      //return Member.fromMap();
      if (querySnapshot.size == 0) return null;
      return Member(
          id: querySnapshot.docs[0].id,
          phone: querySnapshot.docs[0]['phone'],
          verificationId: querySnapshot.docs[0]['verificationId'],
          pin: querySnapshot.docs[0]['pin'],
          name: querySnapshot.docs[0]['name'],
          firebaseUserId: querySnapshot.docs[0]['firebaseUserId'],
          imageUrl: querySnapshot.docs[0]['imageUrl']);
    } catch (e) {
      throw 'Error: $e';
    }
  }

  static firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  static Future<String?> uploadImage(String filePath,
      {required String name, required String phone}) async {
    try {
      File file = File(filePath);
      bool isSuccess = false;
      String? imageUrl;
      await storage.ref('uploads/$name').putFile(file).then((p0) async {
        imageUrl = await p0.ref.getDownloadURL();
        await updateMemberImage(phone, imageUrl!);
        isSuccess = true;
      }).catchError((error) => isSuccess = false);
      return imageUrl;
    } on firebase_storage.FirebaseException catch (e) {
      throw 'Error $e';
    }
  }

  static Future<void> updateMemberImage(String phone, String image) async {
    try {
      CollectionReference _collection = firestore.collection('member');
      final existingUser = await getUser(phone);
      bool isSuccess = false;
      if (existingUser != null) {
        await _collection
            .doc(existingUser.id)
            .set({'imageUrl': image}, SetOptions(merge: true));
      }
    } catch (e) {
      throw 'Error: $e';
    }
  }

  // static Future logout() async {
  //   await _auth.signOut();
  //   LoginService.removePin();
  // }
}
