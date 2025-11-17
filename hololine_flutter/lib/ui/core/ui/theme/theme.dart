// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design System
/// 
/// A clean, elevated design system optimized for financial data management.
/// Design principles:
/// - Trust through clarity and consistency
/// - Hierarchy through elevation and spacing
/// - Professionalism without sterility
/// - Accessibility-first approach
class AppTheme {
  AppTheme._();

  // ==================== COLOR PALETTE ====================
  
  // Primary Blues - Trust & Authority
  static const Color _primaryBlue = Color(0xFF2563EB); // Vibrant, confident blue
  static const Color _primaryBlueLight = Color(0xFF60A5FA);
  static const Color _primaryBlueDark = Color(0xFF1E40AF);
  static const Color _primaryBlueSubtle = Color(0xFFEFF6FF); // Backgrounds

  // Semantic Colors - Clear Communication
  static const Color _successGreen = Color(0xFF10B981);
  static const Color _successGreenLight = Color(0xFFD1FAE5);
  static const Color _errorRed = Color(0xFFEF4444);
  static const Color _errorRedLight = Color(0xFFFEE2E2);
  static const Color _warningAmber = Color(0xFFF59E0B);
  static const Color _warningAmberLight = Color(0xFFFEF3C7);
  static const Color _infoBlue = Color(0xFF3B82F6);
  static const Color _infoBlueLight = Color(0xFFDCEAFE);

  // Premium Tier Accent
  static const Color _premiumPurple = Color(0xFF8B5CF6);
  static const Color _premiumPurpleLight = Color(0xFFF5F3FF);

  // Neutrals - Foundation
  static const Color _white = Color(0xFFFFFFFF);
  static const Color _gray50 = Color(0xFFF9FAFB);
  static const Color _gray100 = Color(0xFFF3F4F6);
  static const Color _gray200 = Color(0xFFE5E7EB);
  static const Color _gray300 = Color(0xFFD1D5DB);
  static const Color _gray400 = Color(0xFF9CA3AF);
  static const Color _gray500 = Color(0xFF6B7280);
  static const Color _gray600 = Color(0xFF4B5563);
  static const Color _gray700 = Color(0xFF374151);
  static const Color _gray800 = Color(0xFF1F2937);
  static const Color _gray900 = Color(0xFF111827);
  static const Color _black = Color(0xFF000000);

  // Dark Theme Colors
  static const Color _darkBg = Color(0xFF0F172A);
  static const Color _darkSurface = Color(0xFF1E293B);
  static const Color _darkSurfaceElevated = Color(0xFF334155);
  static const Color _darkBorder = Color(0xFF475569);

  // ==================== COLOR SCHEMES ====================

  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    // Primary
    primary: _primaryBlue,
    onPrimary: _white,
    primaryContainer: _primaryBlueSubtle,
    onPrimaryContainer: _primaryBlueDark,
    primaryFixed: _primaryBlueLight,
    primaryFixedDim: _primaryBlue,
    onPrimaryFixed: _white,
    onPrimaryFixedVariant: _primaryBlueDark,
    
    // Secondary (Success)
    secondary: _successGreen,
    onSecondary: _white,
    secondaryContainer: _successGreenLight,
    onSecondaryContainer: Color(0xFF065F46),
    secondaryFixed: Color(0xFF34D399),
    secondaryFixedDim: _successGreen,
    onSecondaryFixed: _white,
    onSecondaryFixedVariant: Color(0xFF047857),
    
    // Tertiary (Premium)
    tertiary: _premiumPurple,
    onTertiary: _white,
    tertiaryContainer: _premiumPurpleLight,
    onTertiaryContainer: Color(0xFF5B21B6),
    tertiaryFixed: Color(0xFFA78BFA),
    tertiaryFixedDim: _premiumPurple,
    onTertiaryFixed: _white,
    onTertiaryFixedVariant: Color(0xFF6D28D9),
    
    // Error
    error: _errorRed,
    onError: _white,
    errorContainer: _errorRedLight,
    onErrorContainer: Color(0xFF991B1B),
    
    // Surface & Background
    surface: _white,
    onSurface: _gray900,
    surfaceDim: _gray50,
    surfaceBright: _white,
    surfaceContainerLowest: _white,
    surfaceContainerLow: _gray50,
    surfaceContainer: _gray100,
    surfaceContainerHigh: _gray200,
    surfaceContainerHighest: _gray300,
    onSurfaceVariant: _gray600,
    
