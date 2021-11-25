import 'package:firebase_app/providers/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _pin1 = TextEditingController();
  final _pin2 = TextEditingController();
  final _pin3 = TextEditingController();
  final _pin4 = TextEditingController();
  final _pin5 = TextEditingController();
  final _pin6 = TextEditingController();

  late List<TextEditingController> pins;
  int currentIndex = -1;
  late TextEditingController currentPin;

  @override
  void initState() {
    super.initState();
    pins = [_pin1, _pin2, _pin3, _pin4, _pin5, _pin6];
    currentPin = _pin1;
  }

  setValuePin(String text) {
    if (currentIndex < 5) {
      currentIndex += 1;
      currentPin = pins[currentIndex];
      currentPin.text = text;
    }

    setState(() {});
    if (currentIndex == 5) {
      process();
    }
  }

  process() {
    print("pin1 ${_pin1.text}");
    print("pin2 ${_pin2.text}");
    print("pin3 ${_pin3.text}");
    print("pin4 ${_pin4.text}");
  }

  clear() {
    _pin1.clear();
    _pin2.clear();
    _pin3.clear();
    _pin4.clear();
    _pin5.clear();
    _pin6.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Consumer<LoginProvider>(
            builder: (context, provider, _) => SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: provider.isLoading
                    ? Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: CircularProgressIndicator(
                            color: Colors.red.shade300, strokeWidth: 1),
                      )
                    : provider.isLoginSuccess
                        ? const SizedBox.shrink()
                        : AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            margin: const EdgeInsets.only(top: 30),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.red.shade300, width: 0.4),
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(provider.errMessage),
                          ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.1),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text(
                  'don\'t have an account?',
                  style: TextStyle(fontSize: 12),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (_) => const RegistrationScreen()));
                    },
                    child: const Text('Register'))
              ]),
            ),
          ),
          SizedBox.expand(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Insert Your Pin',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                Consumer<LoginProvider>(
                  builder: (context, provider, _) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildPinCard(controller: _pin1),
                      buildPinCard(controller: _pin2),
                      buildPinCard(controller: _pin3),
                      buildPinCard(controller: _pin4),
                      buildPinCard(controller: _pin5),
                      buildPinCard(controller: _pin6)
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      Consumer<LoginProvider>(
                        builder: (context, provider, _) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildNumberCard('1', onTap: () {
                              //setValuePin('1');
                              provider.setValuePin(context, '1',
                                  controller: pins);
                            }),
                            buildNumberCard('2', onTap: () {
                              //setValuePin('2');
                              provider.setValuePin(context, '2',
                                  controller: pins);
                            }),
                            buildNumberCard('3', onTap: () {
                              //setValuePin('3');
                              provider.setValuePin(context, '3',
                                  controller: pins);
                            })
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Consumer<LoginProvider>(
                        builder: (context, provider, _) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildNumberCard('4', onTap: () {
                              //setValuePin('4');
                              provider.setValuePin(context, '4',
                                  controller: pins);
                            }),
                            buildNumberCard('5', onTap: () {
                              //setValuePin('5');
                              provider.setValuePin(context, '5',
                                  controller: pins);
                            }),
                            buildNumberCard('6', onTap: () {
                              //setValuePin('6');
                              provider.setValuePin(context, '6',
                                  controller: pins);
                            })
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Consumer<LoginProvider>(
                        builder: (context, provider, _) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildNumberCard('7', onTap: () {
                              //setValuePin('7');
                              provider.setValuePin(context, '7',
                                  controller: pins);
                            }),
                            buildNumberCard('8', onTap: () {
                              //setValuePin('8');
                              provider.setValuePin(context, '8',
                                  controller: pins);
                            }),
                            buildNumberCard('9', onTap: () {
                              //setValuePin('9');
                              provider.setValuePin(context, '9',
                                  controller: pins);
                            })
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Consumer<LoginProvider>(
                        builder: (context, provider, _) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildNumberCard(' ', onTap: () {}, isActive: false),
                            buildNumberCard('0', onTap: () {
                              //setValuePin('0');
                              provider.setValuePin(context, '0',
                                  controller: pins);
                            }),
                            buildNumberCard('C', onTap: () {
                              clear();
                              provider.clear();
                            })
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Container buildPinCard({TextEditingController? controller}) {
    return Container(
      width: 35,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Colors.white54, width: 0.8))),
      child: TextField(
        obscureText: true,
        obscuringCharacter: '*',
        controller: controller,
        textAlign: TextAlign.center,
        readOnly: true,
        style: const TextStyle(
            color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),
        decoration: const InputDecoration(
            enabledBorder: InputBorder.none, focusedBorder: InputBorder.none),
      ),
    );
  }

  InkWell buildNumberCard(String text,
      {Function()? onTap, bool isActive = true}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: isActive ? Colors.white30 : Colors.transparent,
                width: 0.6)),
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
