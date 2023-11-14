import 'package:flutter/material.dart';
import 'package:project_database/DB.dart';
import 'dart:async';

List<String> data = [];

class home_te extends StatefulWidget {
  const home_te(this.email);
  final String email;

  @override
  State<home_te> createState() => _home_teState();
}

class _home_teState extends State<home_te> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 300), handleTimeout);
    data = [];
    DB_read("SELECT T_id,T_name,T_email,T_phone FROM teacher WHERE T_email = '${widget.email}'")
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
      text = "ชื่อ " + data[index+1];
    // text = "รหัสครู " + data[index];
    else if (index == 1)
      text = "อีเมล " + data[index+1];
    // text = "ชื่อ " + data[index];
    else if (index == 2) text = "เบอร์ " + data[index+1];
    // text = "อีเมล " + data[index];
    // else if (index == 3) text = "เบอร์ " + data[index];

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
