import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shoes_ui/presentation/dashboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late List<Animation<double>> _fadeAnimations;

  final int _itemCount = 4; // 1: Now, 2: AIR MAX BUBBLE PACK, 3: Shoe image

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _fadeAnimations = List.generate(_itemCount, (index) {
      final start = index * 0.1;
      final end = (start + 0.4).clamp(0.0, 1.0);
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _fadeController,
          curve: Interval(start, end, curve: Curves.easeInOut),
        ),
      );
    });

    // Start fade animation
    Future.delayed(const Duration(milliseconds: 400), () {
      _fadeController.forward();
    });

    // Navigate to Dashboard after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Stack(
        children: [
          // Top "Now"
          Positioned(
            top: screenSize.height * 0.15,
            left: screenSize.width * 0.08,
            child: FadeTransition(
              opacity: _fadeAnimations[0],
              child: Text(
                'Now',
                style: GoogleFonts.bubblegumSans(
                  color: const Color(0xFFFDD835),
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // AIR MAX BUBBLE PACK
          Positioned(
            top: screenSize.height * 0.2,
            left: screenSize.width * 0.05,
            child: FadeTransition(
              opacity: _fadeAnimations[1],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'AIR MAX',
                    style: GoogleFonts.bubblegumSans(
                      color: const Color(0xFFFDD835),
                      fontSize: screenSize.width * 0.25,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                      height: 0.9,
                    ),
                  ),
                  Text(
                    'BUBBLE',
                    style: GoogleFonts.bubblegumSans(
                      color: const Color(0xFFFDD835),
                      fontSize: screenSize.width * 0.25,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                      height: 0.9,
                    ),
                  ),
                  Text(
                    'PACK',
                    style: GoogleFonts.bubblegumSans(
                      color: const Color(0xFFFDD835),
                      fontSize: screenSize.width * 0.28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                      height: 0.9,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Shoe Image
          Positioned(
            bottom: -screenSize.height * 0.35,
            right: -screenSize.width * 0.4,
            child: FadeTransition(
              opacity: _fadeAnimations[3],
              child: Transform.rotate(
                angle: -0.5,
                child: Image.asset(
                  'assets/images/shoes 2.png',
                  width: screenSize.width * 2.8,
                  height: screenSize.height * 1.2,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
