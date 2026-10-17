import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class AddressItem {
const   AddressItem({required this.id, required this.name, required this.phone, required this.address, this.isPrimary = false});
  final String id;
  final String name;
  final String phone;
  final String address;
  final bool isPrimary;
}

/// Halaman daftar alamat — dipakai dari Profile dan Checkout
class AddressPage extends StatelessWidget {
const   AddressPage({super.key});

  // TODO: Ambil dari address repository
  static const _addresses = [
    AddressItem(id: '1', name: 'Customer', phone: '0859-777-588-138',
      address: 'Jl. Sawiji Sari No.14, Kel. Mulyorejo, Kec. Sukun, Kota Malang, Jawa Timur 65147', isPrimary: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg, elevation: 0, scrolledUnderElevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: AppColors.ink), onPressed: () => Navigator.of(context).maybePop()),
        title: Text('Alamat Pengiriman', style: AppTextStyles.appBarTitle),
        actions: [
          TextButton.icon(
            onPressed: () { /* TODO: show form tambah alamat */ },
            icon: Icon(Icons.add, size: 18, color: AppColors.ink),
            label: Text('Tambah', style: AppTextStyles.fieldLabel),
          ),
        ],
      ),
      body: _addresses.isEmpty
          ? _EmptyAddress(onAddTap: () { /* TODO */ })
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(AppDimensions.pageHorizontal, AppDimensions.paddingL, AppDimensions.pageHorizontal, AppDimensions.bottomNavClearance),
              itemCount: _addresses.length,
              separatorBuilder: (_, _) => SizedBox(height: AppDimensions.paddingM),
              itemBuilder: (context, i) => _AddressTile(
                address: _addresses[i],
                onEdit: () { /* TODO: edit address */ },
                onDelete: () { /* TODO: delete address */ },
                onSelect: () { Navigator.of(context).pop(_addresses[i]); },
              ),
            ),
    );
  }
}

class _EmptyAddress extends StatelessWidget {
  const _EmptyAddress({required this.onAddTap});
  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.location_off_outlined, size: 48, color: AppColors.textMuted),
      SizedBox(height: AppDimensions.paddingL),
      Text('Belum ada alamat', style: AppTextStyles.cardTitle),
      SizedBox(height: AppDimensions.gapS),
      Text('Tambahkan alamat pengiriman Anda.', style: AppTextStyles.bodySmall),
      SizedBox(height: AppDimensions.paddingL),
      ElevatedButton(
        onPressed: onAddTap,
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.black, foregroundColor: AppColors.white, elevation: 0, shape: StadiumBorder()),
        child: Text('Tambah Alamat Baru', style: AppTextStyles.buttonLabel),
      ),
    ]),
  );
}

class _AddressTile extends StatelessWidget {
  const _AddressTile({required this.address, required this.onEdit, required this.onDelete, required this.onSelect});
  final AddressItem address;
  final VoidCallback onEdit, onDelete, onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        border: Border.all(color: address.isPrimary ? AppColors.ink : AppColors.border, width: address.isPrimary ? 1.5 : 1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(address.name, style: AppTextStyles.subTitle),
          if (address.isPrimary) ...[
            SizedBox(width: AppDimensions.gapS),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: AppColors.ink, borderRadius: BorderRadius.circular(AppDimensions.radiusS)),
              child: Text('UTAMA', style: AppTextStyles.badge),
            ),
          ],
          Spacer(),
          IconButton(onPressed: onEdit, icon: Icon(Icons.edit_outlined, size: 18, color: AppColors.textSecondary), padding: EdgeInsets.zero),
          IconButton(onPressed: onDelete, icon: Icon(Icons.delete_outline, size: 18, color: Colors.redAccent), padding: EdgeInsets.zero),
        ]),
        SizedBox(height: AppDimensions.gapXS),
        Text(address.phone, style: AppTextStyles.bodySmall),
        SizedBox(height: AppDimensions.gapXS),
        Text(address.address, style: AppTextStyles.bodySmall),
        SizedBox(height: AppDimensions.paddingM),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: onSelect,
            style: OutlinedButton.styleFrom(side: BorderSide(color: AppColors.border), shape: StadiumBorder()),
            child: Text('Ubah Alamat', style: AppTextStyles.seeAll),
          ),
        ),
      ]),
    );
  }
}
