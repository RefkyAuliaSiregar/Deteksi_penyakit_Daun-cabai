import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String? token = await user.getIdToken();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('authToken', token ?? '');
      }
      return 'Sukses';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'Nama Pengguna Tidak Ditemukan') {
        return 'Tidak ditemukan pengguna pada email tersebut.';
      } else if (e.code == 'Salah Kata Sandi') {
        return 'Kata Sandi Salah Pada Pengguna Tersebut.';
      } else {
        return 'Kredensial Masuk Tidak Valid.';
      }
    } catch (e) {
      return e.toString();
    }
  }
}
