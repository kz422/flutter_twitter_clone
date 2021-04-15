import 'package:flutter/material.dart';
import 'package:twitterclone/Services/auth_service.dart';

class ResisterScreen extends StatefulWidget {
  ResisterScreen({Key key}) : super(key: key);

  @override
  _ResisterScreenState createState() => _ResisterScreenState();
}

class _ResisterScreenState extends State<ResisterScreen> {
  String _email;
  String _pw;
  String _name;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.cyan[100], Colors.blue])),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/twitterlogo.png',
                    height: 40,
                  ),
                  SizedBox(height: 30),
                  Text(
                    'ニックネーム、メールアドレス、パスワードを\n入力してください',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  TextField(
                    decoration: InputDecoration(
                        hintText: 'Name',
                        hintStyle: TextStyle(color: Colors.white)),
                    onChanged: (value) {
                      _name = value;
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Colors.white)),
                    onChanged: (value) {
                      _email = value;
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.white)),
                    onChanged: (value) {
                      _pw = value;
                    },
                  ),
                  SizedBox(
                    height: 26,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.symmetric(horizontal: 40, vertical: 10)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: Colors.white))),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.orange),
                    ),
                    child: Text(
                      '登録',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      bool isValid =
                          await AuthService.signUp(_name, _email, _pw);
                      if (isValid) {
                        Navigator.pop(context);
                      } else {
                        print('oops');
                      }
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'キャンセル',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
