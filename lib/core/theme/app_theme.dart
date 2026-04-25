// ─────────────────────────────────────────────────────────────
// CubeTest Mobile — Flutter Theme
// Extracted from the HTML design system in Sites.html
// Drop into lib/theme/app_theme.dart
//
// Fonts: uses google_fonts (https://pub.dev/packages/google_fonts)
// Add to pubspec.yaml:
//   dependencies:
//     google_fonts: ^6.2.1
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── Color tokens ────────────────────────────────────────────
class AppColors {
  AppColors._();

  // Surfaces
  static const bg       = Color(0xFFFAFAFC);
  static const bgTint   = Color(0xFFF6F4FB); // very light violet wash
  static const bgWash   = Color(0xFFF3F2F6); // page wash base
  static const card     = Color(0xFFFFFFFF);

  // Ink / text
  static const ink      = Color(0xFF1A1A2E);
  static const ink2     = Color(0xFF3B3B52);
  static const ink3     = Color(0xFF7C7C93);
  static const ink4     = Color(0xFFB3B3C2);

  // Lines / dividers
  static const line     = Color(0x1414142E); // rgba(20,20,46,.08)
  static const lineSoft = Color(0x0D14142E); // rgba(20,20,46,.05)

  // Primary (violet)
  static const primary    = Color(0xFF6C5CE7);
  static const primaryInk = Color(0xFF5143CC);
  static const primary50  = Color(0xFFF1EEFE);
  static const primary100 = Color(0xFFE3DEFB);
  static const primary200 = Color(0xFFC9C0F5);

  // Category pastels — each has a soft bg + matching ink color.
  // Use these for CatTile-style icon chips, metric blocks, status chips.
  static const pink      = Color(0xFFFFD9E2);
  static const pinkInk   = Color(0xFFE879A1);
  static const peach     = Color(0xFFFFE0CC);
  static const peachInk  = Color(0xFFF08A4B);
  static const lilac     = Color(0xFFE6DEFB);
  static const lilacInk  = Color(0xFF7A5EE2);
  static const sky       = Color(0xFFD6ECFE);
  static const skyInk    = Color(0xFF4B9DE8);
  static const mint      = Color(0xFFD6F3E4);
  static const mintInk   = Color(0xFF3FB97E);
  static const amber     = Color(0xFFFFEFC7);
  static const amberInk  = Color(0xFFE2A23B);

  // Status
  static const open         = Color(0xFF3FB97E);
  static const openWash     = Color(0xFFE7F7EF);
  static const active       = Color(0xFF3F7CB9);
  static const activeWashed = Color(0xFFE7EEF7);
  static const closed       = Color(0xFF7C7C93);
  static const closedWash   = Color(0xFFEFEFF3);
  static const danger       = Color(0xFFEF5A6F);
  static const dangerWash   = Color(0xFFFCE6EA);
  static const warn         = Color(0xFFF08A4B);
  static const warnWash     = Color(0xFFFFE9DA);
}

// ─── Tone system (CatTile background + foreground) ──────────
enum Tone { pink, peach, lilac, sky, mint, amber }

class ToneColors {
  final Color bg;
  final Color fg;
  const ToneColors(this.bg, this.fg);
}

const Map<Tone, ToneColors> kTonePalette = {
  Tone.pink:  ToneColors(AppColors.pink,  AppColors.pinkInk),
  Tone.peach: ToneColors(AppColors.peach, AppColors.peachInk),
  Tone.lilac: ToneColors(AppColors.lilac, AppColors.lilacInk),
  Tone.sky:   ToneColors(AppColors.sky,   AppColors.skyInk),
  Tone.mint:  ToneColors(AppColors.mint,  AppColors.mintInk),
  Tone.amber: ToneColors(AppColors.amber, AppColors.amberInk),
};

// ─── Site type registry ─────────────────────────────────────
// Maps a site's "typeKey" to an icon. Values mirror the web design.
enum SiteType { building, bridge, school, tower, factory, road, hospital, warehouse }

class SiteTypeInfo {
  final String label;
  final IconData icon;
  const SiteTypeInfo(this.label, this.icon);
}

const Map<SiteType, SiteTypeInfo> kSiteTypes = {
  SiteType.building:  SiteTypeInfo('Building',  Icons.apartment_rounded),
  SiteType.bridge:    SiteTypeInfo('Bridge',    Icons.linear_scale_rounded),
  SiteType.school:    SiteTypeInfo('School',    Icons.school_rounded),
  SiteType.tower:     SiteTypeInfo('Tower',     Icons.domain_rounded),
  SiteType.factory:   SiteTypeInfo('Factory',   Icons.factory_rounded),
  SiteType.road:      SiteTypeInfo('Road',      Icons.alt_route_rounded),
  SiteType.hospital:  SiteTypeInfo('Hospital',  Icons.local_hospital_rounded),
  SiteType.warehouse: SiteTypeInfo('Warehouse', Icons.warehouse_rounded),
};

