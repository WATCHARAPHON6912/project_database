import 'package:common_data_table/common_data_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:project_database/DB.dart';
import 'dart:async';

List<List<String>> data = [];
bool error = false;

class add_class extends StatefulWidget {
  add_class(this.email);
  var email;

  @override
  State<add_class> createState() => _add_class_teState();
}

class _add_class_teState extends State<add_class> {
  @override
  String T_id = '';
  String C_id = '';
  void initState() {
    super.initState();
    data.clear();
    Timer(Duration(milliseconds: 300), handleTimeout);
    read_data();
    DB_read_r1("SELECT T_id FROM teacher WHERE T_email = '${widget.email}'")
        .then((t_id) {
      T_id = t_id[0];
    });
  }

  void read_data() {
    setState(() {
      data.clear();
      DB_read_all("""
SELECT c_id,c_name,semester,details,A,B_,B,C_,C,D_,D,F FROM class
right join teacher_has_class
on teacher_has_class.Class_C_id = class.C_id
right join teacher
on teacher.T_id = teacher_has_class.Teacher_T_id
where T_email = '${widget.email}';
""").then((value) {
        print(value);
        for (var x in value) {
          data.add(x);
        }
        print("$data check");
      });
    });
  }

  void handleTimeout() {
    try {
      setState(() {});
    } catch (e) {}
  }

  List<String> ti = [
    'id',
    'Name',
    'semester',
    'details',
    'A',
    'B+',
    'B',
    'C+',
    'C',
    'D+',
    'D',
    'F'
  ];

  var update = ['', '', '', '', '', '', '', '', '', '', '', ''];

