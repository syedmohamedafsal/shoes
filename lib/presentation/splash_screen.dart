import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shoes_ui/presentation/dashboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _textController;
  late AnimationController _shoeController;

  late Animation<Offset> _textAnimation;
  late Animation<Offset> _shoeAnimation;

  @override
  void initState() {
    super.initState();

    _textController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _shoeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _textAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOut,
    ));

    _shoeAnimation = Tween<Offset>(
      begin: const Offset(0, 2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _shoeController,
      curve: Curves.easeOutBack,
    ));

    _startAnimations();

    // Navigate to Dashboard after 3.5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    });
  }

  void _startAnimations() async {
    await _textController.forward();
    await _shoeController.forward();
  }

  @override
  void dispose() {
    _textController.dispose();
    _shoeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFE0E5EB),
      body: Stack(
        children: [
          // Top "Now" Text
          Positioned(
            top: screenSize.height * 0.15,
            left: screenSize.width * 0.08,
            child: SlideTransition(
              position: _textAnimation,
              child: Text(
                'Now',
                style: GoogleFonts.bubblegumSans(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // "AIR MAX BUBBLE PACK"
          Positioned(
            top: screenSize.height * 0.2,
            left: screenSize.width * 0.05,
            child: SlideTransition(
              position: _textAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'AIR MAX',
                    style: GoogleFonts.bubblegumSans(
                      color: Colors.white,
                      fontSize: screenSize.width * 0.25,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                      height: 0.9,
                    ),
                  ),
                  Text(
                    'BUBBLE',
                    style: GoogleFonts.bubblegumSans(
                      color: Colors.white,
                      fontSize: screenSize.width * 0.25,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                      height: 0.9,
                    ),
                  ),
                  Text(
                    'PACK',
                    style: GoogleFonts.bubblegumSans(
                      color: Colors.white,
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

          // Shoe IconButton (FontAwesome)
          // Positioned(
          //   top: screenSize.height * 0.05,
          //   right: screenSize.width * 0.05,
          //   child: IconButton(
          //     icon: const FaIcon(FontAwesomeIcons.shoePrints, color: Colors.black),
          //     onPressed: () {
          //       // Do something if needed
          //     },
          //   ),
          // ),

          // Shoe Image
          Positioned(
            bottom: -screenSize.height * 0.28,
            right: -screenSize.width * 0.2,
            child: SlideTransition(
              position: _shoeAnimation,
              child: Transform.rotate(
                angle: -0.2,
                child: Image.asset(
                  'assets/images/shoes 3.png',
                  width: screenSize.width * 1.8,
                  height: screenSize.height * 0.8,
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
