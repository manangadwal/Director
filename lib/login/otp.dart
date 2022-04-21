// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/home/home_Page.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPSceen extends StatefulWidget {
  final String number;
  OTPSceen(this.number);
  @override
  State<OTPSceen> createState() => _OTPSceenState();
}

class _OTPSceenState extends State<OTPSceen> {
  TextEditingController _controller = TextEditingController();
  String? verificationCode;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Container(
        alignment: Alignment.topCenter,
        // padding: EdgeInsets.all(10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.cyan,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "  Enter the OTP",
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: PinCodeTextField(
                  textStyle: TextStyle(color: Colors.white),
                  controller: _controller,
                  hapticFeedbackTypes: HapticFeedbackTypes.vibrate,
                  useHapticFeedback: true,
                  appContext: context,
                  length: 6,
                  onChanged: (v) {},
                  onCompleted: (pin) async {
                    await FirebaseAuth.instance
                        .signInWithCredential(PhoneAuthProvider.credential(
                            verificationId: verificationCode ?? '',
                            smsCode: pin))
                        .then((value) {
                      if (value.user != null) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                            (route) => false);
                      }
                    });
                  },
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(8),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    disabledColor: Colors.grey[300],
                    inactiveColor: Colors.grey[300],
                  ),
                ),
              )
            ]),
      ),
    );
  }

  _verifyPhone() {
    FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.number,
        verificationCompleted: (credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                  (route) => false);
            }
          });
        },
        verificationFailed: (v) {
          print(v);
        },
        codeSent: (String verificationID, int? resendToken) {
          setState(() {
            verificationCode = verificationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 60));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verifyPhone();
  }
}
