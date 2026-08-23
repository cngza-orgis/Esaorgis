part of 'main.dart';

// ============================================================
// ORTAK ROUTE
// ============================================================

Route<T> materialRoute<T>(Widget page) => MaterialPageRoute<T>(
      builder: (_) => Material(
        type: MaterialType.transparency,
        child: page,
      ),
    );

// ============================================================
// ORTAK APP SCAFFOLD
// ============================================================
//
// Üst sağdaki:
//
//                    Yardım  (i)
//
// tek bir tıklanabilir alan olarak çalışır.
//
// ÇERÇEVE YOKTUR.
// AYRI BUTON YOKTUR.
// ARKA PLAN YOKTUR.
//
// "Yardım" yazısına veya bilgi ikonuna basıldığında
// aynı yardım penceresi açılır.
//
// Araç kendi onInfo callback'i veriyorsa o kullanılır.
// Vermiyorsa genel yardım penceresi açılır.
//
// ============================================================

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final bool info;
  final VoidCallback? onInfo;

  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.info = true,
    this.onInfo,
  });

  void _openHelp(BuildContext context) {
    if (onInfo != null) {
      onInfo!();
      return;
    }

    bilgiPopup(
      context,
      '$title — Bilgi / Yardım',
      'Bu araç için girişlerin anlamı, hesaplama yaklaşımı ve '
          'sonuçların yorumlanması burada açıklanır. '
          'Hesap sonuçları teknik ön değerlendirme niteliğindedir; '
          'kullanılan formüller, standartlar, mevzuat, '
          'dağıtım şirketi şartları, üretici verileri ve '
          'saha koşulları ilgili aracın teknik bilgileriyle '
          'birlikte değerlendirilmelidir.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return ThemeLangWrapper(
      builder: (context) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          toolbarHeight: 56,
          titleSpacing: 0,
          title: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            if (info || onInfo != null)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _openHelp(context),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 6,
                    right: 10,
                    top: 8,
                    bottom: 8,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Yardım',
                        style: TextStyle(
                          color: Colors.white.withValues(
                            alpha: .92,
                          ),
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.info_outline,
                        color: Colors.white,
                        size: 19,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        body: SafeArea(
          child: body,
        ),
      ),
    );
  }
}

// ============================================================
// ORTAK SCROLL BODY
// ============================================================

class ScrollBody extends StatelessWidget {
  final List<Widget> children;

  const ScrollBody({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

// ============================================================
// SECTION CARD
//
// Field + Drop alanları otomatik olarak 2 sütunlu yerleşir.
//
// Örnek:
//
//  Field     Drop
//  Field     Field
//  Drop
//
// Son tek alan tam genişlik kaplar.
//
// Field/Drop olmayan widget'lar grid'i böler ve kendi satırında
// normal şekilde devam eder.
// ============================================================

class SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SectionCard({
    super.key,
    required this.title,
    required this.children,
  });

  bool _isGridField(Widget widget) {
    return widget is Field || widget is Drop;
  }

  List<Widget> _buildContent() {
    final result = <Widget>[];
    final gridItems = <Widget>[];

    void flushGrid() {
      if (gridItems.isEmpty) return;

      for (int i = 0; i < gridItems.length; i += 2) {
        final first = gridItems[i];

        if (i + 1 < gridItems.length) {
          final second = gridItems[i + 1];

          result.add(
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: first,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: second,
                ),
              ],
            ),
          );
        } else {
          result.add(
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: first,
                ),
              ],
            ),
          );
        }
      }

      gridItems.clear();
    }

    for (final child in children) {
      if (_isGridField(child)) {
        gridItems.add(child);
      } else {
        flushGrid();
        result.add(child);
      }
    }

    flushGrid();

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cCard(),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: TextStyle(
                color: cIcon(),
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 10),
            ..._buildContent(),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// ORTAK TEKNİK SONUÇ DETAYI
