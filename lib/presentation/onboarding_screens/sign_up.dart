import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:protivity_app/core/size_config.dart';
import 'package:protivity_app/presentation/onboarding_screens/log_in.dart';
import 'package:protivity_app/core/util.dart';

import '../../core/widgets/custom_input_widget.dart';

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
    SizeConfig.init(context);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 9, 16),
      body: Padding(
        padding: EdgeInsets.only(
            left: getProportionateScreenWidth(24),
            top: getProportionateScreenHeight(25),
            right: getProportionateScreenWidth(24)),
        child: SingleChildScrollView(
          child: Form(
            key: _signUpKey,
            child: Column(
              children: [
                Center(
                    child: SizedBox(
                        height: getProportionateScreenHeight(250),
                        width: getProportionateScreenWidth(300),
                        child: Image.asset('images/Logo_only.png'))),
                Text(
                  'Create Your Account',
                  style: TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.normal,
                      fontSize: getProportionateScreenWidth(30),
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: getProportionateScreenHeight(30)),
                CustomInputField(
                  keyboard: TextInputType.name,
                  inputController: _firstNameController,
                  hintText: 'First Name',
                ),
                SizedBox(
                  height: getProportionateScreenHeight(25),
                ),
                CustomInputField(
                  keyboard: TextInputType.name,
                  inputController: _lastNameController,
                  hintText: 'Last Name',
                ),
                SizedBox(
                  height: getProportionateScreenHeight(25),
                ),
                CustomInputField(
                  keyboard: TextInputType.emailAddress,
                  inputController: _emailController,
                  hintText: 'E-mail',
                ),
                SizedBox(
                  height: getProportionateScreenHeight(25),
                ),
                TextFormField(
                  obscureText: true,
                  controller: _passwordController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      fillColor: Colors.grey,
                      filled: true,
                      hintText: 'Password',
                      contentPadding: EdgeInsets.only(
                          left: getProportionateScreenWidth(14)),
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
                SizedBox(height: getProportionateScreenHeight(70)),
                SizedBox(
                  width: double.infinity,
                  height: getProportionateScreenHeight(60),
                  child: ElevatedButton(
                    onPressed: () {
                      signUp();
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Color(0xffF1E9E9),
                        fontSize: getProportionateScreenWidth(22),
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
                SizedBox(height: getProportionateScreenHeight(5)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: getProportionateScreenWidth(14),
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: ((context) => LogIn())));
                      },
                      child: Text(
                        'LogIn',
                        style: TextStyle(
                            fontSize: getProportionateScreenWidth(14),
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
        print('i am ok here');
        // Navigator.pop(context);
        print('out out');
        Navigator.push(
            context, MaterialPageRoute(builder: ((context) => LogIn())));
      });
    } on FirebaseAuthException catch (e) {
      print('i am in error');
      print(e.message!);
      Navigator.pop(context);
      failureSnackBar(context: context, message: e.message!);
      // successSnackBar(context: context, message: e.message!);
    }
  }
}
