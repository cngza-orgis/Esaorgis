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

// Güç kablosu seçimlerinde yalnızca KHA veri tabanında karşılığı bulunan
// standart kesitler kullanılır. Desteklenmeyen küçük kesitler kullanıcıya
// kapasite sonucu olmadan sunulmaz.
const List<double> nyyTeorikKesitleri = <double>[
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

// ============================================================
// KABLO DIŞ ÇAPI REFERANS VERİLERİ — MERKEZİ KAYNAK
// ============================================================
// Boru/tava gibi geometrik hesaplarda kesit, dış çap yerine geçmez.
// Bulunabilen üretici referans dış çapları burada tutulur; kayıt olmayan
// yapılarda kullanıcı/üretici gerçek dış çapı girebilir.
const Map<String, double> merkeziKabloDisCapMm = <String, double>{
  '1x4 mm²': 6.8,
  '1x6 mm²': 7.3,
  '1x10 mm²': 8.1,
  '3x1,5 mm²': 10.3,
  '3x2,5 mm²': 11.1,
  '3x4 mm²': 12.9,
  '3x6 mm²': 14.3,
  '3x10 mm²': 16.0,
  '3x16 mm²': 18.0,
  '3x25+16 mm²': 22.1,
  '3x35+16 mm²': 24.4,
  '3x50+25 mm²': 27.7,
  '3x70+35 mm²': 31.4,
  '3x95+50 mm²': 36.4,
  '3x120+70 mm²': 40.0,
  '3x150+70 mm²': 43.5,
  '3x185+95 mm²': 48.5,
  '3x240+120 mm²': 55.0,
  '4x1,5 mm²': 11.2,
  '4x2,5 mm²': 12.1,
  '4x4 mm²': 13.9,
  '4x6 mm²': 15.1,
  '4x10 mm²': 16.8,
  '4x16 mm²': 19.2,
  '4x25+16 mm²': 23.6,
  '4x35+16 mm²': 26.2,
  '4x50+25 mm²': 29.4,
  '4x70+35 mm²': 33.6,
  '4x95+50 mm²': 38.4,
  '4x120+70 mm²': 43.0,
  '4x150+70 mm²': 46.8,
  '4x185+95 mm²': 52.2,
  '4x240+120 mm²': 60.0,
};

double? merkeziKabloDisCapGetir(String secim) =>
    merkeziKabloDisCapMm[secim.trim()];

const List<String> standartKabloSecimListesi = <String>[
  // ----------------------------------------------------------
  // TEK DAMAR
  // ----------------------------------------------------------

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

/// AG monofaze ekranlarında gösterilecek standart NYY yapıları.
/// Kullanıcı talimatı gereği 1x, 2x ve 3x yapılar aynı listede tutulur.
/// Monofaze teknik ön seçiminde gerçek devre yapısı ayrıca değerlendirilir;
/// otomatik öneri motoru gereken yerde 2x (faz+nötr) yapı seçer.
/// Verilen AG kablo kesitleri için monofaze kullanıcı seçim yapısını üretir.
/// Kullanıcı talimatı: ilgili tüm AG monofaze araçlarında 1x, 2x ve 3x
/// yapılar görünür olmalıdır. Buradaki liste yalnızca gösterim/seçim
/// standardıdır; otomatik teknik öneri devre yapısına ayrıca karar verir.
List<String> agMonofazeKabloYapilari(Iterable<double> kesitler) {
  final formatted = kesitler.map(_formatKesitMerkezi).toList(growable: false);
  return <String>[
    ...formatted.map((k) => '1x$k mm²'),
    ...formatted.map((k) => '2x$k mm²'),
    ...formatted.map((k) => '3x$k mm²'),
  ];
}

const List<double> nayyKesitleriMerkezi = <double>[10, 16, 25, 35, 50, 70, 95, 120, 150, 185, 240];

List<String> merkeziAgMonofazeNayyKablolar() =>
    agMonofazeKabloYapilari(nayyKesitleriMerkezi);

List<String> merkeziAgTrifazeNayyKablolar() => <String>[
  ...nayyKesitleriMerkezi
      .where((k) => k <= 10)
      .map((k) => '4x${_formatKesitMerkezi(k)} mm²'),
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

List<String> get merkeziAgMonofazeNyyKablolar {
  return agMonofazeKabloYapilari(nyyKesitleri);
}

/// AG trifaze için 4 damarlı başlangıç ve 3 faz + azaltılmış nötr
/// yapısını tek merkezî listede tutar.
List<String> get merkeziAgTrifazeNyyKablolar {
  return <String>[
    '4x1,5 mm²',
    '4x2,5 mm²',
    '4x4 mm²',
    '4x6 mm²',
    '4x10 mm²',
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
  ];
}

String _formatKesitMerkezi(double kesit) {
  if (kesit == kesit.roundToDouble()) return kesit.toInt().toString();
  return kesit.toString().replaceAll('.', ',');
}

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
// 6. NYY TAŞIMA KAPASİTESİ — TEK MERKEZÎ KAYNAK
// ============================================================
//
// Referans veri seti: NYY Cu için doğrulanmış/karşılaştırılmış referans
// tablo yapısı. Değerler kablo yapısı ve döşeme şekline göre ayrı tutulur.
// Aynı kesit farklı damar yapısında farklı KHA üretebilir; bu nedenle
// yalnızca kesit üzerinden tek bir kapasite değeri türetilmez.
//
// Not: Kesin proje hesabında kablo üreticisi, çevre sıcaklığı, toprak
// termik özdirenci, gruplanma, gömme derinliği ve diğer düzeltme katsayıları
// ayrıca doğrulanmalıdır. IEC 60287 akım taşıma hesabını döşeme/çevre
// koşullarına bağlı bir problem olarak tanımlar.
// ============================================================

const Map<String, double> nyyTekDamarHavaAmp = <String, double>{
  '1.5': 26, '2.5': 35, '4': 46, '6': 58, '10': 80, '16': 105,
  '25': 140, '35': 175, '50': 215, '70': 270, '95': 335, '120': 390,
  '150': 445, '185': 510, '240': 620,
};

const Map<String, double> nyyTekDamarToprakAmp = <String, double>{
  '1.5': 37, '2.5': 50, '4': 65, '6': 83, '10': 110, '16': 145,
  '25': 190, '35': 235, '50': 280, '70': 350, '95': 420, '120': 480,
  '150': 540, '185': 620, '240': 770,
};

const Map<String, double> nyyIkiDamarHavaAmp = <String, double>{
  '1.5': 21, '2.5': 29, '4': 38, '6': 48, '10': 66,
};

const Map<String, double> nyyIkiDamarToprakAmp = <String, double>{
  '1.5': 30, '2.5': 41, '4': 53, '6': 66, '10': 88,
};

const Map<String, double> nyyUcDamarHavaAmp = <String, double>{
  '1.5': 18, '2.5': 25, '4': 34, '6': 44, '10': 60,
};

const Map<String, double> nyyUcDamarToprakAmp = <String, double>{
  '1.5': 27, '2.5': 36, '4': 46, '6': 58, '10': 77,
};

const Map<String, double> nyyDortDamarHavaAmp = <String, double>{
  '1.5': 18, '2.5': 25, '4': 34, '6': 44, '10': 60, '16': 80,
};

const Map<String, double> nyyDortDamarToprakAmp = <String, double>{
  '1.5': 27, '2.5': 36, '4': 46, '6': 58, '10': 77, '16': 100,
};

const Map<String, double> nyyUcFazNNotHavaAmp = <String, double>{
  '3x16+10': 105,
  '3x25+16': 130,
  '3x35+16': 160,
  '3x50+25': 200,
  '3x70+35': 245,
  '3x95+50': 285,
  '3x120+70': 325,
  '3x150+70': 370,
  '3x185+95': 435,
  '3x240+120': 500,
};

const Map<String, double> nyyUcFazNNotToprakAmp = <String, double>{
  '3x16+10': 130,
  '3x25+16': 155,
  '3x35+16': 185,
  '3x50+25': 230,
  '3x70+35': 275,
  '3x95+50': 315,
  '3x120+70': 355,
  '3x150+70': 400,
  '3x185+95': 460,
  '3x240+120': 520,
};

// Eski isimlerle uyumluluk: AG trifaze özel yapılar.
const Map<String, double> nyyHavaAmp = nyyUcFazNNotHavaAmp;
const Map<String, double> nyyToprakAmp = nyyUcFazNNotToprakAmp;

// ============================================================
// 7. KAPASİTE SEÇİMİ
// ============================================================

String _normalizeKabloSecim(String secim) =>
    secim.replaceAll(' ', '').replaceAll('×', 'x').replaceAll('MM²', 'mm²');

double? nyyKapasiteSecimeGore(String secim, {required bool toprakta}) {
  final normalized = _normalizeKabloSecim(secim.replaceAll('mm²', ''));
  final int paralel = secimParalel(normalized);
  final String temel = secimTemelYapi(normalized);
  final String key = temel;

  Map<String, double> table;
  if (key.contains('+')) {
    table = toprakta ? nyyUcFazNNotToprakAmp : nyyUcFazNNotHavaAmp;
  } else {
    final Match? m = RegExp(r'^(1|2|3|4)x(\d+(?:[.,]\d+)?)$').firstMatch(key);
    if (m == null) return null;
    final int damar = int.tryParse(m.group(1)!) ?? 0;
    final String kesit = m.group(2)!.replaceAll(',', '.');
    if (damar == 1) {
      table = toprakta ? nyyTekDamarToprakAmp : nyyTekDamarHavaAmp;
    } else if (damar == 2) {
      table = toprakta ? nyyIkiDamarToprakAmp : nyyIkiDamarHavaAmp;
    } else if (damar == 3) {
      table = toprakta ? nyyUcDamarToprakAmp : nyyUcDamarHavaAmp;
    } else {
      table = toprakta ? nyyDortDamarToprakAmp : nyyDortDamarHavaAmp;
    }
    final value = table[kesit];
    return value == null ? null : value * paralel;
  }

  final value = table[key];
  return value == null ? null : value * paralel;
}


// ============================================================
// NAYY ALÜMİNYUM PVC/PVC — MERKEZİ KHA VERİSİ
// Kaynak: KMI NAYY teknik tabloları (IEC 60502-1).
// Hava: 30 °C; toprak: kaynak tabloda verilen referans koşullar.
// Bu değerler üretici/referans tabloya göre tutulur; Cu x 0,78
// gibi genel katsayılarla türetilmez.
// ============================================================

const Map<String, double> nayyHava1xAmp = <String, double>{
  '10': 50, '16': 68, '25': 91, '35': 112, '50': 138, '70': 175,
  '95': 216, '120': 251, '150': 291, '185': 339, '240': 407,
};
const Map<String, double> nayyToprak1xAmp = <String, double>{
  '10': 58, '16': 76, '25': 97, '35': 117, '50': 138, '70': 169,
  '95': 202, '120': 229, '150': 258, '185': 292, '240': 339,
};
const Map<String, double> nayyHava2xAmp = <String, double>{
  '10': 54, '16': 73, '25': 94, '35': 116, '50': 141, '70': 178,
  '95': 218, '120': 253, '150': 285, '185': 331, '240': 390,
};
const Map<String, double> nayyToprak2xAmp = <String, double>{
  '10': 61, '16': 81, '25': 103, '35': 125, '50': 148, '70': 183,
  '95': 219, '120': 250, '150': 279, '185': 317, '240': 366,
};
const Map<String, double> nayyHava3xAmp = <String, double>{
  '10': 46, '16': 62, '25': 81, '35': 100, '50': 126, '70': 158,
  '95': 194, '120': 225, '150': 257, '185': 297, '240': 352,
};
const Map<String, double> nayyToprak3xAmp = <String, double>{
  '10': 52, '16': 69, '25': 88, '35': 106, '50': 131, '70': 160,
  '95': 192, '120': 219, '150': 245, '185': 278, '240': 322,
};
const Map<String, double> nayyHava4xAmp = <String, double>{
  '10': 53, '16': 71, '25': 93, '35': 115, '50': 134, '70': 167,
  '95': 207, '120': 240, '150': 277, '185': 316, '240': 377,
};
const Map<String, double> nayyToprak4xAmp = <String, double>{
  '10': 59, '16': 77, '25': 99, '35': 119, '50': 135, '70': 165,
  '95': 198, '120': 225, '150': 254, '185': 286, '240': 332,
};

const Map<String, double> nayyUcFazNNotHavaAmp = <String, double>{
  '3x16+10': 65,
  '3x25+16': 83,
  '3x35+16': 102,
  '3x50+25': 124,
  '3x70+35': 158,
  '3x95+50': 190,
  '3x120+70': 221,
  '3x150+70': 252,
  '3x185+95': 289,
  '3x240+120': 339,
};

const Map<String, double> nayyUcFazNNotToprakAmp = <String, double>{
  '3x16+10': 70,
  '3x25+16': 99,
  '3x35+16': 118,
  '3x50+25': 142,
  '3x70+35': 176,
  '3x95+50': 211,
  '3x120+70': 242,
  '3x150+70': 270,
  '3x185+95': 308,
  '3x240+120': 363,
};

double? nayyKapasiteSecimeGore(String secim, {required bool toprakta}) {
  final normalized = _normalizeKabloSecim(secim.replaceAll('mm²', ''));
  final temel = secimTemelYapi(normalized);
  final int paralel = secimParalel(normalized);

  // 3 faz + azaltılmış nötr yapıları normal 1/2/3/4x kesit regex'ine
  // girmediği için önce ayrı değerlendirilmelidir. Böylece hem tek sistem
  // hem de 2x(...)/3x(...) paralel NAYY seçimleri aynı merkezi KHA verisini
  // kullanır.
  if (temel.contains('+')) {
    final table = toprakta ? nayyUcFazNNotToprakAmp : nayyUcFazNNotHavaAmp;
    final value = table[temel];
    return value == null ? null : value * paralel;
  }

  final m = RegExp(r'^(1|2|3|4)x(\d+(?:[.,]\d+)?)$').firstMatch(temel);
  if (m == null) return null;
  final damar = int.tryParse(m.group(1)!) ?? 0;
  final kesit = m.group(2)!.replaceAll(',', '.');

  final Map<String,double>? table = switch (damar) {
    1 => toprakta ? nayyToprak1xAmp : nayyHava1xAmp,
    2 => toprakta ? nayyToprak2xAmp : nayyHava2xAmp,
    3 => toprakta ? nayyToprak3xAmp : nayyHava3xAmp,
    4 => toprakta ? nayyToprak4xAmp : nayyHava4xAmp,
    _ => null,
  };
  final value = table?[kesit];
  return value == null ? null : value * paralel;
}


// ============================================================
// OG XLPE KABLO KHA — MERKEZİ VERİ KAYNAĞI
//
// Faz 24: Hat Analizi içindeki OG yerel tabloları buraya taşındı.
// Değerler mevcut 2.4.4 çalışma tabanındaki OG teknik kapasite
// noktalarının aynen merkezileştirilmiş halidir. Üretici/şartname
// bazlı nihai doğrulama ayrıca yapılmalıdır; bu aşamada değerler
// değiştirilmemiş, yalnızca tek kaynağa alınmıştır.
// ============================================================

const List<double> ogKhaKesitleri = <double>[
  35, 50, 70, 95, 120, 150, 185, 240, 300, 400, 500,
];

const Map<String, double> ogN2xsyHavaA = <String, double>{
  '35': 193, '50': 231, '70': 289, '95': 354, '120': 409,
  '150': 464, '185': 532, '240': 631, '300': 722, '400': 837, '500': 961,
};

const Map<String, double> ogN2xsyToprakA = <String, double>{
  '35': 181, '50': 213, '70': 258, '95': 309, '120': 349,
  '150': 390, '185': 438, '240': 506, '300': 565, '400': 635, '500': 711,
};

const Map<String, double> ogNa2xsyHavaA = <String, double>{
  '35': 151, '50': 182, '70': 226, '95': 278, '120': 321,
  '150': 364, '185': 420, '240': 501, '300': 578, '400': 679, '500': 789,
};

const Map<String, double> ogNa2xsyToprakA = <String, double>{
  '35': 143, '50': 167, '70': 205, '95': 243, '120': 277,
  '150': 311, '185': 351, '240': 408, '300': 459, '400': 521, '500': 592,
};

String _ogKhaKey(double kesit) => kesit == kesit.roundToDouble()
    ? kesit.toInt().toString()
    : kesit.toString();

double? ogKapasiteSecimeGore({
  required double kesit,
  required bool al,
  required bool toprakta,
}) {
  final key = _ogKhaKey(kesit);
  final table = al
      ? (toprakta ? ogNa2xsyToprakA : ogNa2xsyHavaA)
      : (toprakta ? ogN2xsyToprakA : ogN2xsyHavaA);
  return table[key];
}

// ============================================================
// OG XLPE 20,3/35 kV — doğrulanmış ürün veri seti
// Kaynak: Nexans YXC7V (N2XSY / 20,3/35 kV) ve YXC7V-A (NA2XSY / 20,3/35 kV).
// Hava değeri: 30°C, üçgen (trefoil) serilim.
// Toprak değeri: 20°C, üçgen (trefoil) serilim.
// Doğrulanmış olmayan kesitler bu veri setinde yaklaşık değer olarak
// üretilmez; farklı üretici/kablo yapılarının karıştırılması önlenir.
// ============================================================

const Map<String, double> og2035N2xsyHavaA = <String, double>{
  '50': 238,
  '70': 296,
  '95': 361,
  '120': 417,
  '150': 473,
  '185': 543,
  '240': 641,
};

const Map<String, double> og2035N2xsyToprakA = <String, double>{
  '50': 196,
  '70': 239,
  '95': 285,
  '120': 323,
  '150': 361,
  '185': 406,
  '240': 469,
};

const Map<String, double> og2035Na2xsyHavaA = <String, double>{
  '50': 184,
  '95': 280,
  '150': 368,
  '185': 424,
};

const Map<String, double> og2035Na2xsyToprakA = <String, double>{
  '50': 152,
  '95': 221,
  '150': 281,
  '185': 317,
};

// ============================================================
// OG MERKEZİ EMPEDANS + DIŞ ÇAP VERİSİ
// ============================================================
// R20 ve çalışma indüktansı aynı kablo gerilim sınıfı + iletken
// yapısından alınır. X, 50 Hz için X = 2πfL ile hesaplanır.
// KHA ve gerilim düşümü artık farklı gerilim sınıflarından veri
// karıştırmaz.
//
// 12/20 kV:
// - N2XSY Cu: Nexans 12/20 kV teknik tablosu.
// - NA2XSY Al: KLZ / Doruk teknik tabloları; üretici ailesi ve
//   12/20 kV ürün sınıfı açıkça belirtilmiştir.
//
// 20,3/35 kV:
// - N2XSY Cu ve NA2XSY Al: Nexans 20,3/35 kV ürün verileri.
// Doğrulanmış veri olmayan kesitlerde yaklaşık R/X üretilmez.
// ============================================================

class MerkeziOgEmpedansVerisi {
  final double r20OhmKm;
  final double inductanceTrefoilMhKm;
  final double? outerDiameterMm;
  final String kaynak;

  const MerkeziOgEmpedansVerisi({
    required this.r20OhmKm,
    required this.inductanceTrefoilMhKm,
    required this.outerDiameterMm,
    required this.kaynak,
  });

  double get x50HzOhmKm =>
      2 * pi * 50.0 * (inductanceTrefoilMhKm / 1000.0);
}

const Map<String, MerkeziOgEmpedansVerisi> _og1220N2xsy = <String, MerkeziOgEmpedansVerisi>{
  '35': MerkeziOgEmpedansVerisi(r20OhmKm: 0.524, inductanceTrefoilMhKm: 0.45, outerDiameterMm: 26.3, kaynak: 'Nexans N2XSY 12/20 kV'),
  '50': MerkeziOgEmpedansVerisi(r20OhmKm: 0.387, inductanceTrefoilMhKm: 0.42, outerDiameterMm: 27.6, kaynak: 'Nexans N2XSY 12/20 kV'),
  '70': MerkeziOgEmpedansVerisi(r20OhmKm: 0.268, inductanceTrefoilMhKm: 0.40, outerDiameterMm: 29.1, kaynak: 'Nexans N2XSY 12/20 kV'),
  '95': MerkeziOgEmpedansVerisi(r20OhmKm: 0.193, inductanceTrefoilMhKm: 0.38, outerDiameterMm: 31.2, kaynak: 'Nexans N2XSY 12/20 kV'),
  '120': MerkeziOgEmpedansVerisi(r20OhmKm: 0.153, inductanceTrefoilMhKm: 0.36, outerDiameterMm: 33.0, kaynak: 'Nexans N2XSY 12/20 kV'),
  '150': MerkeziOgEmpedansVerisi(r20OhmKm: 0.124, inductanceTrefoilMhKm: 0.36, outerDiameterMm: 34.3, kaynak: 'Nexans N2XSY 12/20 kV'),
  '185': MerkeziOgEmpedansVerisi(r20OhmKm: 0.0991, inductanceTrefoilMhKm: 0.35, outerDiameterMm: 36.8, kaynak: 'Nexans N2XSY 12/20 kV'),
  '240': MerkeziOgEmpedansVerisi(r20OhmKm: 0.0754, inductanceTrefoilMhKm: 0.33, outerDiameterMm: 38.8, kaynak: 'Nexans N2XSY 12/20 kV'),
  '300': MerkeziOgEmpedansVerisi(r20OhmKm: 0.0601, inductanceTrefoilMhKm: 0.32, outerDiameterMm: 42.1, kaynak: 'Nexans N2XSY 12/20 kV'),
  '400': MerkeziOgEmpedansVerisi(r20OhmKm: 0.0470, inductanceTrefoilMhKm: 0.31, outerDiameterMm: 44.5, kaynak: 'Nexans N2XSY 12/20 kV'),
  '500': MerkeziOgEmpedansVerisi(r20OhmKm: 0.0366, inductanceTrefoilMhKm: 0.30, outerDiameterMm: 48.0, kaynak: 'Nexans N2XSY 12/20 kV'),
  '630': MerkeziOgEmpedansVerisi(r20OhmKm: 0.0283, inductanceTrefoilMhKm: 0.29, outerDiameterMm: 52.5, kaynak: 'Nexans N2XSY 12/20 kV'),
};

const Map<String, MerkeziOgEmpedansVerisi> _og1220Na2xsy = <String, MerkeziOgEmpedansVerisi>{
  '35': MerkeziOgEmpedansVerisi(r20OhmKm: 0.868, inductanceTrefoilMhKm: 0.454, outerDiameterMm: 25.3, kaynak: '12/20 kV NA2XSY teknik tablosu'),
  '50': MerkeziOgEmpedansVerisi(r20OhmKm: 0.641, inductanceTrefoilMhKm: 0.431, outerDiameterMm: 26.5, kaynak: '12/20 kV NA2XSY teknik tablosu'),
  '70': MerkeziOgEmpedansVerisi(r20OhmKm: 0.443, inductanceTrefoilMhKm: 0.405, outerDiameterMm: 28.5, kaynak: '12/20 kV NA2XSY teknik tablosu'),
  '95': MerkeziOgEmpedansVerisi(r20OhmKm: 0.320, inductanceTrefoilMhKm: 0.387, outerDiameterMm: 30.1, kaynak: '12/20 kV NA2XSY teknik tablosu'),
  '120': MerkeziOgEmpedansVerisi(r20OhmKm: 0.253, inductanceTrefoilMhKm: 0.371, outerDiameterMm: 31.6, kaynak: '12/20 kV NA2XSY teknik tablosu'),
  '150': MerkeziOgEmpedansVerisi(r20OhmKm: 0.206, inductanceTrefoilMhKm: 0.361, outerDiameterMm: 33.1, kaynak: '12/20 kV NA2XSY teknik tablosu'),
  '185': MerkeziOgEmpedansVerisi(r20OhmKm: 0.164, inductanceTrefoilMhKm: 0.350, outerDiameterMm: 35.0, kaynak: '12/20 kV NA2XSY teknik tablosu'),
  '240': MerkeziOgEmpedansVerisi(r20OhmKm: 0.125, inductanceTrefoilMhKm: 0.335, outerDiameterMm: 37.3, kaynak: '12/20 kV NA2XSY teknik tablosu'),
  '300': MerkeziOgEmpedansVerisi(r20OhmKm: 0.100, inductanceTrefoilMhKm: 0.325, outerDiameterMm: 39.6, kaynak: '12/20 kV NA2XSY teknik tablosu'),
  '400': MerkeziOgEmpedansVerisi(r20OhmKm: 0.0778, inductanceTrefoilMhKm: 0.316, outerDiameterMm: 43.2, kaynak: '12/20 kV NA2XSY teknik tablosu'),
  '500': MerkeziOgEmpedansVerisi(r20OhmKm: 0.0605, inductanceTrefoilMhKm: 0.305, outerDiameterMm: 46.4, kaynak: '12/20 kV NA2XSY teknik tablosu'),
  '630': MerkeziOgEmpedansVerisi(r20OhmKm: 0.0469, inductanceTrefoilMhKm: 0.297, outerDiameterMm: 52.8, kaynak: '12/20 kV NA2XSY teknik tablosu'),
};

const Map<String, MerkeziOgEmpedansVerisi> _og2035N2xsyEmpedans = <String, MerkeziOgEmpedansVerisi>{
  '50': MerkeziOgEmpedansVerisi(r20OhmKm: 0.387, inductanceTrefoilMhKm: 0.47, outerDiameterMm: 34.0, kaynak: 'Nexans N2XSY 20,3/35 kV'),
  '70': MerkeziOgEmpedansVerisi(r20OhmKm: 0.268, inductanceTrefoilMhKm: 0.45, outerDiameterMm: 36.0, kaynak: 'Nexans N2XSY 20,3/35 kV'),
  '95': MerkeziOgEmpedansVerisi(r20OhmKm: 0.193, inductanceTrefoilMhKm: 0.43, outerDiameterMm: 38.0, kaynak: 'Nexans N2XSY 20,3/35 kV'),
  '120': MerkeziOgEmpedansVerisi(r20OhmKm: 0.153, inductanceTrefoilMhKm: 0.41, outerDiameterMm: 40.0, kaynak: 'Nexans N2XSY 20,3/35 kV'),
  '150': MerkeziOgEmpedansVerisi(r20OhmKm: 0.124, inductanceTrefoilMhKm: 0.40, outerDiameterMm: 41.0, kaynak: 'Nexans N2XSY 20,3/35 kV'),
  '185': MerkeziOgEmpedansVerisi(r20OhmKm: 0.099, inductanceTrefoilMhKm: 0.39, outerDiameterMm: 43.0, kaynak: 'Nexans N2XSY 20,3/35 kV'),
};

const Map<String, MerkeziOgEmpedansVerisi> _og2035Na2xsyEmpedans = <String, MerkeziOgEmpedansVerisi>{
  '50': MerkeziOgEmpedansVerisi(r20OhmKm: 0.641, inductanceTrefoilMhKm: 0.48, outerDiameterMm: 34.0, kaynak: 'Nexans NA2XSY 20,3/35 kV'),
  '95': MerkeziOgEmpedansVerisi(r20OhmKm: 0.320, inductanceTrefoilMhKm: 0.42, outerDiameterMm: 37.2, kaynak: 'Nexans NA2XSY 20,3/35 kV'),
  '120': MerkeziOgEmpedansVerisi(r20OhmKm: 0.253, inductanceTrefoilMhKm: 0.41, outerDiameterMm: 39.0, kaynak: 'Nexans NA2XSY 20,3/35 kV'),
  '150': MerkeziOgEmpedansVerisi(r20OhmKm: 0.206, inductanceTrefoilMhKm: 0.40, outerDiameterMm: 40.0, kaynak: 'Nexans NA2XSY 20,3/35 kV'),
  '185': MerkeziOgEmpedansVerisi(r20OhmKm: 0.164, inductanceTrefoilMhKm: 0.38, outerDiameterMm: 43.0, kaynak: 'Nexans NA2XSY 20,3/35 kV'),
};

MerkeziOgEmpedansVerisi? merkeziOgEmpedansVerisi({
  required double kesit,
  required bool al,
  required double systemVoltageV,
}) {
  final key = _kesitAnahtari(kesit);
  if (systemVoltageV <= 20000.0 + 1e-6) {
    return (al ? _og1220Na2xsy : _og1220N2xsy)[key];
  }
  if (systemVoltageV <= 34500.0 + 1e-6) {
    return (al ? _og2035Na2xsyEmpedans : _og2035N2xsyEmpedans)[key];
  }
  return null;
}

double? merkeziOgDisCapMm({
  required double kesit,
  required bool al,
  required double systemVoltageV,
}) => merkeziOgEmpedansVerisi(
      kesit: kesit,
      al: al,
      systemVoltageV: systemVoltageV,
    )?.outerDiameterMm;

double? og2035KapasiteSecimeGore({
  required double kesit,
  required bool al,
  required bool toprakta,
}) {
  final key = _ogKhaKey(kesit);
  final table = al
      ? (toprakta ? og2035Na2xsyToprakA : og2035Na2xsyHavaA)
      : (toprakta ? og2035N2xsyToprakA : og2035N2xsyHavaA);
  return table[key];
}


// ============================================================
// 8A. AG MERKEZİ EMPEDANS + GEOMETRİ VERİSİ
// ============================================================
// KHA, R20, 50 Hz X ve mümkün olan yerlerde dış çap verisinin aynı
// kablo veri katmanında tutulması için ortak model.
//
// NAYY verileri IEC 60502-1 referanslı KMI teknik tablolarındaki 0,6/1 kV
// yapı, dış çap, DC direnç ve endüktans değerleriyle eşleştirilmiştir.
// Aynı yapıların KHA değerleri de yukarıdaki merkezî NAYY tablolarında
// tutulur. Böylece AG NAYY için KHA ve empedans aynı veri ailesinden okunur.
//
// NYY tarafında mevcut merkezî KHA + R/X + dış çap verileri korunur;
// burada yalnızca ortak sorgulama modeli oluşturulur.
// ============================================================

class MerkeziAgEmpedansVerisi {
  final double r20OhmKm;
  final double inductanceMhKm;
  final double? outerDiameterMm;
  final String kaynak;

  const MerkeziAgEmpedansVerisi({
    required this.r20OhmKm,
    required this.inductanceMhKm,
    required this.outerDiameterMm,
    required this.kaynak,
  });

  double get x50HzOhmKm =>
      2 * pi * 50.0 * (inductanceMhKm / 1000.0);
}

const Map<String, double> _nayyTekDamarDisCapMm = <String, double>{
  '10': 9.1, '16': 10.3, '25': 11.9, '35': 13.1, '50': 15.0,
  '70': 17.1, '95': 19.2, '120': 21.0, '150': 23.5, '185': 26.0,
  '240': 29.0,
};

const Map<String, double> _nayyIkiDamarDisCapMm = <String, double>{
  '10': 18.4, '16': 21.0, '25': 23.5, '35': 26.0, '50': 29.5,
  '70': 33.0, '95': 38.0, '120': 41.0, '150': 44.0, '185': 50.5,
  '240': 55.5,
};

const Map<String, double> _nayyUcDamarDisCapMm = <String, double>{
  '10': 19.4, '16': 22.5, '25': 24.5, '35': 27.5, '50': 30.0,
  '70': 34.0, '95': 38.5, '120': 41.5, '150': 46.0, '185': 50.5,
  '240': 57.0,
};

const Map<String, double> _nayyDortDamarDisCapMm = <String, double>{
  '10': 21.5, '16': 24.5, '25': 27.0, '35': 30.0, '50': 35.5,
  '70': 39.0, '95': 44.5, '120': 48.5, '150': 54.5, '185': 59.0,
  '240': 66.0,
};

const Map<String, double> _nayyTekDamarInduktansMhKm = <String, double>{
  '10': 0.350, '16': 0.323, '25': 0.313, '35': 0.298, '50': 0.290,
  '70': 0.279, '95': 0.274, '120': 0.270, '150': 0.265, '185': 0.264,
  '240': 0.260,
};

const Map<String, double> _nayyIkiDamarInduktansMhKm = <String, double>{
  '10': 0.269, '16': 0.253, '25': 0.257, '35': 0.247, '50': 0.247,
  '70': 0.238, '95': 0.238, '120': 0.233, '150': 0.235, '185': 0.233,
  '240': 0.232,
};

const Map<String, double> _nayyUcDamarInduktansMhKm = <String, double>{
  '10': 0.269, '16': 0.253, '25': 0.257, '35': 0.247, '50': 0.247,
  '70': 0.238, '95': 0.238, '120': 0.233, '150': 0.235, '185': 0.233,
  '240': 0.232,
};

const Map<String, double> _nayyDortDamarInduktansMhKm = <String, double>{
  '10': 0.269, '16': 0.253, '25': 0.257, '35': 0.247, '50': 0.247,
  '70': 0.238, '95': 0.238, '120': 0.233, '150': 0.235, '185': 0.233,
  '240': 0.232,
};

const Map<String, double> _nyyRMap = <String, double>{
  '1.5': 14.5, '2.5': 8.87, '4': 5.52, '6': 3.69, '10': 2.19,
  '16': 1.38, '25': 0.870, '35': 0.627, '50': 0.463, '70': 0.321,
  '95': 0.232, '120': 0.184, '150': 0.150, '185': 0.121, '240': 0.0926,
};

const Map<String, double> _nayyR20OhmKm = <String, double>{
  '10': 3.08, '16': 1.91, '25': 1.20, '35': 0.868, '50': 0.641,
  '70': 0.443, '95': 0.320, '120': 0.253, '150': 0.206, '185': 0.164,
  '240': 0.125,
};

String _agYapiTuru(String secim) {
  final temel = secimTemelYapi(secim).toLowerCase();
  if (temel.contains('+')) return '3n';
  final m = RegExp(r'^(1|2|3|4)x').firstMatch(temel);
  return m?.group(1) ?? '';
}

double? _agKesitDouble(String secim) {
  final temel = secimTemelYapi(secim);
  final m = RegExp(r'^(?:1|2|3|4)x(\d+(?:[.,]\d+)?)').firstMatch(temel);
  if (m == null) return null;
  return double.tryParse((m.group(1) ?? '').replaceAll(',', '.'));
}

MerkeziAgEmpedansVerisi? merkeziAgEmpedansVerisi({
  required String secim,
  required bool al,
}) {
  final kesit = _agKesitDouble(secim);
  final yapi = _agYapiTuru(secim);
  if (kesit == null || kesit <= 0) return null;
  final key = kesit == kesit.roundToDouble()
      ? kesit.toInt().toString()
      : kesit.toString();

  if (!al) {
    final r = _nyyRMap[key];
    if (r == null) return null;
    final idx = nyyKesitleri.indexWhere((s) => (s - kesit).abs() < 0.001);
    if (idx < 0) return null;
    final x = nyyX50Hz[idx];
    return MerkeziAgEmpedansVerisi(
      r20OhmKm: r,
      inductanceMhKm: x / (2 * pi * 50.0) * 1000.0,
      outerDiameterMm: merkeziKabloDisCapMm['${secimTemelYapi(secim)} mm²'],
      kaynak: 'Merkezî NYY Cu R/X ve geometri verisi',
    );
  }

  final r = _nayyR20OhmKm[key];
  if (r == null) return null;

  Map<String, double>? l;
  Map<String, double>? d;
  switch (yapi) {
    case '1':
      l = _nayyTekDamarInduktansMhKm;
      d = _nayyTekDamarDisCapMm;
      break;
    case '2':
      l = _nayyIkiDamarInduktansMhKm;
      d = _nayyIkiDamarDisCapMm;
      break;
    case '3':
      l = _nayyUcDamarInduktansMhKm;
      d = _nayyUcDamarDisCapMm;
      break;
    case '4':
      l = _nayyDortDamarInduktansMhKm;
      d = _nayyDortDamarDisCapMm;
      break;
    case '3n':
      // 3 faz + nötr seçeneklerinde doğrulanmış çok damarlı 4-core
      // teknik veri referansı kullanılır; dış çap doğrudan türetilmez.
      l = _nayyDortDamarInduktansMhKm;
      d = null;
      break;
    default:
      return null;
  }

  final li = l[key];
  if (li == null) return null;

  return MerkeziAgEmpedansVerisi(
    r20OhmKm: r,
    inductanceMhKm: li,
    outerDiameterMm: d?[key],
    kaynak: yapi == '3n'
        ? 'NAYY Al 4-core referans empedans verisi; 3x+N dış çapı ayrıca doğrulanmalıdır'
        : 'NAYY Al merkezi teknik veri',
  );
}

double? merkeziAgDisCapMm(String secim, {required bool al}) {
  if (al) return merkeziAgEmpedansVerisi(secim: secim, al: true)?.outerDiameterMm;
  final temel = secimTemelYapi(secim).replaceAll(' mm²', '');
  return merkeziAgEmpedansVerisi(secim: secim, al: false)?.outerDiameterMm ??
      merkeziKabloDisCapGetir('$temel mm²');
}

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

double? kabloTemelHava(String secim) =>
    nyyKapasiteSecimeGore(secim, toprakta: false);

// ============================================================
// 10. NYY TEMEL TOPRAK AKIMI
// ============================================================

double? kabloTemelToprak(String secim) =>
    nyyKapasiteSecimeGore(secim, toprakta: true);

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
// Hat analizi sonuç ekranında "Ön Seçim Kesiti" için bu mantık
// kullanılmalıdır.
// ============================================================

String? nyyTeknikUygunKesitBul({
  required double akim,
  required bool threePhase,
  required bool toprakHatti,
  double duzeltme = 1.0,
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

    for (final double kesit in nyyKesitleri) {
      final double? kapasite = toprakHatti
          ? kabloTemelToprak('2x${_formatKesit(kesit)} mm²')
          : kabloTemelHava('2x${_formatKesit(kesit)} mm²');

      if (kapasite == null) {
        continue;
      }

      final double duzeltilmis = kapasite * duzeltme;

      if (duzeltilmis >= akim) {
        return '${_formatKesit(kesit)}x2 mm² NYY (Cu)';
      }
    }

    return null;
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

    final double? kapasite = nyyKapasiteSecimeGore(
      '4x${_formatKesit(kesit)} mm²',
      toprakta: toprakHatti,
    );

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
    final double? kapasite = nyyKapasiteSecimeGore(
      secim,
      toprakta: toprakHatti,
    );

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
      final double? tek = nyyKapasiteSecimeGore(secim, toprakta: toprakHatti);

      if (tek == null) {
        continue;
      }

      final double toplam = tek * paralel * duzeltme;

      if (toplam >= akim) {
        return '${paralel}x(${secim.replaceAll(' mm²', '')}) mm²';
      }
    }
  }

  return null;
}

// ============================================================
// 12. PARALEL KABLO BULMA
// ============================================================

String standartParalelKabloBul(
  double akim, {
  bool toprakta = false,
  double duzeltme = 1.0,
}) {
  if (!akim.isFinite || akim <= 0) {
    return 'Hesaplama yapılamadı';
  }

  final double? temelKapasite = nyyKapasiteSecimeGore(
    '3x240+120 mm²',
    toprakta: toprakta,
  );
  final double tek = (temelKapasite ?? 0) * duzeltme;
  if (!tek.isFinite || tek <= 0) return 'Merkezî KHA verisi bulunamadı';

  final int adet = max(1, (akim / tek).ceil());
  if (adet <= 12) {
    if (adet == 1) return '3x240+120 mm² NYY (Cu)';
    return '$adet paralel × 3x240+120 mm² NYY (Cu)';
  }
  return 'Paralel kablo grubu > 12 sistem — proje bazlı kablo/şebeke tasarımı gerekir';
}

// ============================================================
// 13. GERİLİM DÜŞÜMÜ
// ============================================================

double? merkeziAgBasitR20OhmKm(double kesit, {required bool al}) {
  if (!kesit.isFinite || kesit <= 0) return null;
  final key = _kesitAnahtari(kesit);
  return al ? _nayyR20OhmKm[key] : _nyyRMap[key];
}

double? merkeziAgBasitX50HzOhmKm(double kesit, {required bool al}) {
  if (!kesit.isFinite || kesit <= 0) return null;
  final key = _kesitAnahtari(kesit);
  if (!al) {
    final idx = nyyKesitleri.indexWhere((s) => (s - kesit).abs() < 0.001);
    if (idx < 0) return null;
    return nyyX50Hz[idx];
  }
  final l = _nayyUcDamarInduktansMhKm[key];
  if (l == null) return null;
  return 2 * pi * 50.0 * (l / 1000.0);
}

// ============================================================
// 14. AÇIK İLETKEN / ALPEK / OG — MERKEZİ TEKNİK SEÇİM
// ============================================================

String? acikIletkenTeknikUygunKesitBul({
  required double akim,
  required bool threePhase,
  double duzeltme = 1.0,
}) {
  if (!akim.isFinite || akim <= 0) return null;

  final List<MerkeziAcikIletken> liste = <MerkeziAcikIletken>[
    ...merkeziAgAcikIletkenler,
  ];

  for (final MerkeziAcikIletken iletken in liste) {
    if (iletken.kapasiteA * duzeltme >= akim) {
      final String yapi = threePhase ? '3+1' : '1+1';
      return '$yapi x ${_formatKesit(iletken.kesitMm2)} mm² Açık İletken';
    }
  }

  return null;
}

String? alpekTeknikUygunKesitBul({
  required double akim,
  required bool threePhase,
  double duzeltme = 1.0,
}) {
  if (!akim.isFinite || akim <= 0) return null;

  final List<MerkeziAlpekSecenek> liste =
      threePhase ? merkeziAlpekTrifaze : merkeziAlpekMonofaze;

  for (final MerkeziAlpekSecenek secenek in liste) {
    if (secenek.kapasiteA * duzeltme >= akim) {
      return secenek.etiket.replaceAll(' mm²', ' mm² ALPEK');
    }
  }

  return null;
}

String? ogTeknikUygunKesitBul({
  required double akim,
  double duzeltme = 1.0,
  String iletkenTipi = 'OG',
  bool toprakta = false,
}) {
  if (!akim.isFinite || akim <= 0) return null;

  final bool al = iletkenTipi.toUpperCase().contains('AL') ||
      iletkenTipi.toUpperCase().contains('NA2XSY');

  for (final double kesit in ogKhaKesitleri) {
    final double? kapasite = ogKapasiteSecimeGore(
      kesit: kesit,
      al: al,
      toprakta: toprakta,
    );
    if (kapasite != null && kapasite * duzeltme >= akim) {
      return '1 x ${_formatKesit(kesit)} mm² ${al ? 'NA2XSY' : 'N2XSY'}';
    }
  }

  return null;
}

String? nayyTeknikUygunKesitBul({
  required double akim,
  required bool threePhase,
  required bool toprakHatti,
  double duzeltme = 1.0,
}) {
  if (!akim.isFinite || akim <= 0) return null;

  final List<String> adaylar = threePhase
      ? <String>[
          '4x1,5 mm²', '4x2,5 mm²', '4x4 mm²', '4x6 mm²', '4x10 mm²',
          '3x16+10 mm²', '3x25+16 mm²', '3x35+16 mm²', '3x50+25 mm²',
          '3x70+35 mm²', '3x95+50 mm²', '3x120+70 mm²', '3x150+70 mm²',
          '3x185+95 mm²', '3x240+120 mm²',
        ]
      : <String>[
          '1x10 mm²', '1x16 mm²', '1x25 mm²', '1x35 mm²', '1x50 mm²',
          '1x70 mm²', '1x95 mm²', '1x120 mm²', '1x150 mm²', '1x185 mm²',
          '1x240 mm²', '2x10 mm²', '2x16 mm²', '2x25 mm²', '2x35 mm²',
          '2x50 mm²', '2x70 mm²', '2x95 mm²', '2x120 mm²', '2x150 mm²',
          '2x185 mm²', '2x240 mm²', '3x10 mm²', '3x16 mm²', '3x25 mm²',
          '3x35 mm²', '3x50 mm²', '3x70 mm²', '3x95 mm²', '3x120 mm²',
          '3x150 mm²', '3x185 mm²', '3x240 mm²',
        ];

  for (final String secim in adaylar) {
    final cap = nayyKapasiteSecimeGore(secim, toprakta: toprakHatti);
    if (cap != null && cap * duzeltme >= akim) return secim;
  }
  return null;
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
  double duzeltme = 1.0,
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
  // AG - NAYY
  // ----------------------------------------------------------

  if (tip.contains('NAYY')) {
    return nayyTeknikUygunKesitBul(
      akim: akim,
      threePhase: threePhase,
      toprakHatti: toprakHatti,
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


// ============================================================
// FAZ 4 — YERALTI / ALPEK / AÇIK İLETKEN MERKEZİ VERİ KATMANI
// ============================================================
//
// Bu bölüm, ilgili araçların kendi dosyalarında ayrı ayrı veri
// tabloları tutmasını engellemek için oluşturulmuştur.
// UI katmanı yalnızca bu merkezi modelleri okur.
//
// Kullanıcı ekranına AWG / KCMIL gibi alternatif birim gösterimleri
// taşınmaz. Teknik veri modeli kesit, damar yapısı, faz/nötr yapısı
// ve kapasiteyi açık alanlar halinde tutar.
//
// Not: Aşağıdaki değerler mevcut ESA referans veri setinin merkezi
// veri yapısına taşınmış halidir. Nihai saha/proje seçiminde üretici
// kataloğu, TEDAŞ/dağıtım şirketi şartnamesi, döşeme ve düzeltme
// koşulları ayrıca doğrulanmalıdır.
// ============================================================

class MerkeziYeraltiKablo {
  final String kabloTipi;
  final String malzeme;
  final double kesitMm2;
  final String yapi;
  final double kapasiteA;

  const MerkeziYeraltiKablo({
    required this.kabloTipi,
    required this.malzeme,
    required this.kesitMm2,
    required this.yapi,
    required this.kapasiteA,
  });
}

class MerkeziAlpekSecenek {
  final double fazKesitiMm2;
  final double notrKesitiMm2;
  final int fazDamari;
  final int notrDamari;
  final double kapasiteA;

  const MerkeziAlpekSecenek({
    required this.fazKesitiMm2,
    required this.notrKesitiMm2,
    required this.fazDamari,
    required this.notrDamari,
    required this.kapasiteA,
  });

  String get etiket {
    final String faz = _formatKesit(fazKesitiMm2);
    final String notr = _formatKesit(notrKesitiMm2);
    return '${fazDamari}x$faz+$notr mm²';
  }
}

class MerkeziAcikIletkenElektrikVerisi {
  final String ad;
  final double rOhmKm;
  final double? xOhmKm;
  final String kaynak;

  const MerkeziAcikIletkenElektrikVerisi({
    required this.ad,
    required this.rOhmKm,
    required this.xOhmKm,
    required this.kaynak,
  });
}

const List<MerkeziAcikIletkenElektrikVerisi> merkeziAgAcikIletkenElektrik = <MerkeziAcikIletkenElektrikVerisi>[
  MerkeziAcikIletkenElektrikVerisi(ad: 'Rose', rOhmKm: 1.354, xOhmKm: null, kaynak: 'Mevcut ESA AG açık iletken R referansı'),
  MerkeziAcikIletkenElektrikVerisi(ad: 'Lily', rOhmKm: 1.074, xOhmKm: null, kaynak: 'Mevcut ESA AG açık iletken R referansı'),
  MerkeziAcikIletkenElektrikVerisi(ad: 'Pansy', rOhmKm: 0.6752, xOhmKm: null, kaynak: 'Mevcut ESA AG açık iletken R referansı'),
  MerkeziAcikIletkenElektrikVerisi(ad: 'Poppy', rOhmKm: 0.5351, xOhmKm: null, kaynak: 'Mevcut ESA AG açık iletken R referansı'),
  MerkeziAcikIletkenElektrikVerisi(ad: 'Aster', rOhmKm: 0.4245, xOhmKm: null, kaynak: 'Mevcut ESA AG açık iletken R referansı'),
  MerkeziAcikIletkenElektrikVerisi(ad: 'Phlox', rOhmKm: 0.3366, xOhmKm: null, kaynak: 'Mevcut ESA AG açık iletken R referansı'),
  MerkeziAcikIletkenElektrikVerisi(ad: 'Oxlip', rOhmKm: 0.2671, xOhmKm: null, kaynak: 'Mevcut ESA AG açık iletken R referansı'),
];

const List<MerkeziAcikIletkenElektrikVerisi> merkeziOgAcikIletkenElektrik = <MerkeziAcikIletkenElektrikVerisi>[
  MerkeziAcikIletkenElektrikVerisi(ad: 'Swallow', rOhmKm: 1.0742, xOhmKm: null, kaynak: 'Mevcut ESA OG açık iletken R referansı'),
  MerkeziAcikIletkenElektrikVerisi(ad: 'Raven', rOhmKm: 0.5362, xOhmKm: null, kaynak: 'Mevcut ESA OG açık iletken R referansı'),
  MerkeziAcikIletkenElektrikVerisi(ad: 'Pigeon', rOhmKm: 0.3366, xOhmKm: null, kaynak: 'Mevcut ESA OG açık iletken R referansı'),
  MerkeziAcikIletkenElektrikVerisi(ad: 'Partridge', rOhmKm: 0.214, xOhmKm: null, kaynak: 'Mevcut ESA OG açık iletken R referansı'),
  MerkeziAcikIletkenElektrikVerisi(ad: 'Hawk', rOhmKm: 0.1194, xOhmKm: null, kaynak: 'Mevcut ESA OG açık iletken R referansı'),
];

double? merkeziAcikIletkenROhmKm(String secim, {required bool og}) {
  final hedef = secim.trim().toLowerCase();
  final liste = og ? merkeziOgAcikIletkenElektrik : merkeziAgAcikIletkenElektrik;
  for (final v in liste) {
    if (v.ad.toLowerCase() == hedef) return v.rOhmKm;
  }
  return null;
}

class MerkeziAcikIletken {
  final String ad;
  final String tipAciklama;
  final double kesitMm2;
  final double kapasiteA;

  const MerkeziAcikIletken({
    required this.ad,
    required this.tipAciklama,
    required this.kesitMm2,
    required this.kapasiteA,
  });
}

const List<MerkeziAlpekSecenek> merkeziAlpekMonofaze = <MerkeziAlpekSecenek>[
  MerkeziAlpekSecenek(fazKesitiMm2: 16, notrKesitiMm2: 16, fazDamari: 1, notrDamari: 1, kapasiteA: 63),
  MerkeziAlpekSecenek(fazKesitiMm2: 25, notrKesitiMm2: 25, fazDamari: 1, notrDamari: 1, kapasiteA: 80),
  MerkeziAlpekSecenek(fazKesitiMm2: 35, notrKesitiMm2: 35, fazDamari: 1, notrDamari: 1, kapasiteA: 100),
  MerkeziAlpekSecenek(fazKesitiMm2: 50, notrKesitiMm2: 50, fazDamari: 1, notrDamari: 1, kapasiteA: 125),
  MerkeziAlpekSecenek(fazKesitiMm2: 70, notrKesitiMm2: 70, fazDamari: 1, notrDamari: 1, kapasiteA: 160),
  MerkeziAlpekSecenek(fazKesitiMm2: 95, notrKesitiMm2: 95, fazDamari: 1, notrDamari: 1, kapasiteA: 195),
  MerkeziAlpekSecenek(fazKesitiMm2: 120, notrKesitiMm2: 120, fazDamari: 1, notrDamari: 1, kapasiteA: 225),
  MerkeziAlpekSecenek(fazKesitiMm2: 150, notrKesitiMm2: 150, fazDamari: 1, notrDamari: 1, kapasiteA: 260),
  MerkeziAlpekSecenek(fazKesitiMm2: 185, notrKesitiMm2: 185, fazDamari: 1, notrDamari: 1, kapasiteA: 300),
  MerkeziAlpekSecenek(fazKesitiMm2: 240, notrKesitiMm2: 240, fazDamari: 1, notrDamari: 1, kapasiteA: 345),
];

const List<MerkeziAlpekSecenek> merkeziAlpekTrifaze = <MerkeziAlpekSecenek>[
  MerkeziAlpekSecenek(fazKesitiMm2: 16, notrKesitiMm2: 16, fazDamari: 3, notrDamari: 1, kapasiteA: 50),
  MerkeziAlpekSecenek(fazKesitiMm2: 25, notrKesitiMm2: 25, fazDamari: 3, notrDamari: 1, kapasiteA: 63),
  MerkeziAlpekSecenek(fazKesitiMm2: 35, notrKesitiMm2: 35, fazDamari: 3, notrDamari: 1, kapasiteA: 80),
  MerkeziAlpekSecenek(fazKesitiMm2: 50, notrKesitiMm2: 50, fazDamari: 3, notrDamari: 1, kapasiteA: 100),
  MerkeziAlpekSecenek(fazKesitiMm2: 70, notrKesitiMm2: 70, fazDamari: 3, notrDamari: 1, kapasiteA: 125),
  MerkeziAlpekSecenek(fazKesitiMm2: 95, notrKesitiMm2: 95, fazDamari: 3, notrDamari: 1, kapasiteA: 160),
  MerkeziAlpekSecenek(fazKesitiMm2: 120, notrKesitiMm2: 120, fazDamari: 3, notrDamari: 1, kapasiteA: 195),
  MerkeziAlpekSecenek(fazKesitiMm2: 150, notrKesitiMm2: 150, fazDamari: 3, notrDamari: 1, kapasiteA: 225),
  MerkeziAlpekSecenek(fazKesitiMm2: 185, notrKesitiMm2: 185, fazDamari: 3, notrDamari: 1, kapasiteA: 265),
  MerkeziAlpekSecenek(fazKesitiMm2: 240, notrKesitiMm2: 240, fazDamari: 3, notrDamari: 1, kapasiteA: 305),
];

const List<MerkeziAcikIletken> merkeziAgAcikIletkenler = <MerkeziAcikIletken>[
  MerkeziAcikIletken(ad: 'Rose', tipAciklama: 'Tam Alüminyum İletken', kesitMm2: 21.1, kapasiteA: 85),
  MerkeziAcikIletken(ad: 'Lily', tipAciklama: 'Tam Alüminyum İletken', kesitMm2: 26.6, kapasiteA: 110),
  MerkeziAcikIletken(ad: 'Pansy', tipAciklama: 'Tam Alüminyum İletken', kesitMm2: 42.4, kapasiteA: 135),
  MerkeziAcikIletken(ad: 'Poppy', tipAciklama: 'Tam Alüminyum İletken', kesitMm2: 53.5, kapasiteA: 170),
  MerkeziAcikIletken(ad: 'Aster', tipAciklama: 'Tam Alüminyum İletken', kesitMm2: 67.4, kapasiteA: 210),
  MerkeziAcikIletken(ad: 'Phlox', tipAciklama: 'Tam Alüminyum İletken', kesitMm2: 85, kapasiteA: 250),
  MerkeziAcikIletken(ad: 'Oxlip', tipAciklama: 'Tam Alüminyum İletken', kesitMm2: 107.2, kapasiteA: 290),
];

const List<MerkeziAcikIletken> merkeziOgAcikIletkenler = <MerkeziAcikIletken>[
  MerkeziAcikIletken(ad: 'Swallow', tipAciklama: 'Çelik Özlü Alüminyum İletken', kesitMm2: 31.1, kapasiteA: 135),
  MerkeziAcikIletken(ad: 'Pigeon', tipAciklama: 'Çelik Özlü Alüminyum İletken', kesitMm2: 99.3, kapasiteA: 250),
  MerkeziAcikIletken(ad: 'Partridge', tipAciklama: 'Çelik Özlü Alüminyum İletken', kesitMm2: 156.9, kapasiteA: 330),
  MerkeziAcikIletken(ad: 'Hawk', tipAciklama: 'Çelik Özlü Alüminyum İletken', kesitMm2: 281.1, kapasiteA: 490),
];

List<MerkeziYeraltiKablo> merkeziYeraltiAgSecim({required String faz, required String malzeme}) {
  final bool monofaze = faz.trim().toLowerCase() == 'monofaze';
  final bool al = malzeme.trim().toLowerCase().contains('alüminyum');
  final List<MerkeziYeraltiKablo> result = <MerkeziYeraltiKablo>[];

  for (final double kesit in nyyKesitleri) {
    final String yapilar = monofaze ? '2x' : '4x';
    final String secim = '$yapilar${_formatKesit(kesit)} mm²';
    final double? cap = al
        ? nayyKapasiteSecimeGore(secim, toprakta: true)
        : nyyKapasiteSecimeGore(secim, toprakta: true);
    if (cap == null) continue;
    result.add(MerkeziYeraltiKablo(
      kabloTipi: al ? 'NAYY' : 'NYY',
      malzeme: al ? 'Alüminyum' : 'Bakır',
      kesitMm2: kesit,
      yapi: yapilar,
      kapasiteA: cap,
    ));
  }

  return result;
}

List<MerkeziYeraltiKablo> merkeziYeraltiAgFazSecenekleri({required String malzeme}) {
  final List<MerkeziYeraltiKablo> result = <MerkeziYeraltiKablo>[];
  final bool al = malzeme.trim().toLowerCase().contains('alüminyum');

  for (final double kesit in nyyKesitleri) {
    for (final String yapi in <String>['1x', '2x', '3x', '4x']) {
      final String secim = '$yapi${_formatKesit(kesit)} mm²';
      final double? cap = al
          ? nayyKapasiteSecimeGore(secim, toprakta: true)
          : nyyKapasiteSecimeGore(secim, toprakta: true);
      if (cap == null) continue;
      result.add(MerkeziYeraltiKablo(
        kabloTipi: al ? 'NAYY' : 'NYY',
        malzeme: al ? 'Alüminyum' : 'Bakır',
        kesitMm2: kesit,
        yapi: yapi,
        kapasiteA: cap,
      ));
    }
  }

  return result;
}

String merkeziKabloGosterim({required String yapi, required double kesitMm2}) =>
    '$yapi${_formatKesit(kesitMm2)} mm²';
