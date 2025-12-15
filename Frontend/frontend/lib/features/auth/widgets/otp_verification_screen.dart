import 'package:flutter/material.dart';
import '../../../config/theme/colors.dart';
import '../../homepage/widgets/otp_background.dart';
import 'package:frontend/config/controller/otp_controller.dart';
import '../../homepage/widgets/otp_input_fields.dart';
import 'otp_code_dialog.dart';

class OtpVerificationPage extends StatefulWidget {
  final String email;
  final String otpCode; // Kode OTP dari backend untuk ditampilkan

  const OtpVerificationPage({
    super.key,
    required this.email,
    required this.otpCode,
  });

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage>
    with SingleTickerProviderStateMixin {
  late OtpController otp;

  @override
  void initState() {
    super.initState();
    otp = OtpController(onUpdate: () => setState(() {}), email: widget.email);
    otp.initAnimation(this);
    otp.startTimer();
    otp.setupFocusListeners();

    // Tampilkan pop-up kode OTP setelah widget dibangun
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.otpCode.isNotEmpty) {
        showOtpCodeDialog(context, widget.otpCode, widget.email);
      }
    });
  }

  @override
  void dispose() {
    otp.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            const OtpBackground(),

            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  AnimatedBuilder(
                    animation: otp.scaleAnimation,
                    builder: (_, child) {
                      return Transform.scale(
                        scale: otp.scaleAnimation.value,
                        child: child,
                      );
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.secondary],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.4),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.lock_outline,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                    ).createShader(bounds),
                    child: const Text(
                      'Verifikasi Email',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  const Text(
                    "Masukkan Kode OTP",
                    style: TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 20),

                  OtpInputFields(otp: otp),

                  const SizedBox(height: 20),

                  Text(
                    otp.formattedTime,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: otp.isVerifying
                          ? null
                          : () => otp.verifyOtp(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: otp.isVerifying
                          ? const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            )
                          : const Text(
                              "Verifikasi Sekarang",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: otp.canResend
                        ? () {
                            otp.resendOtp(context);
                          }
                        : null,
                    child: Text(
                      otp.canResend
                          ? "Tidak menerima kode? Kirim Ulang"
                          : "Tunggu ${otp.formattedTime} untuk kirim ulang",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: otp.canResend
                            ? AppColors.secondary
                            : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
