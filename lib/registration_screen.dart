import 'package:firebase_app/home_screen.dart';
import 'package:firebase_app/providers/registration_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/login_provider.dart';
import 'services/registration_service.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sms_autofill/sms_autofill.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SmsAutoFill().listenForCode();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: Consumer<RegistrationProvider>(
              builder: (context, provider, _) => provider.getSms
                  ? buildPinScreen(size)
                  : buildPhoneScreen(size))),
    );
  }

  Widget buildPinScreen(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeader(
            size, 'Please enter the 6 digits verification\ncode we sent to you',
            title: 'VERIFICATION'),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: PinFieldAutoFill(
            autoFocus: true,
            controller: pinController,
            keyboardType: TextInputType.number,
            codeLength: 6,
            textInputAction: TextInputAction.next,
            decoration: const BoxLooseDecoration(
              strokeColorBuilder: FixedColorBuilder(Colors.white54),
              radius: Radius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 30),
        Center(
          child: Consumer<RegistrationProvider>(
            builder: (context, provider, _) => provider.isLoading
                ? CircularProgressIndicator(
                    strokeWidth: 0.6, color: Colors.red.shade400)
                : Container(
                    width: size.width,
                    height: 60,
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white12,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        onPressed: () async {
                          if (pinController.text.isEmpty &&
                              pinController.text.length < 6) {
                            return;
                          }
                          provider.isLoading = true;
                          final member =
                              await RegistrationService.signInWithPhoneNumber(
                                  phone: phoneController.text,
                                  smsCode: pinController.text,
                                  verificationId: provider.verificationId);
                          provider.isLoading = false;
                          provider.getSms = false;
                          if (member != null) {
                            provider.member = member;
                            //LoginProvider().member = member;
                            //login success
                            //print("login success");
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (_) => const HomeScreen()));
                          } else {
                            print("login failed");
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Registrasi gagal')));
                          }
                        },
                        child: const Text('LOGIN')),
                  ),
          ),
        )
      ],
    );
  }

  Widget buildHeader(Size size, String text, {String? title}) {
    return SizedBox(
      height: size.height * 0.25,
      child: Column(
        children: [
          const SizedBox(height: 30),
          Center(
            child: Text(title ?? 'LOGIN',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          ),
          SizedBox(height: size.height * 0.06),
          Text(text,
              style: const TextStyle(
                  color: Colors.white54,
                  fontWeight: FontWeight.w300,
                  fontSize: 12),
              textAlign: TextAlign.center)
        ],
      ),
    );
  }

  Widget buildPhoneScreen(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      //mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildHeader(size,
            'Please enter your phone number\nto receive verification code to log in\nand use this apps.'),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text('Your phone number'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white54, width: 0.8)),
                alignment: Alignment.center,
                child: const Text(
                  '+62',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Flexible(
                child: SizedBox(
                  height: 50,
                  child: TextField(
                    autofocus: true,
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Colors.white54, width: 0.8)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Colors.white54, width: 0.8)),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 30),
        Center(
          child: Consumer<RegistrationProvider>(
              builder: (context, provider, _) => provider.isLoading
                  ? CircularProgressIndicator(
                      color: Colors.red.shade400,
                    )
                  : Container(
                      width: size.width,
                      height: 60,
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white12,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        onPressed: () async {
                          if (phoneController.text.isEmpty) {
                            return;
                          }
                          provider.isLoading = true;
                          final phone = (int.tryParse(phoneController.text))
                              .toString()
                              .trim();
                          await RegistrationService.sendPhoneNumber(phone,
                              verificationCompleted: (phoneCredential) {
                            print('phoneVerificationCompleted');
                          }, verificationFailed: (authException) {
                            print("error");
                            print(authException.code);
                            print(authException.message);
                            provider.isLoading = false;
                            provider.getSms = false;
                            provider.token = "";
                          }, codeSent: (verificationId, token) {
                            print("verification id $verificationId");
                            print("token $token");
                            provider.isLoading = false;
                            provider.getSms = true;
                            provider.verificationId = verificationId;
                            provider.token = token.toString();
                          }, codeAutoRetrievalTimeout: (verificationId) {
                            print("verification id $verificationId");
                            provider.isLoading = false;
                            provider.getSms = false;
                            provider.verificationId = verificationId;
                            provider.token = "";
                          });
                        },
                        label: const Text('CONFIRM'),
                        icon: const Icon(Icons.person_rounded),
                      ),
                    )
              // InkWell(
              //     borderRadius: BorderRadius.circular(30),
              //     splashColor: Colors.red,
              //     onTap: () async {
              //       if (phoneController.text.isEmpty) {
              //         return;
              //       }
              //       provider.isLoading = true;
              //       final phone = (int.tryParse(phoneController.text))
              //           .toString()
              //           .trim();
              //       await RegistrationService.sendPhoneNumber(phone,
              //           verificationCompleted: (phoneCredential) {
              //         print('phoneVerificationCompleted');
              //       }, verificationFailed: (authException) {
              //         print("error");
              //         print(authException.code);
              //         print(authException.message);
              //         provider.isLoading = false;
              //         provider.getSms = false;
              //         provider.token = "";
              //       }, codeSent: (verificationId, token) {
              //         print("verification id $verificationId");
              //         print("token $token");
              //         provider.isLoading = false;
              //         provider.getSms = true;
              //         provider.verificationId = verificationId;
              //         provider.token = token.toString();
              //       }, codeAutoRetrievalTimeout: (verificationId) {
              //         print("verification id $verificationId");
              //         provider.isLoading = false;
              //         provider.getSms = false;
              //         provider.verificationId = verificationId;
              //         provider.token = "";
              //       });
              //       //await Future.delayed(const Duration(seconds: 2));
              //     },
              //     child: Container(
              //       width: 60,
              //       height: 60,
              //       decoration: BoxDecoration(
              //           shape: BoxShape.circle,
              //           border: Border.all(
              //               color: Colors.red.shade400, width: 0.6)),
              //       child: Icon(
              //         Icons.chevron_right_rounded,
              //         size: 36,
              //         color: Colors.red.shade400,
              //       ),
              //     ),
              //   ),
              ),
        )
      ],
    );
  }
}
