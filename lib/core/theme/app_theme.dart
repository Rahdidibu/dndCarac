import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors - Medieval Fantasy Palette
  static const Color bgDark = Color(0xFF0F0B09); // Charcoal wood
  static const Color cardDark = Color(0xFF1B1410); // Aged leather
  static const Color goldAccent = Color(0xFFC59B27); // Antique gold
  static const Color forestGreen = Color(0xFF2E7D32); // Emerald/Forest green
  static const Color crimsonRed = Color(0xFFC62828); // Crimson red
  static const Color magicAmethyst = Color(0xFFAB47BC); // Purple magic
  static const Color textLight = Color(0xFFECE5D8); // Warm ivory

  // Alias neon naming to maintain compatibility with existing widgets
  static const Color neonCyan = goldAccent;
  static const Color neonPurple = magicAmethyst;
  static const Color neonRed = crimsonRed;
  static const Color neonGreen = forestGreen;

  static ThemeData get darkTheme {
    final baseTheme = ThemeData.dark(useMaterial3: true);
    
    return baseTheme.copyWith(
      scaffoldBackgroundColor: bgDark,
      colorScheme: const ColorScheme.dark(
        primary: goldAccent,
        secondary: magicAmethyst,
        error: crimsonRed,
        surface: cardDark,
        onSurface: textLight,
      ),
      textTheme: GoogleFonts.loraTextTheme(baseTheme.textTheme).copyWith(
        bodyLarge: GoogleFonts.lora(textStyle: baseTheme.textTheme.bodyLarge?.copyWith(color: textLight)),
        bodyMedium: GoogleFonts.lora(textStyle: baseTheme.textTheme.bodyMedium?.copyWith(color: textLight.withValues(alpha: 0.85))),
        titleLarge: GoogleFonts.cinzel(textStyle: baseTheme.textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
        titleMedium: GoogleFonts.cinzel(textStyle: baseTheme.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
      ),
      cardTheme: CardThemeData(
        color: cardDark.withValues(alpha: 0.7),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: goldAccent.withValues(alpha: 0.15),
            width: 1.0,
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: goldAccent.withValues(alpha: 0.1),
        thickness: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.02),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: goldAccent.withValues(alpha: 0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: goldAccent.withValues(alpha: 0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: goldAccent, width: 1.5),
        ),
        labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: goldAccent,
        unselectedLabelColor: Colors.white60,
        indicatorColor: goldAccent,
        indicatorSize: TabBarIndicatorSize.tab,
      ),
    );
  }
  
  // Glowing Neon Box Decoration
  static BoxDecoration neonBorderDecoration({
    required Color accentColor,
    double borderRadius = 16,
    double opacity = 0.08,
  }) {
    return BoxDecoration(
      color: cardDark.withValues(alpha: 0.6),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: accentColor.withValues(alpha: 0.3),
        width: 1.2,
      ),
      boxShadow: [
        BoxShadow(
          color: accentColor.withValues(alpha: 0.06),
          blurRadius: 8,
          spreadRadius: 1,
        ),
      ],
    );
  }
}

// Glassmorphism wrapper widget
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final Color color;
  final double borderRadius;
  final Border? border;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;

  const GlassContainer({
    super.key,
    required this.child,
    this.blur = 16,
    this.opacity = 0.04,
    this.color = const Color(0xFFF4EAD4), // Warm parchment overlay
    this.borderRadius = 16,
    this.border,
    this.padding,
    this.margin,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: color.withValues(alpha: opacity),
              borderRadius: BorderRadius.circular(borderRadius),
              border: border ?? Border.all(
                color: AppTheme.goldAccent.withValues(alpha: 0.15),
                width: 1.0,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
