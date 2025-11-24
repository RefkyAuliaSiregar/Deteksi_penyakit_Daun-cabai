import 'dart:io';
import 'dart:typed_data';
import 'dart:convert'; // Ditambahkan untuk base64 encoding
import 'dart:ui' as ui; // Ditambahkan untuk format gambar

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'; // Ditambahkan untuk menangkap widget
import 'package:image_picker/image_picker.dart';
import 'package:penyakit_daun/configure/constants.dart';
import 'package:penyakit_daun/home/penyakit_daun_cabai.dart';
import 'package:pytorch_lite/pytorch_lite.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ObjectDetectionCamera extends StatefulWidget {
  const ObjectDetectionCamera({Key? key}) : super(key: key);

  @override
  State<ObjectDetectionCamera> createState() => _ObjectDetectionCameraState();
}

class _ObjectDetectionCameraState extends State<ObjectDetectionCamera> {
  // Referensi ke Firebase Realtime Database
  final DatabaseReference _database = FirebaseDatabase.instance.ref("users");
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<ResultObjectDetection>? objectDetectionResults;
  Duration? objectDetectionInferenceTime;
  File? _image;
  ModelObjectDetection? _objectModel;
  bool _isLoading = false;

  // Kunci global untuk mengidentifikasi widget yang akan ditangkap
  final GlobalKey _previewContainerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future loadModel() async {
    String pathObjectDetectionModel = "assets/models/fix_revisi.torchscript";
    try {
      _objectModel = await PytorchLite.loadObjectDetectionModel(
        pathObjectDetectionModel, 5, 512, 512,
        labelPath: "assets/labels/label2.txt",
      );
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  // Fungsi untuk menangkap widget sebagai gambar (PNG)
  Future<Uint8List?> _capturePng() async {
    try {
      // Tambahkan delay untuk memastikan UI sudah selesai render
      await Future.delayed(const Duration(milliseconds: 500));

      RenderRepaintBoundary? boundary =
      _previewContainerKey.currentContext?.findRenderObject()
      as RenderRepaintBoundary?;

      if (boundary == null) {
        debugPrint("⚠️ Boundary masih null, UI belum selesai render");
        return null;
      }

      // Gunakan pixelRatio yang lebih tinggi untuk kualitas gambar yang lebih baik
      var image = await boundary.toImage(pixelRatio: 2.0);
      ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint("❌ Error capturing widget: $e");
      return null;
    }
  }

  // Widget untuk menggambar bounding boxes secara manual
  Widget _buildDetectionOverlay() {
    if (objectDetectionResults == null || objectDetectionResults!.isEmpty) {
      return const SizedBox();
    }

    return CustomPaint(
      painter: DetectionPainter(
        detections: objectDetectionResults!,
        imageSize: Size(
          MediaQuery.of(context).size.width * 0.95,
          MediaQuery.of(context).size.height * 0.5,
        ),
      ),
    );
  }

  // Fungsi untuk menyimpan riwayat deteksi
  Future<void> saveDetectionHistory(String mostDetectedDisease) async {
    final user = _auth.currentUser;

    if (user == null) {
      print("User belum login.");
      return;
    }

    // Tunggu sebentar untuk memastikan UI sudah ter-render sempurna
    await Future.delayed(const Duration(milliseconds: 300));

    // Ambil hasil deteksi sebagai gambar (Uint8List)
    Uint8List? imageBytes;
    try {
      imageBytes = await _capturePng();
    } catch (e) {
      debugPrint("❌ Gagal capture PNG: $e");
    }

    // Ubah gambar menjadi string base64
    String? base64Image;
    if (imageBytes != null) {
      base64Image = base64Encode(imageBytes);
      debugPrint("✅ Gambar berhasil di-capture dengan ukuran: ${imageBytes.length} bytes");
    } else {
      debugPrint("⚠️ Tidak ada gambar deteksi yang tersedia.");
    }

    final historyEntry = {
      "tanggal": DateTime.now().toLocal().toString().substring(0, 19),
      "jenis_deteksi": "Kamera",
      "penyakit_terbanyak": mostDetectedDisease,
      "hasil_deteksi": base64Image ?? "", // Simpan gambar sebagai string
    };

    // Simpan data ke path: users/{User UID}/history
    await _database
        .child(user.uid)
        .child("history")
        .push()
        .set(historyEntry);
    debugPrint("✅ History berhasil disimpan!");
  }

  Future runModels() async {
    setState(() => _isLoading = true);

    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.camera);
    if (pickedImage == null) {
      setState(() => _isLoading = false);
      return;
    }

    File image = File(pickedImage.path);
    Uint8List imageBytes = await image.readAsBytes();
    List<ResultObjectDetection>? detectionResults;

    try {
      Stopwatch stopwatch = Stopwatch()..start();
      detectionResults = await _objectModel?.getImagePrediction(
        imageBytes,
        minimumScore: 0.1,
        iOUThreshold: 0.3,
      );
      objectDetectionInferenceTime = stopwatch.elapsed;
      print('object executed in ${stopwatch.elapsed.inMilliseconds} ms');
    } catch (e) {
      print("Error during object detection: $e");
      setState(() {
        _isLoading = false;
        _image = image;
        objectDetectionResults = [];
      });
      return;
    }

    // Perbarui state untuk menampilkan gambar dan hasil deteksi di UI
    setState(() {
      _image = image;
      objectDetectionResults = detectionResults;
      _isLoading = false;
    });

    if (detectionResults != null && detectionResults.isNotEmpty) {
      final detectedClasses = detectionResults.map((e) => e.className).toList();
      final diseaseCount = <String, int>{};

      for (var disease in detectedClasses) {
        if (disease != null) {
          diseaseCount[disease] = (diseaseCount[disease] ?? 0) + 1;
        }
      }

      final mostDetectedDisease = diseaseCount.entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key;

      // Simpan riwayat deteksi setelah UI selesai di-render
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await saveDetectionHistory(mostDetectedDisease);
      });

      // Logika untuk menampilkan dialog hasil
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
                  return Center(
                    child: Column(
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
                    ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.black)
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_image != null) ...[
              RepaintBoundary(
                key: _previewContainerKey,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      // Lapisan 1: Gambar asli
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.file(
                          _image!,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Lapisan 2: Overlay deteksi manual
                      _buildDetectionOverlay(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            Container(
              height: 45,
              width: MediaQuery.of(context).size.width / 2.25,
              child: ElevatedButton(
                onPressed: runModels,
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
                      _image == null ? 'Deteksi' : 'Ambil Ulang',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: textbutton),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      _image == null
                          ? Icons.camera
                          : Icons.restart_alt_rounded,
                      color: texticon,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Painter untuk menggambar bounding boxes
class DetectionPainter extends CustomPainter {
  final List<ResultObjectDetection> detections;
  final Size imageSize;

  DetectionPainter({
    required this.detections,
    required this.imageSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (final detection in detections) {
      // Konversi koordinat dari model ke koordinat widget
      final rect = Rect.fromLTWH(
        detection.rect.left * size.width,
        detection.rect.top * size.height,
        detection.rect.width * size.width,
        detection.rect.height * size.height,
      );

      // Gambar bounding box
      canvas.drawRect(rect, paint);

      // Gambar label
      if (detection.className != null) {
        textPainter.text = TextSpan(
          text: '${detection.className} (${(detection.score * 100).toStringAsFixed(1)}%)',
          style: const TextStyle(
            color: Colors.red,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            backgroundColor: Colors.white,
          ),
        );

        textPainter.layout();

        // Posisi label sedikit di atas bounding box
        final labelOffset = Offset(
          rect.left,
          rect.top - textPainter.height - 2,
        );

        // Gambar background putih untuk label
        final labelRect = Rect.fromLTWH(
          labelOffset.dx - 2,
          labelOffset.dy - 2,
          textPainter.width + 4,
          textPainter.height + 4,
        );

        canvas.drawRect(labelRect, Paint()..color = Colors.white);
        canvas.drawRect(labelRect, Paint()..color = Colors.red..style = PaintingStyle.stroke..strokeWidth = 1);

        textPainter.paint(canvas, labelOffset);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}