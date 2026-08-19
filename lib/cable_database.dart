// lib/cable_database.dart
//
// Elektrik Saha Asistanı
// Merkezi Kablo Veritabanı
//
// Bu dosya:
// - AG / OG kablo seçimleri
// - NYY Cu
// - Açık iletken
// - ALPEK
// - Monofaze / trifaze
// - Paralel kablo grupları
// - Gerilim düşümü ön hesabı
// için ortak veri ve yardımcı fonksiyonları içerir.
//
// NOT:
// Bu veriler ön seçim / teknik değerlendirme amacıyla kullanılır.
// Nihai proje hesabında yürürlükteki standartlar, TEDAŞ / dağıtım
// şirketi şartnameleri, üretici katalogları ve gerçek saha koşulları
// ayrıca doğrulanmalıdır.

import 'dart:math';

// ============================================================
// 1. TEMEL NYY KESİT LİSTESİ
// ============================================================

const List<double> nyyKesitleri = <double>[
  1.5,
  2.5,
  4,
  6,
  10,
  16,
  25,
  35,
  50,
  70,
  95,
  120,
  150,
  185,
  240,
];

// Kullanıcı seçim listesinde teorik olarak 0,75 ve 1 mm² de
// bulunabilmesi için ayrı liste tutulur.
const List<double> nyyTeorikKesitleri = <double>[
  0.75,
  1,
  1.5,
  2.5,
  4,
  6,
  10,
  16,
  25,
  35,
  50,
  70,
  95,
  120,
  150,
  185,
  240,
];

// ============================================================
// 2. NYY Cu - R / X REFERANS TABLOSU
// ============================================================

const List<double> nyyR70Ac = <double>[
  14.5,
  8.87,
  5.52,
  3.69,
  2.19,
  1.38,
  0.870,
  0.627,
  0.463,
  0.321,
  0.232,
  0.184,
  0.150,
  0.121,
  0.0926,
];

const List<double> nyyX50Hz = <double>[
  0.090,
  0.086,
  0.082,
  0.083,
  0.080,
  0.079,
  0.079,
  0.078,
  0.078,
  0.077,
  0.077,
  0.077,
  0.077,
  0.077,
  0.077,
];

// ============================================================
// 3. KABLO SEÇENEĞİ MODELİ
// ============================================================

class KabloSecenegi {
  final String etiket;
  final double kesit;
  final int paralel;
  final bool dortDamar;
  final double? havaA;
  final double? toprakA;

  const KabloSecenegi({
    required this.etiket,
    required this.kesit,
    this.paralel = 1,
    this.dortDamar = false,
    this.havaA,
    this.toprakA,
  });
}

// ============================================================
// 4. STANDART KABLO SEÇİM LİSTESİ
// ============================================================

