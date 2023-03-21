import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:protivity_app/core/size_config.dart';
import 'package:protivity_app/core/widgets/custom_input_widget.dart';
import 'package:protivity_app/presentation/onboarding_screens/sign_up.dart';
import 'package:protivity_app/core/util.dart';

import '../task_management_screens/home.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _logInKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 9, 16),
      body: Padding(
        padding: const EdgeInsets.only(left: 24, top: 25, right: 24),
        child: Form(
          key: _logInKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                    child: Image.asset(
                        width: 500, height: 200, 'images/Logo_only.png')),
                Text(
                  'LogIn to Your Account',
                  style: TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.normal,
                      fontSize: 24,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 30),
                CustomInputField(
                    inputController: _emailController, hintText: 'E-mail'),
                SizedBox(height: 30),
                TextFormField(
                  obscureText: true,
                  controller: _passwordController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      fillColor: Colors.grey,
                      filled: true,
                      hintText: 'Password',
                      contentPadding: EdgeInsets.only(left: 14),
                      focusColor: Color(0xffA0A0A0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none)),
                  validator: (value) {
                    if (_passwordController.text.isEmpty) {
                      return 'Enter Password';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 210),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      logIn();
                    },
                    child: Text(
                      'Log In',
                      style: TextStyle(
                        color: Color(0xffF1E9E9),
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    )),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account?',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => SignUp())));
                      },
                      child: Text(
                        'SignUp',
                        style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff3484ED)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future logIn() async {
    final isValid = _logInKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
              child: CircularProgressIndicator(),
            ));

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text)
          .then((value) => Navigator.push(
              context, MaterialPageRoute(builder: ((context) => TaskHome()))));
    } on FirebaseAuthException catch (e) {
      failureSnackBar(context: context, message: e.message.toString());
    }
    Navigator.pop(context);
  }
}
