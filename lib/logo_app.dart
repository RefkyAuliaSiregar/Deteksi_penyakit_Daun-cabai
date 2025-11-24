import 'dart:async';
import 'package:flutter/material.dart';
import 'package:penyakit_daun/configure/constants.dart';
import 'package:penyakit_daun/user/sign_in.dart';

class LogoApp extends StatefulWidget {
  const LogoApp({super.key});

  @override
  _LogoAppState createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> {
  @override
  void initState() {
    super.initState();
    // Timer untuk menunggu 3 detik dan kemudian navigasi ke halaman SignIn
    Timer(const Duration(seconds: 3), () {
      // Mengganti halaman ke SignIn setelah 3 detik
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignIn()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: 250,
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/selamat_datang.png'),
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/logo apk.1.png'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Container(
                width: 180,
                height: 180,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/teks2.png'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