// ─── Progress tier colors ───────────────────────────────────
// Used for circular + linear progress indicators. Tiers at 0/20/50/80/100.
class ProgressTier {
  final Color fg;
  final Color track;
  const ProgressTier(this.fg, this.track);
}

ProgressTier progressTier(double value) {
  if (value >= 100) return const ProgressTier(AppColors.open,      AppColors.openWash);
  if (value >=  80) return const ProgressTier(AppColors.lilacInk,  AppColors.lilac);
  if (value >=  50) return const ProgressTier(AppColors.primary,   AppColors.primary100);
  if (value >=  20) return const ProgressTier(AppColors.peachInk,  AppColors.peach);
  return               const ProgressTier(AppColors.danger,    AppColors.dangerWash);
}

// ─── Radii ──────────────────────────────────────────────────
class AppRadius {
  AppRadius._();
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 22;
  static const double xl = 28;
  static const double pill = 999;
}

// ─── Spacing scale ──────────────────────────────────────────
class AppSpacing {
  AppSpacing._();
  static const double xxs = 2;
  static const double xs  = 4;
  static const double sm  = 8;
  static const double md  = 12;
  static const double lg  = 16;
  static const double xl  = 20;
  static const double xxl = 28;
  static const double xxlTime4 = 100;
}

// ─── Shadows ────────────────────────────────────────────────
class AppShadows {
  AppShadows._();

  static const List<BoxShadow> sm = [
    BoxShadow(
      color: Color(0x0A322864), // rgba(50,40,100,.04)
      offset: Offset(0, 1),
      blurRadius: 2,
    ),
    BoxShadow(
      color: Color(0x0D322864), // rgba(50,40,100,.05)
      offset: Offset(0, 4),
      blurRadius: 14,
    ),
  ];

  static const List<BoxShadow> md = [
    BoxShadow(
      color: Color(0x14322864), // rgba(50,40,100,.08)
      offset: Offset(0, 6),
      blurRadius: 20,
    ),
  ];

  static const List<BoxShadow> lg = [
    BoxShadow(
      color: Color(0x24322864), // rgba(50,40,100,.14)
      offset: Offset(0, 14),
      blurRadius: 40,
    ),
  ];

  // Purple glow under primary buttons + hero card
  static const List<BoxShadow> primaryGlow = [
    BoxShadow(
      color: Color(0x4D6C5CE7), // rgba(108,92,231,.3)
      offset: Offset(0, 8),
      blurRadius: 20,
    ),
  ];

  // Red glow under danger button
  static const List<BoxShadow> dangerGlow = [
    BoxShadow(
      color: Color(0x47EF5A6F), // rgba(239,90,111,.28)
      offset: Offset(0, 8),
      blurRadius: 20,
    ),
  ];
}

// ─── Typography (Lexend Deca via google_fonts) ──────────────
TextTheme _lexendTextTheme(Color ink, Color ink2, Color ink3) {
  return TextTheme(
    // Hero titles (site name on detail, screen titles)
    displaySmall: GoogleFonts.lexendDeca(
      fontSize: 20, fontWeight: FontWeight.w600,
      letterSpacing: -0.3, height: 1.2, color: ink,
    ),
    // Section headers, card titles
    titleLarge: GoogleFonts.lexendDeca(
      fontSize: 18, fontWeight: FontWeight.w600,
      letterSpacing: -0.2, color: ink,
    ),
    titleMedium: GoogleFonts.lexendDeca(
      fontSize: 16, fontWeight: FontWeight.w600, color: ink,
    ),
    titleSmall: GoogleFonts.lexendDeca(
      fontSize: 15, fontWeight: FontWeight.w600,
      letterSpacing: -0.1, color: ink,
    ),
    // Body copy
    bodyLarge: GoogleFonts.lexendDeca(
      fontSize: 15, fontWeight: FontWeight.w500, color: ink,
    ),
    bodyMedium: GoogleFonts.lexendDeca(
      fontSize: 13.5, fontWeight: FontWeight.w400,
      height: 1.55, color: ink2,
    ),
    bodySmall: GoogleFonts.lexendDeca(
      fontSize: 12, fontWeight: FontWeight.w400, color: ink3,
    ),
    // Labels, captions, meta
    labelLarge: GoogleFonts.lexendDeca(
      fontSize: 13, fontWeight: FontWeight.w600, color: ink,
    ),
    labelMedium: GoogleFonts.lexendDeca(
      fontSize: 11, fontWeight: FontWeight.w400, color: ink3,
    ),
    labelSmall: GoogleFonts.lexendDeca(
      fontSize: 10, fontWeight: FontWeight.w500, color: ink3,
    ),
  );
}