    // Outline & Shadow
    outline: _gray300,
    outlineVariant: _gray200,
    shadow: _black,
    scrim: _black,
    
    // Inverse
    inverseSurface: _gray900,
    onInverseSurface: _gray50,
    inversePrimary: _primaryBlueLight,
    
    // Surface Tint
    surfaceTint: _primaryBlue,
  );

  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    // Primary
    primary: _primaryBlueLight,
    onPrimary: _gray900,
    primaryContainer: _primaryBlueDark,
    onPrimaryContainer: Color(0xFFBFDBFE),
    primaryFixed: _primaryBlueLight,
    primaryFixedDim: _primaryBlue,
    onPrimaryFixed: _gray900,
    onPrimaryFixedVariant: _white,
    
    // Secondary (Success)
    secondary: Color(0xFF34D399),
    onSecondary: _gray900,
    secondaryContainer: Color(0xFF065F46),
    onSecondaryContainer: _successGreenLight,
    secondaryFixed: Color(0xFF34D399),
    secondaryFixedDim: _successGreen,
    onSecondaryFixed: _gray900,
    onSecondaryFixedVariant: _white,
    
    // Tertiary (Premium)
    tertiary: Color(0xFFA78BFA),
    onTertiary: _gray900,
    tertiaryContainer: Color(0xFF5B21B6),
    onTertiaryContainer: _premiumPurpleLight,
    tertiaryFixed: Color(0xFFA78BFA),
    tertiaryFixedDim: _premiumPurple,
    onTertiaryFixed: _gray900,
    onTertiaryFixedVariant: _white,
    
    // Error
    error: Color(0xFFF87171),
    onError: _gray900,
    errorContainer: Color(0xFF991B1B),
    onErrorContainer: _errorRedLight,
    
    // Surface & Background
    surface: _darkSurface,
    onSurface: _gray100,
    surfaceDim: _darkBg,
    surfaceBright: _darkSurfaceElevated,
    surfaceContainerLowest: _darkBg,
    surfaceContainerLow: Color(0xFF1E293B),
    surfaceContainer: Color(0xFF334155),
    surfaceContainerHigh: Color(0xFF475569),
    surfaceContainerHighest: Color(0xFF64748B),
    onSurfaceVariant: _gray400,
    
    // Outline & Shadow
    outline: _darkBorder,
    outlineVariant: Color(0xFF334155),
    shadow: _black,
    scrim: _black,
    
    // Inverse
    inverseSurface: _gray100,
    onInverseSurface: _gray900,
    inversePrimary: _primaryBlue,
    
    // Surface Tint
    surfaceTint: _primaryBlueLight,
  );

  // ==================== TYPOGRAPHY ====================

  static final TextTheme _baseTextTheme = TextTheme(
    // Display - Hero sections, dashboard headers
    displayLarge: const TextStyle(
      fontSize: 56,
      fontWeight: FontWeight.w700,
      letterSpacing: -1.5,
      height: 1.12,
    ),
    displayMedium: const TextStyle(
      fontSize: 44,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      height: 1.16,
    ),
    displaySmall: const TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.22,
    ),

    // Headline - Page titles, card headers
    headlineLarge: const TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
      height: 1.25,
    ),
    headlineMedium: const TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.29,
    ),
    headlineSmall: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.33,
    ),

    // Title - Section headers, dialog titles
    titleLarge: const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.27,
    ),
    titleMedium: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
      height: 1.50,
    ),
    titleSmall: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      height: 1.43,
    ),

    // Body - Main content
    bodyLarge: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      height: 1.50,
    ),
    bodyMedium: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      height: 1.43,
    ),
    bodySmall: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      height: 1.33,
    ),

    // Label - Buttons, tags, metadata
    labelLarge: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      height: 1.43,
    ),
    labelMedium: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.33,
    ),
    labelSmall: const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.45,
    ),
  );

  // ==================== ELEVATION & SHADOWS ====================

  static List<BoxShadow> get elevation1 => [
        BoxShadow(
          color: _black.withValues (alpha: 0.05),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
      ];

  static List<BoxShadow> get elevation2 => [
        BoxShadow(
          color: _black.withValues (alpha: 0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
        BoxShadow(
          color: _black.withValues (alpha: 0.06),
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ];

  static List<BoxShadow> get elevation3 => [
        BoxShadow(
          color: _black.withValues (alpha: 0.12),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: _black.withValues (alpha: 0.08),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get elevation4 => [
        BoxShadow(
          color: _black.withValues (alpha: 0.14),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: _black.withValues (alpha: 0.10),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  // ==================== LIGHT THEME ====================

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _lightColorScheme,
      textTheme: GoogleFonts.interTextTheme(_baseTextTheme),
      scaffoldBackgroundColor: _gray50,

      // AppBar
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 1,
        backgroundColor: _white,
        foregroundColor: _gray900,
        surfaceTintColor: Colors.transparent,
        shadowColor: _black.withValues (alpha: 0.05),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: _gray900,
          letterSpacing: -0.3,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
        ),
      ),

      // Card
      cardTheme: CardThemeData(
        elevation: 0,
        color: _white,
        surfaceTintColor: Colors.transparent,
        shadowColor: _black.withValues (alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: _gray200, width: 1),
        ),
        margin: const EdgeInsets.all(0),
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: _primaryBlue,
          foregroundColor: _white,
          disabledBackgroundColor: _gray200,
          disabledForegroundColor: _gray400,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered)) {
              return _white.withValues (alpha: 0.1);
            }
            if (states.contains(WidgetState.pressed)) {
              return _white.withValues (alpha: 0.2);
            }
            return null;
          }),
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _gray700,
          disabledForegroundColor: _gray400,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(color: _gray300, width: 1.5),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primaryBlue,
          disabledForegroundColor: _gray400,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _gray300, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _gray300, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _errorRed, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _errorRed, width: 2),
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: _gray600,
        ),
        floatingLabelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: _primaryBlue,
        ),
        hintStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: _gray400,
        ),
        errorStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: _errorRed,
        ),
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: _gray100,
        disabledColor: _gray200,
        selectedColor: _primaryBlueSubtle,
        secondarySelectedColor: _successGreenLight,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelPadding: const EdgeInsets.symmetric(horizontal: 4),
        labelStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: _gray700,
        ),
        secondaryLabelStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: _gray700,
        ),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        elevation: 3,
        backgroundColor: _white,
        surfaceTintColor: Colors.transparent,
        shadowColor: _black.withValues (alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: _gray900,
          letterSpacing: -0.3,
        ),
        contentTextStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: _gray700,
          height: 1.5,
        ),
      ),

      // Bottom Sheet
      bottomSheetTheme: const BottomSheetThemeData(
        elevation: 3,
        backgroundColor: _white,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: _white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),

      // Floating Action Button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 2,
        highlightElevation: 4,
        backgroundColor: _primaryBlue,
        foregroundColor: _white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      // Navigation Bar
      navigationBarTheme: NavigationBarThemeData(
        elevation: 1,
        height: 64,
        backgroundColor: _white,
        surfaceTintColor: Colors.transparent,
        indicatorColor: _primaryBlueSubtle,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: _primaryBlue, size: 24);
          }
          return const IconThemeData(color: _gray500, size: 24);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _primaryBlue,
            );
          }
          return GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: _gray500,
          );
        }),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: _gray200,
        thickness: 1,
        space: 1,
      ),

      // List Tile
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        minVerticalPadding: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: Colors.transparent,
        selectedTileColor: _primaryBlueSubtle,
        textColor: _gray900,
        iconColor: _gray600,
      ),

      // Progress Indicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: _primaryBlue,
        linearTrackColor: _gray200,
        circularTrackColor: _gray200,
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return _white;
          return _gray300;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return _primaryBlue;
          return _gray300;
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),

      // Checkbox
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return _primaryBlue;
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(_white),
        side: const BorderSide(color: _gray300, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      // Radio
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return _primaryBlue;
          return _gray400;
        }),
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        elevation: 3,
        backgroundColor: _gray800,
        contentTextStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: _white,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),

      // Tooltip
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: _gray800,
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: _white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  // ==================== DARK THEME ====================

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _darkColorScheme,
      textTheme: GoogleFonts.interTextTheme(_baseTextTheme),
      scaffoldBackgroundColor: _darkBg,

      // AppBar
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 1,
        backgroundColor: _darkBg,
        foregroundColor: _gray100,
        surfaceTintColor: Colors.transparent,
        shadowColor: _black.withValues (alpha: 0.3),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: _gray100,
          letterSpacing: -0.3,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
        ),
      ),

      // Card
      cardTheme: CardThemeData(
        elevation: 0,
        color: _darkSurface,
        surfaceTintColor: Colors.transparent,
        shadowColor: _black.withValues (alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: _darkBorder.withValues (alpha: 0.3), width: 1),
        ),
        margin: const EdgeInsets.all(0),
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: _primaryBlueLight,
          foregroundColor: _gray900,
          disabledBackgroundColor: _darkBorder,
          disabledForegroundColor: _gray600,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _darkSurfaceElevated,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _darkBorder, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _darkBorder, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryBlueLight, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _errorRed, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _errorRed, width: 2),
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: _gray400,
        ),
        floatingLabelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: _primaryBlueLight,
        ),
        hintStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: _gray500,
        ),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        elevation: 3,
        backgroundColor: _darkSurface,
        surfaceTintColor: Colors.transparent,
        shadowColor: _black.withValues (alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: _gray100,
          letterSpacing: -0.3,
        ),
        contentTextStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: _gray300,
          height: 1.5,
        ),
      ),

      // Bottom Sheet
      bottomSheetTheme: BottomSheetThemeData(
        elevation: 3,
        backgroundColor: _darkSurface,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: _darkSurface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),

      // Floating Action Button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 2,
        highlightElevation: 4,
        backgroundColor: _primaryBlueLight,
        foregroundColor: _gray900,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      // Navigation Bar
      navigationBarTheme: NavigationBarThemeData(
        elevation: 1,
        height: 64,
        backgroundColor: _darkSurface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: _primaryBlueDark,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: _primaryBlueLight, size: 24);
          }
          return const IconThemeData(color: _gray500, size: 24);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _primaryBlueLight,
            );
          }
          return GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: _gray500,
          );
        }),
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: _darkBorder.withValues (alpha: 0.3),
        thickness: 1,
        space: 1,
      ),

      // List Tile
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        minVerticalPadding: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: Colors.transparent,
        selectedTileColor: _primaryBlueDark,
        textColor: _gray100,
        iconColor: _gray400,
      ),

      // Progress Indicator
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: _primaryBlueLight,
        linearTrackColor: _darkBorder,
        circularTrackColor: _darkBorder,
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        elevation: 3,
        backgroundColor: _darkSurfaceElevated,
        contentTextStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: _gray100,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),

      // Tooltip
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: _gray100,
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: _gray900,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}