const List<String> standartKabloSecimListesi = <String>[
  // ----------------------------------------------------------
  // TEK DAMAR
  // ----------------------------------------------------------

  '1x0,75 mm²',
  '1x1 mm²',
  '1x1,5 mm²',
  '1x2,5 mm²',
  '1x4 mm²',
  '1x6 mm²',
  '1x10 mm²',
  '1x16 mm²',
  '1x25 mm²',
  '1x35 mm²',
  '1x50 mm²',
  '1x70 mm²',
  '1x95 mm²',
  '1x120 mm²',
  '1x150 mm²',
  '1x185 mm²',
  '1x240 mm²',

  // ----------------------------------------------------------
  // MONOFAZE - FAZ + NÖTR
  // ----------------------------------------------------------

  '2x0,75 mm²',
  '2x1 mm²',
  '2x1,5 mm²',
  '2x2,5 mm²',
  '2x4 mm²',
  '2x6 mm²',
  '2x10 mm²',
  '2x16 mm²',
  '2x25 mm²',
  '2x35 mm²',
  '2x50 mm²',
  '2x70 mm²',
  '2x95 mm²',
  '2x120 mm²',
  '2x150 mm²',
  '2x185 mm²',
  '2x240 mm²',

  // ----------------------------------------------------------
  // TRİFAZE - 3 DAMAR
  // ----------------------------------------------------------

  '3x0,75 mm²',
  '3x1 mm²',
  '3x1,5 mm²',
  '3x2,5 mm²',
  '3x4 mm²',
  '3x6 mm²',
  '3x10 mm²',

  // ----------------------------------------------------------
  // TRİFAZE - 3 FAZ + NÖTR
  // ----------------------------------------------------------

  '4x1,5 mm²',
  '4x2,5 mm²',
  '4x4 mm²',
  '4x6 mm²',
  '4x10 mm²',

  // ----------------------------------------------------------
  // TRİFAZE - 3 FAZ + AZALTILMIŞ NÖTR
  // ----------------------------------------------------------

  '3x16+10 mm²',
  '3x25+16 mm²',
  '3x35+16 mm²',
  '3x50+25 mm²',
  '3x70+35 mm²',
  '3x95+50 mm²',
  '3x120+70 mm²',
  '3x150+70 mm²',
  '3x185+95 mm²',
  '3x240+120 mm²',

  // ----------------------------------------------------------
  // 2 PARALEL
  // ----------------------------------------------------------

  '2x(3x16+10) mm²',
  '2x(3x25+16) mm²',
  '2x(3x35+16) mm²',
  '2x(3x50+25) mm²',
  '2x(3x70+35) mm²',
  '2x(3x95+50) mm²',
  '2x(3x120+70) mm²',
  '2x(3x150+70) mm²',
  '2x(3x185+95) mm²',
  '2x(3x240+120) mm²',

  // ----------------------------------------------------------
  // 3 PARALEL
  // ----------------------------------------------------------

  '3x(3x16+10) mm²',
  '3x(3x25+16) mm²',
  '3x(3x35+16) mm²',
  '3x(3x50+25) mm²',
  '3x(3x70+35) mm²',
  '3x(3x95+50) mm²',
  '3x(3x120+70) mm²',
  '3x(3x150+70) mm²',
  '3x(3x185+95) mm²',
  '3x(3x240+120) mm²',
];

// ============================================================
// 5. MONOFAZE / TRİFAZE LİSTELERİ
// ============================================================

List<String> get merkeziMonofazeKablolar {
  return standartKabloSecimListesi.where((e) {
    return e.startsWith('1x') || (e.startsWith('2x') && !e.startsWith('2x('));
  }).toList();
}

List<String> get merkeziTrifazeKablolar {
  return standartKabloSecimListesi.where((e) {
    return e.startsWith('3x') || e.startsWith('4x') || e.startsWith('2x(');
  }).toList();
}

// ============================================================
// 6. NYY TAŞIMA KAPASİTESİ
// ============================================================
//
// Buradaki değerler özellikle 3x...+N yapısı içindir.
//
// "hava" ve "toprak" tabloları yalnızca BİR KEZ tanımlanmıştır.
// Önceki derleme hatasının nedeni aynı isimlerin iki kez
// tanımlanmasıydı.
// ============================================================

const Map<String, double> nyyHavaAmp = <String, double>{
  '3x25+16': 108,
  '3x35+16': 132,
  '3x50+25': 160,
  '3x70+35': 202,
  '3x95+50': 249,
  '3x120+70': 289,
  '3x150+70': 329,
  '3x185+95': 377,
  '3x240+120': 443,
};

const Map<String, double> nyyToprakAmp = <String, double>{
  '3x25+16': 133,
  '3x35+16': 160,
  '3x50+25': 190,
  '3x70+35': 234,
  '3x95+50': 280,
  '3x120+70': 319,
  '3x150+70': 357,
  '3x185+95': 402,
  '3x240+120': 463,
};

// ============================================================
// 7. BASİT NYY TEK KESİT TAŞIMA KAPASİTESİ
// ============================================================
//
// Bu tablo, hat analizinde kullanıcı seçimine göre değil,
// teknik ön seçim için kullanılır.
//
// Değerler proje/saha koşullarına göre ayrıca düzeltilmelidir.
// ============================================================

const Map<String, double> nyyTekDamarHavaAmp = <String, double>{
  '0.75': 10,
  '1': 13,
  '1.5': 18,
  '2.5': 25,
  '4': 34,
  '6': 44,
  '10': 61,
  '16': 82,
  '25': 108,
  '35': 132,
  '50': 160,
  '70': 202,
  '95': 249,
  '120': 289,
  '150': 329,
  '185': 377,
  '240': 443,
};

