import 'package:dashboard_mobile/constants/colors.dart';
import 'package:flutter/material.dart';

// Widgets
import 'package:dashboard_mobile/widgets/loading_widget.dart';

class LoginButton extends StatefulWidget {
  final Function() onTap;
  final bool isLoading;
  final double loadingSize;

  LoginButton({
    super.key, 
    required this.onTap, 
    required this.isLoading,
    this.loadingSize = 20, 
  });

  @override
  _LoginButtonState createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isLoading ? null : widget.onTap, 
      child: Container(
        width: MediaQuery.of(context).size.width - 50,
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Color.fromRGBO(67, 169, 162, 1),
          borderRadius: BorderRadius.circular(5),
        ),
        alignment: Alignment.center,
        child: widget.isLoading
            ? LoadingWidget(
                size: widget.loadingSize,
                color: baseColor,
              ) 
            : Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
