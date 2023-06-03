import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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
    var duration = const Duration(seconds: 5);
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Lottie.asset(
                'assets/house-loading-icon.json',
                height: 100,
                width: 100,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 0),
            FutureBuilder(
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
            ),
          ],
        ),
      ),
    );
  }
}