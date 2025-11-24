import 'dart:async';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:penyakit_daun/firebase_options.dart';
import 'package:penyakit_daun/logo_app.dart';
import 'package:penyakit_daun/user/sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    // webRecaptchaSiteKey: 'recaptcha-v3-site-key'
    // Set androidProvider to `AndroidProvider.debug`
    androidProvider: AndroidProvider.debug,
  );

  runApp(await ChiliLeafDeseasse.initialize());
}

class ChiliLeafDeseasse extends StatefulWidget {
  // const ChiliLeafDeseasse({super.key});
  final String? authToken;
  ChiliLeafDeseasse({this.authToken});

  static Future<ChiliLeafDeseasse> initialize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('authToken');
    return ChiliLeafDeseasse(authToken: authToken);
  }

  @override
  State<ChiliLeafDeseasse> createState() => _ChiliLeafDeseasseState();
}

class _ChiliLeafDeseasseState extends State<ChiliLeafDeseasse> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimeout();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimeout() {
    const timeout = Duration(minutes: 30);
    _timer = Timer(timeout, _handleTimeout);
  }

  void _handleTimeout() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('authToken');
      _handleLogout();
    });
  }

  void _restartTimeout() {
    _timer.cancel();
    _startTimeout();
  }

  Future<void> _handleLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');

    // Dapatkan context yang valid dari widget ChiliLeafDeseasse
    BuildContext context = this.context;

    // Navigate ke halaman login menggunakan widget langsung dan hapus semua route sebelumnya
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (BuildContext context) => SignIn(), // Ganti SignIn dengan widget halaman login Anda
      ),
          (Route<dynamic> route) => false, // Menghapus semua route sebelumnya
    );
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chili Leaf Disease',
      themeMode: ThemeMode.system,
      // Menentukan halaman pertama berdasarkan authToken
      home: widget.authToken != null ? SignIn() : LogoApp(),
      builder: (context, child) {
        _restartTimeout();
        return child!;
      },
    );
  }

}

