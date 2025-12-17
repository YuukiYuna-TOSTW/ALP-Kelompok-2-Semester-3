import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/features/homepage/widgets/otp_success_dialog.dart';
import 'package:frontend/core/services/otp_service.dart'; // ✅ pastikan ada
import 'package:frontend/features/auth/widgets/otp_code_dialog.dart';
import 'package:frontend/main.dart';

class OtpController {
  final VoidCallback onUpdate;
  final String email;

  OtpController({required this.onUpdate, required this.email});

  int remainingTime = 300;
  bool canResend = false;
  bool isVerifying = false;

  List<TextEditingController> controllers = List.generate(6, (_) => TextEditingController());
  List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  Timer? _timer;
  late AnimationController animationController;
  late Animation<double> scaleAnimation;

  // ✅ TAMBAH: property untuk ambil OTP yang diinput
  String get pin => controllers.map((c) => c.text).join();

  void initAnimation(TickerProvider vsync) {
    animationController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 500),
    );
    scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );
    animationController.repeat(reverse: true);
  }

  void setupFocusListeners() {
    for (int i = 0; i < 6; i++) {
      focusNodes[i].addListener(onUpdate);
    }
  }

  void startTimer() {
    _timer?.cancel();
    remainingTime = 300; // 5 menit
    canResend = false;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        remainingTime--;
        onUpdate();
      } else {
        canResend = true;
        onUpdate();
        timer.cancel();
      }
    });
  }

  /// Format waktu menjadi MM:SS
  String get formattedTime {
    final minutes = remainingTime ~/ 60;
    final seconds = remainingTime % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> resendOtp(BuildContext context) async {
    for (var c in controllers) {
      c.clear();
    }

    isVerifying = true;
    onUpdate();

    try {
      final result = await OtpService.resendOtp(email: email);

      if (result['success'] == true) {
        final otpCode = result['otp_code'] ?? '';

        // Tampilkan pop-up dengan kode OTP baru
        if (context.mounted) {
          showOtpCodeDialog(context, otpCode, email);
        }

        startTimer();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kode OTP baru telah dikirim!')),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'] ?? 'Gagal mengirim OTP')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Terjadi kesalahan')));
      }
    } finally {
      isVerifying = false;
      onUpdate();
    }
  }

  // ✅ BARU: method untuk verify OTP + get user role
  Future<void> verifyOtpWithRole(BuildContext context, RoleController roleController) async {
    String otp = pin;

    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Masukkan 6 digit OTP")),
      );
      return;
    }

    isVerifying = true;
    onUpdate();

    try {
      final result = await OtpService.verifyOtp(email: email, otp: otp);

      if (result['success'] == true) {
        final userData = result['user'] as Map<String, dynamic>?;
        final role = userData?['Role']?.toString() ?? 'guru';

        // ✅ Set role ke RoleController
        roleController.setRole(role);

        if (context.mounted) {
          showOtpSuccessDialog(context);
          await Future.delayed(const Duration(milliseconds: 1500));
          Navigator.of(context).pushNamedAndRemoveUntil('/dashboard', (route) => false);
        }
      } else {
        final msg = result['message'] ?? 'Kode OTP tidak valid';
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Terjadi kesalahan verifikasi')),
        );
      }
    } finally {
      isVerifying = false;
      onUpdate();
    }
  }

  void dispose() {
    _timer?.cancel();
    animationController.dispose();
    for (var c in controllers) {
      c.dispose();
    }
    for (var f in focusNodes) {
      f.dispose();
    }
  }
}
