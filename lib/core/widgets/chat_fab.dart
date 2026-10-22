import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../assets.dart';
import '../theme/app_colors.dart';
import '../../features/chatbot/chatbot_screen.dart';

class ChatFab extends StatelessWidget {
  const ChatFab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark || AppColors.isDark;

    return FloatingActionButton(
      onPressed: () => showClayBotPopup(context),
      backgroundColor: AppColors.black,
      elevation: 4,
      shape: CircleBorder(
        side: BorderSide(
          color: isDark
              ? Colors.white.withValues(alpha: 0.35)
              : Colors.white.withValues(alpha: 0.15),
          width: 1.2,
        ),
      ),
      child: SvgPicture.asset(
        AppAssets.iconFloatingCS,
        width: 28,
        height: 28,
        colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
      ),
    );
  }
}
