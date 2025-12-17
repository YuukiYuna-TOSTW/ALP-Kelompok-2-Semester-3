import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/theme/colors.dart';
import '../../homepage/widgets/otp_background.dart';
import 'package:frontend/config/controller/otp_controller.dart';
import '../../homepage/widgets/otp_input_fields.dart';
import '../../../main.dart';
import '../../../core/services/otp_service.dart';

class OtpVerificationPage extends StatefulWidget {
  final String email;

  const OtpVerificationPage({
    super.key,
    required this.email,
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
  }

  @override
  void dispose() {
    otp.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                        gradient: const LinearGradient(
                          colors: [Color(0xFF75CFFF), Color(0xFF4DAFF5)],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF75CFFF).withOpacity(0.4),
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
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFF75CFFF), Color(0xFF4DAFF5)],
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
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4DAFF5),
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      // ✅ UBAH: panggil method verify
                      onPressed: otp.isVerifying ? null : () => _verifyOtpFromUser(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4DAFF5),
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
                    onPressed: otp.canResend ? () => otp.resendOtp(context) : null,
                    child: Text(
                      otp.canResend
                          ? "Tidak menerima kode? Kirim Ulang"
                          : "Tunggu ${otp.formattedTime} untuk kirim ulang",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: otp.canResend
                            ? const Color(0xFF4DAFF5)
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

  // ✅ BARU: Verify OTP yang diinput user dengan OTP dari backend
  Future<void> _verifyOtpFromUser() async {
    otp.isVerifying = true;
    setState(() {});

    final otpInput = otp.pin; // ✅ ambil OTP yang user inputkan

    if (otpInput.isEmpty || otpInput.length != 6) {
      _showSnack("Masukkan 6 digit OTP");
      otp.isVerifying = false;
      setState(() {});
      return;
    }

    // ✅ Kirim OTP yang user inputkan ke backend untuk verifikasi
    final res = await OtpService.verifyOtp(
      email: widget.email,
      otp: otpInput,
    );

    if (res['success'] == true) {
      final userData = res['user'] as Map<String, dynamic>;
      final role = userData['Role']?.toString() ?? 'guru';

      print('✅ OTP Verified with backend');
      print('User: ${userData['Nama_User']}');
      print('Role: $role');

      if (mounted) {
        // ✅ Set role dari response backend
        context.read<RoleController>().setRole(role);

        // ✅ Tampilkan success dialog
        showOtpSuccessDialog(context);

        await Future.delayed(const Duration(milliseconds: 1500));
        if (mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/dashboard',
            (route) => false,
          );
        }
      }
    } else {
      _showSnack(res['message'] ?? 'OTP tidak valid atau kadaluarsa');
    }

    otp.isVerifying = false;
    if (mounted) setState(() {});
  }

  void _showSnack(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
    }
  }
}

// ✅ IMPORT dialog
void showOtpSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              'Verifikasi Berhasil!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Anda akan diarahkan ke dashboard',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    },
  );
}
