import 'package:flutter/material.dart';
import 'dart:math' as math;

// ==================== Original Animated Dot ====================
class AnimatedDot extends StatelessWidget {
  final bool isActive;
  final bool isSecondDotActive;
  final bool isThirdDotActive;

  const AnimatedDot({
    super.key,
    required this.isActive,
    required this.isSecondDotActive,
    required this.isThirdDotActive,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: _getDotSize(),
      height: _getDotSize(),
      duration: const Duration(milliseconds: 100),
      child: CircleAvatar(
        backgroundColor: AppColors.cherryShine.withOpacity(0.5),
        child: isActive
            ? SizedBox(
                width: 8,
                height: 8,
                child: CircleAvatar(backgroundColor: AppColors.cherryShine),
              )
            : null,
      ),
    );
  }

  double _getDotSize() {
    if (isActive) return 14;
    if (isSecondDotActive) return 6;
    if (isThirdDotActive) return 4;
    return 0;
  }
}

// ==================== Bouncing Dots ====================
class BouncingDots extends StatefulWidget {
  final Color color;
  final double dotSize;
  final int dotCount;
  final double bounceHeight;

  const BouncingDots({
    super.key,
    this.color = Colors.blue,
    this.dotSize = 12.0,
    this.dotCount = 3,
    this.bounceHeight = 25.0,
  });

  @override
  State<BouncingDots> createState() => _BouncingDotsState();
}

