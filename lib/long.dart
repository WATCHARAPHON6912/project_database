import 'package:flutter/material.dart';
import 'package:day_night_switch/day_night_switch.dart';
import 'DB.dart';
import 'dart:async';

class long extends StatefulWidget {
  const long({super.key});

  @override
  State<long> createState() => _longState();
}

class _longState extends State<long> {
  bool st = false;

  Future<bool> _getFuture() async {
    await Future.delayed(const Duration(seconds: 2));
    return !st;
  }

  void initState() {
    super.initState();
    DB_read_all("SELECT * FROM project1.on;").then(
      (value) {
        print(value);

        Timer(Duration(milliseconds: 500), () {
          setState(() {
            if (value[0][1] == '1')
              st = true;
            else
              st = false;
            print(st);
          });
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(80),
        ),
        Transform.scale(
          scale: 4,
          child: Text(
            "สถานะ : ${st ? 'เปิด' : 'ปิด'}การลงทะเบียน",
            style:
                TextStyle(color: st?Colors.green:Colors.red),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(100),
        ),
        Transform.scale(
            scale: 3.0,
            child: DayNightSwitch(
              value: st,
              moonImage: AssetImage('assets/images/moon.png'),
              sunImage: AssetImage('assets/images/sun.png'),
              sunColor: Colors.orange,
              moonColor: Colors.green.shade50,
              dayColor: Colors.black12,
              nightColor: Colors.black,
              onChanged: (value) {
                setState(() {
                  st = value;

                  DB_update(
                          "UPDATE `project1`.`on` SET `on` = '${value ? 1 : 0}' WHERE (`idon` = '1');")
                      .then((value) {
                    if (value == 1) Error();
                  });
                });
              },
            ))
      ],
    );
  }

  Future Error() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Image.asset(
                'assets/images/error.png',
                width: 30,
                height: 30,
                fit: BoxFit.contain,
              ),
              Text('\t\tแจ้งเตือน'),
            ],
          ),
          content: const Text('ข้อผิดพลาด'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'ตกลง');
              },
              child: const Text('ตกลง'),
            ),
          ],
        ),
      );
}
