import 'dart:io';
import 'dart:typed_data';
import 'dart:convert'; // untuk base64
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:penyakit_daun/configure/constants.dart';
import 'package:penyakit_daun/home/penyakit_daun_cabai.dart';
import 'package:pytorch_lite/lib.dart';
import 'package:flutter/rendering.dart';

class ObjectDetectionAlbum extends StatefulWidget {
  const ObjectDetectionAlbum({Key? key}) : super(key: key);

  @override
  State<ObjectDetectionAlbum> createState() => _ObjectDetectionAlbumState();
}

class _ObjectDetectionAlbumState extends State<ObjectDetectionAlbum> {
  // Referensi Firebase
  final DatabaseReference _database = FirebaseDatabase.instance.ref("users");
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late ModelObjectDetection _objectModel;
  String? textToShow;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  List<ResultObjectDetection>? objDetect;
  final GlobalKey _previewContainerKey = GlobalKey(); // untuk tangkap widget

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  // Load model PyTorch
  Future loadModel() async {
    String pathObjectDetectionModel = "assets/models/fix_revisi.torchscript";
    try {
      _objectModel = await PytorchLite.loadObjectDetectionModel(
        pathObjectDetectionModel,
        5,
        512,
        512,
        labelPath: "assets/labels/label2.txt",
      );
    } catch (e) {
      if (e is PlatformException) {
        print("only supported for android, Error is $e");
      } else {
        print("Error is $e");
      }
    }
  }

  // 🔥 Tangkap hasil deteksi ke Uint8List
  Future<Uint8List?> _capturePng() async {
    try {
      RenderRepaintBoundary? boundary =
      _previewContainerKey.currentContext?.findRenderObject()
      as RenderRepaintBoundary?;
      if (boundary == null) {
        debugPrint("⚠️ Boundary masih null, UI belum selesai render");
        return null;
      }

      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
      await image.toByteData(format: ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint("❌ Error capturing widget: $e");
      return null;
    }
  }

  // Simpan hasil deteksi + gambar ke Firebase
  Future<void> saveDetectionHistory(String mostDetectedDisease) async {
    final user = _auth.currentUser;

    if (user == null) {
      print("User belum login.");
      return;
    }

    await Future.delayed(const Duration(milliseconds: 300));
    await WidgetsBinding.instance.endOfFrame;

    // 🔥 ambil hasil deteksi sebagai gambar (Uint8List)
    Uint8List? imageBytes;
    try {
      imageBytes = await _capturePng();
    } catch (e) {
      debugPrint("❌ Gagal capture PNG: $e");
    }

    String? base64Image;
    if (imageBytes != null) {
      base64Image = base64Encode(imageBytes);
    } else {
      debugPrint("⚠️ No detection image available.");
    }

    final historyEntry = {
      "tanggal": DateTime.now().toLocal().toString().substring(0, 19),
      "jenis_deteksi": "Album",
      "penyakit_terbanyak": mostDetectedDisease,
      "hasil_deteksi": base64Image ?? "", // simpan gambar sebagai string
    };

    await _database
        .child(user.uid)
        .child("history")
        .push()
        .set(historyEntry);
    debugPrint("✅ History berhasil disimpan!");
  }

  // Jalankan deteksi
  Future runObjectDetection() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    Stopwatch stopwatch = Stopwatch()..start();
    objDetect = await _objectModel.getImagePrediction(
      await File(image.path).readAsBytes(),
      minimumScore: 0.1,
      iOUThreshold: 0.3,
    );
    textToShow = inferenceTimeAsString(stopwatch);
    print('object executed in ${stopwatch.elapsed.inMilliseconds} ms');

    setState(() {
      _image = File(image.path);
    });

    if (objDetect != null && objDetect!.isNotEmpty) {
      final detectedClasses = objDetect!.map((e) => e.className).toList();
      final diseaseCount = <String, int>{};

      for (var disease in detectedClasses) {
        if (disease != null) {
          diseaseCount[disease] = (diseaseCount[disease] ?? 0) + 1;
        }
      }

      final mostDetectedDisease = diseaseCount.entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key;

      await saveDetectionHistory(mostDetectedDisease);

      print("object terdeteksi $mostDetectedDisease");

      if (mostDetectedDisease.toLowerCase().contains("sehat")) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Hasil Deteksi"),
            content: const Text(
              "Daun ini sehat.\nTidak ditemukan gejala penyakit.",
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK", style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        );
        return;
      }

      List<PenyakitDaunCabai> detectedDiseases = DataPenyakitDaunCabai
          .daftarPenyakit
          .where((penyakit) => mostDetectedDisease.contains(penyakit.jenis))
          .toList();

      if (detectedDiseases.isNotEmpty) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Detail Penyakit Terdeteksi"),
            content: SizedBox(
              height: 150,
              child: ListView.builder(
                itemCount: detectedDiseases.length,
                itemBuilder: (context, index) {
                  final penyakit = detectedDiseases[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        penyakit.namaPenyakit,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text("Gejala: ${penyakit.gejala.join(', ')}"),
                      const SizedBox(height: 8),
                      Text("Pencegahan: ${penyakit.pencegahan.join(', ')}"),
                      const Divider(),
                    ],
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK", style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        );
      }
    }
  }

  String inferenceTimeAsString(Stopwatch stopwatch) =>
      "Inference Took ${stopwatch.elapsed.inMilliseconds} ms";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(color: Colors.black),
      )
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (_image != null)
            RepaintBoundary(
              key: _previewContainerKey,
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.5,
                width: MediaQuery.sizeOf(context).width * 0.95,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: _objectModel != null
                      ? _objectModel!
                      .renderBoxesOnImage(_image!, objDetect ?? [])
                      : const SizedBox(),
                ),
              ),
            ),
          const SizedBox(height: 16),
          Center(
            child: Container(
              height: 45,
              width: MediaQuery.of(context).size.width / 2.25,
              child: ElevatedButton(
                onPressed: runObjectDetection,
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  backgroundColor:
                  MaterialStateProperty.all<Color>(button),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _image == null ? 'Pilih Gambar' : 'Ambil Ulang',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: textbutton,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      _image == null
                          ? Icons.photo_album_outlined
                          : Icons.restart_alt_rounded,
                      color: texticon,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
