// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:animated_icon_button/animated_icon_button.dart';

class Expenses extends StatefulWidget {
  String uid;
  Expenses(this.uid);

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  DateTime? newDate;
  TextEditingController titleController = TextEditingController();
  TextEditingController amtController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  double? saved, used, salary;
  double? savedPercent;
  bool? less;
  String? finPercent;

  Stream<QuerySnapshot> getData() {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(widget.uid)
        .collection("expenses")
        .orderBy("date", descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getSalary() {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(widget.uid)
        .collection("salary")
        .snapshots();
  }

  getVals() async {
    await getSalData();
    await getExpData();
    var usedPercent = 100 * (used ?? 0) / (salary ?? 0);
    savedPercent = 100 - usedPercent;
    print("% ${savedPercent}");

    finPercent = (savedPercent ?? 0).toStringAsFixed(2);
  }

  getSalData() async {
    salary = 0;
    final data = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.uid)
        .collection('salary')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        var ans = (element.data()['salary']);
        salary = double.parse(ans);
        print(salary);
        print('salary');
      });
    });
  }

  getExpData() async {
    used = 0;
    saved = 0;
    final data = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.uid)
        .collection('expenses')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        var ans = (element.data()['amounr']);
        // print(ans);
        used = (used ?? 0) + ans;
        print(used);
        print('used');
        saved = (salary ?? 0) - (used ?? 0);
        if ((saved ?? 0) < 0) {
          saved = 0;
        }
        print(saved);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVals();
    getData();
    getSalary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(13)),
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(6),
              height: 250,
              alignment: Alignment.center,
              child: Column(children: [
                SizedBox(
                  width: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Total Earnings",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Container(
                                  height: 150,
                                  child: Column(
                                    children: [
                                      TextField(
                                        keyboardType: TextInputType.number,
                                        controller: salaryController,
                                        decoration: InputDecoration(
                                            hintText: "Enter new salary"),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      FlatButton(
                                          color: Colors.black,
                                          onPressed: () async {
                                            FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(widget.uid)
                                                .collection('salary')
                                                .get()
                                                .then((snapshot) {
                                              for (DocumentSnapshot doc
                                                  in snapshot.docs) {
                                                doc.reference.delete();
                                              }
                                            });
                                            FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(widget.uid)
                                                .collection('salary')
                                                .add({
                                              'salary': salaryController.text
                                            });

                                            setState(() {});

                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "Done",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ))
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      child: Icon(
                        Icons.edit,
                        color: Colors.black,
                        size: 17,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StreamBuilder(
                        stream: getSalary(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          return Text(
                            snapshot.data?.docs
                                    .map((sal) {
                                      // salary = sal['salary'];
                                      return sal['salary'];
                                    })
                                    .toString()
                                    .replaceAll('(', '')
                                    .replaceAll(')', '') ??
                                '',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 37,
                                fontWeight: FontWeight.bold),
                          );
                        }),
                    // salary = sal.['salary'];
                    Text(
                      ' ₹',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 37,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  // margin: EdgeInsets.all(10),

                  height: 90,
                  child: PieChart(
                      colorList: [Colors.black, Colors.cyan],
                      chartValuesOptions:
                          ChartValuesOptions(showChartValues: false),
                      dataMap: {
                        "Spendings": used ?? 0,
                        "Savings": (used ?? 0) == 0 ? salary ?? 0 : saved ?? 0,
                      },
                      chartType: ChartType.ring),
                  color: Colors.grey[100],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    (savedPercent ?? 0) < 50
                        ? Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "You're Spending too much money",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  "only saving ${finPercent ?? ''}% of your income.",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Good job !",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  "you're saving ${finPercent ?? ''}% of your income.",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ),
                    GestureDetector(
                        onTap: () async {
                          await getVals();

                          setState(() {});
                        },
                        child: Container(
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.circular(30)),
                            padding: EdgeInsets.all(10),
                            child: Icon(
                              Icons.refresh,
                              color: Colors.white,
                            ))),
                  ],
                )
              ]),
            ),
            StreamBuilder(
                stream: getData(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  return ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: snapshot.data?.docs.map((document) {
                          // used = used + document['amounr'];
                          // used = 0;
                          // print(used);

                          return Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, left: 10, right: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(10)),
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: ListTile(
                                title: Text(
                                  // used.toString(),
                                  document['title'],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child: Text(
                                          document['amounr'].toString() + " ₹",
                                          overflow: TextOverflow.clip),
                                    ),
                                    Text(
                                      document['date'],
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          FirebaseFirestore.instance
                                              .collection("users")
                                              .doc(widget.uid)
                                              .collection("expenses")
                                              .doc(document.id)
                                              .delete();
                                        },
                                        child: Icon(Icons.delete)),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList() ??
                        [],
                  );
                }),
            SizedBox(
              height: 70,
            )
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Container(
                    height: 250,
                    child: Column(
                      children: [
                        TextField(
                          controller: titleController,
                          decoration: InputDecoration(hintText: "Title"),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                            controller: amtController,
                            decoration:
                                InputDecoration(hintText: "Amount in Rs"),
                            keyboardType: TextInputType.number),
                        Padding(
                          padding: const EdgeInsets.only(top: 18.0),
                          child: GestureDetector(
                            onTap: () async {
                              newDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2022),
                                  lastDate: DateTime(2023));
                            },
                            child: Row(
                              children: [
                                Icon(Icons.calendar_month),
                                Text(" Choose Date")
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        FlatButton(
                            color: Colors.black,
                            onPressed: () {
                              String date = DateFormat('yyyy-MM-dd')
                                  .format(newDate ?? DateTime.now());
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(widget.uid)
                                  .collection('expenses')
                                  .add({
                                'title': titleController.text,
                                'amounr': double.parse(amtController.text),
                                'date': date,
                              });

                              // FirebaseFirestore.instance
                              //     .collection('users')
                              //     .doc(widget.uid)
                              //     .collection('salary')
                              //     .add({'salary': "0"});
                              titleController.clear();
                              amtController.clear();
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Add Transaction",
                              style: TextStyle(color: Colors.white),
                            ))
                      ],
                    ),
                  ),
                );
              });
        },
        backgroundColor: Colors.black,
        child: Icon(Icons.list_alt),
      ),
    );
  }
}
