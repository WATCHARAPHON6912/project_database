import 'package:common_data_table/common_data_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:project_database/DB.dart';
import 'dart:async';

List<List<String>> data = [];

class table_te_te extends StatefulWidget {
  const table_te_te({super.key});

  @override
  State<table_te_te> createState() => _table_te_teState();
}

class _table_te_teState extends State<table_te_te> {
  @override
  void initState() {
    super.initState();
    data.clear();
    Timer(Duration(milliseconds: 300), handleTimeout);
    DB_read_all("SELECT * FROM teacher").then((value) {
      for (var x in value) {
        data.add(x);
      }
    });
  }

  void handleTimeout() {
    try {
      setState(() {});
    } catch (e) {}
  }

  List<String> ti = ['T.NO', 'Name', 'Email', 'Password', 'Phone','admin'];

  var update = ['', '', '', '', '',''];

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
            FontAwesomeIcons.bookBible,
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

      title: "ข้อมูลครู",
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
          title: Text("เพิ่มข้อมูล"),
          content: Column(
            children: [
              for (int i = 1; i < ti.length; i++) ...[
                TextField(
                  decoration: InputDecoration(hintText: "${ti[i]}"),
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
                    data.add([
                      update[0],
                      update[1],
                      update[2],
                      update[3],
                      update[4],
                      update[5],
                    ]);
                    print(data);

                    DB_update(
                        """INSERT INTO teacher (T_name, T_email, T_pass, T_phone, admin_teacher) 
                        VALUES ('${update[1]}', '${update[2]}', '${update[3]}', '${update[4]}', '${update[5]}');""");
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
  Future open_edit(index) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("แก้ไข้ข้อมูล"),
          content: Column(
            children: [
              for (int i = 1; i < ti.length; i++) ...[
                TextField(
                  decoration: InputDecoration(hintText: "${data[index][i]}"),
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
                    for (int i = 0; i < ti.length; i++) {
                      if (update[i] != '') {
                        data[index][i] = update[i];
                      }
                    }
                    print(update);
                    for (int x = 0; x < update.length; x++) {
                      var update_title = [
                        "T_id",
                        "T_name",
                        "T_email",
                        "T_pass",
                        "T_phone",
                        "admin_teacher"
                      ];

                      
                      if (update[x] != '') {
                        DB_update(
                                "update teacher set ${update_title[x]} ='${update[x]}' where T_id ='${data[index][0]}';");
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
                  DB_update(
                      "DELETE FROM teacher WHERE (T_id = '${data[index][0]}');");
                  data.removeAt(index);
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
          content: const Text('=เกิดข้อผิดพลาด'),
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