class _BouncingDotsState extends State<BouncingDots>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _bounceAnimations;
  late List<Animation<double>> _scaleAnimations;

  // Custom curve that simulates bouncing with gravity
  static final _bounceCurve = Curves.easeOut;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.dotCount,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      ),
    );

    // Bounce animation with gravity effect
    _bounceAnimations = _controllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: controller, curve: _bounceCurve));
    }).toList();

    // Scale animation for squash effect when hitting ground
    _scaleAnimations = _controllers.map((controller) {
      return TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 1.0,
            end: 0.85,
          ).chain(CurveTween(curve: Curves.easeOut)),
          weight: 0.15,
        ),
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 0.85,
            end: 1.0,
          ).chain(CurveTween(curve: Curves.elasticOut)),
          weight: 0.85,
        ),
      ]).animate(controller);
    }).toList();

    // Start first animation immediately
    if (_controllers.isNotEmpty) {
      _controllers[0].repeat(reverse: true);
    }

    // Start remaining animations with staggered delays
    for (int i = 1; i < _controllers.length; i++) {
      final index = i; // Capture index for closure
      Future.delayed(Duration(milliseconds: index * 150), () {
        if (mounted && index < _controllers.length) {
          _controllers[index].repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // Calculate bounce position with physics-like behavior
  double _calculateBouncePosition(double animationValue) {
    // Use a parabolic curve for more realistic bounce
    // Simulates gravity: slow at top, fast when falling
    // When going up (0 to 0.5), decelerate
    // When coming down (0.5 to 1.0), accelerate due to gravity
    if (animationValue <= 0.5) {
      // Going up - decelerate (easeOut effect)
      final normalized = animationValue * 2;
      // Quadratic ease-out: starts fast, ends slow
      return (1 - (1 - normalized) * (1 - normalized)) * widget.bounceHeight;
    } else {
      // Coming down - accelerate (easeIn effect for gravity)
      final normalized = (animationValue - 0.5) * 2;
      // Quadratic ease-in: starts slow, ends fast (gravity)
      return (1 - normalized * normalized) * widget.bounceHeight;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ensure animations are initialized
    if (_bounceAnimations.isEmpty ||
        _scaleAnimations.isEmpty ||
        _bounceAnimations.length != widget.dotCount ||
        _scaleAnimations.length != widget.dotCount) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.dotCount, (index) {
        final bounceAnimation = _bounceAnimations[index];
        final scaleAnimation = _scaleAnimations[index];

        // Use nested AnimatedBuilders to avoid Listenable.merge issues
        return AnimatedBuilder(
          animation: bounceAnimation,
          builder: (context, _) {
            return AnimatedBuilder(
              animation: scaleAnimation,
              builder: (context, __) {
                final bounceValue = bounceAnimation.value;
                final scaleValue = scaleAnimation.value;
                final bouncePosition = _calculateBouncePosition(bounceValue);

                return Transform.translate(
                  offset: Offset(0, -bouncePosition),
                  child: Transform.scale(
                    scale: scaleValue,
                    child: Container(
                      width: widget.dotSize,
                      height: widget.dotSize,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: widget.color,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: widget.color.withOpacity(0.3),
                            blurRadius: 4,
                            offset: Offset(0, bouncePosition * 0.3),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }
}

// ==================== Pulsing Dots ====================
class PulsingDots extends StatefulWidget {
  final Color color;
  final double dotSize;
  final int dotCount;

  const PulsingDots({
    super.key,
    this.color = Colors.purple,
    this.dotSize = 12.0,
    this.dotCount = 3,
  });

  @override
  State<PulsingDots> createState() => _PulsingDotsState();
}

class _PulsingDotsState extends State<PulsingDots>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.dotCount,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800),
      ),
    );
    _animations = _controllers.map((controller) {
      return Tween<double>(
        begin: 0.5,
        end: 1.0,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
    }).toList();

    for (int i = 0; i < _controllers.length; i++) {
      _controllers[i].repeat(reverse: true);
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) _controllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.dotCount, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Transform.scale(
              scale: _animations[index].value,
              child: Container(
                width: widget.dotSize,
                height: widget.dotSize,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: widget.color,
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

// ==================== Rotating Dots ====================
class RotatingDots extends StatefulWidget {
  final Color color;
  final double dotSize;
  final int dotCount;

  const RotatingDots({
    super.key,
    this.color = Colors.green,
    this.dotSize = 12.0,
    this.dotCount = 4,
  });

  @override
  State<RotatingDots> createState() => _RotatingDotsState();
}

class _RotatingDotsState extends State<RotatingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          width: widget.dotSize * 3,
          height: widget.dotSize * 3,
          child: Stack(
            alignment: Alignment.center,
            children: List.generate(widget.dotCount, (index) {
              final angle = (2 * math.pi / widget.dotCount) * index;
              final radius = widget.dotSize;
              final x =
                  math.cos(angle + _controller.value * 2 * math.pi) * radius;
              final y =
                  math.sin(angle + _controller.value * 2 * math.pi) * radius;
              return Transform.translate(
                offset: Offset(x, y),
                child: Container(
                  width: widget.dotSize,
                  height: widget.dotSize,
                  decoration: BoxDecoration(
                    color: widget.color,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

// ==================== Sliding Dots ====================
class SlidingDots extends StatefulWidget {
  final Color color;
  final double dotSize;
  final int dotCount;

  const SlidingDots({
    super.key,
    this.color = Colors.orange,
    this.dotSize = 12.0,
    this.dotCount = 3,
  });

  @override
  State<SlidingDots> createState() => _SlidingDotsState();
}

class _SlidingDotsState extends State<SlidingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (widget.dotSize + 8) * widget.dotCount,
      height: widget.dotSize,
      child: Stack(
        children: List.generate(widget.dotCount, (index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final position =
                  (_controller.value + index / widget.dotCount) % 1.0;
              return Positioned(
                left: position * (widget.dotSize + 8) * (widget.dotCount - 1),
                child: Container(
                  width: widget.dotSize,
                  height: widget.dotSize,
                  decoration: BoxDecoration(
                    color: widget.color,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

// ==================== Fading Dots ====================
class FadingDots extends StatefulWidget {
  final Color color;
  final double dotSize;
  final int dotCount;

  const FadingDots({
    super.key,
    this.color = Colors.teal,
    this.dotSize = 12.0,
    this.dotCount = 3,
  });

  @override
  State<FadingDots> createState() => _FadingDotsState();
}

class _FadingDotsState extends State<FadingDots> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.dotCount,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1000),
      ),
    );
    _animations = _controllers.map((controller) {
      return Tween<double>(
        begin: 0.3,
        end: 1.0,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
    }).toList();

    for (int i = 0; i < _controllers.length; i++) {
      _controllers[i].repeat(reverse: true);
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) _controllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.dotCount, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Opacity(
              opacity: _animations[index].value,
              child: Container(
                width: widget.dotSize,
                height: widget.dotSize,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: widget.color,
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

// ==================== Wave Dots ====================
class WaveDots extends StatefulWidget {
  final Color color;
  final double dotSize;
  final int dotCount;

  const WaveDots({
    super.key,
    this.color = Colors.pink,
    this.dotSize = 12.0,
    this.dotCount = 5,
  });

  @override
  State<WaveDots> createState() => _WaveDotsState();
}

class _WaveDotsState extends State<WaveDots> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.dotCount,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1000),
      ),
    );
    _animations = _controllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
    }).toList();

    for (int i = 0; i < _controllers.length; i++) {
      _controllers[i].repeat(reverse: true);
      Future.delayed(Duration(milliseconds: i * 100), () {
        if (mounted) _controllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.dotCount, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            final scale = 0.5 + (_animations[index].value * 0.5);
            return Transform.scale(
              scale: scale,
              child: Container(
                width: widget.dotSize,
                height: widget.dotSize,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: widget.color,
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

// ==================== Expanding Dots (Ripple Effect) ====================
class ExpandingDots extends StatefulWidget {
  final Color color;
  final double dotSize;
  final int dotCount;

  const ExpandingDots({
    super.key,
    this.color = Colors.indigo,
    this.dotSize = 12.0,
    this.dotCount = 3,
  });

  @override
  State<ExpandingDots> createState() => _ExpandingDotsState();
}

class _ExpandingDotsState extends State<ExpandingDots>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _opacityAnimations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.dotCount,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1500),
      ),
    );
    _scaleAnimations = _controllers.map((controller) {
      return Tween<double>(
        begin: 1.0,
        end: 2.5,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
    }).toList();
    _opacityAnimations = _controllers.map((controller) {
      return Tween<double>(
        begin: 0.8,
        end: 0.0,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
    }).toList();

    for (int i = 0; i < _controllers.length; i++) {
      _controllers[i].repeat();
      Future.delayed(Duration(milliseconds: i * 500), () {
        if (mounted) _controllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.dotSize * 5,
      height: widget.dotSize * 5,
      child: Stack(
        alignment: Alignment.center,
        children: List.generate(widget.dotCount, (index) {
          return AnimatedBuilder(
            animation: _controllers[index],
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimations[index].value,
                child: Opacity(
                  opacity: _opacityAnimations[index].value,
                  child: Container(
                    width: widget.dotSize,
                    height: widget.dotSize,
                    decoration: BoxDecoration(
                      color: widget.color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: widget.color.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

// ==================== Spinning Dots ====================
class SpinningDots extends StatefulWidget {
  final Color color;
  final double dotSize;
  final int dotCount;

  const SpinningDots({
    super.key,
    this.color = Colors.red,
    this.dotSize = 10.0,
    this.dotCount = 8,
  });

  @override
  State<SpinningDots> createState() => _SpinningDotsState();
}

class _SpinningDotsState extends State<SpinningDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          width: widget.dotSize * 4,
          height: widget.dotSize * 4,
          child: Stack(
            alignment: Alignment.center,
            children: List.generate(widget.dotCount, (index) {
              final angle =
                  (2 * math.pi / widget.dotCount) * index +
                  _controller.value * 2 * math.pi;
              final radius = widget.dotSize * 1.5;
              final x = math.cos(angle) * radius;
              final y = math.sin(angle) * radius;
              final opacity =
                  0.3 + (math.sin(angle + math.pi / 2) + 1) / 2 * 0.7;
              return Positioned(
                left: widget.dotSize * 2 + x - widget.dotSize / 2,
                top: widget.dotSize * 2 + y - widget.dotSize / 2,
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    width: widget.dotSize,
                    height: widget.dotSize,
                    decoration: BoxDecoration(
                      color: widget.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

class AppColors {
  AppColors._();

  static Color appBarPrimaryColor = HexColor("282968");
  static Color appBarSecondaryColor = HexColor("264C93");

  static Color sapphireDeep = HexColor("06245F");

  static Color tangTwist = HexColor("FAAD1B");
  static Color tangTwistDark = HexColor("F89919");

  static Color whiteColor = HexColor("FFFFFF");
  static Color whiteOut = HexColor("FBFBFB");
  static Color lemonChiffon = HexColor("FFFBCE");
  static Color simplyDelicious = HexColor("FFD1C0");
  static Color gerberaRed = HexColor("F66915");
  static Color mourningBlue = HexColor("1953BE");
  static Color stratosBg = HexColor("000A44");
  static Color blueGladiola = HexColor("5A6ABB");

  static Color leadTextColor = HexColor("212121");
  static Color greyWolFram = HexColor("B6B6B6");
  static Color greySteelWool = HexColor("777777");
  static Color unityTextColor = HexColor("264C93");
  static Color lavenderTextColor = HexColor("EBE5FF");
  static Color paleLavendar = HexColor("DACFFF");
  static Color kickStartPurple = HexColor("727ECE52");
  static Color primaryDisabledColor = HexColor("#727ECE");
  static Color primaryLightColor = HexColor("#B8C9FF");
  static Color wondrousWisteria = HexColor("A2ACF7");
  static Color riseNShine = HexColor("FAC232");
  static Color eyePatch = HexColor("222121");

  static Color blackBgColor = HexColor("000000");
  static Color greenWinColor = HexColor("1AB85B");

  static Color greyLineColor = HexColor("E7E7E7");
  static Color lightPeriwinkle = HexColor("000A44");

  //tab colors
  static Color tabSelectedColor = HexColor("264C93");
  static Color tabUnSelectedColor = HexColor("3e3e3e");

  static Color redLossColor = HexColor("EA3C3D");
  static Color redPigment = HexColor("ED1C24");

  static const bottomMenuColor = Color(0xff091B33);
  static const indicatorColor = Color(0xff1050BB);
  static const blueSecondaryLight = Color(0xff8981CB);
  static const colorSecondaryInfoBg = Color(0xff5F599F);

  static const matchCentreBgColor = Color(0xfff2f2f2);
  static const matchCentreTxtColorGrey = Color(0xFF7A7A7A);
  static const wolfram = Color(0xFFB6B6B6);
  static const luckyGrey = Color(0xFF777777);
  static const storm = Color(0xFF000A44);
  static const purplish = Color(0xFF4A468A);
  static const gloriousunset = Color(0xFFF88B1A);
  static const matchCentreRedColor = Color(0xFFFF0D0F);
  static const redHot = Color(0xFFE00034);

  static const dividerColor = Color(0xFFDFDFDF);
  static const afterWorkBlue = Color(0xFF282968);
  static const azul = Color(0xFF2064E3);
  static const oldGloryBlue = Color(0xff002765);
  static const blueMarieTime = Color(0xFF28293D);
  static const blackCarbon = Color(0xFF333333);
  static const blackErrie = Color(0xFF1A1A1A);
  static const grey = Color(0xFF808080);
  static const yellowSunRay = Color(0xFFFCAF17);

  //app bg color
  static const appBgColor = Color(0xffffffff);

  // static const tangTwistNew  = Color(0xffFAAD1B);

  //loading color
  static const baseLoadColor = Color(0xfffbfbfb);
  static const lighGreyLoad = Color(0xfffefefe);
  static const highlightLoadColor = Color(0xffe4e4e4);

  //text colors
  static const blackTextColor = Color(0xFF1A1A1A);
  static const lightBlueTextColor = Color(0xFF3F62AE);

  static Color prunePlum = HexColor("191740");
  static Color spaceExplorer = HexColor("164192");
  static Color coralRed = HexColor("FB4041");
  static Color navajoWhite = HexColor("FFDEAD");
  static Color oxfordBlue = HexColor("001D4A");
  static Color squant = HexColor("666666");
  static Color silverSetting = HexColor("D8DADC");
  static Color infraredFlush = HexColor("D03045");
  static Color blueDahlia = HexColor("415B9F");
  static Color madForMango = HexColor("F5A500");
  static Color cascadingWhite = HexColor("f6f6f6");
  static Color mazarineBlue = HexColor("243778");
  static Color panCake = HexColor("F8D886");
  static Color portage = HexColor("8491DF");
  static Color chineseBellFlower = HexColor("475CA9");
  static Color amparoBlue = HexColor("5A6ABB");
  static Color walledGreen = HexColor("14CD48");
  static Color namaraGrey = HexColor("7C7C7C");
  static Color cornFlowerLilac = HexColor("FFAEAE");
  static Color shadyCharacter = HexColor("4C4C4C");
  static Color navalNight = HexColor("0A1B3B");
  static Color greyCerberal = HexColor("CCCCCC");
  static Color midnightDreams = HexColor("001A30");
  static Color cherryShine = HexColor("D71921");
  static Color cherryRed = HexColor("F93626");
  static Color charcoalGrey = HexColor("6D696A");
  static Color blackTie = HexColor("474747");

  static Color gradOneColor = HexColor("2A58A5");
  static Color gradTwoColor = HexColor("2A4A92");
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
