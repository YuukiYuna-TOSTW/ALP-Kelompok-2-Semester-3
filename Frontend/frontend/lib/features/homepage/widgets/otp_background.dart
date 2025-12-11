import 'package:flutter/material.dart';
import '../../../../config/theme/colors.dart';

class OtpBackground extends StatelessWidget {
  const OtpBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -50,
          right: -30,
          child: _bubble(150, AppColors.primary.withOpacity(0.1)),
        ),
        Positioned(
          bottom: -80,
          left: -40,
          child: _bubble(200, AppColors.accent.withOpacity(0.1)),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.4,
          left: 20,
          child: _bubble(60, AppColors.secondary.withOpacity(0.07)),
        ),
      ],
    );
  }

  Widget _bubble(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
