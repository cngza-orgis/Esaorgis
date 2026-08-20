import 'dart:math';
import 'cable_database.dart';

// Elektrik Saha Asistanı - Modüler Stabil Sürüm
// Türkçe arayüz + açık/koyu tema. Çevrimdışı çalışacak şekilde tasarlanmıştır.
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part 'app_theme.dart';
part 'widgets.dart';
part 'technical_data.dart';
part 'ana_menu.dart';
part 'hat_analizi.dart';
part 'pano_malzeme.dart';
part 'kompanzasyon.dart';
part 'motor_koruma.dart';
part 'ges.dart';
part 'topraklama.dart';
part 'aydinlatma.dart';
part 'jenerator.dart';
part 'sigorta.dart';
part 'trafo_araclari.dart';
part 'santiye.dart';
part 'faturalama.dart';
part 'dagitim_enh.dart';
part 'yeralti_kablo.dart';
part 'alpek_iletken.dart';
part 'acik_iletken.dart';
part 'teknik_bilgiler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SahaAsistaniApp());
}

class SahaAsistaniApp extends StatelessWidget {
  const SahaAsistaniApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkNotifier,
      builder: (context, isDark, _) {
        final light = ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF4F7FB),
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF0B5CC9), brightness: Brightness.light),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF073B7A),
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: false,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Color(0xFF073B7A),
              systemNavigationBarColor: Color(0xFF073B7A),
              systemNavigationBarDividerColor: Color(0xFF073B7A),
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
          ),
          cardTheme: CardThemeData(
            color: Colors.white,
            elevation: 0,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              side: BorderSide(color: Color(0xFFDCE6F2)),
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(isDense: true),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF18A957),
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(42),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              textStyle:
                  const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
            ),
          ),
        );
        final dark = ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFF101923),
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF2C9BEF), brightness: Brightness.dark),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF061F40),
            foregroundColor: Colors.white,
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Color(0xFF061F40),
              systemNavigationBarColor: Color(0xFF061F40),
              systemNavigationBarDividerColor: Color(0xFF061F40),
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
          ),
          cardTheme: CardThemeData(
            color: const Color(0xFF182431),
            elevation: 0,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                side: BorderSide(color: Color(0xFF304355))),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF18A957),
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(42),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
            ),
          ),
        );
        // Uygulamanın üst durum çubuğu ve alt sistem/navigasyon alanı,
        // uygulamanın koyu mavi kurumsal çerçevesiyle aynı renkte tutulur.
        final systemBarColor =
            isDark ? const Color(0xFF061F40) : const Color(0xFF073B7A);
        final systemUiStyle = SystemUiOverlayStyle(
          statusBarColor: systemBarColor,
          systemNavigationBarColor: systemBarColor,
          systemNavigationBarDividerColor: systemBarColor,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.light,
        );

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Elektrik Saha Asistanı',
          theme: light,
          darkTheme: dark,
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          // Sistem durum çubuğu ve alt navigasyon alanı uygulamanın tamamında
          // tek bir kurumsal renkle, üst/alt mavi barlarla aynı tonda tutulur.
          // builder ile Navigator'ın içine sarıldığı için tüm menü ve araçlarda
          // aynı SystemUiOverlayStyle geçerli olur.
          builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
            value: systemUiStyle,
            child: child ?? const SizedBox.shrink(),
          ),
          home: const AnaMenu(),
        );
      },
    );
  }
}
