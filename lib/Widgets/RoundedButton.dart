import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String btnText;
  final Function onBtnPressed;

  const RoundedButton({Key key, this.btnText, this.onBtnPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      color: Colors.orange,
      borderRadius: BorderRadius.circular(25),
      child: MaterialButton(
        onPressed: onBtnPressed,
        minWidth: 120.0,
        height: 30.0,
        child: Text(
          btnText,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
