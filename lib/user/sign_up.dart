import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/scheduler.dart';
import 'package:penyakit_daun/configure/constants.dart';
import 'package:penyakit_daun/user/sign_in.dart';

FirebaseAuth auth = FirebaseAuth.instance;
DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("users");

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _passwordVisible1 = false;
  bool _passwordVisible2 = false;
  static bool visible = false;

  void initState() {
    super.initState();
    visible = false;
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _userPasswordController1 = TextEditingController();
  TextEditingController _userPasswordController2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.93,
                height: MediaQuery.of(context).size.height * 0.6,
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
                        children: <Widget>[
                          // Padding(
                          //   padding: const EdgeInsets.all(10.0),
                          //   child: Text("Create Account",
                          //       style: TextStyle(
                          //           fontWeight: FontWeight.bold,
                          //           fontSize: 20,
                          //           color: textlogin,
                          //       )),
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 15, bottom: 0),
                            child: TextFormField(
                              style: TextStyle(color: textlogin),
                              cursorColor: Colors.black,
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.mail_outline_rounded,
                                    color: iconlogin,
                                  ),
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
                                  labelStyle: TextStyle(color: textlogin),
                                  labelText: 'Email',
                                  hintStyle: TextStyle(color: textlogin),
                                  hintText: 'email@gmail.com'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 10, bottom: 0),
                            child: TextFormField(
                              style: TextStyle(color: textlogin),
                              cursorColor: Colors.black,
                              controller: _usernameController,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.account_circle_outlined,
                                    color: iconlogin,
                                  ),
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
                                  labelStyle: TextStyle(color: textlogin),
                                  hintStyle: TextStyle(color: textlogin),
                                  labelText: 'Nama Pengguna',
                                  hintText: 'Nama Pengguna'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 10.0, bottom: 0.0),
                            child: TextFormField(
                              style: TextStyle(color: textlogin),
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.visiblePassword,
                              controller: _userPasswordController1,
                              obscureText: !_passwordVisible1,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.lock_outline_rounded,
                                    color: iconlogin,
                                  ),
                                  suffixIcon: IconButton(
                                      icon: Icon(
                                        _passwordVisible1
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: iconlogin,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _passwordVisible1 = !_passwordVisible1;
                                        });
                                      }),
                                  hintStyle: TextStyle(color: textlogin),
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
                                  labelStyle: TextStyle(color: textlogin),
                                  labelText: 'kata Sandi',
                                  hintText: ''),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 10.0, bottom: 40.0),
                            child: TextFormField(
                              style: TextStyle(color: textlogin),
                              controller: _userPasswordController2,
                              obscureText: !_passwordVisible2,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.lock_outline_rounded,
                                    color: iconlogin,
                                  ),
                                  suffixIcon: IconButton(
                                      icon: Icon(
                                        _passwordVisible2
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: iconlogin,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _passwordVisible2 = !_passwordVisible2;
                                        });
                                      }),
                                  hintStyle: TextStyle(color: textlogin),
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
                                  labelText: 'Konfirmasi Kata Sandi',
                                  labelStyle: TextStyle(color: textlogin),
                                  hintText: ''),
                            ),
                          ),
                          Container(
                            height: 45,
                            width: MediaQuery.of(context).size.width / 2.25,
                            child: ElevatedButton(
                              onPressed: () {
                                if (!_emailController.text.contains('@')) {
                                  displayToastMessage('Masukkan Email yang Valid', context);
                                } else if (_usernameController.text.isEmpty) {
                                  displayToastMessage('Masukkan Nama Anda', context);
                                } else if (_userPasswordController1.text.length < 8) {
                                  displayToastMessage(
                                      'Kata Sandi Harus memiliki minimal 8 karakter',
                                      context);
                                } else if (_userPasswordController1.text !=
                                    _userPasswordController2.text) {
                                  displayToastMessage(
                                      'Kata Sandi Tidak Valid', context);
                                } else {
                                  setState(() {
                                    load();
                                  });
                                  registerNewUser(context);
                                }
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                backgroundColor: MaterialStateProperty.all<Color>(
                                  button,
                                ),
                              ),
                              child: Text(
                                'Daftar',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: textbutton),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (BuildContext context) => SignIn()));
                            },
                            style: ButtonStyle(
                              overlayColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
                            ),
                            child: Text('Sudah Punya Akun? Masuk', style: TextStyle(color: textlogin)),
                          ),
                          Visibility(
                            maintainSize: true,
                            maintainAnimation: true,
                            maintainState: true,
                            visible: visible,
                            child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                child: Container(
                                    width: 290,
                                    margin: EdgeInsets.only(),
                                    child: LinearProgressIndicator(
                                      minHeight: 2,
                                      backgroundColor: Colors.blueGrey[800],
                                      valueColor: AlwaysStoppedAnimation(Colors.white),
                                    ))),
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
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _userPasswordController1.dispose();
    _userPasswordController2.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> sendVerificationEmail(User user) async {
    await user.sendEmailVerification();
    displayToastMessage('Verifikasi Email Sudah dikirim ke ${user.email}', context);
  }

  Future<void> registerNewUser(BuildContext context) async {
    User? currentUser;
    try {
      currentUser = (await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _userPasswordController1.text.trim())).user;

      if (currentUser != null) {
        await sendVerificationEmail(currentUser);

        // Check if the user already exists
        DatabaseEvent event = await dbRef.child(currentUser.uid).once();
        DataSnapshot snapshot = event.snapshot;
        if (!snapshot.exists) {
          // User does not exist, add user data
          Map<String, String> userDataMap = {
            'User Name': _usernameController.text.trim(),
            'Email': _emailController.text.trim(),
            'User UID' : currentUser.uid,
          };

          dbRef.child(currentUser.uid).set(userDataMap);
        }

        if (_formKey.currentState != null) {
          _formKey.currentState!.save();
        }

        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SignIn()));
        });

        displayToastMessage('Akun Sukses Dibuat', context);
      }
    } catch (e) {
      displayToastMessage('Gagal: $e', context);
      load();
    }
  }

  void showInSnackBar(String value, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value),
      backgroundColor: Colors.white,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 1),
    ));
  }

  void displayToastMessage(String message, BuildContext context) {
    Fluttertoast.showToast(msg: message);
  }

  void load() {
    setState(() {
      visible = !visible;
    });
  }
}
