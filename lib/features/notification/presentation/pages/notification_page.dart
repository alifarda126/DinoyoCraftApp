import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

enum NotifCategory { semua, transaksi, akun }
enum NotifType { promo, workshop, payment, system }

class NotifItem {
const   NotifItem({required this.type, required this.category, required this.badge, required this.time, required this.title, required this.body, this.actionLabel, this.isRead = false});
  final NotifType type;
  final NotifCategory category;
  final String badge, time, title, body;
  final String? actionLabel;
  final bool isRead;
}

class NotificationPage extends StatefulWidget {
const   NotificationPage({super.key});
  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  NotifCategory _tab = NotifCategory.semua;

  static const _items = [
    NotifItem(type: NotifType.promo, category: NotifCategory.semua, badge: 'DISKON PENGRAJIN', time: '2 jam lalu',
      title: 'Voucher Diskon Keramik 15%',
      body: 'Gunakan kode DINOYOKARYA untuk potongan belanja produk tembikar buatan pengrajin Dinoyo.',
      actionLabel: 'Salin Voucher'),
    NotifItem(type: NotifType.workshop, category: NotifCategory.semua, badge: 'WISATA KREATIF', time: 'Kemarin, 14:20',
      title: 'Jadwal Workshop Pembuatan Keramik',
      body: 'Kelas seni putar tanah liat akhir pekan ini di Studio Dinoyo dibuka. Kuota tersisa 3 orang!',
      actionLabel: 'Lihat Detail Workshop'),
    NotifItem(type: NotifType.payment, category: NotifCategory.transaksi, badge: 'PEMBAYARAN', time: '3 hari lalu',
      title: 'Pembayaran Berhasil',
      body: 'Pesanan #DNC-001 telah dikonfirmasi dan sedang dikemas oleh penjual.', isRead: true),
    NotifItem(type: NotifType.system, category: NotifCategory.akun, badge: 'INFO AKUN', time: '1 minggu lalu',
      title: 'Akun Berhasil Diverifikasi',
      body: 'Email Anda telah diverifikasi. Selamat berbelanja di DinoyoCraft!', isRead: true),
  ];

  List<NotifItem> get _filtered => _tab == NotifCategory.semua
      ? _items
      : _items.where((n) => n.category == _tab).toList();

  int get _unreadCount => _items.where((n) => !n.isRead).length;

  static const _tabs = ['Semua', 'Transaksi & Pesanan', 'Info Akun'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg, elevation: 0, scrolledUnderElevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: AppColors.ink), onPressed: () => Navigator.of(context).maybePop()),
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Notifikasi', style: AppTextStyles.appBarTitle),
          if (_unreadCount > 0)
            Text('$_unreadCount Baru', style: AppTextStyles.caption.copyWith(color: Colors.redAccent)),
        ]),
      ),
      body: Column(children: [
        // Tabs
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.pageHorizontal),
            itemCount: _tabs.length,
            separatorBuilder: (_, _) => SizedBox(width: AppDimensions.gapS),
            itemBuilder: (context, i) {
              final isActive = i == _tab.index;
              return GestureDetector(
                onTap: () => setState(() => _tab = NotifCategory.values[i]),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.black : AppColors.inputBg,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
                  ),
                  child: Text(_tabs[i], style: AppTextStyles.caption.copyWith(
                    color: isActive ? AppColors.white : AppColors.ink,
                    fontWeight: FontWeight.w600,
                  )),
                ),
              );
            },
          ),
        ),
        Divider(height: 16, color: AppColors.border),
        Expanded(
          child: _filtered.isEmpty
              ? Center(child: Text('Tidak ada notifikasi.', style: AppTextStyles.bodySmall))
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(AppDimensions.pageHorizontal, 0, AppDimensions.pageHorizontal, AppDimensions.bottomNavClearance),
                  itemCount: _filtered.length,
                  separatorBuilder: (_, _) => Divider(height: 1, color: AppColors.border),
                  itemBuilder: (context, i) => _NotifTile(item: _filtered[i]),
                ),
        ),
      ]),
    );
  }
}

class _NotifTile extends StatelessWidget {
  const _NotifTile({required this.item});
  final NotifItem item;

  IconData get _icon => switch (item.type) {
    NotifType.promo => Icons.local_offer_outlined,
    NotifType.workshop => Icons.brush_outlined,
    NotifType.payment => Icons.payment_outlined,
    NotifType.system => Icons.info_outline,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      color: item.isRead ? null : AppColors.inputBg.withValues(alpha: 0.6),
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingL),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 44, height: 44,
          decoration: BoxDecoration(color: AppColors.black, borderRadius: BorderRadius.circular(AppDimensions.radiusM)),
          child: Icon(_icon, color: AppColors.white, size: 20),
        ),
        SizedBox(width: AppDimensions.gapM),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: AppColors.ink, borderRadius: BorderRadius.circular(4)),
                child: Text(item.badge, style: AppTextStyles.badge.copyWith(fontSize: 9)),
              ),
              Spacer(),
              Text(item.time, style: AppTextStyles.caption),
              if (!item.isRead) ...[
                SizedBox(width: 6),
                CircleAvatar(radius: 4, backgroundColor: Colors.redAccent),
              ],
            ]),
            SizedBox(height: 4),
            Text(item.title, style: AppTextStyles.subTitle),
            SizedBox(height: 2),
            Text(item.body, style: AppTextStyles.bodySmall),
            if (item.actionLabel != null) ...[
              SizedBox(height: AppDimensions.gapS),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size(0, 28)),
                child: Text(item.actionLabel!, style: AppTextStyles.seeAllBold),
              ),
            ],
          ]),
        ),
      ]),
    );
  }
}
