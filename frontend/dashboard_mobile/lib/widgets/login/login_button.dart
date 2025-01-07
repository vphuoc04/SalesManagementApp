import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final Function() ?onTap;

  LoginButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width - 50,
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Color.fromRGBO(67, 169, 162, 1),
          borderRadius: BorderRadius.circular(5)
        ),
        alignment: Alignment.center,
        child: Text(
          'Login',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}