const Map<String, double> nyyTekDamarToprakAmp = <String, double>{
  '0.75': 12,
  '1': 16,
  '1.5': 22,
  '2.5': 30,
  '4': 40,
  '6': 51,
  '10': 70,
  '16': 94,
  '25': 133,
  '35': 160,
  '50': 190,
  '70': 234,
  '95': 280,
  '120': 319,
  '150': 357,
  '185': 402,
  '240': 463,
};

// ============================================================
// 8. KABLO ETİKETİ PARSE YARDIMCILARI
// ============================================================

String secimTemelYapi(String secim) {
  String s = secim.trim();

  s = s.replaceAll(' mm²', '');
  s = s.replaceAll(' ', '');
  s = s.replaceAll('×', 'x');

  // Örnek:
  // 2x(3x240+120)
  // -> 3x240+120

  s = s.replaceFirst(
    RegExp(r'^\d+x\('),
    '',
  );

  if (s.endsWith(')')) {
    s = s.substring(0, s.length - 1);
  }

  return s;
}

int secimParalel(String secim) {
  final RegExpMatch? m = RegExp(
    r'^(\d+)x\(',
  ).firstMatch(
    secim.replaceAll(' ', ''),
  );

  if (m == null) {
    return 1;
  }

  return int.tryParse(m.group(1) ?? '') ?? 1;
}

double? _kesitAnahtarindanDouble(String value) {
  return double.tryParse(
    value.replaceAll(',', '.').trim(),
  );
}

String _kesitAnahtari(double kesit) {
  if (kesit == kesit.roundToDouble()) {
    return kesit.toInt().toString();
  }

  return kesit
      .toStringAsFixed(2)
      .replaceFirst(RegExp(r'0+$'), '')
      .replaceFirst(RegExp(r'\.$'), '');
}

// ============================================================
// 9. NYY TEMEL HAVA AKIMI
// ============================================================

double? kabloTemelHava(String secim) {
  final String temiz = secimTemelYapi(secim);

  // 3x240+120 gibi özel kablo
  final double? ozel = nyyHavaAmp[temiz];

  if (ozel != null) {
    return ozel * secimParalel(secim);
  }

  // 1x240 / 2x240 / 3x240 vb.
  final RegExpMatch? m = RegExp(
    r'^(?:\d+x)?(\d+(?:[.,]\d+)?)$',
  ).firstMatch(temiz);

  if (m == null) {
    return null;
  }

  final double? kesit = _kesitAnahtarindanDouble(
    m.group(1) ?? '',
  );

  if (kesit == null) {
    return null;
  }

  final double? base = nyyTekDamarHavaAmp[_kesitAnahtari(kesit)];

  if (base == null) {
    return null;
  }

  final int damar = int.tryParse(
        RegExp(r'^(\d+)x').firstMatch(temiz)?.group(1) ?? '1',
      ) ??
      1;

  return base * damar;
}

// ============================================================
// 10. NYY TEMEL TOPRAK AKIMI
// ============================================================

double? kabloTemelToprak(String secim) {
  final String temiz = secimTemelYapi(secim);

  final double? ozel = nyyToprakAmp[temiz];

  if (ozel != null) {
    return ozel * secimParalel(secim);
  }

  final RegExpMatch? m = RegExp(
    r'^(?:\d+x)?(\d+(?:[.,]\d+)?)$',
  ).firstMatch(temiz);

  if (m == null) {
    return null;
  }

  final double? kesit = _kesitAnahtarindanDouble(
    m.group(1) ?? '',
  );

  if (kesit == null) {
    return null;
  }

  final double? base = nyyTekDamarToprakAmp[_kesitAnahtari(kesit)];

  if (base == null) {
    return null;
  }

  final int damar = int.tryParse(
        RegExp(r'^(\d+)x').firstMatch(temiz)?.group(1) ?? '1',
      ) ??
      1;

  return base * damar;
}

// ============================================================
// 11. TEKNİK OLARAK UYGUN NYY KESİT BULMA
// ============================================================
//
// ÖNEMLİ:
// Kullanıcının seçtiği kablo kesiti burada belirleyici değildir.
//
// Örneğin kullanıcı:
//   2x10 seçmiş,
// fakat hesaplanan akım 58 A ise,
// sistem teknik olarak uygun daha büyük bir kesit arar.
//
// Hat analizi sonuç ekranında "Önerilen Kesit" için bu mantık
// kullanılmalıdır.
// ============================================================

