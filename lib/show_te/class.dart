import 'package:common_data_table/common_data_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:project_database/DB.dart';
import 'dart:async';
import 'package:dropdown_button2/dropdown_button2.dart';

List<List<String>> data = [];
List<String> items = [];
String name_class = "Class";
var data_edit = [];

class Class extends StatefulWidget {
  Class(this.email);
  var email;

  @override
  State<Class> createState() => _ClassState();
}

class _ClassState extends State<Class> {
  @override
  void initState() {
    super.initState();
    data.clear();
    name_class = "Class";
    Timer(Duration(milliseconds: 300), handleTimeout);

    DB_read_r1("""
SELECT C_name FROM teacher 
right join teacher_has_class 
on teacher.T_id = teacher_has_class.teacher_t_id
right join class 
on teacher_has_class.Class_C_id = class.c_id
where teacher_has_class.Class_C_id = class.c_id and T_email = '${widget.email}';
""").then((value) {
      items = value;
      // print(items);
    });
  }

  void handleTimeout() {
    try {
      setState(() {
        print('set');
      });
    } catch (e) {}
  }

  String? selectedValue;
  List<String> ti = ['S.NO', 'Name'];
  var update = ['', ''];

  @override
  Widget build(BuildContext context) {
    return CommonDataTable(
      isSearchAble: true,
      tableActionButtons: [
        TableActionButton(
            child: Text("delete"),
            onTap: () {
              if (name_class != 'Class') {
                delete();
              } else {
                Error();
              }
            },
            icon: Icon(
              Icons.delete,
              size: 20,
            ),
            bgColor: Colors.red),
        TableActionButton(
            child: Text("Add"),
            onTap: () {
              if (name_class != 'Class') {
                add_work();
              } else {
                Error();
              }
            },
            shortcuts: SingleActivator(
              LogicalKeyboardKey.keyA,
              control: true,
            ),
            icon: Icon(
              Icons.work,
              size: 20,
            ),
            bgColor: Colors.orange),
        TableActionButton(
          child: Center(
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                isExpanded: true,
                hint: const Row(
                  children: [
                    SizedBox(
                      width: 4,
                    ),
                    Expanded(
                      child: Text(
                        'Select Item',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                items: items
                    .map((String item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                    .toList(),
                value: selectedValue,
                onChanged: (String? value) {
                  reload(value);
                  setState(() {
                    selectedValue = value;
                    name_class = value.toString();
                    Timer(Duration(milliseconds: 300), handleTimeout);
                  });
                },
                buttonStyleData: ButtonStyleData(
                  height: 30,
                  width: 80,
                ),
                iconStyleData: const IconStyleData(
                  icon: Icon(
                    Icons.arrow_forward_ios_outlined,
                  ),
                  iconSize: 14,
                  iconEnabledColor: Color.fromARGB(255, 0, 0, 0),
                  iconDisabledColor: Colors.grey,
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 600,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.blue,
                  ),
                  offset: const Offset(-20, 0),
                  scrollbarTheme: ScrollbarThemeData(
                    radius: const Radius.circular(40),
                    thickness: MaterialStateProperty.all<double>(6),
                    thumbVisibility: MaterialStateProperty.all<bool>(true),
                  ),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                  padding: EdgeInsets.only(left: 14, right: 14),
                ),
              ),
            ),
          ),
          onTap: () {
            print("add");
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

      title: "ข้อมูลการสอน",
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
        open_edit(index);
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

  Future open_edit(index) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "แก้ไข้ข้อมูล",
          ),
          content: Column(
            children: [
              for (int i = 2; i < ti.length-2; i++) ...[
                TextField(
                  decoration: InputDecoration(
                      hintText: "${ti[i]} = ${data[index][i]} "),
                  onChanged: (value) {
                    update[i] = value;
                  },
                ),
              ]
            ],
          ),
          actions: [
            TextButton(
                onPressed: () {
                  setState(() {
                    for (int i = 0; i < ti.length - 2; i++) {
                      if (update[i] != '') {
                        data[index][i] = update[i];
                      }
                    }
                    for (int x = 2; x < ti.length - 2; x++) {
                      if (update[x] != '') {
                        DB_read_r1("""
SELECT Student_has_Criteriacol  FROM student_has_criteria
right join criteria
on criteria.Cr_id = student_has_criteria.Criteria_Cr_id 
where criteria.name = '${data_edit[x]}' and Student_S_id = '${data[index][0]}'
;
""").then((value) {
                          DB_update(
                              "update student_has_criteria set value ='${update[x]}' where Student_has_Criteriacol ='${value[0]}';");
                        });
                      }
                    }
                  });

                  Navigator.pop(context, 'ยืนยัน');

                  Timer(Duration(milliseconds: 300), () {
                    // print(name_class);
                    reload(name_class);
                    Timer(Duration(milliseconds: 300), () {
                      for (int i = 0; i < update.length; i++) {
                        update[i] = '';
                      }
                      setState(() {});
                    });
                    // reload(value)
                  });
                },
                child: Text("ยืนยัน")),
            TextButton(
                onPressed: () => Navigator.pop(context, 'ยกเลิก'),
                child: Text("ยกเลิก")),
          ],
        ),
      );

  Future Error() => showDialog(
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
          content: const Text('โปรดเลือกคลาส'),
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

  var work = ['ชื่องาน', "คะแนน"];
  Future add_work() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("เพิ่มงาน"),
          content: Column(
            children: [
              for (int i = 0; i < work.length; i++) ...[
                TextField(
                  decoration: InputDecoration(hintText: "${work[i]}"),
                  onChanged: (value) {
                    update[i] = value;
                  },
                ),
              ]
            ],
          ),
          actions: [
            TextButton(
                onPressed: () {
                  setState(() {
                    DB_read_r1(
                            "SELECT C_id FROM class where c_name = '$name_class'")
                        .then((value) {
                      DB_update(
                          "INSERT INTO criteria (Name,max_value,class_id) values ('${update[0]}','${update[1]}','${value[0]}');");
                    });

                    DB_read_r1("""
SELECT S_id FROM teacher
right join teacher_has_class
on teacher.T_id = teacher_has_class.teacher_t_id
right join class
on teacher_has_class.Class_C_id = class.c_id
right join student_has_class
on student_has_class.Class_C_id = class.c_id
right join student
on student.S_id = student_has_class.student_s_id
where teacher_has_class.Class_C_id = class.c_id and T_email = '${widget.email}' and C_name ='${name_class}';
                            """).then((value1) {
                      Timer(Duration(milliseconds: 300), () {
                        DB_read("""
SELECT * from criteria 
right join class
on class.c_id = criteria.class_id
where criteria.name = '${update[0]}' and class.C_name = '$name_class'
;
""").then((value2) {
                          for (var x in value1) {
                            DB_update(
                                "INSERT INTO student_has_criteria (Student_S_id,Criteria_Cr_id) values ('$x','${value2[0]}');");
                          }
                        });
                      });
                    });
                  });
                  Timer(Duration(milliseconds: 1000), () {
                    reload(name_class);
                    Timer(Duration(milliseconds: 500), () {
                      print(data);
                      setState(() {});
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

  void reload(value_name_class) {
    ti = ['S.NO', 'Name'];
    update = ['', ''];
    data_edit = ['S.NO', 'Name'];

    DB_read_all("""
SELECT distinct(criteria.name),max_value  FROM teacher
right join teacher_has_class
on teacher.T_id = teacher_has_class.teacher_t_id
right join class
on teacher_has_class.Class_C_id = class.c_id
right join student_has_class
on student_has_class.Class_C_id = class.c_id
right join student
on student.S_id = student_has_class.student_s_id
right join student_has_criteria
on student.S_id = student_has_criteria.Student_S_id
right join criteria
on criteria.Cr_id = student_has_criteria.Criteria_Cr_id
where teacher_has_class.Class_C_id = class.c_id and T_email = '${widget.email}' and C_name ='$value_name_class'
and class.C_id = criteria.class_id
;
""").then((value) {
      // print(value);
      for (int i = 0; i < value.length; i++) {
        ti.add("${value[i][0]} / ${value[i][1]}");
        data_edit.add(value[i][0]);
        update.add('');
      }
      ti.add("totol");
      ti.add("GPA");
      
      // for (var i in value) {
      //   ti.add(i);
      //   update.add('');
      // }
    });

    data.clear();
    DB_read_st("""
SELECT S_id,S_name,criteria.name,value  FROM teacher
right join teacher_has_class
on teacher.T_id = teacher_has_class.teacher_t_id
right join class
on teacher_has_class.Class_C_id = class.c_id
right join student_has_class
on student_has_class.Class_C_id = class.c_id
right join student
on student.S_id = student_has_class.student_s_id
right join student_has_criteria
on student.S_id = student_has_criteria.Student_S_id
right join criteria
on criteria.Cr_id = student_has_criteria.Criteria_Cr_id
where teacher_has_class.Class_C_id = class.c_id and T_email = '${widget.email}' and C_name ='$value_name_class'
and class.C_id = criteria.class_id
;
""").then((da) {
      print(da);
      if (da.length <= 0) {
        DB_read_st("""
SELECT S_id,S_name  FROM teacher
right join teacher_has_class
on teacher.T_id = teacher_has_class.teacher_t_id
right join class
on teacher_has_class.Class_C_id = class.c_id
right join student_has_class
on student_has_class.Class_C_id = class.c_id
right join student
on student.S_id = student_has_class.student_s_id
where teacher_has_class.Class_C_id = class.c_id and T_email = '${widget.email}' and C_name ='$value_name_class'
;
""").then((value_if) {
          for (int x =0;x< value_if.length;x++) {
            data.add(value_if[x]);
            data[x].add('0');
          }
        });
      } else {
        
        var g = convert(da);
        
        for (int i = 0; i < g.length; i++) {
          int num = 0;
          for (int j = 2; j < g[i].length; j++) {
            if (g[i][j] != "null") {
              num += int.parse(g[i][j]);
            }
          }
          g[i].add('$num');
        }
        
        for (var x in g) {
          DB_read_all(
                "SELECT A,B_,B,C_,C,D_,D,F FROM project1.class where C_name = '$value_name_class';")
            .then((value) {
          if (int.parse(x[x.length - 1])>=int.parse(value[0][0]))x.add("A");
          else if (int.parse(x[x.length - 1])>=int.parse(value[0][1]))x.add("B+");
          else if (int.parse(x[x.length - 1])>=int.parse(value[0][2]))x.add("B");
          else if (int.parse(x[x.length - 1])>=int.parse(value[0][3]))x.add("C+");
          else if (int.parse(x[x.length - 1])>=int.parse(value[0][4]))x.add("C");
          else if (int.parse(x[x.length - 1])>=int.parse(value[0][5]))x.add("D+");
          else if (int.parse(x[x.length - 1])>=int.parse(value[0][6]))x.add("D");
          else if (int.parse(x[x.length - 1])>=int.parse(value[0][7]))x.add("F");
          data.add(x);
        });
          // x.add("4");
          // data.add(x);
          
        }

//         print(data);
      }
    });
  }

  Color getColor(int i, Color1, Color2) {
    if (i % 2 == 0) {
      return Color1;
    } else {
      return Color2;
    }
  }

  dynamic delete() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(
                child: Text(
              "ลบงาน",
              style: TextStyle(fontSize: 40),
            )),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                itemCount: data_edit.sublist(2).length,
                itemBuilder: (context, i) {
                  return TextButton(
                    onPressed: () {
                      DB_read_r1(
                              "SELECT Cr_id FROM criteria where name = '${data_edit[i + 2]}';")
                          .then((CR_ID) {
                        DB_update(
                            "DELETE FROM student_has_criteria WHERE (Criteria_Cr_id = '${CR_ID[0]}');");
                        DB_update(
                            "DELETE FROM criteria WHERE (Cr_id = '${CR_ID[0]}');");

                        Timer(Duration(milliseconds: 500), () {
                          reload(name_class);
                          Navigator.pop(context);
                          Timer(Duration(milliseconds: 800), () {
                            setState(() {});
                          });
                        });
                      });
                    },
                    child: Text(data_edit[i + 2]),
                    style: TextButton.styleFrom(
                      backgroundColor:
                          getColor(i, Colors.greenAccent, Colors.yellowAccent),
                      foregroundColor: Colors.black,
                      textStyle: TextStyle(fontSize: 25),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("ยกเลิก")),
            ],
          );
        });
  }
}