// ============================================================
//
// Tüm sonuç kartlarında aynı açıklama standardını kullanmak için ortak
// model. Eski araçlar yeni alanları vermese bile sonuç kartı standart
// başlıkları göstermeye devam eder. Araç özelinde daha ayrıntılı veri
// verilmesi gerektiğinde alanlar doldurulabilir.
//
class TechnicalResultDetails {
  final String nedir;
  final String nasilHesaplandi;
  final String neyeGoreSecildi;
  final String nedenCikti;
  final String sahaNotu;

  const TechnicalResultDetails({
    required this.nedir,
    required this.nasilHesaplandi,
    required this.neyeGoreSecildi,
    required this.nedenCikti,
    required this.sahaNotu,
  });
}

TechnicalResultDetails defaultTechnicalResultDetails({
  required String title,
  required String value,
  String? detail,
  String? subtitle,
}) {
  final note = (detail != null && detail.trim().isNotEmpty)
      ? detail.trim()
      : (subtitle != null && subtitle.trim().isNotEmpty)
          ? subtitle.trim()
          : 'Nihai teknik seçim için güncel standart/mevzuat, dağıtım şirketi şartları, üretici verileri ve saha koşulları ayrıca doğrulanmalıdır.';

  return TechnicalResultDetails(
    nedir: '$title sonucu, hesap veya ön seçim ekranında gösterilen teknik değeri ifade eder.',
    nasilHesaplandi: 'Seçilen girişler ve ilgili aracın hesap modeli kullanılarak oluşturulmuştur. Araç özelindeki teknik yöntem ve kullanılan büyüklükler ilgili yardım/kütüphane açıklamalarından doğrulanmalıdır.',
    neyeGoreSecildi: 'Varsa ilgili standart değerler, teknik sınırlar, kablo/ekipman verileri, sistem tipi ve kullanıcı girişleri birlikte değerlendirilir. Otomatik sonuçlar ön seçim niteliğindedir.',
    nedenCikti: 'Sonuç; girilen değerlerin, seçilen ekipman veya tesis koşullarının ve uygulanan hesap modelinin birlikte değerlendirilmesiyle oluşmuştur. Girdi değişirse sonuç da değişebilir.',
    sahaNotu: note,
  );
}

Widget technicalResultDetailsView(
  TechnicalResultDetails details,
) {
  Widget section(String title, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: cIcon(),
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            text,
            style: TextStyle(
              color: cText().withValues(alpha: .84),
              fontSize: 11.3,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      section('Nedir?', details.nedir),
      section('Nasıl hesaplandı?', details.nasilHesaplandi),
      section('Neye göre seçildi?', details.neyeGoreSecildi),
      section('Bu sonuç neden çıktı?', details.nedenCikti),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: cCardAlpha(),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: cIcon().withValues(alpha: .28)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.engineering_outlined, color: cIcon(), size: 18),
            const SizedBox(width: 7),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Saha notu',
                    style: TextStyle(
                      color: cIcon(),
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    details.sahaNotu,
                    style: TextStyle(
                      color: cText(),
                      fontSize: 11.3,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

// ============================================================
// RESULT CARD
// ============================================================

class ResultCard extends StatefulWidget {
  final String title;
  final String value;
  final String? subtitle;
  final bool good;
  final bool error;
  final String? detail;
  final TechnicalResultDetails? technicalDetails;

  const ResultCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.good = false,
    this.error = false,
    this.detail,
    this.technicalDetails,
  });

  @override
  State<ResultCard> createState() => _ResultCardState();
}

class _ResultCardState extends State<ResultCard> {
  bool detay = false;

  IconData _resultIcon(String title) {
    final t = title.toLowerCase();
    if (t.contains('panel') || t.contains('pv') || t.contains('solar')) return Icons.solar_power_outlined;
    if (t.contains('inverter') || t.contains('invertör') || t.contains('sürücü')) return Icons.power_rounded;
    if (t.contains('motor')) return Icons.settings_rounded;
    if (t.contains('akü') || t.contains('battery')) return Icons.battery_charging_full_rounded;
    if (t.contains('kablo') || t.contains('iletken')) return Icons.cable_rounded;
    if (t.contains('akım') || t.contains('güç') || t.contains('cosφ')) return Icons.bolt_rounded;
    if (t.contains('trafo')) return Icons.electrical_services_outlined;
    if (t.contains('toprak')) return Icons.foundation_rounded;
    if (t.contains('kompanz')) return Icons.tune_rounded;
    if (t.contains('teknik') || t.contains('uygun')) return Icons.verified_outlined;
    if (t.contains('fatura') || t.contains('enerji')) return Icons.receipt_long_outlined;
    return Icons.analytics_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final line = widget.error
        ? Colors.red.shade700
        : widget.good
            ? Colors.green.shade700
            : cIcon();

    final details = widget.technicalDetails ??
        defaultTechnicalResultDetails(
          title: widget.title,
          value: widget.value,
          detail: widget.detail,
          subtitle: widget.subtitle,
        );

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cCard(),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: line,
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: line.withValues(alpha: .10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _resultIcon(widget.title),
                  color: line,
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    color: line,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    detay = !detay;
                  });
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  detay ? 'Özet' : 'Detay',
                  style: TextStyle(
                    color: cIcon(),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            widget.value,
            style: TextStyle(
              color: cText(),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            softWrap: true,
          ),
          if (!detay && widget.subtitle != null) ...[
            const SizedBox(height: 3),
            Text(
              widget.subtitle!,
              style: TextStyle(
                color: cText().withValues(alpha: .75),
                fontSize: 12,
                height: 1.35,
              ),
            ),
          ],
          if (detay) ...[
            const Divider(height: 14),
            technicalResultDetailsView(details),
          ],
        ],
      ),
    );
  }
}

