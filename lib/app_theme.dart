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
Widget uiResultCard(String title, String value, String unit) {
  return _UiResultCard(title: title, value: value, unit: unit);
}

class _UiResultCard extends StatefulWidget {
  final String title;
  final String value;
  final String unit;
  const _UiResultCard({required this.title, required this.value, required this.unit});
  @override State<_UiResultCard> createState() => _UiResultCardState();
}

class _UiResultCardState extends State<_UiResultCard> {
  bool detay = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cCard(),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: cIcon().withValues(alpha: .28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(widget.title, style: TextStyle(color: cIcon(), fontSize: 12, fontWeight: FontWeight.w800), maxLines: 2, overflow: TextOverflow.ellipsis)),
              TextButton(
                onPressed: () => setState(() => detay = !detay),
                style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                child: Text(detay ? 'Özet' : 'Detay', style: TextStyle(color: cIcon(), fontSize: 11, fontWeight: FontWeight.w800)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(widget.value, style: TextStyle(color: cText(), fontSize: 17, fontWeight: FontWeight.w800, height: 1.2), softWrap: true),
          if (widget.unit.isNotEmpty) ...[
            const SizedBox(height: 3),
            Text(widget.unit, style: TextStyle(color: cText().withValues(alpha: .72), fontSize: 12, fontWeight: FontWeight.w600, height: 1.25), softWrap: true),
          ],
          if (detay) ...[
            const Divider(height: 14),
            Text('Bu sonuç, seçilen giriş değerleriyle aracın ön hesap modelinden üretilmiştir. Kesin teknik seçim için ilgili standart/mevzuat, TEDAŞ veya dağıtım şirketi şartları, üretici teknik verileri ve saha koşulları ayrıca kontrol edilmelidir.', style: TextStyle(color: cText().withValues(alpha: .82), fontSize: 11.5, height: 1.4)),
          ],
        ],
      ),
    );
  }
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

int standartTMSBul(double akim) {
  const tmsler = [16, 20, 25, 32, 40, 50, 63, 80, 100, 125, 160, 200, 250, 315, 400, 500, 630, 800, 1000, 1250, 1600, 2000, 2500, 3200, 4000];
  return tmsler.firstWhere((val) => val >= akim, orElse: () => 4000);
}

int standartKontaktorBul(double akim) {
  const values = [9, 12, 18, 25, 32, 40, 50, 65, 80, 95, 115, 150, 185, 225, 265, 330, 400, 500];
  return values.firstWhere((val) => val >= akim, orElse: () => 500);
}

String standartAkimTrafosuBul(double akim) {
  const primler = [20, 30, 40, 50, 75, 100, 150, 200, 250, 300, 400, 500, 600, 800, 1000, 1250, 1600, 2000, 2500, 3000, 4000];
  final c = primler.firstWhere((p) => p >= akim, orElse: () => 0);
  return c == 0 ? 'Özel Proje' : '$c/5 A';
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
  if (akim <= 0) return '-';
  const kapasiteler = <int, int>{6: 36, 10: 50, 16: 68, 25: 89, 35: 111, 50: 134, 70: 171, 95: 207, 120: 239, 150: 275, 185: 314, 240: 369};
  for (final entry in kapasiteler.entries) {
    if (entry.value >= akim) return '${formatKabloKesiti(entry.key.toDouble(), is3F)} mm² NYY (Cu)';
  }
  if (is3F) return standartParalelKabloBul(akim);
  final adet = max(1, (akim / (369 * .84)).ceil());
  if (adet <= 12) return adet == 1 ? '1x240 mm² NYY (Cu)' : '$adet paralel × 1x240 mm² NYY (Cu)';
  return 'Paralel kablo grubu > 12 sistem — proje bazlı tasarım gerekir';
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
