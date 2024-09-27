import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:courtcast/Core/features/auth/domain/auth_states.dart';
import 'package:courtcast/Core/features/auth/presentation/screens/sign_up.dart';
import 'package:courtcast/Core/features/auth/presentation/widgets/textfield.dart';
import 'package:courtcast/main.dart';
import 'package:courtcast/on_boarding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../domain/auth_cubit.dart';
import '../controller/auth_cubit/cubit/auth_cubit.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  var formKey = GlobalKey<FormState>();
  var EmailController = TextEditingController();
  var PasswordController = TextEditingController();
  bool isPasswordHidden = true;
  final TapGestureRecognizer _signUpRecognizer = TapGestureRecognizer();

  @override
  void dispose() {
    _signUpRecognizer.dispose(); // Dispose the recognizer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<authCubit, authStates>(
          listener: (context, state) {
            if (state is authStatesSuccess) {
              Fluttertoast.showToast(
                  msg: "Login Successfully",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.SNACKBAR,
                  backgroundColor: Colors.green);
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            } else if (state is authStatesError) {
              Fluttertoast.showToast(
                  msg: state.error,
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.SNACKBAR,
                  backgroundColor: Colors.redAccent);
            }
          },
          builder: (context, state) {
            return Stack(alignment: Alignment.center, children: [
              // Background Image Container
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/OB.png"),
                  ),
                ),
              ),
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Logo Image
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            image: DecorationImage(
                              fit: BoxFit.contain,
                              image: AssetImage("assets/smile.png"),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Welcome Back !",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'PlaywriteDEGrund'),
                        ),
                        SizedBox(height: 20),

                        // Email TextField
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 15.0, bottom: 18.0),
                          child: CustomTextFormField(
                            focusedCustomColor: Colors.purple,
                            controller: EmailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                Fluttertoast.showToast(
                                  msg: "Please Enter Your Email",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                                return 'Please Enter Your Email';
                              }
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                  .hasMatch(value)) {
                                Fluttertoast.showToast(
                                  msg: 'Enter a valid email',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                            labelText: "Email",
                            hintText: "Enter Your Email Address",
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icons.attach_email_rounded,
                          ),
                        ),

                        // Password TextField
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 18.0, bottom: 18.0),
                          child: CustomTextFormField(
                            controller: PasswordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Your Password';
                              }
                              return null;
                            },
                            labelText: "Password",
                            obscureText: isPasswordHidden,
                            focusedCustomColor: Colors.purple,
                            suffixIcon: isPasswordHidden
                                ? Icons.visibility_off
                                : Icons.visibility,
                            onSuffixIconPressed: () {
                              setState(() {
                                isPasswordHidden = !isPasswordHidden;
                              });
                            },
                            hintText: "Enter Your Password",
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icons.lock,
                          ),
                        ),
                        SizedBox(height: 20),
                        // Sign In Button
                        ConditionalBuilder(
                          builder: (context) => ElevatedButton(
                            onPressed: () async {
                              String message = '';
                              if (formKey.currentState!.validate()) {
                                authCubit.get(context).signInWithFirebase(
                                    EmailController.text.trim(),
                                    PasswordController.text.trim());
                              }
                            },
                            child: Text(
                              "Let's Play",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                            ),
                          ),
                          condition: state is! authStatesLoading,
                          fallback: (context) => CircularProgressIndicator(),
                        ),
                        SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(
                                  text: "Don't have an account?",
                                  style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontFamily: 'PlaywriteDEGrund',
                                      fontSize: 16),
                                  children: [
                                    TextSpan(
                                      text: " Sign up",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          fontFamily: 'PlaywriteDEGrund'),
                                      recognizer: _signUpRecognizer
                                        ..onTap = () {
                                          // Code to navigate to the sign-up screen
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SignUpScreen(), // Replace with your actual sign-up screen widget
                                            ),
                                          );
                                        },
                                    )
                                  ]),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ]);
          },
        ),
      ),
    );
  }
}
