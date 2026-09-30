import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/dc_app_header.dart';
import '../../core/widgets/dc_button.dart';
import '../../data/mock_data.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final faqs = MockData.faqs
        .where(
          (f) =>
              _query.isEmpty ||
              f.question.toLowerCase().contains(_query.toLowerCase()) ||
              f.answer.toLowerCase().contains(_query.toLowerCase()),
        )
        .toList();

    return CustomScrollView(
      slivers: [
        const SliverPinnedDcHeader(),
        SliverPadding(
          padding: const EdgeInsets.only(bottom: 100),
          sliver: SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Butuh Bantuan?',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Temukan jawaban cepat atau hubungi tim kami.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    onChanged: (v) => setState(() => _query = v),
                    decoration: InputDecoration(
                      hintText: 'Cari pertanyaan...',
                      hintStyle: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: AppColors.textMuted,
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12),
                        child: SvgPicture.asset(
                          AppAssets.iconSearch,
                          width: 20,
                          height: 20,
                          colorFilter: const ColorFilter.mode(
                            AppColors.textMuted,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      filled: true,
                      fillColor: AppColors.inputBg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'FAQ',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...faqs.map(
                    (f) => Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        tilePadding: EdgeInsets.zero,
                        childrenPadding:
                            const EdgeInsets.only(bottom: 12),
                        title: Text(
                          f.question,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                          ),
                        ),
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              f.answer,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                height: 1.5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
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
                          'Kontak Customer Service',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Email: hello@dinoyocraft.id\nWhatsApp: +62 812-3456-7890\nJam operasional: 09.00–18.00 WIB',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            height: 1.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  DcButton(
                    label: 'ClayBot Asisten',
                    trailingIconPath: AppAssets.iconChat,
                    onPressed: () => context.push('/chatbot'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
