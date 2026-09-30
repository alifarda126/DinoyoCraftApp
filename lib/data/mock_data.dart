import '../core/assets.dart';

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.studio,
    required this.price,
    required this.rating,
    required this.category,
    required this.image,
    this.hot = false,
  });

  final String id;
  final String name;
  final String studio;
  final int price;
  final double rating;
  final String category;
  final String image;
  final bool hot;
}

class Store {
  const Store({
    required this.name,
    required this.location,
    required this.description,
    required this.rating,
    required this.image,
  });

  final String name;
  final String location;
  final String description;
  final double rating;
  final String image;
}

class FaqItem {
  const FaqItem({required this.question, required this.answer});

  final String question;
  final String answer;
}

class CartItem {
  const CartItem({required this.product, required this.qty});

  final Product product;
  final int qty;
}

abstract final class MockData {
  static const List<String> categories = [
    'Semua',
    'Vas',
    'Cangkir',
    'Piring',
    'Mangkuk',
  ];

  // Image paths mapped to actual photo content (asset QA).
  static const List<Product> products = [
    Product(
      id: '1',
      name: 'Vas Minimalis',
      studio: 'Dinoyo Ceramic Studio',
      price: 85000,
      rating: 4.8,
      category: 'Vas',
      image: AppAssets.productVas,
      hot: true,
    ),
    Product(
      id: '2',
      name: 'Cangkir Handmade',
      studio: 'Karya Tanah',
      price: 65000,
      rating: 4.6,
      category: 'Cangkir',
      image: AppAssets.productMangkuk,
      hot: true,
    ),
    Product(
      id: '3',
      name: 'Mangkuk Keramik',
      studio: 'Ruang Tanah',
      price: 75000,
      rating: 4.7,
      category: 'Mangkuk',
      image: AppAssets.productPiring,
    ),
    Product(
      id: '4',
      name: 'Piring Artisan',
      studio: 'Dinoyo Craft House',
      price: 95000,
      rating: 4.9,
      category: 'Piring',
      image: AppAssets.productMangkukRamen,
      hot: true,
    ),
    Product(
      id: '5',
      name: 'Vas Modern',
      studio: 'Ruang Tanah',
      price: 120000,
      rating: 4.5,
      category: 'Vas',
      image: AppAssets.productVasModern,
    ),
    Product(
      id: '6',
      name: 'Cangkir Speckle',
      studio: 'Dinoyo Ceramic Studio',
      price: 70000,
      rating: 4.4,
      category: 'Cangkir',
      image: AppAssets.productCangkirSpeckle,
    ),
    Product(
      id: '7',
      name: 'Set Piring Dinoyo',
      studio: 'Dinoyo Craft House',
      price: 110000,
      rating: 4.8,
      category: 'Piring',
      image: AppAssets.productSetPiring,
    ),
    Product(
      id: '8',
      name: 'Mangkuk Spekel',
      studio: 'Karya Tanah',
      price: 80000,
      rating: 4.6,
      category: 'Mangkuk',
      image: AppAssets.productPiring,
    ),
  ];

  static const List<Store> stores = [
    Store(
      name: 'Dinoyo Ceramic Studio',
      location: 'Jl. MT Haryono, Dinoyo, Malang',
      description:
          'Studio keramik klasik Dinoyo dengan koleksi vas dan cangkir handmade.',
      rating: 4.9,
      image: AppAssets.storeDinoyo,
    ),
    Store(
      name: 'Karya Tanah',
      location: 'Kampung Keramik Dinoyo, Malang',
      description:
          'Pengrajin muda yang fokus pada cangkir dan mangkuk spekel unik.',
      rating: 4.7,
      image: AppAssets.storeRuangTanah,
    ),
    Store(
      name: 'Ruang Tanah',
      location: 'Jl. Keramik No. 12, Dinoyo',
      description:
          'Galeri dan workshop terbuka untuk eksplorasi tanah liat kontemporer.',
      rating: 4.8,
      image: AppAssets.storeRuangTanah,
    ),
    Store(
      name: 'Dinoyo Craft House',
      location: 'Jl. Simpang Gajayana, Malang',
      description:
          'Rumah craft dengan set piring artisan dan merchandise lokal.',
      rating: 4.6,
      image: AppAssets.storeDinoyo,
    ),
  ];

  static const List<FaqItem> faqs = [
    FaqItem(
      question: 'Bagaimana cara memesan produk?',
      answer:
          'Pilih produk dari Beranda atau tab Produk, tap tombol +, lalu lanjutkan ke Checkout untuk menyelesaikan pembayaran.',
    ),
    FaqItem(
      question: 'Apakah bisa pickup di toko?',
      answer:
          'Ya. Pilih opsi ambil di toko pada checkout jika tersedia, atau hubungi studio terkait melalui ClayBot.',
    ),
    FaqItem(
      question: 'Berapa lama pengiriman ke luar kota?',
      answer:
          'Estimasi 2–5 hari kerja tergantung kurir (Regular/Hemat/Express) dan destinasi pengiriman.',
    ),
    FaqItem(
      question: 'Apakah produk bisa dikustom?',
      answer:
          'Beberapa studio menerima custom order. Hubungi ClayBot atau WhatsApp studio untuk konfirmasi desain dan estimasi harga.',
    ),
    FaqItem(
      question: 'Bagaimana cara reservasi workshop?',
      answer:
          'Buka tab Workshop, baca detail pengalaman, lalu tap Reservasi via WhatsApp untuk menjadwalkan sesi.',
    ),
    FaqItem(
      question: 'Metode pembayaran apa saja yang tersedia?',
      answer:
          'MVP mendukung QRIS, Virtual Account, dan E-Wallet. Pembayaran di demo ini bersifat simulasi.',
    ),
  ];

  static List<CartItem> get mockCart => [
        CartItem(product: products[0], qty: 1),
        CartItem(product: products[1], qty: 2),
      ];

  static String formatPrice(int price) {
    final digits = price.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(digits[i]);
    }
    return 'Rp${buffer.toString()}';
  }

  static List<Product> filterProducts({
    String category = 'Semua',
    String query = '',
  }) {
    final q = query.trim().toLowerCase();
    return products.where((p) {
      final catOk = category == 'Semua' || p.category == category;
      final queryOk = q.isEmpty ||
          p.name.toLowerCase().contains(q) ||
          p.studio.toLowerCase().contains(q);
      return catOk && queryOk;
    }).toList();
  }

  static List<Store> filterStores(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return stores;
    return stores
        .where(
          (s) =>
              s.name.toLowerCase().contains(q) ||
              s.location.toLowerCase().contains(q),
        )
        .toList();
  }
}
