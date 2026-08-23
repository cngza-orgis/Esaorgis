part of 'main.dart';

final ValueNotifier<bool> isDarkNotifier = ValueNotifier<bool>(false);

// İngilizce arayüz şimdilik kullanılmıyor; mevcut araç kodlarındaki çift dil
// metinlerinin tamamında Türkçe tarafı döndürülür.
String t(String tr, String en) => tr;

Color cBg() => isDarkNotifier.value ? const Color(0xFF101923) : const Color(0xFFF4F7FB);
Color cCard() => isDarkNotifier.value ? const Color(0xFF182431) : Colors.white;
Color cCardAlpha() => isDarkNotifier.value ? const Color(0x33182431) : const Color(0x1A0B5CC9);
Color cIcon() => isDarkNotifier.value ? const Color(0xFF2C9BEF) : const Color(0xFF0B5CC9);
Color cText() => isDarkNotifier.value ? const Color(0xFFE8F1FB) : const Color(0xFF12345B);
Color cBarBg() => isDarkNotifier.value ? const Color(0xFF061F40) : const Color(0xFF073B7A);
Color cBarFg() => Colors.white;
Color cInputBg() => isDarkNotifier.value ? const Color(0xFF20364D) : Colors.white;


// ================= ORTAK WIDGETLAR / YARDIMCI METOTLAR =================
Widget uiResultCard(
  String title,
  String value,
  String unit, {
  TechnicalResultDetails? technicalDetails,
}) {
  // uiResultCard ve ResultCard artık aynı ortak sonuç bileşenini kullanır.
  // Böylece özet/detay görünümü, teknik açıklama standardı ve tema davranışı
  // araçlar arasında farklılaşmaz.
  return ResultCard(
    title: title,
    value: value,
    subtitle: unit.isEmpty ? null : unit,
    technicalDetails: technicalDetails,
  );
}

InputDecoration customInputDec(String label) {
  final borderColor = isDarkNotifier.value ? const Color(0x665A6A7D) : const Color(0xFFCBD5E1);
  return InputDecoration(
    labelText: label,
    labelStyle: TextStyle(color: isDarkNotifier.value ? const Color(0xFFCBD5E1) : const Color(0xFF64748B), fontSize: 13),
    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: borderColor)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: cIcon())),
  );
}

int? standartTMSBul(double akim) {
  return esaSelectFirstStandardProtection(akim);
}

int standartKontaktorBul(double akim) {
  return esaSelectFirstStandardContactor(akim);
}

/// Ortak CT ön seçim motoru.
/// Kural: hesaplanan akıma eşit veya onu karşılayan ilk standart primer oran seçilir.
/// Örn. 7,33 A -> 10/5 A. Bu fonksiyon tüm CT kullanan araçlarda ortak kullanılmalıdır.
String standartAkimTrafosuBul(double akim) {
  if (!akim.isFinite || akim <= 0) return 'Hesaplanamadı';

  return esaSelectFirstStandardCt(akim);
}

String standartKakrBul(int sigorta, String tip) {
  if (sigorta > 125) return 'Toroid Röle + Açtırma Bobini';
  const values = [25, 32, 40, 63, 80, 100, 125];
  final k = values.firstWhere((val) => val >= sigorta, orElse: () => 125);
  return '${k}A - $tip';
}

String formatKabloKesiti(double kesit, bool is3F) {
  final kText = kesit == kesit.roundToDouble() ? kesit.toInt().toString() : kesit.toStringAsFixed(2).replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
  final k = kesit.toInt();
  if (!is3F) return '2x$kText';
  if (k <= 10) return '4x$kText';
  int n = 0;
  if (k == 16) n = 10;
  else if (k == 25 || k == 35) n = 16;
  else if (k == 50) n = 25;
  else if (k == 70) n = 35;
  else if (k == 95) n = 50;
  else if (k == 120 || k == 150) n = 70;
  else if (k == 185) n = 95;
  else if (k == 240) n = 120;
  else if (k == 300) n = 150;
  return n > 0 ? '3x$k+$n' : '3x$k';
}

String standartKabloBulNYY(double akim, bool is3F) {
  if (!akim.isFinite || akim <= 0) return '-';

  final sonuc = nyyTeknikUygunKesitBul(
    akim: akim,
    threePhase: is3F,
    toprakHatti: false,
    duzeltme: esaTechnicalSelectionCorrectionFactor,
  );

  if (sonuc == null || sonuc.isEmpty) return '-';
  return sonuc.contains('NYY') ? sonuc : '$sonuc NYY (Cu)';
}

String standartBaraBul(num tms) {
  if (tms <= 100) return 'Kablo İle Dağıtım';
  if (tms <= 160) return '15x3 mm Cu';
  if (tms <= 250) return '20x3 mm Cu';
  if (tms <= 315) return '30x5 mm Cu';
  if (tms <= 400) return '40x5 mm Cu';
  if (tms <= 630) return '50x5 mm Cu';
  if (tms <= 800) return '60x5 mm Cu';
  if (tms <= 1000) return '80x5 mm Cu';
  if (tms <= 1250) return '100x5 mm Cu';
  if (tms <= 1600) return '2x(80x5) mm Cu';
  if (tms <= 2000) return '2x(100x5) mm Cu';
  if (tms <= 2500) return '2x(100x10) mm Cu';
  if (tms <= 3200) return '3x(100x10) mm Cu';
  if (tms <= 4000) return '4x(100x10) mm Cu';
  if (tms <= 5000) return '5x(100x10) mm Cu';
  return 'Bara sistemi proje/kısa devre dayanımına göre özel boyutlandırılmalıdır';
}

class ThemeLangWrapper extends StatelessWidget {
  final Widget Function(BuildContext) builder;
  const ThemeLangWrapper({super.key, required this.builder});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkNotifier,
      builder: (ctx, isDark, _) {
        return builder(ctx);
      },
    );
  }
}
