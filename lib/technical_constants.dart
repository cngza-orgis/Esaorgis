part of 'main.dart';

// ================================================================
// ESA TEKNİK SABİTLERİ
// Tekrarlanan nominal gerilimler ve ortak varsayılanlar tek kaynaktan yönetilir.
// ================================================================

const double esaAgThreePhaseVoltage = 400.0;
const double esaAgSinglePhaseVoltage = 230.0;
const double esaDefaultOgVoltage = 20000.0;
const double esaDefaultPowerFactor = 0.80;
const double esaDefaultMotorEfficiency = 0.85;
// Teknik ön seçimde gizli düzeltme katsayısı kullanılmaz.
// Döşeme/çevre/gruplama düzeltmeleri doğrulanmış saha koşullarından ayrıca uygulanmalıdır.
const double esaTechnicalSelectionCorrectionFactor = 1.0;

// Mevcut merkezi N2XSY/NA2XSY KHA tablolarının gerilim sınıfı 12/20 kV'dir.
// 20,3/35(42) kV sınıfı ayrı bir teknik veri seti gerektirir; mevcut 12/20 kV
// kapasite tablosu 20 kV üzerindeki OG sistemlerinde kullanılmaz.
const String esaCurrentOgCableVoltageClass = '12/20 kV';
const String esaHighOgCableVoltageClass = '20,3/35 kV';
const double esaCurrentOgCableMaxNominalSystemVoltageV = 20000.0;
const double esaHighOgCableMaxNominalSystemVoltageV = 34500.0;

bool esaOgCableClassCompatibleWithSystemVoltage({
  required double systemVoltageV,
  required String cableVoltageClass,
}) {
  if (!systemVoltageV.isFinite || systemVoltageV <= 0) return false;

  final String sinif = cableVoltageClass.trim().toUpperCase();

  if (sinif == esaCurrentOgCableVoltageClass.toUpperCase()) {
    return systemVoltageV <= esaCurrentOgCableMaxNominalSystemVoltageV + 1e-6;
  }

  if (sinif == esaHighOgCableVoltageClass.toUpperCase()) {
    return systemVoltageV > esaCurrentOgCableMaxNominalSystemVoltageV &&
        systemVoltageV <= esaHighOgCableMaxNominalSystemVoltageV + 1e-6;
  }

  return false;
}

String esaOgCableVoltageClassForSystem(double systemVoltageV) {
  if (systemVoltageV > 0 && systemVoltageV <= esaCurrentOgCableMaxNominalSystemVoltageV + 1e-6) {
    return esaCurrentOgCableVoltageClass;
  }
  if (systemVoltageV > esaCurrentOgCableMaxNominalSystemVoltageV &&
      systemVoltageV <= esaHighOgCableMaxNominalSystemVoltageV + 1e-6) {
    return esaHighOgCableVoltageClass;
  }
  return 'Desteklenmeyen OG gerilim sınıfı';
}

String esaOgCableCompatibilityNote({required double systemVoltageV}) {
  final String sinif = esaOgCableVoltageClassForSystem(systemVoltageV);
  if (sinif == esaCurrentOgCableVoltageClass) {
    return '${esaCurrentOgCableVoltageClass} veri seti bu nominal OG sistem gerilimi için kullanılabilir.';
  }
  if (sinif == esaHighOgCableVoltageClass) {
    return '${esaHighOgCableVoltageClass} veri seti kullanılmalı; 12/20 kV veri seti bu sistem için kullanılmamalıdır.';
  }
  return '${systemVoltageV / 1000.0} kV nominal sistem gerilimi için doğrulanmış OG kablo gerilim sınıfı veri seti bulunmuyor.';
}


const List<String> esaOgVoltageOptions = <String>[
  '6300',
  '10500',
  '15800',
  '20000',
  '31500',
  '33000',
  '34500',
];

const List<String> esaAcVoltageOptions = <String>[
  '230',
  '400',
  '415',
];

// Ortak güç/akım dönüşümleri. Aynı fiziksel büyüklük için araçların
// farklı formüller kullanmasını önlemek amacıyla tek kaynakta tutulur.
double esaKvaFromKw(double kw, double pf) => pf > 0 ? kw / pf : double.nan;

double esaThreePhaseCurrentFromKw(double kw, double voltage, double pf) =>
    (pf > 0 && voltage > 0) ? kw * 1000 / (3.1415926535897931 * 0.5773502691896258 * voltage * pf) : double.nan;

double esaThreePhaseCurrentFromKva(double kva, double voltage) =>
    voltage > 0 ? kva * 1000 / (3.1415926535897931 * 0.5773502691896258 * voltage) : double.nan;

double esaSinglePhaseCurrentFromKw(double kw, double voltage, double pf) =>
    (pf > 0 && voltage > 0) ? kw * 1000 / (voltage * pf) : double.nan;

// ============================================================
// KORUMA / ÖLÇÜ STANDARTLARI — ORTAK KAYNAK
// Aynı standart değerlerin farklı araçlarda ayrı ayrı tanımlanmasını önler.
// ============================================================

const List<int> esaStandardProtectionRatings = <int>[
  16, 20, 25, 32, 40, 50, 63, 80, 100, 125, 160, 200, 250, 315, 400,
  500, 630, 800, 1000, 1250, 1600, 2000, 2500, 3200, 4000,
];

const List<int> esaStandardCtPrimaryRatings = <int>[
  5, 10, 15, 20, 25, 30, 40, 50, 60, 75, 100, 150, 200, 250, 300, 400,
  500, 600, 750, 800, 1000, 1250, 1600, 2000, 2500, 3000, 4000, 5000,
];

const List<int> esaStandardContactorRatings = <int>[
  9, 12, 18, 25, 32, 40, 50, 65, 80, 95, 115, 150, 185, 225, 265, 330,
  400, 500,
];

int? esaSelectFirstStandardProtection(double akim) {
  if (!akim.isFinite || akim <= 0) return null;
  for (final val in esaStandardProtectionRatings) {
    if (val >= akim) return val;
  }
  return null;
}

String esaSelectFirstStandardCt(double akim, {int secondaryA = 5}) {
  if (!akim.isFinite || akim <= 0) return 'Hesaplanamadı';
  final int primer = esaStandardCtPrimaryRatings.firstWhere(
    (val) => val >= akim,
    orElse: () => 0,
  );
  return primer == 0 ? 'Özel Proje' : '$primer/$secondaryA A';
}

int esaSelectFirstStandardContactor(double akim) =>
    esaStandardContactorRatings.firstWhere(
      (val) => val >= akim,
      orElse: () => esaStandardContactorRatings.last,
    );

String esaIbInIzStatus({required double ib, required double inRating, double? iz}) {
  if (!ib.isFinite || !inRating.isFinite || ib <= 0 || inRating <= 0) {
    return 'Koruma değerlendirmesi için geçerli akım değerleri gerekir.';
  }
  if (iz == null || !iz.isFinite || iz <= 0) {
    return 'Ib ve In hesaplandı; Iz, seçilen kablonun gerçek döşeme koşullarıyla ayrıca doğrulanmalıdır.';
  }
  if (ib > inRating) return 'Uygun değil: In, hesaplanan Ib değerinin altında.';
  if (inRating > iz) return 'Uygun değil: In, kablonun Iz kapasitesini aşıyor.';
  return 'Ön kontrol uygun: Ib ≤ In ≤ Iz. Kısa devre/selektivite ve saha koşulları ayrıca doğrulanmalıdır.';
}