String? nyyTeknikUygunKesitBul({
  required double akim,
  required bool threePhase,
  required bool toprakHatti,
  double duzeltme = 0.84,
}) {
  if (!akim.isFinite || akim <= 0) {
    return null;
  }

  if (!threePhase) {
    // --------------------------------------------------------
    // MONOFAZE
    //
    // Hat analizinde:
    // 1 faz + 1 nötr
    //
    // Bu nedenle maksimum:
    // 2x240
    //
    // Toprak hattı ayrıca eklenmez.
    // --------------------------------------------------------

    for (final double kesit in nyyTeorikKesitleri) {
      final double? kapasite = nyyTekDamarHavaAmp[_kesitAnahtari(kesit)];

      if (kapasite == null) {
        continue;
      }

      final double duzeltilmis = kapasite * duzeltme;

      if (duzeltilmis >= akim) {
        return '${_formatKesit(kesit)}x2 mm² NYY (Cu)';
      }
    }

    return '2x240 mm² NYY (Cu)';
  }

  // ----------------------------------------------------------
  // TRİFAZE
  //
  // 4x10'dan sonra:
  //
  // 3x16+10
  // 3x25+16
  // ...
  // 3x240+120
  //
  // Toprak hattı hat analizinde ayrıca eklenmez.
  // ----------------------------------------------------------

  const List<String> dortDamarli = <String>[
    '4x1,5 mm²',
    '4x2,5 mm²',
    '4x4 mm²',
    '4x6 mm²',
    '4x10 mm²',
  ];

  for (final String secim in dortDamarli) {
    final String temiz = secimTemelYapi(secim);

    final RegExpMatch? m = RegExp(
      r'^4x(\d+(?:[.,]\d+)?)$',
    ).firstMatch(temiz);

    if (m == null) {
      continue;
    }

    final double? kesit = _kesitAnahtarindanDouble(m.group(1) ?? '');

    if (kesit == null) {
      continue;
    }

    final double? kapasite = nyyTekDamarHavaAmp[_kesitAnahtari(kesit)];

    if (kapasite == null) {
      continue;
    }

    final double duzeltilmis = kapasite * duzeltme;

    if (duzeltilmis >= akim) {
      return secim.replaceAll(' ', '');
    }
  }

  // 4x10'dan sonra özel 3+N yapısına geçilir.
  final List<String> ozel = <String>[
    '3x16+10 mm²',
    '3x25+16 mm²',
    '3x35+16 mm²',
    '3x50+25 mm²',
    '3x70+35 mm²',
    '3x95+50 mm²',
    '3x120+70 mm²',
    '3x150+70 mm²',
    '3x185+95 mm²',
    '3x240+120 mm²',
  ];

  for (final String secim in ozel) {
    final double? kapasite = kabloTemelHava(secim);

    if (kapasite == null) {
      continue;
    }

    final double duzeltilmis = kapasite * duzeltme;

    if (duzeltilmis >= akim) {
      return secim;
    }
  }

  // ----------------------------------------------------------
  // Tek sistem yeterli değilse paralel sistemler.
  // ----------------------------------------------------------

  for (int paralel = 2; paralel <= 12; paralel++) {
    for (final String secim in ozel) {
      final double? tek = kabloTemelHava(secim);

      if (tek == null) {
        continue;
      }

      final double toplam = tek * paralel * duzeltme;

      if (toplam >= akim) {
        return '${paralel}x(${secim.replaceAll(' mm²', '')}) mm²';
      }
    }
  }

  return '3x240+120 mm² NYY (Cu)';
}

// ============================================================
// 12. PARALEL KABLO BULMA
// ============================================================

String standartParalelKabloBul(
  double akim, {
  double duzeltme = 0.84,
}) {
  if (!akim.isFinite || akim <= 0) {
    return 'Hesaplama yapılamadı';
  }

  final double tek = 443.0 * duzeltme;

  final int adet = max(
    1,
    (akim / tek).ceil(),
  );

  if (adet <= 12) {
    if (adet == 1) {
      return '3x240+120 mm² NYY (Cu)';
    }

    return '$adet paralel × 3x240+120 mm² NYY (Cu)';
  }

  return 'Paralel kablo grubu > 12 sistem — proje bazlı kablo/şebeke tasarımı gerekir';
}

// ============================================================
// 13. GERİLİM DÜŞÜMÜ
// ============================================================