// ─── Theme builder ──────────────────────────────────────────
class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primary50,
      onPrimaryContainer: AppColors.primaryInk,
      secondary: AppColors.lilacInk,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.lilac,
      onSecondaryContainer: AppColors.ink,
      tertiary: AppColors.peachInk,
      onTertiary: Colors.white,
      tertiaryContainer: AppColors.peach,
      onTertiaryContainer: AppColors.ink,
      error: AppColors.danger,
      onError: Colors.white,
      errorContainer: AppColors.dangerWash,
      onErrorContainer: AppColors.danger,
      surface: AppColors.card,
      onSurface: AppColors.ink,
      surfaceContainerLowest: AppColors.card,
      surfaceContainerLow: AppColors.bgWash,
      surfaceContainer: AppColors.bgTint,
      surfaceContainerHigh: AppColors.primary50,
      surfaceContainerHighest: AppColors.primary100,
      onSurfaceVariant: AppColors.ink3,
      outline: AppColors.line,
      outlineVariant: AppColors.lineSoft,
      shadow: Colors.black,
      scrim: Color(0x73000000),
      inverseSurface: AppColors.ink,
      onInverseSurface: Colors.white,
      inversePrimary: AppColors.primary200,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.bgWash,
      splashFactory: InkRipple.splashFactory,
      textTheme: _lexendTextTheme(AppColors.ink, AppColors.ink2, AppColors.ink3),

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.ink),
        titleTextStyle: GoogleFonts.lexendDeca(
          fontSize: 18, fontWeight: FontWeight.w600,
          letterSpacing: -0.2, color: AppColors.ink,
        ),
      ),

      cardTheme: CardThemeData(
        color: AppColors.card,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.primary200,
          minimumSize: const Size(double.infinity, 52),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          textStyle: GoogleFonts.lexendDeca(
            fontSize: 15, fontWeight: FontWeight.w600,
          ),
          elevation: 0,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.ink,
          backgroundColor: AppColors.card,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          side: const BorderSide(color: AppColors.line, width: 1),
          textStyle: GoogleFonts.lexendDeca(
            fontSize: 15, fontWeight: FontWeight.w600,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryInk,
          textStyle: GoogleFonts.lexendDeca(
            fontSize: 13, fontWeight: FontWeight.w600,
          ),
        ),
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: CircleBorder(
          side: BorderSide(color: Colors.white, width: 4),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.card,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: GoogleFonts.lexendDeca(
          fontSize: 14, color: AppColors.ink3,
        ),
        labelStyle: GoogleFonts.lexendDeca(
          fontSize: 11, color: AppColors.ink3,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.primary50,
        selectedColor: AppColors.primary,
        disabledColor: AppColors.bgTint,
        labelStyle: GoogleFonts.lexendDeca(
          fontSize: 13, fontWeight: FontWeight.w500,
          color: AppColors.primaryInk,
        ),
        secondaryLabelStyle: GoogleFonts.lexendDeca(
          fontSize: 13, fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          side: BorderSide.none,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.primary50,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.ink4,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.lexendDeca(
          fontSize: 11, fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.lexendDeca(
          fontSize: 11, fontWeight: FontWeight.w500,
        ),
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.primary100,
        circularTrackColor: AppColors.primary100,
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.line,
        thickness: 1,
        space: 1,
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.card,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: AppColors.line,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppRadius.xl),
            topRight: Radius.circular(AppRadius.xl),
          ),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.ink,
        contentTextStyle: GoogleFonts.lexendDeca(
          fontSize: 13, color: Colors.white,
        ),
        actionTextColor: AppColors.primary200,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Usage:
//
//   MaterialApp(
//     theme: AppTheme.light(),
//     home: const SitesScreen(),
//   );
//
//   // Tone chip:
//   final tone = kTonePalette[Tone.pink]!;
//   Container(
//     decoration: BoxDecoration(
//       color: tone.bg,
//       borderRadius: BorderRadius.circular(AppRadius.sm + 2),
//     ),
//     child: Icon(kSiteTypes[SiteType.tower]!.icon, color: tone.fg),
//   );
//
//   // Progress ring color tier:
//   final t = progressTier(67);
//   CircularProgressIndicator(value: .67, color: t.fg, backgroundColor: t.track);
//
// ─────────────────────────────────────────────────────────────
