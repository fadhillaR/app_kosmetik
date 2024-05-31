class UnbordingContent {
  String image;
  String title;
  String discription;

  UnbordingContent({required this.image, required this.title, required this.discription});
}

List<UnbordingContent> contents = [
  UnbordingContent(
    title: 'Selamat Datang',
    image: 'assets/b1.png',
    discription: "Selamat Datang di Enchanté Beauty! Temukan produk kosmetik terbaik untuk kebutuhan Anda."
  ),
  UnbordingContent(
    title: 'Produk Berkualitas',
    image: 'assets/b2.png',
    discription: "Hanya produk dengan bahan terbaik dan aman untuk kulit Anda."
  ),
  UnbordingContent(
    title: 'Personalisasi',
    image: 'assets/b3.png',
    discription: "Dapatkan rekomendasi produk sesuai dengan jenis kulit dan preferensi Anda."
  ),
];