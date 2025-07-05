// Your imports remain the same
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProductDetailPage extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String price;
  final Color accentColor;

  const ProductDetailPage({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.accentColor,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with TickerProviderStateMixin {
  String _selectedSize = '9.5';
  bool _isExpanded = false;
  final List<String> _allSizes = ['8', '9', '9.5', '10', '11', '11.5', '12'];
  int _currentSizePage = 0;

  List<String> get _visibleSizes {
    int start = _currentSizePage * 3;
    int end = start + 3;
    return _allSizes.sublist(
        start, end > _allSizes.length ? _allSizes.length : end);
  }

  bool _isFavorite = false;
  Color _selectedColor = Colors.green;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  final int _itemCount =
      14; // Total number of widgets inside the Column (adjust as needed)

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut, // bouncy pop effect
    );
    _fadeAnimations = List.generate(_itemCount, (index) {
      final start = index * 0.06;
      final end = start + 0.3;
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeIn),
        ),
      );
    });

    _slideAnimations = List.generate(_itemCount, (index) {
      final start = index * 0.06;
      final end = start + 0.3;
      return Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
          .animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeOut),
        ),
      );
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool anySelected = _selectedColor != null;
    final List<Color> colors = [Colors.blue, Colors.red, Colors.grey];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            /// BACKGROUND: Tilted Nike Text
            Positioned(
              top: 180,
              left: -25,
              child: Center(
                child: Transform.rotate(
                  angle: -0.2,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Text(
                      'NIKE',
                      style: GoogleFonts.bebasNeue(
                        fontSize: 350,
                        color: Colors.grey.withOpacity(0.2),
                        fontWeight: FontWeight.w900,
                        letterSpacing: -2,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 280,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 350,
                child: Hero(
                  tag: 'shoe-image-${widget.title}', // Match the dashboard tag
                  child: Image.asset(
                    widget.imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            /// FOREGROUND: All main content
            Column(
              children: [
                // Top Bar
                FadeTransition(
                  opacity: _fadeAnimations[0],
                  child: SlideTransition(
                    position: _slideAnimations[0],
                    child: Padding(
                      padding: const EdgeInsets.only(right: 25, left: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _circleButton(Icons.arrow_back, () {
                            Navigator.pop(context);
                          }),
                          Image.asset('assets/images/nike_logo-bg.png',
                              height: 50, width: 50),
                          Stack(
                            children: [
                              _circleButton(
                                  Icons.shopping_cart_outlined, () {}),
                              Positioned(
                                right: 32,
                                top: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  constraints: const BoxConstraints(
                                      minWidth: 18, minHeight: 18),
                                  child: Text(
                                    '3',
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                FadeTransition(
                  opacity: _fadeAnimations[2],
                  child: SlideTransition(
                    position: _slideAnimations[2],
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        widget.title,
                        style: GoogleFonts.orbit(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),

                FadeTransition(
                  opacity: _fadeAnimations[3],
                  child: SlideTransition(
                    position: _slideAnimations[3],
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Unisex',
                        style: GoogleFonts.orbit(
                            fontSize: 16, color: Colors.black54),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Size, Color, Fav
                FadeTransition(
                  opacity: _fadeAnimations[5],
                  child: SlideTransition(
                    position: _slideAnimations[5],
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25.0, right: 25),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Size
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text('Size',
                                    style: GoogleFonts.orbit(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                              ),
                              const SizedBox(height: 8),
                              if (_currentSizePage > 0)
                                GestureDetector(
                                  onTap: () =>
                                      setState(() => _currentSizePage--),
                                  child: _buildArrowButton(isUp: true),
                                ),
                              const SizedBox(height: 8),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                transitionBuilder: (child, animation) {
                                  return SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0.0, 0.3),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: FadeTransition(
                                        opacity: animation, child: child),
                                  );
                                },
                                child: Column(
                                  key: ValueKey<int>(_currentSizePage),
                                  children: _visibleSizes
                                      .map((size) => Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8),
                                            child: _buildSizeButton(size),
                                          ))
                                      .toList(),
                                ),
                              ),
                              const SizedBox(height: 8),
                              if ((_currentSizePage + 1) * 3 < _allSizes.length)
                                GestureDetector(
                                  onTap: () =>
                                      setState(() => _currentSizePage++),
                                  child: _buildArrowButton(isUp: false),
                                ),
                            ],
                          ),
                          const SizedBox(width: 80),

                          // Color
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Active',
                                  style: GoogleFonts.orbit(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black38)),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: colors.map((color) {
                                  final bool isActive = color == _selectedColor;
                                  final bool isDimmed = !isActive;
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: anySelected ? 4.0 : 8.0),
                                    child: _buildColorDot(
                                        color, isActive, isDimmed),
                                  );
                                }).toList(),
                              )
                            ],
                          ),
                          const Spacer(),

                          // Fav
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Text('Fav',
                                    style: GoogleFonts.orbit(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                              ),
                              const SizedBox(height: 8),

                              // Replace your existing favorite UI with this:
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isFavorite = !_isFavorite;
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.black87, width: 1.5),
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: _isFavorite
                                            ? [
                                                BoxShadow(
                                                  color: const Color.fromARGB(
                                                          255, 0, 0, 0)
                                                      .withOpacity(0.3),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ]
                                            : [],
                                      ),
                                      child: Icon(
                                        _isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  if (_isFavorite)
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Text(
                                        'Added',
                                        style: GoogleFonts.orbit(
                                            fontSize: 12,
                                            color: Colors.black54),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 130),

                // Bottom Row
                FadeTransition(
                  opacity: _fadeAnimations[7],
                  child: SlideTransition(
                    position: _slideAnimations[7],
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25.0, right: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Question',
                                  style: GoogleFonts.orbit(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              const SizedBox(height: 8),
                              _circleIcon(Icons.question_mark_rounded),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Price',
                                  style: GoogleFonts.orbit(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              const SizedBox(height: 4),
                              Text(widget.price,
                                  style: GoogleFonts.inter(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Viewed',
                                  style: GoogleFonts.orbit(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black45)),
                              const SizedBox(height: 8),
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black26,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Opacity(
                                  opacity: 0.5, // Adjusts image transparency
                                  child: Transform.translate(
                                    offset: const Offset(0,
                                        2), // Adjust vertical/horizontal position
                                    child: Transform.scale(
                                      scale:
                                          0.8, // Shrink or enlarge image (0.8 = 80% of original size)
                                      child: Image.asset(
                                        'assets/images/shoes 2.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black26,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Opacity(
                                  opacity: 0.5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      'assets/images/shoe 4.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                FadeTransition(
                  opacity: _fadeAnimations[9],
                  child: SlideTransition(
                    position: _slideAnimations[9],
                    child: Text(
                      'Swipe Right',
                      style: GoogleFonts.orbit(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Add to Cart
                FadeTransition(
                  opacity: _fadeAnimations[11],
                  child: SlideTransition(
                    position: _slideAnimations[11],
                    child: const SwipeToAddButton(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArrowButton({required bool isUp}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(isUp ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          color: Colors.white),
    );
  }

  Widget _buildSizeButton(String size) {
    final bool isActive = size == _selectedSize;
    final bool isDownArrow = size.isEmpty;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isDownArrow) {
            _isExpanded = !_isExpanded;
          } else {
            _selectedSize = size;
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isDownArrow && _isExpanded
              ? Colors.black
              : (isActive ? Colors.black : Colors.white),
          borderRadius: BorderRadius.circular(15),
          border: (isDownArrow && _isExpanded) || isActive
              ? null
              : Border.all(color: Colors.black, width: 1),
        ),
        child: Center(
          child: isDownArrow
              ? Icon(Icons.keyboard_arrow_down,
                  color: _isExpanded ? Colors.white : Colors.black)
              : Text(
                  size,
                  style: GoogleFonts.inter(
                    color: isActive ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildColorDot(Color color, bool isActive, bool isDimmed) {
    return GestureDetector(
      onTap: () => setState(() => _selectedColor = color),
      child: Opacity(
        opacity: isDimmed ? 0.4 : 1.0,
        child: Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            border:
                isActive ? Border.all(color: Colors.black87, width: 1.5) : null,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: color.withOpacity(0.6),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: AnimatedScale(
                scale: isActive ? 1.1 : 1.0,
                duration: const Duration(milliseconds: 250),
                child: isActive
                    ? const Center(
                        child: Icon(Icons.check, color: Colors.white, size: 0))
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _circleButton(IconData icon, VoidCallback onTap) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(15),
      ),
      child:
          IconButton(icon: Icon(icon, color: Colors.black), onPressed: onTap),
    );
  }

  Widget _circleIcon(IconData icon) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.black87,
            width: 1.5,
          )),
      child: Icon(icon, color: Colors.black),
    );
  }
}

class SwipeToAddButton extends StatefulWidget {
  const SwipeToAddButton({super.key});

  @override
  State<SwipeToAddButton> createState() => _SwipeToAddButtonState();
}

class _SwipeToAddButtonState extends State<SwipeToAddButton>
    with SingleTickerProviderStateMixin {
  double _dragPosition = 0.0;
  bool _isAdded = false;
  final double maxDrag = 200.0;

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragPosition += details.delta.dx;
      _dragPosition = _dragPosition.clamp(0.0, maxDrag);
    });
  }

  void _onDragEnd(DragEndDetails details) {
    if (_dragPosition > maxDrag * 0.6) {
      setState(() {
        _dragPosition = maxDrag;
        _isAdded = true;
      });
    } else {
      setState(() {
        _dragPosition = 0.0;
        _isAdded = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 260,
      child: Stack(
        children: [
          // BACKGROUND CONTAINER
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: _isAdded ? Colors.green.shade600 : Colors.black,
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Cart Icon (changes color based on state)
                Icon(
                  Icons.shopping_cart_outlined,
                  color: _isAdded ? Colors.white : Colors.grey.shade300,
                ),
                Row(
                  children: [
                    const FaIcon(FontAwesomeIcons.chevronRight,
                        color: Colors.white30, size: 16),
                    const SizedBox(width: 4),
                    const FaIcon(FontAwesomeIcons.chevronRight,
                        color: Colors.white60, size: 16),
                    const SizedBox(width: 4),
                    const FaIcon(FontAwesomeIcons.chevronRight,
                        color: Colors.white, size: 16),
                    const SizedBox(width: 20),
                    Text(
                      'Add to Cart',
                      style: GoogleFonts.orbit(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // SWIPING FOREGROUND BUTTON
          Positioned(
            left: _dragPosition,
            child: GestureDetector(
              onHorizontalDragUpdate: _onDragUpdate,
              onHorizontalDragEnd: _onDragEnd,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.black87),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/nike_logo-bg.png', // Replace with your logo
                    height: 25,
                    width: 25,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
