import 'package:ai_mental_health_chatbot/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:huawei_account/huawei_account.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late AccountAuthService _authService;

  @override
  void initState() {
    super.initState();

    final AccountAuthParamsHelper authParamsHelper = AccountAuthParamsHelper()
      ..setProfile()
      ..setAccessToken();
    final AccountAuthParams authParams = authParamsHelper.createParams();
    _authService = AccountAuthManager.getService(authParams);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Image.asset(
                'assets/img/care.png', // Replace with your image URL
                // height: 100, // You can adjust the size
              ),
              // Add a title below the image
              const Text(
                'MindMate',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
            child: Column(
              children: [
                HuaweiIdAuthButton(
                  onPressed: _signIn,
                  elevation: 0,
                  borderRadius: AuthButtonRadius.SMALL,
                  buttonColor: AuthButtonBackground.RED,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _signIn() async {
    final AuthAccount account = await _authService.signIn();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Home(displayName: account.displayName ?? 'User', authService: _authService,),
      ),
    );
  }


}
