import 'package:flutter/material.dart';

// Screens
import 'package:dashboard_mobile/screens/layout_screen.dart';

// Services
import 'package:dashboard_mobile/services/token_service.dart';
import 'package:dashboard_mobile/services/auth_service.dart';

// Constants
import 'package:dashboard_mobile/constants/strings.dart';
import 'package:dashboard_mobile/constants/colors.dart';

// Components
import 'package:dashboard_mobile/components/login/login_input.dart';
import 'package:dashboard_mobile/components/login/login_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthService authService = AuthService();

  bool keyboardVisible = false;
  bool isLoading = false;
  late AnimationController animationController;
  late Animation<double> animation;

  int? id;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this
    );
    animation = Tween(begin: 0.0, end: 1.0).animate(animationController);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void login(BuildContext context) async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            emailPasswordErrorMessage,
            textAlign: TextAlign.center,
          ),
          backgroundColor: errorColor,
          duration: Duration(milliseconds: 1000),
        ),
      );
      Future.delayed(Duration(milliseconds: 1000), () {
        ScaffoldMessenger.of(context).clearSnackBars();
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await Future.delayed(Duration(seconds: 2)); 
      final result = await authService.login(email, password);

      if (result['success']) {
        String token = result['token'];
        String refreshToken = result['refreshToken'];
        await TokenService.setToken(token, refreshToken);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              loginSuccessMessage,
              textAlign: TextAlign.center,
            ),
            backgroundColor: baseColor,
            duration: Duration(milliseconds: 1000),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LayoutScreen(id: id)),
        );

        print('Login successful: Token: $token, Refresh token: $refreshToken');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              loginErrorMessage,
              textAlign: TextAlign.center,
            ),
            backgroundColor: errorColor,
          ),
        );
        Future.delayed(Duration(milliseconds: 1000), () {
          ScaffoldMessenger.of(context).clearSnackBars();
        });
        print('Login failed: ${result['message']}');
      }
    } catch (error) {
      print('Error occurred: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(genericErrorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (keyboardVisible) {
        animationController.forward();
      }
      else {
        animationController.reverse();
      }
    });

    return Scaffold(
      backgroundColor: Colors.grey[50],
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 150),
                AnimatedPadding(
                  padding: EdgeInsets.only(top: keyboardVisible ? 0 : 10), 
                  duration: const Duration(milliseconds: 200),
                  child: LoginInput(
                    controller: emailController,
                    hintText: "Username",
                    obscureText: false,
                  ),
                ),
                AnimatedPadding(
                  padding: EdgeInsets.only(top: keyboardVisible ? 12 : 18), 
                  duration: const Duration(milliseconds: 200),
                  child: LoginInput(
                    controller: passwordController, 
                    hintText: "Password",
                    obscureText: true
                  ),
                ),
                AnimatedPadding(
                  padding: EdgeInsets.only(top: keyboardVisible ? 12 : 18), 
                  duration: const Duration(milliseconds: 200),
                  child: LoginButton(
                    isLoading: isLoading,
                    onTap: () => login(context),
                  ),
                )
              ],
            ),
          ),
        )
      ),
    );
  }
}
