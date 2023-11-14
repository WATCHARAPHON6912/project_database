import 'package:flutter/material.dart';
import 'package:project_database/DB.dart';
import 'dart:async';

List<String> data = [];

class home extends StatefulWidget {
  const home(this.email);
  final String email;

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 300), handleTimeout);
    data = [];
    DB_read("SELECT S_id,S_name,S_email,S_phone FROM student WHERE S_email = '${widget.email}'")
        .then((value) {
      data = value;
    });
    print("Home");
  }

  void handleTimeout() {
    try {
      setState(() {});
    } catch (e) {}
  }

  String list_show(index) {
    String text = "";
    if (index == 0)
      text = "รหัสนักศึกษา " + data[index];
    else if (index == 1)
      text = "ชื่อ " + data[index];
    else if (index == 2)
      text = "อีเมล " + data[index];
    else if (index == 3) text = "เบอร์ " + data[index];

    return text;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      padding: const EdgeInsets.only(top: 10),
      itemBuilder: (context, index) => Container(
        alignment: Alignment.center,
        child: Text(
          list_show(index),
          style: TextStyle(
              color: const Color.fromARGB(255, 255, 255, 255), fontSize: 50),
        ),
        height: 100,
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10, right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).canvasColor,
        ),
      ),
    );
  }
}
