import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_text.dart';
import '../../core/assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/dc_app_header.dart';
import '../../core/widgets/dc_button.dart';

class WorkshopScreen extends StatelessWidget {
  const WorkshopScreen({super.key});

  static const String _phoneNumber = '+62 812-3553-1979';
  static const String _waNumber = '6281235531979';
  static const String _email = 'kreasikeramikdinoyo58@gmail.com';
  static const String _address =
      'Jl. Mt Haryono 9 No.336, Dinoyo, Kec. Lowokwaru, Kota Malang, Jawa Timur 65144, Indonesia';

  Future<void> _openWhatsApp(BuildContext context) async {
    final message = Uri.encodeComponent(
      'Halo Dinoyo Ceramic, saya ingin reservasi/tanya seputar jadwal workshop keramik.',
    );
    final uri = Uri.parse('https://wa.me/$_waNumber?text=$message');
    try {
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tidak dapat membuka WhatsApp'.tr)),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tidak dapat membuka WhatsApp'.tr)),
        );
      }
    }
  }

  Future<void> _openMaps(BuildContext context) async {
    final query = Uri.encodeComponent(
      'Kampung Wisata Keramik Dinoyo, $_address',
    );
    final uri =
        Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  Future<void> _openEmail(BuildContext context) async {
    final uri = Uri.parse(
      'mailto:$_email?subject=${Uri.encodeComponent('Reservasi Workshop Keramik Dinoyo')}',
    );
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  Future<void> _handleRefresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
  }

  @override
  Widget build(BuildContext context) {
    final topHeaderHeight = DcAppHeader.totalHeight(context);

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: AppColors.ink,
      backgroundColor: AppColors.surfaceElevated,
      edgeOffset: topHeaderHeight,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          SliverPinnedDcHeader(),
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Workshop Keramik'.tr,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 14),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Stack(
                          children: [
                            AspectRatio(
                              aspectRatio: 16 / 10,
                              child: Image.asset(
                                AppAssets.workshopHero,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned.fill(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withValues(alpha: 0.65),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 16,
                              right: 16,
                              bottom: 16,
                              child: Text(
                                'Rasakan pengalaman membentuk tanah liat bersama pengrajin Dinoyo'.tr,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.white,
                                  height: 1.35,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      _InfoCard(
                        title: 'Pengalaman Workshop'.tr,
                        child: Text(
                          'Sesi 2 jam: pengenalan tanah liat, teknik dasar throwing/handbuilding, '
                          'glazing intro, dan hasil karya bisa dibawa pulang setelah pembakaran '
                          '(estimasi 7–14 hari). Cocok untuk pemula, keluarga & komunitas.'.tr,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            height: 1.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _InfoCard(
                        title: 'Jadwal Operasional Workshop'.tr,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Kampung Wisata Keramik Dinoyo'.tr,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildScheduleRow('Sabtu – Kamis', '08.00 - 15.00'),
                            _buildScheduleRow('Jumat', '08.00 - 10.30\n13.30 - 14.30'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      _InfoCard(
                        title: 'Contact Person & Lokasi'.tr,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.person_outline_rounded,
                                    size: 18, color: AppColors.ink),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Dinoyo Ceramic',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.ink,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      InkWell(
                                        onTap: () => _openWhatsApp(context),
                                        child: Text(
                                          'WhatsApp: $_phoneNumber',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.ink,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Divider(height: 1),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.location_on_outlined,
                                    size: 18, color: AppColors.ink),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _address,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 13,
                                          height: 1.4,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      InkWell(
                                        onTap: () => _openMaps(context),
                                        child: Text(
                                          'Buka di Google Maps'.tr,
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF2563EB),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Divider(height: 1),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.email_outlined,
                                    size: 18, color: AppColors.ink),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: InkWell(
                                    onTap: () => _openEmail(context),
                                    child: Text(
                                      _email,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.ink,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      DcButton(
                        label: 'Reservasi via WhatsApp'.tr,
                        trailingIcon: Icons.open_in_new,
                        onPressed: () => _openWhatsApp(context),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleRow(String day, String hours) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            day.tr,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              hours,
              textAlign: TextAlign.end,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
