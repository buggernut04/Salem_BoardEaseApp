import 'dart:async';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() {
    var duration = const Duration(seconds: 7);
    return Timer(duration, route);
  }

  route() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  void dispose() {
    startTimer().cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: content(),
    );
  }

  Widget content(){
    return Padding(
      padding: const EdgeInsets.only(left: 1),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Image.asset(
              'assets/app_logo.jpg',
              height: 100,
              width: 100,
              fit: BoxFit.contain,
            ),

            ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (Rect bounds){
                  return LinearGradient(
                    colors: [Colors.blue.shade800, Colors.blue.shade400],
                  ).createShader(bounds);
                },
                child: const Padding(
                  padding: EdgeInsets.only(top: 0),
                  child: Text(
                    'BoardEase',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                )
            ),

            /*FutureBuilder(
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  } else{
                    return ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (Rect bounds){
                          return LinearGradient(
                              colors: [Colors.blue.shade800, Colors.blue.shade400],
                          ).createShader(bounds);
                        },
                      child: const Padding(
                        padding: EdgeInsets.only(bottom: 0),
                        child: Text(
                          'BoardEase',
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      )
                    );
                  }
                }
            ),*/
          ],
        ),
      ),
    );
  }
}