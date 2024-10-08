import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:courtcast/Core/features/auth/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../fetch_weather_conditions/presentation/screens/weather_screen.dart';
import 'controller/cubit/auth_cubit.dart';
import 'controller/states/auth_states.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _firebaseAuth = FirebaseAuth.instance;
  var EmailController = TextEditingController();
  var UserNameController = TextEditingController();
  var PasswordController = TextEditingController();
  bool isPasswordHidden = true;
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<authCubit, authStates>(
          listener: (context, state) {
            if (state is signUpStatesSuccess) {
              Fluttertoast.showToast(
                  msg: "Sign Up Successfully",
                  toastLength: Toast.LENGTH_SHORT,
                  backgroundColor: Colors.green);

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const WeatherScreen()),
                    (Route<dynamic> route) => false,
              );
            } else if (state is signUpStatesError) {
              Fluttertoast.showToast(
                  msg: state.error,
                  toastLength: Toast.LENGTH_LONG,
                  backgroundColor: Colors.redAccent);
            }
          },
          builder: (context, state) {
            return Stack(alignment: Alignment.center, children: [
              // Background Image Container
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  image: const DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage("assets/OB.png"),
                  ),
                ),
              ),
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Background Image Container
                        Center(
                          child: Container(
                            alignment: Alignment.center,
                            height: 150,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              image: const DecorationImage(
                                fit: BoxFit.contain,
                                image: AssetImage("assets/char3.png"),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Create Account",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              fontFamily: 'PlaywriteDEGrund'),
                        ),

                        // Username TextField
                        Padding(
                          padding:
                          const EdgeInsets.only(bottom: 18.0, top: 35.0),
                          child: CustomTextFormField(
                            controller: UserNameController,
                            labelText: "Username",
                            focusedCustomColor: Colors.purple,
                            keyboardType: TextInputType.name,
                            hintText: "Enter your preferred username",
                            prefixIcon: Icons.account_circle,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Username should not be empty';
                              }
                              return null;
                            },
                          ),
                        ),

                        // Email TextField
                        Padding(
                          padding:
                          const EdgeInsets.only(bottom: 18.0, top: 18.0),
                          child: CustomTextFormField(
                            controller: EmailController,
                            labelText: "Email",
                            keyboardType: TextInputType.emailAddress,
                            focusedCustomColor: Colors.purple,
                            hintText: "Enter your email here",
                            prefixIcon: Icons.attach_email_outlined,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
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
                                    fontSize: 16.0);
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                          ),
                        ),

                        // Password
                        Padding(
                          padding:
                          const EdgeInsets.only(bottom: 30.0, top: 18.0),
                          child: CustomTextFormField(
                            controller: PasswordController,
                            labelText: "Password",
                            obscureText: isPasswordHidden,
                            focusedCustomColor: Colors.purple,
                            keyboardType: TextInputType.visiblePassword,
                            hintText: "Enter your strong password",
                            prefixIcon: Icons.lock,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password Cannot Be Empty';
                              }
                              return null;
                            },
                            suffixIcon: isPasswordHidden
                                ? Icons.visibility
                                : Icons.visibility_off,
                            onSuffixIconPressed: () {
                              setState(() {
                                isPasswordHidden = !isPasswordHidden;
                              });
                            },
                          ),
                        ),

                        ConditionalBuilder(
                          builder: (context) => Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  authCubit.get(context).signUpWithFirebase(
                                      EmailController.text.trim(),
                                      PasswordController.text.trim());
                                }
                              },
                              child: const Text(
                                "Let's Go",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber,
                                  minimumSize: const Size(150, 50)),
                            ),
                          ),
                          fallback: (context) =>
                              const Center(child: CircularProgressIndicator()),
                          condition: state is! authStatesLoading,
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