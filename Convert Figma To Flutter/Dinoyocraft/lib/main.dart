import 'package:flutter/material.dart';
import 'screens/Alamat.dart';
import 'screens/Bantuan.dart';
import 'screens/Beranda.dart';
import 'screens/BeriUlasanProduk.dart';
import 'screens/Chat.dart';
import 'screens/ChatDenganToko.dart';
import 'screens/CO.dart';
import 'screens/DataDiri.dart';
import 'screens/DetailProduk.dart';
import 'screens/HapusAkun.dart';
import 'screens/Keranjang.dart';
import 'screens/ModalPilihVariasiJumlahProduk.dart';
import 'screens/Notif.dart';
import 'screens/Pengaturan.dart';
import 'screens/PopUpChatbot.dart';
import 'screens/Produk.dart';
import 'screens/ProfileToko.dart';
import 'screens/ProfilPesananDikemas.dart';
import 'screens/ProfilPesananDikrim.dart';
import 'screens/ProfilPesananDiterima.dart';
import 'screens/Toko.dart';
import 'screens/Ulasan.dart';
import 'screens/Workshop.dart';    
void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/Alamat',
      routes: {
			'/Alamat': (context) => const Alamat(),
			'/Bantuan': (context) => const Bantuan(),
			'/Beranda': (context) => const Beranda(),
			'/BeriUlasanProduk': (context) => const BeriUlasanProduk(),
			'/Chat': (context) => const Chat(),
			'/ChatDenganToko': (context) => const ChatDenganToko(),
			'/CO': (context) => const CO(),
			'/DataDiri': (context) => const DataDiri(),
			'/DetailProduk': (context) => const DetailProduk(),
			'/HapusAkun': (context) => const HapusAkun(),
			'/Keranjang': (context) => const Keranjang(),
			'/ModalPilihVariasiJumlahProduk': (context) => const ModalPilihVariasiJumlahProduk(),
			'/Notif': (context) => const Notif(),
			'/Pengaturan': (context) => const Pengaturan(),
			'/PopUpChatbot': (context) => const PopUpChatbot(),
			'/Produk': (context) => const Produk(),
			'/ProfileToko': (context) => const ProfileToko(),
			'/ProfilPesananDikemas': (context) => const ProfilPesananDikemas(),
			'/ProfilPesananDikrim': (context) => const ProfilPesananDikrim(),
			'/ProfilPesananDiterima': (context) => const ProfilPesananDiterima(),
			'/Toko': (context) => const Toko(),
			'/Ulasan': (context) => const Ulasan(),
			'/Workshop': (context) => const Workshop(),
      },
    );
  }
}