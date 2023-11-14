import 'package:flutter/material.dart';
import 'package:project_database/DB.dart';
import 'dart:async';

int hi = 100;
int remove = 120;
var check = '0';

class enroll extends StatefulWidget {
  enroll(this.email);
  String email;

  @override
  State<enroll> createState() => _enrollState();
}

class _enrollState extends State<enroll> {
  @override
  List<String> register = [];
  List<String> not_registered = [];
  String id = '';

  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 300), handleTimeout);
    // for (int i = 1; i <= 9; i++) {
    //   not_registered.add("วิชา $i");
    // }

    print("enroll");
    DB_read_r1("SELECT s_id FROM student where S_email = '${widget.email}'")
        .then(
      (value) {
        id = value[0];
      },
    );

    DB_read_r1("""
SELECT distinct(c_name) FROM student right join student_has_class 
on student.S_id = student_has_class.Student_S_id
right join class on student_has_class.class_c_id = class.c_id where S_email <> '${widget.email}' or S_email is null ;
""").then((value) {
      not_registered = value;
    });
    DB_read_r1("""
SELECT distinct(c_name) FROM student right join student_has_class 
on student.S_id = student_has_class.Student_S_id
right join class on student_has_class.class_c_id = class.c_id 
where student_has_class.class_c_id = class.c_id and s_email = '${widget.email}';
""").then((value) {
      register = value;
    });
  }

  void handleTimeout() {
    try {
      List<String> intersection =
          register.where((e) => not_registered.contains(e)).toList();
      for (String i in intersection) {
        not_registered.remove(i);
      }

      setState(() {});
    } catch (e) {}
  }

  void del(index) {
    setState(() {
      not_registered.add(register[index]);
      register.removeAt(index);
      not_registered.sort();
      register.sort();
    });
  }

  void add(index) {
    setState(() {
      register.add(not_registered[index]);
      not_registered.removeAt(index);
      not_registered.sort();
      register.sort();
    });
  }

  Widget build(BuildContext context) {
    var x1 = Container(
      child: ListView.builder(
        itemCount: register.length,
        padding: const EdgeInsets.only(top: 10, left: 10),
        itemBuilder: (context, index) => Container(
          alignment: Alignment.center,
          child: ListTile(
              leading: IconButton(
                icon: Icon(Icons.delete, color: Colors.red, size: 30),
                onPressed: () {
                  del(index);
                },
              ),
              title: Text(
                register[index],
                style: TextStyle(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontSize: 30),
              )),
          // child: Text("วิชา ${index+1}",style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255),fontSize: 50),),
          height: 90,
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 10, right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).canvasColor,
            // boxShadow: const [BoxShadow()],
          ),
        ),
      ),
      width: (MediaQuery.of(context).size.width / 2) - remove,
      height: MediaQuery.of(context).size.height - hi,
      // color: Colors.red,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.deepPurple.shade800,
      ),
    );

    var x2 = Container(
      child: ListView.builder(
        itemCount: not_registered.length,
        padding: const EdgeInsets.only(top: 10, left: 10),
        itemBuilder: (context, index) => Container(
          alignment: Alignment.center,
          child: ListTile(
              leading: IconButton(
                icon: Icon(Icons.add, color: Colors.green, size: 30),
                onPressed: () {
                  add(index);
                },
              ),
              title: Text(
                not_registered[index],
                style: TextStyle(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontSize: 30),
              )),
          // child: Text("วิชา ${index+1}",style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255),fontSize: 50),),
          height: 90,
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 10, right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).canvasColor,
            // boxShadow: const [BoxShadow()],
          ),
        ),
      ),
      width: (MediaQuery.of(context).size.width / 2) - remove,
      height: MediaQuery.of(context).size.height - hi,
      // color: Colors.red,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Color.fromARGB(255, 76, 242, 148),
      ),
    );

    return Center(
      child: Column(children: [
        Padding(padding: const EdgeInsets.only(top: 10)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [x1, Padding(padding: const EdgeInsets.only(left: 10)), x2],
        ),
        Padding(padding: const EdgeInsets.all(10)),
        Center(
            child: SizedBox(
          width: MediaQuery.of(context).size.width - 230,
          child: TextButton(
            onPressed: () {
              print("OK");
              DB_read_all("SELECT * FROM project1.on;").then(
                (value) {
                  if (value[0][1] == '1') {
                    DB_update(
                        "DELETE FROM student_has_class WHERE (Student_S_id = '$id');");
                    DB_read_r1(
                            "SELECT S_id FROM student where S_email = '${widget.email}';")
                        .then(
                      (value) {
                        for (int i = 0; i < register.length; i++) {
                          DB_read_r1(
                                  "SELECT C_id FROM class where c_name = '${register[i]}';")
                              .then(
                            (value1) {
                              DB_update(
                                  "INSERT INTO student_has_class (Student_S_id, Class_C_id) VALUES ('${value[0]}', '${value1[0]}');");
                            },
                          );
                        }
                      },
                    );
                    Complete();
                  } else {
                    no_on();
                  }
                },
              );
            },
            child: Text(
              "ยืนยัน",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.all(16.0),
              // textStyle: const TextStyle(fontSize: 20, color: Colors.white),
              backgroundColor: const Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ))
      ]),
    );
  }

  Future Complete() => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Row(
            children: [
              Image.asset(
                'assets/images/acc.png',
                width: 55,
                height: 55,
                fit: BoxFit.contain,
              ),
              Text(
                '\tแจ้งเตือน',
                style: TextStyle(fontSize: 35),
              ),
            ],
          ),
          content: const Text(
            'ลงทะเบียนสำเร็จ',
            style: TextStyle(fontSize: 20),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ตกลง', style: TextStyle(fontSize: 25)),
            ),
          ],
        ),
      );
  Future no_on() => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Row(
            children: [
              Image.asset(
                'assets/images/al.png',
                width: 55,
                height: 55,
                fit: BoxFit.contain,
              ),
              Text(
                '\tแจ้งเตือน',
                style: TextStyle(fontSize: 35),
              ),
            ],
          ),
          content: const Text(
            'ระบบยังไม่เปิดหรือถอนการลงทะเบียน',
            style: TextStyle(fontSize: 20),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ตกลง', style: TextStyle(fontSize: 25)),
            ),
          ],
        ),
      );
}
