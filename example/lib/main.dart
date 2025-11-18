import 'package:flutter/material.dart';
import 'package:flutter_animated_dot/flutter_animated_dot.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animated Dots Showcase',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AnimatedDotsShowcase(),
    );
  }
}

class AnimatedDotsShowcase extends StatelessWidget {
  const AnimatedDotsShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animated Dots Showcase'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 2,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.grey.shade100, Colors.grey.shade50],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionTitle('Classic Animations'),
            _buildDotCard(
              context,
              'Bouncing Dots',
              'Realistic bouncing with gravity effect and squash animation',
              const BouncingDots(
                color: Colors.blue,
                dotSize: 14,
                dotCount: 3,
                bounceHeight: 25,
              ),
              Colors.blue.shade50,
            ),
            _buildDotCard(
              context,
              'Pulsing Dots',
              'Dots pulse with scale animation',
              const PulsingDots(color: Colors.purple, dotSize: 14, dotCount: 3),
              Colors.purple.shade50,
            ),
            _buildDotCard(
              context,
              'Fading Dots',
              'Dots fade in and out smoothly',
              const FadingDots(color: Colors.teal, dotSize: 14, dotCount: 3),
              Colors.teal.shade50,
            ),
            _buildDotCard(
              context,
              'Wave Dots',
              'Dots create a wave effect',
              const WaveDots(color: Colors.pink, dotSize: 14, dotCount: 5),
              Colors.pink.shade50,
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Motion Animations'),
            _buildDotCard(
              context,
              'Rotating Dots',
              'Dots rotate around a center point',
              const RotatingDots(color: Colors.green, dotSize: 12, dotCount: 4),
              Colors.green.shade50,
            ),
            _buildDotCard(
              context,
              'Sliding Dots',
              'Dots slide horizontally in a loop',
              const SlidingDots(color: Colors.orange, dotSize: 14, dotCount: 3),
              Colors.orange.shade50,
            ),
            _buildDotCard(
              context,
              'Spinning Dots',
              'Multiple dots spin in a circle with opacity',
              const SpinningDots(color: Colors.red, dotSize: 10, dotCount: 8),
              Colors.red.shade50,
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Special Effects'),
            _buildDotCard(
              context,
              'Expanding Dots',
              'Ripple effect with expanding circles',
              const ExpandingDots(
                color: Colors.indigo,
                dotSize: 12,
                dotCount: 3,
              ),
              Colors.indigo.shade50,
            ),
            _buildDotCard(
              context,
              'Original Animated Dot',
              'The original implementation',
              _buildOriginalDotDemo(),
              Colors.deepPurple.shade50,
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Custom Variations'),
            _buildDotCard(
              context,
              'Bouncing Dots (Large)',
              'Larger bouncing dots with more dots and enhanced bounce',
              const BouncingDots(
                color: Colors.cyan,
                dotSize: 18,
                dotCount: 5,
                bounceHeight: 30,
              ),
              Colors.cyan.shade50,
            ),
            _buildDotCard(
              context,
              'Pulsing Dots (Small)',
              'Smaller pulsing dots',
              const PulsingDots(color: Colors.amber, dotSize: 10, dotCount: 4),
              Colors.amber.shade50,
            ),
            _buildDotCard(
              context,
              'Wave Dots (Extended)',
              'Extended wave with more dots',
              const WaveDots(
                color: Colors.deepOrange,
                dotSize: 12,
                dotCount: 7,
              ),
              Colors.deepOrange.shade50,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildDotCard(
    BuildContext context,
    String title,
    String description,
    Widget dotWidget,
    Color cardColor,
  ) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 16),
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: dotWidget,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOriginalDotDemo() {
    return StatefulBuilder(
      builder: (context, setState) {
        return _OriginalDotDemo();
      },
    );
  }
}

class _OriginalDotDemo extends StatefulWidget {
  @override
  State<_OriginalDotDemo> createState() => _OriginalDotDemoState();
}

class _OriginalDotDemoState extends State<_OriginalDotDemo> {
  int _activeIndex = 0;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _activeIndex = (_activeIndex + 1) % 3;
        });
        _startAnimation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedDot(
          isActive: index == _activeIndex,
          isSecondDotActive: index == (_activeIndex + 1) % 3,
          isThirdDotActive: index == (_activeIndex + 2) % 3,
        );
      }),
    );
  }
}
