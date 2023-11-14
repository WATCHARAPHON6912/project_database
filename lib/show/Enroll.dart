import 'package:flutter/material.dart';
import 'dart:collection';

class enroll extends StatefulWidget {
  const enroll({super.key});

  @override
  State<enroll> createState() => _enrollState();
}

class _enrollState extends State<enroll> {
  @override
  List<String> register = [];
  List<String> not_registered = [];
  void initState() {
    super.initState();
    for (int i = 1; i <= 9; i++) {
      not_registered.add("วิชา $i");
    }
    print("enroll");
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
    return  Row(
      children: [
        Container(
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
          width: (MediaQuery.of(context).size.width / 2) - 55,
          height: MediaQuery.of(context).size.height - 20,
          // color: Colors.red,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.deepPurple.shade800,
          ),
        ),
        Padding(padding: const EdgeInsets.only(left: 10)),
        Container(
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
          width: (MediaQuery.of(context).size.width / 2) - 55,
          height: MediaQuery.of(context).size.height - 20,
          // color: Colors.red,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Color.fromARGB(255, 76, 242, 148),
          ),
        )
      ],
    );
  }
}
// Row(
//       children: [
//         Container(
//           child: ListView.builder(
//             itemCount: register.length,
//             padding: const EdgeInsets.only(top: 10, left: 10),
//             itemBuilder: (context, index) => Container(
//               alignment: Alignment.center,
//               child: ListTile(
//                   leading: IconButton(
//                     icon: Icon(Icons.delete, color: Colors.red, size: 30),
//                     onPressed: () {
//                       del(index);
//                     },
//                   ),
//                   title: Text(
//                     register[index],
//                     style: TextStyle(
//                         color: const Color.fromARGB(255, 255, 255, 255),
//                         fontSize: 30),
//                   )),
//               // child: Text("วิชา ${index+1}",style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255),fontSize: 50),),
//               height: 90,
//               width: double.infinity,
//               margin: const EdgeInsets.only(bottom: 10, right: 10),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 color: Theme.of(context).canvasColor,
//                 // boxShadow: const [BoxShadow()],
//               ),
//             ),
//           ),
//           width: (MediaQuery.of(context).size.width / 2) - 55,
//           height: MediaQuery.of(context).size.height - 20,
//           // color: Colors.red,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.all(Radius.circular(20)),
//             color: Colors.deepPurple.shade800,
//           ),
//         ),
//         Padding(padding: const EdgeInsets.only(left: 10)),
//         Container(
//           child: ListView.builder(
//             itemCount: not_registered.length,
//             padding: const EdgeInsets.only(top: 10, left: 10),
//             itemBuilder: (context, index) => Container(
//               alignment: Alignment.center,
//               child: ListTile(
//                   leading: IconButton(
//                     icon: Icon(Icons.add, color: Colors.green, size: 30),
//                     onPressed: () {
//                       add(index);
//                     },
//                   ),
//                   title: Text(
//                     not_registered[index],
//                     style: TextStyle(
//                         color: const Color.fromARGB(255, 255, 255, 255),
//                         fontSize: 30),
//                   )),
//               // child: Text("วิชา ${index+1}",style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255),fontSize: 50),),
//               height: 90,
//               width: double.infinity,
//               margin: const EdgeInsets.only(bottom: 10, right: 10),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 color: Theme.of(context).canvasColor,
//                 // boxShadow: const [BoxShadow()],
//               ),
//             ),
//           ),
//           width: (MediaQuery.of(context).size.width / 2) - 55,
//           height: MediaQuery.of(context).size.height - 20,
//           // color: Colors.red,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.all(Radius.circular(20)),
//             color: Color.fromARGB(255, 76, 242, 148),
//           ),
//         )
//       ],
//     );