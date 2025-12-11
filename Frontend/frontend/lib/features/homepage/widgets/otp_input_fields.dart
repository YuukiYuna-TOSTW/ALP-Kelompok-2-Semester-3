import 'package:flutter/material.dart';
import '../../../../config/theme/colors.dart';
import 'package:frontend/config/controller/otp_controller.dart';

class OtpInputFields extends StatelessWidget {
  final OtpController otp;

  const OtpInputFields({super.key, required this.otp});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (i) {
        return Container(
          width: 50,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.cardLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: otp.focusNodes[i].hasFocus
                  ? AppColors.primary
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: TextField(
            controller: otp.controllers[i],
            focusNode: otp.focusNodes[i],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            decoration: const InputDecoration(
              counterText: "",
              border: InputBorder.none,
            ),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.secondary,
            ),
            onChanged: (value) {
              if (value.isNotEmpty && i < 5) {
                otp.focusNodes[i + 1].requestFocus();
              }
              if (value.isEmpty && i > 0) {
                otp.focusNodes[i - 1].requestFocus();
              }
              otp.onUpdate();
            },
          ),
        );
      }),
    );
  }
}
