import 'package:flutter/material.dart';

class PageLegal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kebijakan Privasi & Syarat Ketentuan', style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(23),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kebijakan Privasi',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 8.0),
            Text(
              'Informasi yang Kami Kumpulkan: Kami dapat mengumpulkan informasi pribadi Anda seperti nama, alamat email, alamat pengiriman, dan informasi pembayaran ketika Anda melakukan transaksi di aplikasi kami.',
                        textAlign: TextAlign.justify,
            ),
            Text(
              'Penggunaan Informasi: Informasi yang kami kumpulkan digunakan untuk memproses pesanan Anda, mengirimkan pembaruan tentang pesanan, dan untuk komunikasi lain yang terkait dengan layanan kami. Kami juga dapat menggunakan informasi ini untuk tujuan pemasaran, namun Anda dapat memilih keluar dari pemasaran ini kapan saja.',
                        textAlign: TextAlign.justify,
            ),
            Text(
              'Keamanan: Kami menjaga keamanan informasi pribadi Anda dengan menerapkan langkah-langkah keamanan yang sesuai untuk melindungi informasi tersebut dari akses yang tidak sah.',
                        textAlign: TextAlign.justify,
            ),
            Text(
              'Pengungkapan kepada Pihak Ketiga: Kami tidak akan menjual, membagikan, atau menyewakan informasi pribadi Anda kepada pihak ketiga tanpa izin Anda, kecuali jika diperlukan oleh hukum.',
                        textAlign: TextAlign.justify,
            ),
            Text(
              'Persetujuan: Dengan menggunakan aplikasi kami, Anda menyetujui kebijakan privasi kami.',
                        textAlign: TextAlign.justify,
            ),
            SizedBox(height: 16.0),
            Text(
              'Syarat dan Ketentuan',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Penggunaan Aplikasi: Dengan menggunakan aplikasi kami, Anda setuju untuk mematuhi syarat dan ketentuan yang telah ditetapkan.',
                        textAlign: TextAlign.justify,
            ),
            Text(
              'Kewajiban Pengguna: Anda bertanggung jawab atas segala aktivitas yang terjadi di akun Anda dan harus menjaga keamanan kata sandi Anda.',
                        textAlign: TextAlign.justify,
            ),
            Text(
              'Konten Pengguna: Jika Anda memposting konten di aplikasi kami, Anda bertanggung jawab atas konten tersebut dan menyetujui bahwa konten tersebut tidak melanggar hak pihak lain.',
                        textAlign: TextAlign.justify,
            ),
            Text(
              'Perubahan Kebijakan: Kami berhak untuk mengubah kebijakan privasi dan syarat dan ketentuan kami tanpa pemberitahuan sebelumnya. Perubahan akan mulai berlaku segera setelah diposting di halaman kami.',
                        textAlign: TextAlign.justify,
            ),
            Text(
              'Persetujuan Terhadap Perubahan: Dengan terus menggunakan aplikasi kami setelah perubahan tersebut, Anda menyetujui kebijakan dan syarat dan ketentuan yang telah diubah.',
                        textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
