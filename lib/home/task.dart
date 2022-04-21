// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:confetti/confetti.dart';

class Task extends StatefulWidget {
  String uid;
  Task(this.uid);

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  final controller = ConfettiController(duration: Duration(seconds: 2));

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    getVal();
  }

  DateTime? newDate;
  TextEditingController descController = TextEditingController(),
      titleController = TextEditingController();

  getVal() async {
    await getData();
  }

  Stream<QuerySnapshot> getData() {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(widget.uid)
        .collection("tasks")
        .orderBy("date", descending: false)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Column(children: [
              ///
              StreamBuilder(
                  stream: getData(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    return ListView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: snapshot.data?.docs.map((document) {
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
                                    document['title'],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(document['desc'],
                                          overflow: TextOverflow.clip),
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
                                            if (document.get("isDone") ==
                                                false) {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      content: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          height: 100,
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                  "Have you completed this task?"),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Expanded(
                                                                    child: FlatButton(
                                                                        color: Colors.green,
                                                                        onPressed: () {
                                                                          FirebaseFirestore
                                                                              .instance
                                                                              .collection(
                                                                                  "users")
                                                                              .doc(widget
                                                                                  .uid)
                                                                              .collection(
                                                                                  "tasks")
                                                                              .doc(document
                                                                                  .id)
                                                                              .update({
                                                                            'isDone':
                                                                                true
                                                                          });

                                                                          controller
                                                                              .play();
                                                                          setState(
                                                                              () {});

                                                                          Navigator.pop(
                                                                              context);
                                                                          // stopAnimation();
                                                                        },
                                                                        child: Text("Yes")),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Expanded(
                                                                    child: FlatButton(
                                                                        color: Colors.grey,
                                                                        onPressed: () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child: Text("No")),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          )),
                                                    );
                                                  });
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.check_circle,
                                              color: document['isDone']
                                                  ? Colors.green
                                                  : Colors.grey[600],
                                            ),
                                          )),
                                      GestureDetector(
                                          onTap: () {
                                            FirebaseFirestore.instance
                                                .collection("users")
                                                .doc(widget.uid)
                                                .collection("tasks")
                                                .doc(document.id)
                                                .delete();

                                            setState(() {});
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

              ///
            ]),
            ConfettiWidget(
              confettiController: controller,
              shouldLoop: false,
              blastDirection: pi / 2,
              emissionFrequency: 0.05,
              gravity: 0.5,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black87,
          child: Icon(Icons.add),
          onPressed: () {
            titleController.clear();
            descController.clear();
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Container(
                      height: 250,
                      child: Column(children: [
                        TextField(
                          controller: titleController,
                          decoration: InputDecoration(hintText: "Title"),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: descController,
                          decoration: InputDecoration(hintText: "Description"),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
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
                        RaisedButton(
                            color: Colors.black,
                            child: Text(
                              "Save",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              bool isDone = false;
                              String date = DateFormat('yyyy-MM-dd')
                                  .format(newDate ?? DateTime.now());
                              ;
                              // FirebaseFirestore.instance.doc(documentPath)
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(widget.uid)
                                  .collection('tasks')
                                  .add({
                                'title': titleController.text,
                                'desc': descController.text,
                                'date': date,
                                'isDone': isDone
                              });
                              Navigator.pop(context);
                            })
                      ]),
                    ),
                  );
                });
          }),
    );
  }
}
