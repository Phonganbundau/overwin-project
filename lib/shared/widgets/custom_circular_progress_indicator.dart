import 'package:flutter/material.dart';
import 'package:overwin_mobile/shared/theme/app_colors.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  const CustomCircularProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(
        AppColors.secondary,
      ),
    );
  }
}
