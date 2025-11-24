import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:penyakit_daun/configure/constants.dart';
import 'package:penyakit_daun/home/about.dart';
import 'package:penyakit_daun/home/history.dart';
import 'package:penyakit_daun/home/object_detection_album.dart';
import 'package:penyakit_daun/home/object_detection_camera.dart';
import 'package:penyakit_daun/user/sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  // const Home({super.key});
 final String email;
 const Home({Key? key, required this.email}) : super(key: key);

 @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  // Function to handle log out
  Future<void> _handleLogout(BuildContext context) async {
    // Remove token otentikasi dari shared_preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');

    // Navigate ke halaman login dan hapus semua route sebelumnya
    Navigator.of(context).pushAndRemoveUntil(
      // MaterialPageRoute(builder: (context) => LogoApp()),
      MaterialPageRoute(builder: (context) => SignIn()),
          (Route<dynamic> route) => false, // Menghapus semua route sebelumnya dan hanya menampilkan halaman login
    );
  }

  @override
  Widget build(BuildContext context) {
    //final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait; //mendeteksi layar
    return Scaffold(
      backgroundColor: background,
      appBar: // isPortrait ?
      AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: header,
        iconTheme: IconThemeData(color: texticon),
        // elevation: 20,
        // title: const Text('GoogleNavBar'),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Deteksi Penyakit Daun Cabai",
              style: TextStyle(
                fontSize: 20,
                color: textheader,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) => History()));
                },
                icon: Icon(Icons.history_rounded, color: texticon,)),
          ],
        ),
      ),
      // : null, //fungsi menghilangkan appbar
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          About(),
          ObjectDetectionCamera(),
          ObjectDetectionAlbum(),
        ],
      ),
      bottomNavigationBar: Container(
        color: header,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: texticon,
              // activeColor: Colors.black,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Colors.white12,
              // tabBackgroundColor: Colors.grey[100]!,
              backgroundColor: header,
              // color: Colors.black,
              tabs: [
                GButton(
                  iconColor: texticon,
                  textColor: texticon,
                  icon: Icons.home,
                  text: 'Beranda',
                ),
                GButton(
                  iconColor: texticon,
                  textColor: texticon,
                  icon: CupertinoIcons.camera,
                  text: 'Ambil Foto',
                ),
                GButton(
                  iconColor: texticon,
                  textColor: texticon,
                  icon: CupertinoIcons.folder_open,
                  text: 'Album',
                ),
                GButton(
                  iconColor: texticon,
                  // textColor: texticon,
                  icon: Icons.logout_rounded,
                  // text: 'Log Out',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                  if (_selectedIndex == 3) {
                    _handleLogout(context);  // Call logout when the last tab is selected
                  }
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
