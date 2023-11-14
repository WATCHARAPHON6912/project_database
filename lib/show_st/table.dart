import 'dart:ffi';

import 'package:common_data_table/common_data_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:project_database/DB.dart';
import 'dart:async';

List<List<String>> data = [];

class table_GPA extends StatefulWidget {
  table_GPA(this.email);
  String email;

  @override
  State<table_GPA> createState() => _table_GPAState();
}

class _table_GPAState extends State<table_GPA> {
  @override
  List<String> ti = ['ชื่อคลาส'];

  void initState() {
    super.initState();
    ti = ['ชื่อคลาส'];
    data = [];
    DB_read_all("""
SELECT C_name,criteria.name,value  FROM
student
right join student_has_criteria
on student.S_id = student_has_criteria.Student_S_id
right join criteria
on criteria.Cr_id = student_has_criteria.Criteria_Cr_id
right join class
on C_id=class_id
where S_email = "${widget.email}";
""").then((value) {
      // print(value);
      List<List<List<String>>> x = convert_GPA(value);

      for (int i = 0; i < x[1].length; i++) {
        int num = 0;
        for (int j = 1; j < x[1][i].length; j++) {
          if (x[1][i][j] != "null") {
            num += int.parse(x[1][i][j]);
          }
        }
        x[1][i].add('$num');
      }
      for (int i = 0; i < int.parse("${x[0][0][0]}") - 1; i++) {
        ti.add("คะแนน ${i + 1}");
      }
      ti.add("รวม");
      ti.add("GPA");

      for (var g in x[1]) {
        DB_read_all(
                "SELECT A,B_,B,C_,C,D_,D,F FROM project1.class where C_name = '${g[0]}';")
            .then((value) {
          print(value);
          if (int.parse(g[g.length - 1])>=int.parse(value[0][0]))g.add("A");
          else if (int.parse(g[g.length - 1])>=int.parse(value[0][1]))g.add("B+");
          else if (int.parse(g[g.length - 1])>=int.parse(value[0][2]))g.add("B");
          else if (int.parse(g[g.length - 1])>=int.parse(value[0][3]))g.add("C+");
          else if (int.parse(g[g.length - 1])>=int.parse(value[0][4]))g.add("C");
          else if (int.parse(g[g.length - 1])>=int.parse(value[0][5]))g.add("D+");
          else if (int.parse(g[g.length - 1])>=int.parse(value[0][6]))g.add("D");
          else if (int.parse(g[g.length - 1])>=int.parse(value[0][7]))g.add("F");
          data.add(g);
        });
      }
    });
    Timer(Duration(milliseconds: 500), () {
      try {
        setState(() {});
      } catch (e) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return CommonDataTable(
      isSearchAble: true,
      tableActionButtons: [],
      sortColumn: [
        0,
        1,
        2,
        3,
      ],
      title: "ข้อมูลคะแนน",
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
}
