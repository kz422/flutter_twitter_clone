import 'package:flutter/material.dart';
import 'package:twitterclone/Services/auth_service.dart';
import 'package:twitterclone/Widgets/RoundedButton.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email;
  String _pw;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Login'),
          backgroundColor: Colors.blueGrey,
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(hintText: 'Email'),
                  onChanged: (value) {
                    _email = value;
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(hintText: 'PW'),
                  onChanged: (value) {
                    _pw = value;
                  },
                ),
                SizedBox(
                  height: 26,
                ),
                RoundedButton(
                  btnText: 'Submit',
                  onBtnPressed: () async {
                    bool isValid = await AuthService.signIn(_email, _pw);
                    if (isValid) {
                      Navigator.pop(context);
                    } else {
                      print('oops');
                    }
                  },
                )
              ],
            ),
          ),
        ));
  }
}