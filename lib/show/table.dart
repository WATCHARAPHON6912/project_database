import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Example without a datasource
class DataTable2SimpleDemo extends StatelessWidget {
  const DataTable2SimpleDemo();

  @override
  Widget build(BuildContext context) {
    final Color colum_color = Color.fromARGB(255, 255, 255, 255);
    final Color data_color = Colors.white;
    List<DataColumn> ti = [
      DataColumn2(
        label: Text('ชื่อวิชา', style: TextStyle(color: colum_color)),
        size: ColumnSize.L,
      ),
    ];

    List<DataCell> data = [DataCell(Text('A', style: TextStyle(color: data_color)))];

    for (int i = 1; i <= 10; i++) {
      ti.add(DataColumn2(label: Text('งานที่$i', style: TextStyle(color: colum_color)),size: ColumnSize.L));
      data.add(DataCell(Text('A$i', style: TextStyle(color: data_color))));
    }
    
    ti.add(DataColumn2(label: Text('รวม', style: TextStyle(color: colum_color)),size: ColumnSize.L));
    data.add(DataCell(Text('h', style: TextStyle(color: data_color))));

    return Padding(
      padding: const EdgeInsets.all(16),
      child: DataTable2(
        columnSpacing: 12,
        horizontalMargin: 12,
        minWidth: 600,
        columns: ti,
        rows: List<DataRow>.generate(
          50,
          (index) => DataRow(cells: data),
        ),
      ),
    );
  }
}