double nyyGerilimDusumuYuzde({
  required double powerKw,
  required double distanceM,
  required double sectionMm2,
  required double cosPhi,
  required bool threePhase,
  required double voltage,
}) {
  final int idx = nyyKesitleri.indexWhere(
    (s) => (s - sectionMm2).abs() < 0.001,
  );

  if (idx < 0) {
    return double.nan;
  }

  if (!powerKw.isFinite ||
      !distanceM.isFinite ||
      !cosPhi.isFinite ||
      !voltage.isFinite ||
      voltage <= 0) {
    return double.nan;
  }

  final double r = nyyR70Ac[idx];
  final double x = nyyX50Hz[idx];

  final double cos = max(cosPhi, 0.01);

  final double i = threePhase
      ? powerKw * 1000 / (sqrt(3) * voltage * cos)
      : powerKw * 1000 / (voltage * cos);

  final double sinPhi = sqrt(
    max(
      0.0,
      1 - cosPhi * cosPhi,
    ),
  );

  final double du;

  if (threePhase) {
    du = sqrt(3) * i * ((r / 1000) * cosPhi + (x / 1000) * sinPhi) * distanceM;
  } else {
    du = 2 * i * (r / 1000) * distanceM;
  }

  return du / voltage * 100;
}

// ============================================================
// 14. AÇIK İLETKEN
// ============================================================
//
// AG açık iletken için:
// Monofaze = 1 + 1
// Trifaze  = 3 + 1
//
// Buradaki yapı NYY'den bağımsız tutulmuştur.
// ============================================================

const List<double> acikIletkenKesitleri = <double>[
  16,
  25,
  35,
  50,
  70,
  95,
  120,
  150,
  185,
  240,
];

const Map<String, double> acikIletkenAmp = <String, double>{
  '16': 82,
  '25': 108,
  '35': 132,
  '50': 160,
  '70': 202,
  '95': 249,
  '120': 289,
  '150': 329,
  '185': 377,
  '240': 443,
};

// ============================================================
// 15. AÇIK İLETKEN TEKNİK UYGUN KESİT
// ============================================================

String? acikIletkenTeknikUygunKesitBul({
  required double akim,
  required bool threePhase,
  double duzeltme = 0.84,
}) {
  if (!akim.isFinite || akim <= 0) {
    return null;
  }

  for (final double kesit in acikIletkenKesitleri) {
    final double? kapasite = acikIletkenAmp[_kesitAnahtari(kesit)];

    if (kapasite == null) {
      continue;
    }

    if (kapasite * duzeltme >= akim) {
      if (threePhase) {
        return '3+1 x ${_formatKesit(kesit)} mm² Açık İletken';
      }

      return '1+1 x ${_formatKesit(kesit)} mm² Açık İletken';
    }
  }

  return threePhase
      ? '3+1 x 240 mm² Açık İletken'
      : '1+1 x 240 mm² Açık İletken';
}

// ============================================================
// 16. ALPEK
// ============================================================

const List<double> alpekKesitleri = <double>[
  16,
  25,
  35,
  50,
  70,
  95,
  120,
  150,
  185,
  240,
];

const Map<String, double> alpekAmp = <String, double>{
  '16': 82,
  '25': 108,
  '35': 132,
  '50': 160,
  '70': 202,
  '95': 249,
  '120': 289,
  '150': 329,
  '185': 377,
  '240': 443,
};

// ============================================================
// 17. ALPEK TEKNİK UYGUN KESİT
// ============================================================

String? alpekTeknikUygunKesitBul({
  required double akim,
  required bool threePhase,
  double duzeltme = 0.84,
}) {
  if (!akim.isFinite || akim <= 0) {
    return null;
  }

  for (final double kesit in alpekKesitleri) {
    final double? kapasite = alpekAmp[_kesitAnahtari(kesit)];

    if (kapasite == null) {
      continue;
    }

    if (kapasite * duzeltme >= akim) {
      if (threePhase) {
        return '3+1 x ${_formatKesit(kesit)} mm² ALPEK';
      }

      return '1+1 x ${_formatKesit(kesit)} mm² ALPEK';
    }
  }

  return threePhase ? '3+1 x 240 mm² ALPEK' : '1+1 x 240 mm² ALPEK';
}

// ============================================================
// 18. OG KABLO YAPISI
// ============================================================
//
// OG tarafında her sistem için 3 iletken mantığı kullanılır.
// ============================================================

