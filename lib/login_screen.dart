import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_login/flutter_login.dart';
import 'package:mysql_manager/src/mysql_manager.dart';
import 'package:project_database/dashboard_te_ad.dart';
import 'package:project_database/dashboard_te_no_ad.dart';
import 'lib/constants.dart';
import 'lib/custom_route.dart';
import 'lib/users.dart';
import 'dart:async';
import 'dashboard.dart';
import 'package:project_database/DB.dart';

// import 'show_te/table.dart';
int sw = 0;
String on_log = "";

class LoginScreen extends StatelessWidget {
  static const routeName = '/auth';

  const LoginScreen({Key? key}) : super(key: key);

  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);

  Future<String?> _loginUser(LoginData data) async {
    bool u = false;
    bool p = false;
    try {
      sw = 0;
      final MySQLManager manager = MySQLManager.instance;
      final conn = await manager.init(false, {
        'db': 'project1',
        'host': '127.0.0.1',
        'user': 'root',
        'password': '1234',
        'port': '3306'
      });
      var result = await conn.execute("SELECT T_email,T_pass FROM teacher");
      for (final row in result.rows) {
        if (row.assoc()["T_email"] == data.name) u = true;
        if (row.assoc()["T_pass"] == data.password) p = true;
        if (u && p) sw = 1;
      }
      if (u == false || p == false) {
        result = await conn.execute("SELECT S_email,pass FROM student");
        for (final row in result.rows) {
          if (row.assoc()["S_email"] == data.name) u = true;
          if (row.assoc()["pass"] == data.password) p = true;
          if (u && p) sw = 2;
        }
      }
      print(u);
      print(p);
      conn.close();
    } catch (e) {
      return 'ข้อผิดพลาดในการเชื่อมต่อเซิร์ฟเวอร์';
    }

    return Future.delayed(loginTime).then((_) {
      if (!u) {
        return 'อีเมลไม่ถูกต้องโปรเช็คอีกครั้ง';
      }
      if (!p) {
        return 'รหัสผ่านไม่ถูกต้องโปรเช็คอีกครั้ง';
      }
      return null;
    });
  }

  Future<String?> _signupUser(SignupData data) {
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String?> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {
      if (!mockUsers.containsKey(name)) {
        return 'User not exists';
      }
      return null;
    });
  }

  Future<String?> _signupConfirm(String error, LoginData data) {
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    on_log = "";
    return FlutterLogin(
      title: "ระบบดูเกรดนักศึกษา",
      // logo: const AssetImage('assets/images/ecorp.png'),
      logoTag: Constants.logoTag,

      titleTag: Constants.titleTag,
      navigateBackAfterRecovery: true,
      onConfirmRecover: _signupConfirm,
      onConfirmSignup: _signupConfirm,
      loginAfterSignUp: false,
      loginProviders: [],
      theme: LoginTheme(
          primaryColor: Color.fromARGB(255, 65, 65, 65),
          cardTheme: CardTheme(
            color: const Color.fromARGB(255, 255, 255, 255),
          )),

      userValidator: (value) {
        if (!value!.contains('@') || !value.endsWith('.ac.th')) {
          return "อีเมลต้องมี '@' และจบด้วย '.ac.th'";
        }
        return null;
      },
      passwordValidator: (value) {
        if (value!.isEmpty) {
          return 'โปรใส่รหัสผ่าน';
        }
        return null;
      },
      onLogin: (loginData) {
        debugPrint('Login info');
        debugPrint('Name: ${loginData.name}');
        debugPrint('Password: ${loginData.password}');
        on_log = loginData.name;
        return _loginUser(loginData);
      },
      onRecoverPassword: (name) {
        debugPrint('Recover password info');
        debugPrint('Name: $name');
        return _recoverPassword(name);
      },
      onSubmitAnimationCompleted: () {
        DB_read_r1(
                "SELECT admin_teacher FROM teacher where T_email = '$on_log';")
            .then((value) {
          if (sw == 1) {
            if(value[0] == '1'){
              Navigator.of(context).pushReplacement(
              FadePageRoute(
                builder: (context) => SidebarXExampleApp1(on_log),
              ),
            );
            }else{
              Navigator.of(context).pushReplacement(
              FadePageRoute(
                builder: (context) => SidebarXExampleApp_no_ad(on_log),
              ),
            );

            }
          }
          if (sw == 2) {
            Navigator.of(context).pushReplacement(
              FadePageRoute(
                builder: (context) => SidebarXExampleApp(on_log),
              ),
            );
          }
        });
      },
    );
  }
}
