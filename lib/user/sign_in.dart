import 'package:flutter/material.dart';
import 'package:penyakit_daun/configure/constants.dart';
import 'package:penyakit_daun/home/home.dart';
import 'package:penyakit_daun/user/auth_service.dart';
import 'package:penyakit_daun/user/reset_password.dart';
import 'package:penyakit_daun/user/sign_up.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    // Cek apakah ada email dan kata sandi yang tersimpan di shared_preferences
    _loadSavedCredentials();
  }

  // Function untuk memuat email dan kata sandi yang tersimpan
  void _loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('email');
    String? savedPassword = prefs.getString('password');

    if (savedEmail != null && savedPassword != null) {
      setState(() {
        _emailController.text = savedEmail;
        _passwordController.text = savedPassword;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      //backgroundColor: Color.fromRGBO(255, 230, 173, 1.0),
      // appBar: AppBar(
      //   title: Icon(Icons.camera_alt),
      // ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.93,
              height: MediaQuery.of(context).size.height * 0.5, // Mengatur tinggi kontainer menjadi setengah dari tinggi layar
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(35),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget> [
                        // Padding(
                        //   padding: const EdgeInsets.all(10.0),
                        //   child: Text("Sign In",
                        //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: textlogin)),
                        // ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                          child:
                          TextFormField(
                            style: TextStyle(color: textlogin),
                            cursorColor: Colors.black,
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                // Based on passwordVisible state choose the icon
                                Icons.mail_outline_rounded,
                                color: iconlogin,
                              ),
                              hintText: 'email@gmail.com',
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: textlogin,
                              ),
                              // filled: true,
                              // fillColor: Colors.black12,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: colorlogin),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15.0), // Set the border radius to 20
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: colorlogin), // Warna garis saat difokuskan
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0), // Sudut border
                                ),
                              ),
                              labelStyle: TextStyle(color: textlogin),
                              labelText: "Email",
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                          child: TextFormField(
                            style: TextStyle(color: textlogin),
                            cursorColor: Colors.black,
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                // Based on passwordVisible state choose the icon
                                Icons.lock_outline_rounded,
                                color: iconlogin,
                              ),
                              hintText: '',
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              // filled: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: colorlogin),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15.0),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: colorlogin), // Warna garis saat difokuskan
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0), // Sudut border
                                ),
                              ),
                              labelText: "Kata Sandi",
                              labelStyle: TextStyle(color: textlogin),
                              suffixIcon: IconButton(
                                icon: Icon(_obscurePassword ? Icons.visibility_off_rounded :
                                Icons.visibility_rounded, color: iconlogin,),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        // const SizedBox(
                        //   height: 5.0,
                        // ),
                        // SignUp Navigation
                        TextButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (BuildContext context) => ResetPassword()));
                          },
                          style: ButtonStyle(
                            overlayColor: MaterialStateColor.resolveWith((states) => Colors.transparent), // Mengatur overlay color menjadi transparent
                          ),
                          child: Align(
                            alignment: Alignment.centerRight, // Mengatur posisi ke samping kanan
                            child: Text('Lupa Kata Sandi', style: TextStyle(color: iconlogin),),
                          ),
                        ),
                        Container(
                          height: 45,
                          // width: 350,
                          width: MediaQuery.of(context).size.width / 2.25,
                          child: ElevatedButton(
                            onPressed: () async {
                              // Simpan email dan kata sandi ke shared_preferences jika autofill diaktifkan
                              _saveCredentials();
                              // Lakukan login
                              final message = await AuthService().login(
                                email: _emailController.text,
                                password: _passwordController.text,
                              );
                              if (message!.contains('Sukses')) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Home(email: _emailController.text,),
                                  ),
                                );
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(message),
                                ),
                              );
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15), // Adjust the corner radius as desired

                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                button,
                                //const Color.fromRGBO(20, 26, 70, 1.0), // Red color (RGB: 255, 0, 0)
                              ),
                            ),
                            child: const Text('Masuk', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: textbutton),),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (BuildContext context) => SignUp()));
                          },
                          style: ButtonStyle(
                            overlayColor: MaterialStateColor.resolveWith((states) => Colors.transparent), // Mengatur overlay color menjadi transparent
                          ),
                          child: Text('Belum Memiliki Akun? Daftar',style: TextStyle(color: textlogin),),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Function untuk menyimpan email dan kata sandi ke shared_preferences
  void _saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', _emailController.text);
    prefs.setString('password', _passwordController.text);
  }
}
