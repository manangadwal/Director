// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/login/otp.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _controller = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  bool correct = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: CustomScrollView(slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                // margin: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.only(left: 10, right: 10, bottom: 20),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset("assets/1.png")),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        // borderRadius: BorderRadius.circular(10)
                      ),
                      padding: EdgeInsets.only(bottom: 70, top: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Enter Phone Number",
                            style: GoogleFonts.patuaOne(
                                textStyle: TextStyle(fontSize: 17)),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  // padding: EdgeInsets.symmetric(horizontal: 0),
                                  width: 40,
                                  height: 40,
                                  child: Text("IN")),
                              Container(
                                width: 200,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: TextField(
                                  onChanged: (v) {
                                    correct = true;
                                    setState(() {});
                                  },
                                  // textAlign: TextAlign.center,
                                  controller: _controller,
                                  showCursor: false,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          correct
                              ? Container()
                              : Text(
                                  "enter correct number",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 167, 16, 5)),
                                ),
                          SizedBox(
                            height: 20,
                          ),
                          RaisedButton(
                            color: Colors.black87,
                            textColor: Colors.white,
                            onPressed: () {
                              if (_controller.text.length == 10) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OTPSceen(
                                            "+91" + _controller.text)));
                              } else {
                                correct = false;
                                setState(() {});
                              }
                            },
                            child: Text(
                              "Login",
                              style: GoogleFonts.satisfy(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          )
        ]),
      ),
    );
  }
}
