import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ============================================================
  // GLOBAL PRIMARY COLORS
  // ============================================================
  static const Color primaryColor = Color(0xFF1E3A5F);   // Deep Navy Blue
  static const Color primaryLight = Color(0xFF2D5A8E);
  static const Color primaryDark  = Color(0xFF152B47);

  static const Color accentColor  = Color(0xFFFF6B35);   // Warm Orange
  static const Color accentLight  = Color(0xFFFF8C5A);
  static const Color accentDark   = Color(0xFFE55A28);

  // ============================================================
  // SCREEN BACKGROUND COLORS  (light & aesthetic)
  // ============================================================

  /// Dashboard  – soft lavender-white
  static const Color dashboardBg        = Color(0xFFF0F4FF);
  static const Color dashboardAppBar    = Color(0xFFFFFFFF);
  static const Color dashboardAccent    = Color(0xFF4F6AF0);   // indigo

  /// POS        – warm cream
  static const Color posBg              = Color(0xFFFFF8F0);
  static const Color posAppBar          = Color(0xFFFFFFFF);
  static const Color posAccent          = Color(0xFFFF6B35);   // orange

  /// Products   – fresh mint-green tint
  static const Color productsBg         = Color(0xFFF0FBF5);
  static const Color productsAppBar     = Color(0xFFFFFFFF);
  static const Color productsAccent     = Color(0xFF10B981);   // emerald

  /// Categories – soft sky blue
  static const Color categoriesBg       = Color(0xFFF0F7FF);
  static const Color categoriesAppBar   = Color(0xFFFFFFFF);
  static const Color categoriesAccent   = Color(0xFF3B82F6);   // blue

  /// Customers  – blush pink
  static const Color customersBg        = Color(0xFFFFF0F5);
  static const Color customersAppBar    = Color(0xFFFFFFFF);
  static const Color customersAccent    = Color(0xFFEC4899);   // pink

  /// Ledger     – warm amber tint
  static const Color ledgerBg           = Color(0xFFFFFBF0);
  static const Color ledgerAppBar       = Color(0xFFFFFFFF);
  static const Color ledgerAccent       = Color(0xFFF59E0B);   // amber

  /// Reports    – light cyan
  static const Color reportsBg          = Color(0xFFF0FDFF);
  static const Color reportsAppBar      = Color(0xFFFFFFFF);
  static const Color reportsAccent      = Color(0xFF06B6D4);   // cyan

  /// Inventory  – lavender
  static const Color inventoryBg        = Color(0xFFF5F0FF);
  static const Color inventoryAppBar    = Color(0xFFFFFFFF);
  static const Color inventoryAccent    = Color(0xFF8B5CF6);   // violet

  /// Vendors    – light teal
  static const Color vendorsBg          = Color(0xFFF0FAFA);
  static const Color vendorsAppBar      = Color(0xFFFFFFFF);
  static const Color vendorsAccent      = Color(0xFF14B8A6);   // teal

  /// Purchases  – warm rose
  static const Color purchasesBg        = Color(0xFFFFF5F5);
  static const Color purchasesAppBar    = Color(0xFFFFFFFF);
  static const Color purchasesAccent    = Color(0xFFEF4444);   // red

  /// Settings   – slate gray tint
  static const Color settingsBg         = Color(0xFFF8FAFC);
  static const Color settingsAppBar     = Color(0xFFFFFFFF);
  static const Color settingsAccent     = Color(0xFF64748B);   // slate

  /// Backup     – indigo tint
  static const Color backupBg           = Color(0xFFF3F0FF);
  static const Color backupAppBar       = Color(0xFFFFFFFF);
  static const Color backupAccent       = Color(0xFF6366F1);   // indigo

  /// Auth/Login – deep navy gradient
  static const Color authBgTop          = Color(0xFF1E3A5F);
  static const Color authBgBottom       = Color(0xFF0F2440);

  // ============================================================
  // SHARED SEMANTIC COLORS
  // ============================================================
  static const Color backgroundColor = Color(0xFFF7F9FC);
  static const Color surfaceColor    = Color(0xFFFFFFFF);
  static const Color cardColor       = Color(0xFFFFFFFF);

  static const Color textPrimary     = Color(0xFF1A1D29);
  static const Color textSecondary   = Color(0xFF6B7280);
  static const Color textLight       = Color(0xFF9CA3AF);

  static const Color successColor    = Color(0xFF10B981);
  static const Color warningColor    = Color(0xFFF59E0B);
  static const Color errorColor      = Color(0xFFEF4444);
  static const Color infoColor       = Color(0xFF3B82F6);

  static const Color dividerColor    = Color(0xFFE5E7EB);
  static const Color shadowColor     = Color(0x1A000000);

  static const Color snackBarAdd     = Color(0xFF3B82F6);
  static const Color snackBarUpdate  = Color(0xFFF59E0B);
  static const Color snackBarDelete  = Color(0xFFDC2626);

  // ============================================================
  // GRADIENTS
  // ============================================================
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryColor, primaryLight],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentColor, accentLight],
  );

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryDark, primaryColor],
  );

  static const LinearGradient dashboardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [dashboardAccent, Color(0xFF667EEA)],
  );

  static const LinearGradient posGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [posAccent, Color(0xFFFF8C5A)],
  );

  static const LinearGradient productsGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [productsAccent, Color(0xFF34D399)],
  );

  static const LinearGradient customersGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [customersAccent, Color(0xFFF472B6)],
  );

  static const LinearGradient reportsGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [reportsAccent, Color(0xFF22D3EE)],
  );

  // ============================================================
  // TEXT STYLES
  // ============================================================
  static TextStyle get headingLarge => GoogleFonts.plusJakartaSans(
    fontSize: 32, fontWeight: FontWeight.bold,
    color: textPrimary, letterSpacing: -0.5,
  );

  static TextStyle get headingMedium => GoogleFonts.plusJakartaSans(
    fontSize: 24, fontWeight: FontWeight.bold,
    color: textPrimary, letterSpacing: -0.3,
  );

  static TextStyle get headingSmall => GoogleFonts.plusJakartaSans(
    fontSize: 20, fontWeight: FontWeight.w600, color: textPrimary,
  );

  static TextStyle get titleLarge => GoogleFonts.plusJakartaSans(
    fontSize: 18, fontWeight: FontWeight.w600, color: textPrimary,
  );

  static TextStyle get titleMedium => GoogleFonts.plusJakartaSans(
    fontSize: 16, fontWeight: FontWeight.w600, color: textPrimary,
  );

  static TextStyle get bodyLarge => GoogleFonts.plusJakartaSans(
    fontSize: 16, fontWeight: FontWeight.normal, color: textPrimary,
  );

  static TextStyle get bodyMedium => GoogleFonts.plusJakartaSans(
    fontSize: 14, fontWeight: FontWeight.normal, color: textPrimary,
  );

  static TextStyle get bodySmall => GoogleFonts.plusJakartaSans(
    fontSize: 12, fontWeight: FontWeight.normal, color: textSecondary,
  );

  static TextStyle get labelLarge => GoogleFonts.plusJakartaSans(
    fontSize: 14, fontWeight: FontWeight.w500, color: textPrimary,
  );

  static TextStyle get labelMedium => GoogleFonts.plusJakartaSans(
    fontSize: 12, fontWeight: FontWeight.w500, color: textSecondary,
  );

  static TextStyle get labelSmall => GoogleFonts.plusJakartaSans(
    fontSize: 10, fontWeight: FontWeight.w500, color: textSecondary,
  );

  static TextStyle get buttonText => GoogleFonts.plusJakartaSans(
    fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white,
  );

  static TextStyle get priceText => GoogleFonts.jetBrainsMono(
    fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor,
  );

  static TextStyle get priceLarge => GoogleFonts.jetBrainsMono(
    fontSize: 28, fontWeight: FontWeight.bold, color: primaryColor,
  );

  // ============================================================
  // THEME DATA
  // ============================================================
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
      surface: surfaceColor,
      error: errorColor,
      onPrimary: Colors.white,
      onSecondary: textPrimary,
      onSurface: textPrimary,
      onError: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      iconTheme: const IconThemeData(color: textPrimary),
      titleTextStyle: headingSmall,
    ),
    cardTheme: CardThemeData(
      color: cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: dividerColor, width: 1),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: buttonText,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: buttonText.copyWith(color: primaryColor),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: labelLarge.copyWith(color: primaryColor),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: dividerColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: dividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor, width: 2),
      ),
      labelStyle: bodyMedium.copyWith(color: textSecondary),
      hintStyle: bodyMedium.copyWith(color: textLight),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: accentColor,
      foregroundColor: Colors.white,
      elevation: 4,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: textLight,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: labelMedium.copyWith(color: primaryColor),
      unselectedLabelStyle: labelMedium,
    ),
    dividerTheme: const DividerThemeData(color: dividerColor, thickness: 1),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: snackBarAdd,
      contentTextStyle: bodyMedium.copyWith(color: Colors.white),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titleTextStyle: headingSmall,
      contentTextStyle: bodyMedium,
    ),
  );

  // ============================================================
  // BOX DECORATIONS
  // ============================================================
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: cardColor,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: dividerColor),
  );

  static BoxDecoration get elevatedCardDecoration => BoxDecoration(
    color: cardColor,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [BoxShadow(color: shadowColor, blurRadius: 20, offset: const Offset(0, 4))],
  );

  static BoxDecoration get gradientCardDecoration => BoxDecoration(
    gradient: primaryGradient,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: primaryColor.withValues(alpha: 0.3),
        blurRadius: 20,
        offset: const Offset(0, 8),
      ),
    ],
  );

  // ============================================================
  // HELPER: AppBar decoration per screen
  // ============================================================
  static BoxDecoration appBarDecoration(Color accentColor) => BoxDecoration(
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: accentColor.withValues(alpha: 0.08),
        blurRadius: 12,
        offset: const Offset(0, 2),
      ),
    ],
  );

  // ============================================================
  // HELPER: Stat card decoration per screen
  // ============================================================
  static BoxDecoration statCardDecoration(Color color) => BoxDecoration(
    color: color.withValues(alpha: 0.08),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: color.withValues(alpha: 0.15), width: 1),
  );

  // ============================================================
  // HELPER: Screen header gradient
  // ============================================================
  static BoxDecoration screenHeaderDecoration(Color color) => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        color.withValues(alpha: 0.12),
        color.withValues(alpha: 0.04),
      ],
    ),
    borderRadius: const BorderRadius.only(
      bottomLeft: Radius.circular(24),
      bottomRight: Radius.circular(24),
    ),
  );
}