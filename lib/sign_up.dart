import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:protivity_app/log_in.dart';
import 'package:protivity_app/util.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _signUpKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 9, 16),
      body: Padding(
        padding: EdgeInsets.only(left: 24, top: 25, right: 24),
        child: SingleChildScrollView(
          child: Form(
            key: _signUpKey,
            child: Column(
              children: [
                Center(
                    child: Image.asset(
                        width: 500, height: 200, 'images/Logo_only.png')),
                Text(
                  'Create Your Account',
                  style: TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.normal,
                      fontSize: 24,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: _firstNameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    fillColor: Colors.grey,
                    filled: true,
                    hintText: 'First Name',
                    contentPadding: EdgeInsets.only(left: 14),
                    focusColor: Color(0xffA0A0A0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
                  ),
                  validator: (value) {
                    if (_firstNameController.text.isEmpty) {
                      return 'Enter First Name';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 25),
                TextFormField(
                  controller: _lastNameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      fillColor: Colors.grey,
                      filled: true,
                      hintText: 'Last Name',
                      contentPadding: EdgeInsets.only(left: 14),
                      focusColor: Color(0xffA0A0A0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none)),
                  validator: (value) {
                    if (_lastNameController.text.isEmpty) {
                      return 'Enter Last Name';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 25),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      fillColor: Colors.grey,
                      filled: true,
                      hintText: 'E-mail',
                      contentPadding: EdgeInsets.only(left: 14),
                      focusColor: Color(0xffA0A0A0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none)),
                  validator: (value) {
                    if (_emailController.text.isEmpty) {
                      return 'Enter E-mail';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 25),
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
                SizedBox(height: 70),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      signUp();
                    },
                    child: Text(
                      'Sign Up',
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
                      'Already have an account?',
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
                                builder: ((context) => LogIn())));
                      },
                      child: Text(
                        'LogIn',
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

  Future signUp() async {
    final isValid = _signUpKey.currentState!.validate();
    if (!isValid) return;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text)
          .then((value) {
        FirebaseFirestore.instance
            .collection('userData')
            .doc(value.user!.uid)
            .set({
          'email': value.user!.email,
          'first_name': _firstNameController.text,
          'last_name': _lastNameController.text
        });
        Navigator.push(
            context, MaterialPageRoute(builder: ((context) => LogIn())));
      });
    } on FirebaseAuthException catch (e) {
      failureSnackBar(context: context, message: e.message.toString());
    }
    Navigator.pop(context);
  }
}
