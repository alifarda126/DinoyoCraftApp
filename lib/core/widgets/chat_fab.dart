import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../assets.dart';
import '../theme/app_colors.dart';
import '../../features/chatbot/chatbot_screen.dart';

class ChatFab extends StatelessWidget {
  const ChatFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => showClayBotPopup(context),
      backgroundColor: AppColors.black,
      elevation: 4,
      shape: const CircleBorder(),
      child: SvgPicture.asset(
        AppAssets.iconChat,
        width: 24,
        height: 24,
        colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
      ),
    );
  }
}
