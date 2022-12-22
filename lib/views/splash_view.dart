import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_input/main.dart';
import 'package:test_input/views/dashboard.dart';
import 'package:test_input/views/login_page.dart';
import 'package:test_input/views/ms_employee.dart';
import 'package:test_input/views/profile_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isVisible = false;

  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      setState(() {
        isVisible = true;
      });
      toHomePage();
    });
    // TODO: implement initState
    super.initState();
  }

  toHomePage() {
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ProfilePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedSwitcher(
                duration: const Duration(seconds: 2),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: isVisible
                    ? FlutterLogo(size: screenSize.height / 4)
                    : const SizedBox()),
            const SizedBox(height: 25),
            const Text("Selamat Datang di Aplikasi Surgika...", style: TextStyle(fontSize: 18)),
            isVisible
                ? const Align(
                    heightFactor: 5,
                    alignment: Alignment.bottomCenter,
                    child: CircularProgressIndicator(color: Colors.grey))
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
