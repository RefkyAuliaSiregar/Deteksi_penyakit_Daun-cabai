import 'dart:convert'; // untuk base64 decode
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:penyakit_daun/configure/constants.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref("users");
  List<Map<String, dynamic>> _historyData = []; // ganti ke dynamic supaya bisa simpan Uint8List/base64

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  // Fetch data from Firebase Realtime Database
  Future<void> _fetchHistory() async {
    final user = _auth.currentUser;
    if (user == null) {
      print("User is not logged in.");
      return;
    }

    try {
      final snapshot = await _database.child(user.uid).child("history").get();
      if (snapshot.exists) {
        final historyList = snapshot.value as Map;
        List<Map<String, dynamic>> tempHistoryData = [];

        historyList.forEach((key, value) {
          tempHistoryData.add({
            'key': key,
            'tanggal': value['tanggal'],
            'jenis_deteksi': value['jenis_deteksi'],
            'penyakit_terbanyak': value['penyakit_terbanyak'],
            'hasil_deteksi': value['hasil_deteksi'], // ambil field hasil_deteksi
          });
        });

        setState(() {
          _historyData = tempHistoryData;
        });
      } else {
        print("No history found.");
      }
    } catch (e) {
      print("Error fetching history: $e");
    }
  }

  // Delete item from Firebase
  Future<void> _deleteHistoryItem(String key) async {
    final user = _auth.currentUser;
    if (user == null) {
      print("User is not logged in.");
      return;
    }

    try {
      await _database.child(user.uid).child("history").child(key).remove();
      print("Item with key $key deleted successfully.");
      _fetchHistory(); // Refresh data after deletion
    } catch (e) {
      print("Error deleting history item: $e");
    }
  }

  // Show confirmation dialog before deleting
  Future<void> _showDeleteConfirmationDialog(String key) async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi Hapus"),
          content: const Text("Apakah Anda yakin ingin menghapus item ini?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Batal", style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Hapus", style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );

    if (result == true) {
      _deleteHistoryItem(key);
    }
  }

  // Tampilkan gambar hasil_deteksi
  void _showDetectionImage(String? base64Image) {
    if (base64Image == null || base64Image.isEmpty) {
      print("No detection image available.");
      return;
    }

    try {
      Uint8List bytes = base64Decode(base64Image);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Hasil Deteksi"),
          content: Image.memory(bytes, fit: BoxFit.contain),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Tutup", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      );
    } catch (e) {
      print("Error decoding image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        iconTheme: IconThemeData(color: texticon),
        title: const Text(
          'Riwayat Deteksi',
          style: TextStyle(color: textheader),
        ),
        backgroundColor: header,
      ),
      body: _historyData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _historyData.length,
        itemBuilder: (ctx, index) {
          final historyItem = _historyData[index];
          final String? key = historyItem['key'];

          return Card(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: ListTile(
              onTap: () {
                // kalau item di klik -> tampilkan gambar
                _showDetectionImage(historyItem['hasil_deteksi']);
              },
              contentPadding: const EdgeInsets.all(10),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Jenis: ${historyItem['jenis_deteksi'] ?? 'No type'}',
                          style: TextStyle(color: textbiasa),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Tanggal: ${historyItem['tanggal'] ?? 'No date'}',
                          style: TextStyle(color: textbiasa),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Penyakit: ${historyItem['penyakit_terbanyak'] ?? 'No type'}',
                          style: TextStyle(color: textbiasa),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (key != null) {
                        _showDeleteConfirmationDialog(key);
                      } else {
                        print("Key is null for this item.");
                      }
                    },
                    child: const Icon(
                      Icons.restore_from_trash_rounded,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