const List<double> ogKesitleri = <double>[
  16,
  25,
  35,
  50,
  70,
  95,
  120,
  150,
  185,
  240,
];

const Map<String, double> ogAmp = <String, double>{
  '16': 82,
  '25': 108,
  '35': 132,
  '50': 160,
  '70': 202,
  '95': 249,
  '120': 289,
  '150': 329,
  '185': 377,
  '240': 443,
};

// ============================================================
// 19. OG TEKNİK UYGUN KESİT
// ============================================================

String? ogTeknikUygunKesitBul({
  required double akim,
  double duzeltme = 0.84,
  String iletkenTipi = 'OG',
}) {
  if (!akim.isFinite || akim <= 0) {
    return null;
  }

  for (final double kesit in ogKesitleri) {
    final double? kapasite = ogAmp[_kesitAnahtari(kesit)];

    if (kapasite == null) {
      continue;
    }

    if (kapasite * duzeltme >= akim) {
      return '3 x ${_formatKesit(kesit)} mm² $iletkenTipi';
    }
  }

  return '3 x 240 mm² $iletkenTipi';
}

// ============================================================
// 20. GENEL TEKNİK KABLO SEÇİCİ
// ============================================================
//
// Hat analizinde mümkün olduğunca BU fonksiyonun kullanılması
// önerilir.
//
// Kullanıcı ne seçerse seçsin:
//
//   hesaplanan akım
//          ↓
//   teknik uygunluk
//          ↓
//   gerekli kesit
//
// zinciri işletilir.
// ============================================================

String? teknikUygunKabloBul({
  required double akim,
  required String gerilimSeviyesi,
  required String kabloTipi,
  required bool threePhase,
  bool toprakHatti = false,
  double duzeltme = 0.84,
}) {
  final String gerilim = gerilimSeviyesi.trim().toUpperCase();

  final String tip = kabloTipi.trim().toUpperCase();

  // ----------------------------------------------------------
  // OG
  // ----------------------------------------------------------

  if (gerilim == 'OG' || gerilim.contains('ORTA')) {
    return ogTeknikUygunKesitBul(
      akim: akim,
      duzeltme: duzeltme,
      iletkenTipi: kabloTipi,
    );
  }

  // ----------------------------------------------------------
  // AG - AÇIK İLETKEN
  // ----------------------------------------------------------

  if (tip.contains('AÇIK') ||
      tip.contains('ACIK') ||
      tip.contains('İLETKEN') && !tip.contains('KABLO')) {
    return acikIletkenTeknikUygunKesitBul(
      akim: akim,
      threePhase: threePhase,
      duzeltme: duzeltme,
    );
  }

  // ----------------------------------------------------------
  // AG - ALPEK
  // ----------------------------------------------------------

  if (tip.contains('ALPEK')) {
    return alpekTeknikUygunKesitBul(
      akim: akim,
      threePhase: threePhase,
      duzeltme: duzeltme,
    );
  }

  // ----------------------------------------------------------
  // AG - NYY
  // ----------------------------------------------------------

  return nyyTeknikUygunKesitBul(
    akim: akim,
    threePhase: threePhase,
    toprakHatti: toprakHatti,
    duzeltme: duzeltme,
  );
}

// ============================================================
// 21. KESİT FORMATLAMA
// ============================================================

String _formatKesit(double kesit) {
  if (kesit == kesit.roundToDouble()) {
    return kesit.toInt().toString();
  }

  return kesit
      .toStringAsFixed(2)
      .replaceFirst(RegExp(r'0+$'), '')
      .replaceFirst(RegExp(r'\.$'), '')
      .replaceAll('.', ',');
}

// ============================================================
// 22. TEKNİK KAYNAK NOTU
// ============================================================

const String teknikKaynakNotu =
    'Teknik referanslar; yürürlükteki mevzuat, ilgili standartlar, '
    'TEDAŞ/dağıtım şirketleri teknik şartnameleri, üretici teknik '
    'verileri ve onaylı proje koşulları esas alınarak değerlendirilmelidir. '
    'Uygulamadaki değerler ön değerlendirme içindir; saha koşulları, '
    'döşeme şekli, ortam sıcaklığı, gruplanma, toprak koşulları ve '
    'proje özel şartları ayrıca doğrulanmalıdır.';

// ============================================================
// DOSYA SONU
// ============================================================
