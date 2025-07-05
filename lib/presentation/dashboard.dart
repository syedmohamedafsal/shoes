import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shoes_ui/presentation/detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  String _selectedCategory = 'Basketball';
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentPage = 0;

  late AnimationController _fadeController;
  // late Animation<double> _fadeAnimation;
  late List<Animation<double>> _fadeAnimations;
  late AnimationController _controller;

  final List<Map<String, dynamic>> _products = [
    {
      'title': 'Air Max 270',
      'subtitle': 'Men’s Shoe',
      'image': 'assets/images/shoes 3.png',
      'color': Colors.redAccent,
      'watermark': ['NIKE', 'AIR'],
    },
    {
      'title': 'Nike Court',
      'subtitle': 'Nike\'s new court shoes',
      'image': 'assets/images/shoes 7.png',
      'color': const Color.fromARGB(255, 77, 197, 240),
      'watermark': ['NIKE', 'COURT'],
    },
    {
      'title': 'Nike Zoom',
      'subtitle': 'High performance running',
      'image': 'assets/images/shoe 4.png',
      'color': const Color(0xFFBBDEFB),
      'watermark': ['NIKE', 'ZOOM'],
    },
  ];
  final int _itemCount = 14;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _fadeAnimations = List.generate(_itemCount, (index) {
      final start = index * 0.06;
      final end = (start + 0.3).clamp(0.0, 1.0);
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _fadeController,
          curve: Interval(start, end, curve: Curves.easeInOut),
        ),
      );
    });

    // 👇 Add delay before starting animation
    Future.delayed(const Duration(milliseconds: 500), () {
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: FadeTransition(
          opacity: _fadeAnimations[0],
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Image.asset(
              'assets/images/nike_logo-bg.png',
              height: 30,
              width: 30,
            ),
          ),
        ),
        actions: [
          FadeTransition(
            opacity: _fadeAnimations[0],
            child: IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {},
            ),
          ),
          FadeTransition(
            opacity: _fadeAnimations[2],
            child: IconButton(
              icon:
                  const Icon(Icons.shopping_bag_outlined, color: Colors.white),
              onPressed: () {},
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Tabs
          FadeTransition(
            opacity: _fadeAnimations[3],
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  _buildCategoryTab('Basketball'),
                  const SizedBox(width: 20),
                  _buildCategoryTab('Running'),
                  const SizedBox(width: 20),
                  _buildCategoryTab('Training'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 80),

          // Carousel
          FadeTransition(
            opacity: _fadeAnimations[4],
            child: SizedBox(
              height: 500,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _products.length,
                onPageChanged: (int index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final double scale = _currentPage == index ? 1.0 : 0.9;
                  final double opacity = _currentPage == index ? 1.0 : 0.6;

                  return TweenAnimationBuilder(
                    duration: const Duration(milliseconds: 400),
                    tween: Tween<double>(begin: scale, end: scale),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Opacity(
                          opacity: opacity,
                          child: _buildProductCard(
                            context,
                            _products[index]['title'],
                            _products[index]['subtitle'],
                            _products[index]['image'],
                            _products[index]['color'],
                            _products[index]['watermark'],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
      bottomNavigationBar: FadeTransition(
        opacity: _fadeAnimations[5],
        child: _buildBottomNavigationBar(screenSize),
      ),
    );
  }

  Widget _buildCategoryTab(String title) {
    final bool isSelected = _selectedCategory == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = title;
        });
      },
      child: Text(
        title,
        style: GoogleFonts.orbit(
          color: isSelected
              ? const Color(0xFFFDD835)
              : Colors.white.withOpacity(0.6),
          fontSize: 18,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    String title,
    String subtitle,
    String imageUrl,
    Color accentColor,
    List<String> watermarkLines,
  ) {
    final Size screenSize = MediaQuery.of(context).size;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailPage(
              title: title,
              price: '\$2000',
              imageUrl: imageUrl,
              accentColor: accentColor,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        width: screenSize.width * 0.75,
        height: 300,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.orbit(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              style: GoogleFonts.orbit(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 400,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    bottom: 200,
                    right: 50,
                    child: Opacity(
                      opacity: 0.1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: watermarkLines
                            .map((line) => Text(
                                  line,
                                  style: GoogleFonts.bubblegumSans(
                                    fontSize: screenSize.width * 0.2,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black,
                                    height: 0.9,
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    left: 0,
                    right: 0,
                    child: Hero(
                      tag: 'shoe-image-$title',
                      child: Image.asset(
                        imageUrl,
                        height: 400,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 0,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:
                          const Icon(Icons.add, color: Colors.black, size: 24),
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

  Widget _buildBottomNavigationBar(Size screenSize) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBottomNavItem(FontAwesomeIcons.house, isSelected: true),
          _buildBottomNavItem(FontAwesomeIcons.camera),
          _buildBottomNavItem(FontAwesomeIcons.user),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, {bool isSelected = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FaIcon(
          icon,
          color: isSelected
              ? const Color(0xFFFDD835)
              : Colors.white.withOpacity(0.6),
          size: 24,
        ),
        if (isSelected)
          Container(
            margin: const EdgeInsets.only(top: 4),
            height: 4,
            width: 4,
            decoration: const BoxDecoration(
              color: Color(0xFFFDD835),
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }
}
