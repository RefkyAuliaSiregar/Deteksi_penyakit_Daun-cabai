
class PenyakitDaunCabai {
  final String namaPenyakit;
  final String jenis;
  final String deskripsi;
  final List<String> gejala;
  final List<String> penyebab;
  final List<String> dampak;
  final List<String> pencegahan;
  final List<String> pengendalian;
  final String gambar;

  PenyakitDaunCabai({
    required this.namaPenyakit,
    required this.jenis,
    required this.deskripsi,
    required this.gejala,
    required this.penyebab,
    required this.dampak,
    required this.pencegahan,
    required this.pengendalian,
    required this.gambar,
  });
}

class DataPenyakitDaunCabai {
  static final List<PenyakitDaunCabai> daftarPenyakit = [
    PenyakitDaunCabai(
      namaPenyakit: "Bercak Daun Cabai",
      jenis: "Bercak",
      deskripsi:
      "Penyakit bercak daun cabai sering menyerang tanaman cabai, disebabkan oleh patogen seperti jamur Cercospora capsici atau Alternaria solani, serta bakteri Xanthomonas campestris.",
      gejala: [
        "Bercak kecil, bulat, cokelat hingga hitam pada daun.",
        "Bercak membesar dan memiliki lingkaran konsentris.",
        "Daun menguning, mengering, dan gugur.",
        "Bercak dapat menyebar ke buah."
      ],
      penyebab: [
        "Infeksi oleh jamur atau bakteri melalui luka atau stomata.",
        "Lingkungan dengan suhu hangat (25–30°C) dan kelembapan tinggi.",
        "Penyebaran melalui angin, air hujan, atau kontak antar tanaman."
      ],
      dampak: [
        "Menurunkan kualitas dan kuantitas hasil panen.",
        "Mengurangi kemampuan fotosintesis tanaman.",
        "Kerugian ekonomi signifikan bagi petani."
      ],
      pencegahan: [
        "Gunakan benih yang sehat dan tahan penyakit.",
        "Lakukan rotasi tanaman.",
        "Jaga kebersihan lahan dari sisa-sisa tanaman terinfeksi."
      ],
      pengendalian: [
        "Hindari penanaman terlalu rapat.",
        "Gunakan fungisida berbahan aktif mancozeb atau chlorothalonil.",
        "Manfaatkan agen hayati seperti Trichoderma."
      ],
      gambar: "assets/images/daun bercak.png",
    ),
    PenyakitDaunCabai(
      namaPenyakit: "Whitefly pada Daun Cabai",
      jenis: "Whitefly",
      deskripsi:
      "Whitefly, atau kutu kebul, menyerang tanaman cabai dengan cara mengisap cairan daun dan menjadi vektor penyakit virus seperti TYLCV.",
      gejala: [
        "Daun menguning, layu, dan keriting.",
        "Kehadiran jamur jelaga akibat cairan honeydew.",
        "Whitefly dewasa beterbangan saat daun disentuh."
      ],
      penyebab: [
        "Whitefly berkembang biak di lingkungan hangat dan lembap.",
        "Penyebaran melalui angin atau alat pertanian yang terkontaminasi."
      ],
      dampak: [
        "Menurunkan kualitas tanaman dan hasil panen.",
        "Penyebaran virus yang sulit dikendalikan."
      ],
      pencegahan: [
        "Gunakan bibit yang bebas infeksi whitefly.",
        "Pasang jaring pelindung dan perangkap kuning.",
        "Gunakan tanaman perangkap seperti jagung."
      ],
      pengendalian: [
        "Manfaatkan musuh alami seperti Encarsia formosa.",
        "Gunakan insektisida berbahan aktif imidakloprid.",
        "Lakukan rotasi tanaman untuk memutus siklus hidup whitefly."
      ],
      gambar: "assets/images/daun whitefly.png",
    ),
    PenyakitDaunCabai(
      namaPenyakit: "Virus Kuning pada Daun Cabai",
      jenis: "Kuning",
      deskripsi:
      "virus kuning daun cabai, atau dikenal sebagai Tomato Yellow Leaf Curl Virus (TYLCV), Penyakit ini disebabkan oleh virus yang ditularkan melalui vektor utama, yaitu whitefly (Bemisia tabaci). ",
      gejala: [
        "Daun muda berwarna kuning cerah atau mengalami klorosis.",
        "Pertumbuhan tanaman terhambat (kerdil) dan tidak normal.",
        "Buah yang dihasilkan kecil dan sering kali tidak matang sempurna."
      ],
      penyebab: [
        "Virus Kuning berkembang biak di lingkungan hangat dan lembap.",
        "Penyebaran melalui angin atau alat pertanian yang terkontaminasi."
      ],
      dampak: [
        "Menurunkan hasil panen hingga 80%.",
        "Kerusakan pada kualitas dan ukuran buah cabai."
      ],
      pencegahan: [
        "Gunakan benih atau bibit yang tahan terhadap TYLCV.",
        "Pasang jaring pelindung (insect net).",
        "Lakukan sanitasi lahan dengan membersihkan gulma atau tanaman liar yang menjadi inang virus."
      ],
      pengendalian: [
        "Manfaatkan musuh alami seperti Encarsia formosa.",
        "Gunakan pestisida nabati berbasis minyak neem.",
        "Segera cabut dan musnahkan tanaman yang terinfeksi berat untuk mencegah penyebaran virus ke tanaman sehat."
      ],
      gambar: "assets/images/daun kuning.png",
    ),
    PenyakitDaunCabai(
      namaPenyakit: "Daun Keriting pada Daun Cabai",
      jenis: "Keriting",
      deskripsi:
      "Daun Keriting disebabkan oleh virus Tomato Yellow Leaf Curl Virus (TYLCV) dan Pepper Veinal Mottle Virus (PVMV), yang ditularkan oleh vektor hama seperti whitefly (Bemisia tabaci) atau thrips.",
      gejala: [
        "Daun muda yang terinfeksi akan menggulung ke arah bawah atau ke atas, dan bentuknya menjadi tidak normal",
        "Tanaman yang terinfeksi virus atau hama akan mengalami stunting (pertumbuhan yang terhambat), sehingga tanaman tampak kerdil",
        "Buah cabai yang terinfeksi sering kali menunjukkan gejala warna yang tidak sempurna atau lebih pucat."
      ],
      penyebab: [
        "Penyebaran virus umumnya dilakukan oleh hama vektor seperti whitefly (Bemisia tabaci) dan thrips yang mengisap cairan dari daun tanaman dan membawa virus ke tanaman sehat",
        "Suhu panas dan kelembapan tinggi cenderung mendukung perkembangbiakan hama vektor dan penyebaran virus."
      ],
      dampak: [
        "Serangan daun keriting dapat menurunkan hasil panen hingga 70-80%.",
        "Buah cabai yang dihasilkan menjadi kecil, kurang matang, dan tidak memiliki kualitas yang baik."
      ],
      pencegahan: [
        "Gunakan benih cabai yang sudah terbukti tahan terhadap infeksi virus.",
        "Menanam cabai dengan jarak yang cukup akan mengurangi kelembapan tinggi dan menghindari kondisi yang mendukung perkembangan hama.",
        "Segera cabut dan musnahkan tanaman yang terinfeksi untuk mencegah penyebaran lebih lanjut."
      ],
      pengendalian: [
        "Pasang perangkap kuning yang dapat menarik whitefly dan thrips untuk mengurangi populasi hama vektor.",
        "Gunakan Pestisida berbahan dasar minyak neem atau ekstrak daun tuba dapat digunakan untuk mengendalikan populasi hama secara alami.",
        "Lakukan rotasi tanaman dengan tanaman non-inang untuk memutus siklus hidup virus dan hama vektor."
      ],
      gambar: "assets/images/daun keriting.png",
    ),
  ];
}
