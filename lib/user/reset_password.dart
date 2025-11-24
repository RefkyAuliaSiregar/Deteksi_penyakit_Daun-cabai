import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:penyakit_daun/configure/constants.dart';
import 'package:penyakit_daun/user/sign_in.dart';


FirebaseAuth auth = FirebaseAuth.instance;
DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("users");

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  static bool visible = false;

  void initState() {
    super.initState();
    visible = false;
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      //backgroundColor: Colors.transparent,
      backgroundColor: background,
      // appBar: AppBar(
      //   title: Text("Login Page", ),
      // ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.93,
                height: MediaQuery.of(context).size.height * 0.4, // Mengatur tinggi kontainer menjadi setengah dari tinggi layar
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(35),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          const SizedBox(
                            height: 20,
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Text("Mengatur Ulang Kata Sandi",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: textlogin)),
                          const SizedBox(
                            height: 20.0,
                          ),
                          // Container(
                          //   padding: const EdgeInsets.only(),
                          //   child: (Text(
                          //     'Please enter your email below, \n to recieve your password reset instructions!',
                          //     style: TextStyle(
                          //       fontSize: 15,
                          //       color: textlogin,
                          //       fontWeight: FontWeight.normal
                          //     ),
                          //     textAlign: TextAlign.center,
                          //   )),
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 20, bottom: 0),
                            //  padding: EdgeInsets.symmetric(horizontal: 15),
                            child: TextFormField(
                              style: TextStyle(color: textlogin),
                              controller: _emailController,
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.emailAddress,
                              // style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.mail_outline_rounded,
                                    color: iconlogin,
                                  ),
                                  // filled: true,
                                  // fillColor: Colors.black12,
                                  hintText: 'email@gmail.com',
                                  // hintStyle: TextStyle(
                                  //   fontWeight: FontWeight.bold,
                                  // ),
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
                                  hintStyle: TextStyle(color: textlogin),
                                  labelStyle: TextStyle(color: textlogin),
                                  labelText: 'Email'),
                            ),
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
                                      margin: EdgeInsets.only(top: 10),
                                      child: LinearProgressIndicator(
                                        minHeight: 2,
                                        backgroundColor: Colors.blueGrey[800],
                                        valueColor: AlwaysStoppedAnimation(Colors.white),
                                      )))),
                          Container(
                            height: 45,
                            width: MediaQuery.of(context).size.width / 2.25,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_emailController.text.isEmpty) {
                                  displayToastMessage('Masukkan Email yang Valid', context);
                                }
                                else {
                                  setState(() {
                                    load();
                                  });
                                  resetPwd(context);
                                }
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15), // Adjust the corner radius as desired

                                  ),
                                ),
                                backgroundColor: MaterialStateProperty.all<Color>(
                                  // Colors.transparent
                                  button,
                                  //const Color.fromRGBO(20, 26, 70, 1.0), // Red color (RGB: 255, 0, 0)
                                ),
                              ),
                              child: Text(
                                'Lupa Kata Sandi',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: textbutton)
                                //style: TextStyle(color: Colors.white, fontSize: 20,),
                                // style: TextStyle(
                                //   fontSize: 19,
                                //   color: Colors.white,
                                //   fontWeight: FontWeight.w500,
                                // ),
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
                              overlayColor: MaterialStateColor.resolveWith((states) => Colors.transparent), // Mengatur overlay color menjadi transparent
                            ),
                            child: Text('Sudah Punya Akun? Masuk',style: TextStyle(color: textlogin),),
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

  Future<void> resetPwd(BuildContext context) async {
    // final ParseUser user = ParseUser(null, null, _emailidController.text.trim());
    try {
      await auth.sendPasswordResetEmail(email: _emailController.text.trim());
      displayToastMessage('Email Sudah dikirim', context);
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => SignIn()));
      });
    } catch (e) {
      displayToastMessage(e.toString(), context);
      setState(() {
        load();
      });
      // Message.showError(context: context, message: parseResponse.error.message);
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _emailController.dispose();
    super.dispose();
  }

  void load() {
    visible = !visible;
  }

  void displayToastMessage(String message, BuildContext context) {
    Fluttertoast.showToast(msg: message);
  }
}
