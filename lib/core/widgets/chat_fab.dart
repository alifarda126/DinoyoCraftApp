import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../assets.dart';
import '../theme/app_colors.dart';

class ChatFab extends StatelessWidget {
  const ChatFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => context.push('/chatbot'),
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