  @override
  Widget build(BuildContext context) {
    return CommonDataTable(
      isSearchAble: true,
      tableActionButtons: [
        TableActionButton(
          child: Text("Add data"),
          onTap: () {
            print("add");
            add_data();
          },
          shortcuts: SingleActivator(
            LogicalKeyboardKey.keyA,
            control: true,
          ),
          icon: Icon(
            FontAwesomeIcons.addressCard,
            size: 20,
          ),
        )
      ],
      sortColumn: [
        0,
        1,
        2,
        3,
      ],

      title: "ข้อมูลคลาส",
      titleBgColor: Colors.black,
      titleStyle: TextStyle(
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      heading: ti,

      rowBGColor: (index) {
        if (index.isOdd) {
          return Color.fromARGB(255, 236, 230, 119);
        } else {
          return Color.fromARGB(255, 154, 236, 119);
        }
      },
      data: data,
      headingAlign: {
        0: TblAlign.center,
        1: TblAlign.center,
      },
      dataAlign: {
        0: TblAlign.center,
      },
      onEdit: (index) {
        print("edit $index");
        print("edit ${data[0][0]}");
        open_edit(index);
      },
      onDelete: (index) {
        print("delete $index");
        open_delet(index);
      },
      // disabledDeleteButtons: [1, 3, 5],
      // disabledEditButtons: [0, 2, 4],
      dataTextStyle: (row) {
        return {0: TextStyle(color: Colors.blue, fontSize: 20)};
      },
      onExportExcel: (file) async {
        await launchUrl(Uri.file(file.path));
      },
      onExportPDF: (file) async {
        await launchUrl(Uri.file(file.path));
      },
    );
  }

  Future add_data() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "เพิ่มข้อมูล",
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: ti.sublist(1).length,
              itemBuilder: (_, i) {
                return Container(
                  padding: new EdgeInsets.all(5.0),
                  child: TextField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          hintText: "${ti[i + 1]}",
                          hintStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ))),
                      onChanged: (value) {
                        update[i] = value;
                      }),
                );
              },
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  var GPA = [
                    '80',
                    '75',
                    '70',
                    '65',
                    '60',
                    '55',
                    '50',
                    '0',
                    '0'
                  ];
                  for (int i = 0; i < update.length; i++) {
                    if (update[i] == '') {
                      if (i >= 3) {
                        update[i] = GPA[i - 3];
                      } else {
                        update[i] = 'Null';
                      }
                    }
                  }
                  print(update);
                  setState(() {
                    DB_update("""INSERT INTO class (
                      C_name, 
                      Semester, 
                      details, 
                      A, 
                      B_, 
                      B, 
                      C_, 
                      C, 
                      D_, 
                      D, 
                      F) 
                      VALUES (
                        '${update[0]}', 
                        '${update[1]}', 
                        '${update[2]}', 
                        '${update[3]}', 
                        '${update[4]}', 
                        '${update[5]}', 
                        '${update[6]}', 
                        '${update[7]}', 
                        '${update[8]}', 
                        '${update[9]}', 
                        '${update[10]}');
""").then(
                      (value) {
                        error = value;
                      },
                    );

                    Timer(Duration(milliseconds: 500), () {
                      if (error == false) {
                        DB_read_r1(
                                "SELECT c_id FROM class WHERE c_name = '${update[0]}'")
                            .then((c_id) {
                          // print(c_id);
                          C_id = c_id[0];
                          DB_update(
                              "INSERT INTO teacher_has_class (Teacher_T_id,Class_C_id) values ('$T_id','$C_id');");
                          // print("$T_id  $C_id");
                        });
                        Timer(Duration(milliseconds: 500), () {
                          read_data();
                          Timer(Duration(milliseconds: 500), () {
                            setState(() {});
                          });
                        });
                      } else {
                        Timer(Duration(milliseconds: 100), () {
                          Error_add();
                        });
                      }
                      for (int i = 0; i < update.length; i++) {
                        update[i] = '';
                      }
                    });
                  });

                  Navigator.pop(context, 'ยืนยัน');
                },
                child: Text("ยืนยัน")),
            TextButton(
                onPressed: () => Navigator.pop(context, 'ยกเลิก'),
                child: Text("ยกเลิก")),
          ],
        ),
      );

  Future open_edit(index) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("แก้ไข้ข้อมูล"),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: ti.sublist(1).length,
              itemBuilder: (_, i) {
                return Container(
                  padding: new EdgeInsets.all(5.0),
                  child: TextField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          hintText: "${ti[i + 1]}",
                          hintStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ))),
                      onChanged: (value) {
                        update[i] = value;
                      }),
                );
              },
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  setState(() {
                    for (int i = 0; i < ti.length; i++) {
                      if (update[i] != '') {
                        data[index][i + 1] = update[i];
                      }
                    }
                    // print(update);
                    for (int x = 0; x < update.length; x++) {
                      // print(update[x]);
                      var update_title = [
                        'c_name',
                        'semester',
                        'details',
                        'A',
                        'B_',
                        'B',
                        'C_',
                        'C',
                        'D_',
                        'D',
                        'F'
                      ];
                      // print(update);

                      if (update[x] != '') {
                        DB_update(
                            "update class set ${update_title[x]} ='${update[x]}' where C_id ='${data[index][0]}';");
                      }
                    }
                    for (int i = 0; i < ti.length; i++) {
                      update[i] = '';
                    }
                  });
                  Navigator.pop(context, 'ยืนยัน');
                },
                child: Text("ยืนยัน")),
            TextButton(
                onPressed: () => Navigator.pop(context, 'ยกเลิก'),
                child: Text("ยกเลิก")),
          ],
        ),
      );

  Future open_delet(index) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Image.asset(
                'assets/images/al.png',
                width: 30,
                height: 30,
                fit: BoxFit.contain,
              ),
              Text('\t\tแจ้งเตือน'),
            ],
          ),
          content: const Text('คุณแน่ใจในการลบหรือไม่!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  Navigator.pop(context, 'ตกลง');
                  print(data[index][0]);
                  DB_read_r1(
                          "SELECT Teacher_class_id FROM teacher_has_class where Class_C_id = '${data[index][0]}'")
                      .then((value) {
                    print(data[index][0]);
                    DB_update(
                        "DELETE FROM teacher_has_class WHERE (Teacher_class_id = '${value[0]}');");
                    DB_update(
                        "DELETE FROM class WHERE (c_id = '${data[index][0]}');");
                  });

                  Timer(Duration(milliseconds: 500), () {
                    read_data();
                    Timer(Duration(milliseconds: 500), () {
                      setState(() {});
                    });
                  });
                });
              },
              child: const Text('ตกลง'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'ยกเลิก'),
              child: const Text('ยกเลิก'),
            ),
          ],
        ),
      );
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
          content: const Text('เกิดข้อผิดพลาด'),
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

  Future Error_add() => showDialog(
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
          content: const Text('มีชื่อคลาสนี้แล้ว'),
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