// ============================================================
// STANDART SONUÇ BÖLÜM KARTI
// ============================================================
//
// Uzun/karmaşık sonuç metinlerini konu başlıklarına ve hizalı
// etiket-değer satırlarına ayırmak için kullanılır. Böylece bütün
// araçlarda sonuçların aynı görsel hiyerarşide, taşma yapmadan ve
// birbirine girmeden gösterilmesi sağlanır.
//
class ResultRowData {
  final String label;
  final String value;

  const ResultRowData(this.label, this.value);
}

class ResultSectionCard extends StatelessWidget {
  final String title;
  final List<ResultRowData> rows;
  final String? note;
  final IconData icon;
  final Color? accent;

  const ResultSectionCard({
    super.key,
    required this.title,
    required this.rows,
    this.note,
    this.icon = Icons.analytics_outlined,
    this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final color = accent ?? cIcon();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
      decoration: BoxDecoration(
        color: cCard(),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: .42), width: 1.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .10),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          ...rows.map(
            (row) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 6,
                    child: Text(
                      row.label,
                      style: TextStyle(
                        color: cText().withValues(alpha: .88),
                        fontSize: 12,
                        height: 1.25,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 5,
                    child: Text(
                      row.value,
                      textAlign: TextAlign.right,
                      softWrap: true,
                      style: TextStyle(
                        color: cText(),
                        fontSize: 12,
                        height: 1.25,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (note != null && note!.trim().isNotEmpty) ...[
            const Divider(height: 12),
            Text(
              note!,
              style: TextStyle(
                color: cText().withValues(alpha: .72),
                fontSize: 11.3,
                height: 1.35,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Eski araçlarda üretilen bölüm başlıklı sonuç metinlerini ortak
/// ResultSectionCard görünümüne dönüştürür.
List<Widget> resultSectionCardsFromText(
  String text, {
  String fallbackTitle = 'Sonuç',
  String? fallbackNote,
  List<IconData> icons = const [],
}) {
  final blocks = text
      .split(RegExp(r'\n\s*\n'))
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  if (blocks.isEmpty) return const [];

  final widgets = <Widget>[];

  for (int bi = 0; bi < blocks.length; bi++) {
    final lines = blocks[bi]
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    if (lines.isEmpty) continue;

    String title = fallbackTitle;
    int start = 0;

    final first = lines.first;
    final looksLikeHeading = !first.contains(':') &&
        (first == first.toUpperCase() ||
            first.startsWith(RegExp(r'\d+\.')));

    if (looksLikeHeading) {
      title = first
          .replaceFirst(RegExp(r'^\d+\.\s*'), '')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();
      start = 1;
    }

    final rows = <ResultRowData>[];
    final loose = <String>[];

    for (final line in lines.skip(start)) {
      final idx = line.indexOf(':');
      if (idx > 0 && idx < line.length - 1) {
        rows.add(
          ResultRowData(
            line.substring(0, idx).trim(),
            line.substring(idx + 1).trim(),
          ),
        );
      } else {
        loose.add(line.replaceFirst(RegExp(r'^[-•]\s*'), '').trim());
      }
    }

    widgets.add(
      ResultSectionCard(
        title: title,
        icon: bi < icons.length ? icons[bi] : Icons.analytics_outlined,
        rows: rows,
        note: loose.isEmpty ? null : loose.join('\n'),
      ),
    );
  }

  if (fallbackNote != null && fallbackNote.trim().isNotEmpty) {
    widgets.add(AdviceCard(title: 'Teknik doğrulama notu', text: fallbackNote));
  }

  return widgets;
}

// ============================================================
// ADVICE CARD
// ============================================================

class AdviceCard extends StatelessWidget {
  final String title;
  final String text;
  final bool error;

  const AdviceCard({
    super.key,
    required this.title,
    required this.text,
    this.error = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = error ? Colors.red.shade700 : Colors.green.shade700;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cCard(),
        border: Border.all(
          color: color,
          width: 1.2,
        ),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            error ? Icons.warning_amber : Icons.check_circle_outline,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '$title\n',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: text,
                    style: TextStyle(
                      color: cText(),
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// TEXT FIELD
// ============================================================

class Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;

  const Field({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType = TextInputType.number,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(
          color: cText(),
        ),
        decoration: customInputDec(label),
      ),
    );
  }
}

// ============================================================
// DROPDOWN
// ============================================================

class Drop extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const Drop({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final safeItems = <String>[];

    for (final item in items) {
      if (item.isNotEmpty && !safeItems.contains(item)) {
        safeItems.add(item);
      }
    }

    final String? safeValue = safeItems.contains(value)
        ? value
        : (safeItems.isNotEmpty ? safeItems.first : null);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DropdownButtonFormField<String>(
        value: safeValue,
        isExpanded: true,
        dropdownColor: cInputBg(),
        style: TextStyle(
          color: cText(),
          fontSize: 13,
        ),
        decoration: customInputDec(label),
        items: safeItems
            .map(
              (e) => DropdownMenuItem<String>(
                value: e,
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    e,
                    softWrap: false,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: safeItems.isEmpty ? null : onChanged,
      ),
    );
  }
}

// ============================================================
// HESAPLAMA BUTONU
// ============================================================

Widget calcButton(
  String text,
  VoidCallback onPressed,
) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

// ============================================================
// BİLGİ
// ============================================================

void showInfo(
  BuildContext context,
  String title,
  String text,
) {
  bilgiPopup(
    context,
    title,
    text,
  );
}

// ============================================================
// SAYISAL FORMAT
// ============================================================

String fmt2(num value) {
  return value.toStringAsFixed(2);
}

// ============================================================
// TEKNİK BAŞLIK
// ============================================================

Widget technicalHeader(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Align(
      alignment: Alignment.centerRight,
      child: Text(
        text,
        textAlign: TextAlign.right,
        style: TextStyle(
          color: cText().withValues(alpha: .72),
          fontSize: 11,
          height: 1.3,
        ),
      ),
    ),
  );
}

// ============================================================
// TWO COLUMN
// ============================================================

Widget twoCol(
  Widget a,
  Widget b,
) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: a,
      ),
      const SizedBox(width: 10),
      Expanded(
        child: b,
      ),
    ],
  );
}
