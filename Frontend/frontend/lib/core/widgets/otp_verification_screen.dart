import 'package:flutter/material.dart';
import '../../../../config/theme/colors.dart';
import '../widgets/otp_background.dart';
import 'package:frontend/config/controller/otp_controller.dart';
import '../widgets/otp_input_fields.dart';

class OtpVerificationPage extends StatefulWidget {
  const OtpVerificationPage({super.key});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage>
    with SingleTickerProviderStateMixin {
  late OtpController otp;

  @override
  void initState() {
    super.initState();
    otp = OtpController(onUpdate: () => setState(() {}));
    otp.initAnimation(this);
    otp.startTimer();
    otp.setupFocusListeners();
  }

  @override
  void dispose() {
    otp.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
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
                          colors: [primaryColor, secondaryColor],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.4),
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
                      colors: [primaryColor, secondaryColor],
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
                    "${otp.remainingTime} detik",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: secondaryColor,
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
                        backgroundColor: primaryColor,
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
                    onPressed: () {
                      otp.resendOtp();
                    },
                    child: Text(
                      "Tidak menerima kode? Kirim Ulang",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: secondaryColor,
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
