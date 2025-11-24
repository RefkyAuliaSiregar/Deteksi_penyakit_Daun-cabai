import 'package:flutter/material.dart';
import 'package:penyakit_daun/configure/constants.dart';
import 'package:penyakit_daun/home/penyakit_daun_cabai.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Text(
          //     "Macam-Macam Jenis Penyakit",
          //     style: TextStyle(color: Colors.white, fontSize: 20),
          //   ),
          // ),
          Expanded(
            child: ListView.builder(
              itemCount: DataPenyakitDaunCabai.daftarPenyakit.length,
              itemBuilder: (context, index) {
                final penyakit = DataPenyakitDaunCabai.daftarPenyakit[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          child: Image.asset(
                            penyakit.gambar, // Gambar diambil dari properti `gambar`
                            width: double.infinity,
                            height: 180,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                penyakit.namaPenyakit,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                penyakit.deskripsi,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Gejala:",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ...penyakit.gejala.map((gejala) => Text(
                                "- $gejala",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              )),
                              const SizedBox(height: 8),
                              Text(
                                "Penyebab:",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ...penyakit.penyebab.map((penyebab) => Text(
                                "- $penyebab",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              )),
                              const SizedBox(height: 8),
                              Text(
                                "Dampak:",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ...penyakit.dampak.map((dampak) => Text(
                                "- $dampak",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              )),
                              const SizedBox(height: 8),
                              Text(
                                "Pencegahan:",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ...penyakit.pencegahan.map((pencegahan) => Text(
                                "- $pencegahan",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              )),
                              const SizedBox(height: 8),
                              Text(
                                "Pengendalian:",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ...penyakit.pengendalian.map((pengendalian) => Text(
                                "- $pengendalian",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              )),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
