import 'package:flutter/material.dart';
import 'package:twitterclone/Widgets/RoundedButton.dart';
import 'package:twitterclone/screens/LoginScreen.dart';
import 'package:twitterclone/screens/ResisterScreen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Image.asset(
                  'assets/top.png',
                  height: 200,
                ),
                Text(
                  'Welcome',
                  style: TextStyle(fontSize: 42.0),
                ),
              ],
            ),
            Column(
              children: [
                RoundedButton(
                  btnText: 'Login',
                  onBtnPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => LoginScreen(),
                        ));
                  },
                ),
                SizedBox(
                  height: 32.0,
                ),
                RoundedButton(
                  btnText: 'Resister',
                  onBtnPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => ResisterScreen(),
                        ));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
