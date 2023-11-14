import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'login_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_database/show_te/home_te.dart';
// import 'DB.dart';
import 'package:project_database/show_te/table_te_st.dart';
import 'show_te/class.dart';
import 'package:project_database/show_te/add_class.dart';
import 'show_te/table_te_te.dart';
import 'long.dart';
class SidebarXExampleApp1 extends StatelessWidget {
  static const routeName = '/dash';

  SidebarXExampleApp1(this.email);
  final String email;

  final _controller = SidebarXController(selectedIndex: 0);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SidebarX Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        canvasColor: canvasColor,
        scaffoldBackgroundColor: scaffoldBackgroundColor,
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            color: Colors.white,
            fontSize: 46,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      home: Scaffold(
        body: Row(
          children: [
            SidebarX(
              controller: _controller,
              theme: SidebarXTheme(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: canvasColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                textStyle: const TextStyle(color: Colors.white),
                selectedTextStyle: const TextStyle(color: Colors.white),
                itemTextPadding: const EdgeInsets.only(left: 30),
                selectedItemTextPadding: const EdgeInsets.only(left: 30),
                itemDecoration: BoxDecoration(
                  border: Border.all(color: canvasColor),
                ),
                selectedItemDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: actionColor.withOpacity(0.37),
                  ),
                  gradient: const LinearGradient(
                    colors: [accentCanvasColor, canvasColor],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.28),
                      blurRadius: 30,
                    )
                  ],
                ),
                iconTheme: const IconThemeData(
                  color: Colors.white,
                  size: 20,
                ),
              ),
              extendedTheme: const SidebarXTheme(
                width: 200,
                decoration: BoxDecoration(
                  color: canvasColor,
                ),
                margin: EdgeInsets.only(right: 10),
              ),
              footerDivider: divider,
              headerBuilder: (context, extended) {
                return SizedBox(
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset('assets/images/avatar.png'),
                  ),
                );
              },
              items: [
                SidebarXItem(
                  icon: Icons.home,
                  label: 'ข้อมูลผู้ใช้',
                  onTap: () {
                    
                  },
                ),
               
                SidebarXItem(
                  icon: Icons.score,
                  label: 'ข้อมูลคะแนน',
                ),
                SidebarXItem(
                  icon: Icons.ad_units,
                  label: 'คลาส',
                ),
                 SidebarXItem(
                  icon:  FontAwesomeIcons.bookBible,
                  label: 'ข้อมูลครู',
                ),
                 SidebarXItem(
                  icon: Icons.book,
                  label: 'ข้อมูลนักศึกษา',
                ),
                 SidebarXItem(
                  icon: Icons.radio_button_on,
                  label: 'การลงทะเบียน',
                ),
                SidebarXItem(
                  icon: Icons.logout,
                  label: 'ออกจากระบบ',
                  onTap: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
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
                      content: const Text('คุณต้องการออกจากระบบหรือไม่!'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'ยกเลิก'),
                          child: const Text('ยกเลิก'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen())),
                          child: const Text('ตกลง'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: _ScreensExample(_controller,email),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScreensExample extends StatelessWidget {
  const _ScreensExample(this.controller,this.email);
  final String email;

  final SidebarXController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        switch (controller.selectedIndex) {
          case 0:
            return home_te(email);
          case 1:
            return Class(email);
          case 2:
            return add_class(email);
          case 3:
            return table_te();
          case 4:
            return table_te_te();
          case 5:
            return long();
          default:
            return Text(
              'Not found page',
              style: theme.textTheme.headlineSmall,
            );
        }
      },
    );
  }
}

const primaryColor = Colors.white;
const canvasColor = Color(0xFF2E2E48);
const scaffoldBackgroundColor = Color(0xFF464667);
const accentCanvasColor = Color.fromARGB(255, 0, 26, 255);
const white = Colors.white;
final actionColor = const Color(0xFF5F5FA7).withOpacity(0.6);

final divider = Divider(color: white.withOpacity(0.3), height: 1);
