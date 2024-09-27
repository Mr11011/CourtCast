import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../../main.dart'; // Adjust this path as needed
import '../../domain/auth_cubit.dart';
import '../controller/auth_cubit/states/auth_states.dart';
import '../widgets/textfield.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var emailController = TextEditingController();
  var userNameController = TextEditingController();
  var passwordController = TextEditingController();
  bool isPasswordHidden = true;
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccessState) {
              Fluttertoast.showToast(
                  msg: "Sign Up Successfully",
                  toastLength: Toast.LENGTH_SHORT,
                  backgroundColor: Colors.green);

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const HomePage()),
                (Route<dynamic> route) => false,
              );
            } else if (state is AuthErrorState) {
              Fluttertoast.showToast(
                  msg: state.error,
                  toastLength: Toast.LENGTH_LONG,
                  backgroundColor: Colors.redAccent);
            }
          },
          builder: (context, state) {
            return Stack(
              alignment: Alignment.center,
              children: [
                // Background Image Container
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
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
                              controller: userNameController,
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
                              controller: emailController,
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
                              controller: passwordController,
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

                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  context.read<AuthCubit>().signUp(
                                        emailController.text.trim(),
                                        passwordController.text.trim(),
                                      );
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
                          if (state is AuthLoadingState)
                            const Center(child: CircularProgressIndicator()),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