// ==================== CUSTOM EXTENSIONS ====================

/// Extension for accessing custom semantic colors
extension HLColors on ColorScheme {
  Color get success => const Color(0xFF10B981);
  Color get successLight => const Color(0xFFD1FAE5);
  Color get warning => const Color(0xFFF59E0B);
  Color get warningLight => const Color(0xFFFEF3C7);
  Color get info => const Color(0xFF3B82F6);
  Color get infoLight => const Color(0xFFDCEAFE);
  Color get errorLight => Color(0xFFFEE2E2);
  Color get premium => const Color(0xFF8B5CF6);
  Color get premiumLight => const Color(0xFFF5F3FF);
  
  // Financial semantic colors
  Color get profit => success;
  Color get loss => error;
  Color get pending => warning;
  Color get archived => const Color(0xFF6B7280);
}

/// Extension for accessing elevation shadows
extension HLElevation on ThemeData {
  List<BoxShadow> get elevation1 => AppTheme.elevation1;
  List<BoxShadow> get elevation2 => AppTheme.elevation2;
  List<BoxShadow> get elevation3 => AppTheme.elevation3;
  List<BoxShadow> get elevation4 => AppTheme.elevation4;
}

/// Extension for common spacing values
extension HLSpacing on BuildContext {
  double get spacing4 => 4.0;
  double get spacing8 => 8.0;
  double get spacing12 => 12.0;
  double get spacing16 => 16.0;
  double get spacing20 => 20.0;
  double get spacing24 => 24.0;
  double get spacing32 => 32.0;
  double get spacing40 => 40.0;
  double get spacing48 => 48.0;
  double get spacing64 => 64.0;
}

/// Extension for common border radius values
extension HLRadius on BuildContext {
  double get radiusSmall => 8.0;
  double get radiusMedium => 12.0;
  double get radiusLarge => 16.0;
  double get radiusXLarge => 20.0;
  double get radiusRound => 999.0;
  
  BorderRadius get borderRadiusSmall => BorderRadius.circular(radiusSmall);
  BorderRadius get borderRadiusMedium => BorderRadius.circular(radiusMedium);
  BorderRadius get borderRadiusLarge => BorderRadius.circular(radiusLarge);
  BorderRadius get borderRadiusXLarge => BorderRadius.circular(radiusXLarge);
  BorderRadius get borderRadiusRound => BorderRadius.circular(radiusRound);
}
