// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/home/expenses.dart';
import 'package:flutter_application_2/home/task.dart';
import 'package:flutter_application_2/login/login_Page.dart';
import 'package:flutter_application_2/login/otp.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  String? uid;
  // TabController tabBar = TabController(length: 2, vsync: this, initialIndex: 0);
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black87,
              actions: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (route) => false);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(Icons.logout),
                  ),
                ),
              ],
              title: Text(
                'Director',
                style: GoogleFonts.lobster(textStyle: TextStyle(fontSize: 22)),
              ),
              bottom: TabBar(tabs: [
                Tab(
                  text: "Tasks",
                ),
                Tab(
                  text: "Expenses",
                )
              ]),
            ),
            body: TabBarView(
              children: [
                Task(uid ?? ''),
                Expenses(uid ?? ''),
              ],
            )),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uid = FirebaseAuth.instance.currentUser?.uid ?? '';
  }
}
