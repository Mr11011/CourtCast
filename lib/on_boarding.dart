import 'package:courtcast/Core/features/auth/presentation/screens/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          // Wrap the entire body content with a Container
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/top-view-tennis-balls-ground.jpg'),
              fit: BoxFit.cover, // Adjust the fit as needed
            ),
          ),
          child: Center(
            // Keep your existing content within the Container
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: '  Welcome To\n',
                      style: TextStyle(
                        fontFamily: 'Fredoka',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'CourtCast',
                          style: TextStyle(
                            fontSize: 45,
                            fontFamily: 'PlaywriteDEGrund',
                            fontWeight: FontWeight.bold,
                            color: Colors.lightGreenAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Text('\n  Where every point is a victory',
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: 'Fredoka',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignInScreen()));
                    },
                    child: Text(
                      "Ready To Play ?",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold,fontFamily: 'karla',fontSize: 16),
                    ),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
