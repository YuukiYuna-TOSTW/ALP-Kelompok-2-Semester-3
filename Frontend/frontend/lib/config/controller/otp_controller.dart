import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/features/homepage/widgets/otp_success_dialog.dart';

class OtpController {
  final VoidCallback onUpdate;
  OtpController({required this.onUpdate});

  int remainingTime = 60;
  bool canResend = false;
  bool isVerifying = false;

  List<TextEditingController> controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  Timer? _timer;

  late AnimationController animationController;
  late Animation<double> scaleAnimation;

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
    remainingTime = 60;
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

  void resendOtp() {
    for (var c in controllers) {
      c.clear();
    }
    startTimer();
    onUpdate();
  }

  void verifyOtp(BuildContext context) {
    String otp = controllers.map((c) => c.text).join();

    if (otp.length != 6) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Masukkan 6 digit OTP")));
      return;
    }

    isVerifying = true;
    onUpdate();

    Future.delayed(const Duration(seconds: 2), () {
      isVerifying = false;
      onUpdate();
      showOtpSuccessDialog(context);
    });
  }

  void dispose() {
    _timer?.cancel();
    animationController.dispose();
    for (var c in controllers) c.dispose();
    for (var f in focusNodes) f.dispose();
  }
}
