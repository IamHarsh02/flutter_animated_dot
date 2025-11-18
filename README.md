# flutter_animated_dot

A collection of beautiful animated dot widgets for Flutter with multiple animation styles. Perfect for loading indicators, progress indicators, and UI enhancements.

## Features

- 🎨 **9 Different Animation Styles**: Bouncing, Pulsing, Rotating, Sliding, Fading, Wave, Expanding, Spinning, and Original
- ⚡ **Highly Customizable**: Control colors, sizes, dot counts, and animation parameters
- 🎯 **Physics-Based Animations**: Realistic bouncing with gravity effects and squash animations
- 📱 **Cross-Platform**: Works on iOS, Android, Web, and Desktop
- 🚀 **Lightweight**: No external dependencies, pure Flutter animations
- 🎭 **Smooth Performance**: Optimized animations using Flutter's animation framework

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_animated_dot: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Usage

### Import the package

```dart
import 'package:flutter_animated_dot/flutter_animated_dot.dart';
```

### Bouncing Dots

Realistic bouncing animation with gravity effect and squash animation:

```dart
BouncingDots(
  color: Colors.blue,
  dotSize: 14.0,
  dotCount: 3,
  bounceHeight: 25.0,
)
```

### Pulsing Dots

Dots that pulse with scale animation:

```dart
PulsingDots(
  color: Colors.purple,
  dotSize: 12.0,
  dotCount: 3,
)
```

### Rotating Dots

Dots that rotate around a center point:

```dart
RotatingDots(
  color: Colors.green,
  dotSize: 12.0,
  dotCount: 4,
)
```

### Sliding Dots

Dots that slide horizontally in a loop:

```dart
SlidingDots(
  color: Colors.orange,
  dotSize: 12.0,
  dotCount: 3,
)
```

### Fading Dots

Dots that fade in and out smoothly:

```dart
FadingDots(
  color: Colors.teal,
  dotSize: 12.0,
  dotCount: 3,
)
```

### Wave Dots

Dots that create a wave effect:

```dart
WaveDots(
  color: Colors.pink,
  dotSize: 12.0,
  dotCount: 5,
)
```

### Expanding Dots

Ripple effect with expanding circles:

```dart
ExpandingDots(
  color: Colors.indigo,
  dotSize: 12.0,
  dotCount: 3,
)
```

### Spinning Dots

Multiple dots spinning in a circle with varying opacity:

```dart
SpinningDots(
  color: Colors.red,
  dotSize: 10.0,
  dotCount: 8,
)
```

### Original Animated Dot

The original implementation with custom states:

```dart
AnimatedDot(
  isActive: true,
  isSecondDotActive: false,
  isThirdDotActive: false,
)
```

## Complete Example

```dart
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
      title: 'Animated Dots Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Animated Dots')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const BouncingDots(color: Colors.blue),
            const SizedBox(height: 40),
            const PulsingDots(color: Colors.purple),
            const SizedBox(height: 40),
            const RotatingDots(color: Colors.green),
          ],
        ),
      ),
    );
  }
}
```

## Widget Parameters

### BouncingDots

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `color` | `Color` | `Colors.blue` | Color of the dots |
| `dotSize` | `double` | `12.0` | Size of each dot |
| `dotCount` | `int` | `3` | Number of dots |
| `bounceHeight` | `double` | `25.0` | Height of the bounce animation |

### PulsingDots, FadingDots, WaveDots

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `color` | `Color` | Varies | Color of the dots |
| `dotSize` | `double` | `12.0` | Size of each dot |
| `dotCount` | `int` | `3-5` | Number of dots |

### RotatingDots, SlidingDots, SpinningDots, ExpandingDots

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `color` | `Color` | Varies | Color of the dots |
| `dotSize` | `double` | `10.0-12.0` | Size of each dot |
| `dotCount` | `int` | `3-8` | Number of dots |

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

Your Name

## Support

If you find this package useful, please consider giving it a ⭐ on GitHub!
