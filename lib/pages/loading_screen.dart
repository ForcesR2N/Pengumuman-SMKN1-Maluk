import 'package:flutter/material.dart';
import 'package:pengumuman_smkn_1_maluk/model/student.dart';
import 'package:pengumuman_smkn_1_maluk/pages/result_page.dart';

class LoadingScreen extends StatefulWidget {
  final String nisn;
  final Student student;

  const LoadingScreen({Key? key, required this.nisn, required this.student})
    : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _pulseAnimation;
  int _progressValue = 0;
  String _statusText = "Memulai pencarian data...";

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6000), // Total animation duration
    );

    // Progress animation (0.0 to 1.0)
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Fade in animation for the result
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.8, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Pulse animation for the progress
    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.25), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 1.25, end: 1.0), weight: 1),
    ]).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 0.8, curve: Curves.easeInOut),
      ),
    );

    // Listen to animation progress and update state
    _animationController.addListener(() {
      if (_animationController.value < 0.3) {
        setState(() {
          _progressValue = (_animationController.value * 100 * 0.3).round();
          _statusText = "Mencari data NISN ${widget.nisn}...";
        });
      } else if (_animationController.value < 0.6) {
        setState(() {
          _progressValue =
              (30 + (_animationController.value - 0.3) * 100).round();
          _statusText = "Memeriksa database kelulusan...";
        });
      } else if (_animationController.value < 0.9) {
        setState(() {
          _progressValue =
              (60 + (_animationController.value - 0.6) * 100).round();
          _statusText = "Mempersiapkan hasil pengumuman...";
        });
      } else {
        setState(() {
          _progressValue = 100;
          _statusText = "Selesai!";
        });
      }
    });

    // Start the animation
    _animationController.forward();

    // Navigate to result page after animation completes
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder:
                (context, animation, secondaryAnimation) =>
                    ResultPage(student: widget.student),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade900, Colors.blue.shade700],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // School logo
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: Image.asset(
                    'assets/logo_sekolah.png',
                    height: 100,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback if image not found
                      return Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.school,
                          size: 60,
                          color: Colors.blue.shade700,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 40),
                // Progress indicator
                AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 120,
                              height: 120,
                              child: CircularProgressIndicator(
                                value: _progressAnimation.value,
                                strokeWidth: 8,
                                backgroundColor: Colors.white.withOpacity(0.3),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                            Text(
                              "$_progressValue%",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Text(
                          _statusText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "NISN: ${widget.nisn}",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 40),
                        FadeTransition(
                          opacity: _fadeInAnimation,
                          child: const Text(
                            "Mohon tunggu sebentar...",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
