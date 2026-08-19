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
// RESULT CARD
// ============================================================

class ResultCard extends StatefulWidget {
  final String title;
  final String value;
  final String? subtitle;
  final bool good;
  final bool error;
  final String? detail;

  const ResultCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.good = false,
    this.error = false,
    this.detail,
  });

  @override
  State<ResultCard> createState() => _ResultCardState();
}

class _ResultCardState extends State<ResultCard> {
  bool detay = false;

  @override
  Widget build(BuildContext context) {
    final line = widget.error
        ? Colors.red.shade700
        : widget.good
            ? Colors.green.shade700
            : cIcon();

    final detailText = widget.detail ??
        widget.subtitle ??
        'Sonuç, seçilen girişler ve ilgili aracın ön hesap modeli '
            'kullanılarak oluşturulmuştur. Nihai teknik uygunluk; '
            'güncel mevzuat, standartlar, dağıtım şirketi şartları, '
            'üretici verileri ve saha koşullarıyla ayrıca '
            'doğrulanmalıdır.';

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
              Expanded(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    color: line,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
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
            Text(
              detailText,
              style: TextStyle(
                color: cText().withValues(alpha: .82),
                fontSize: 11.5,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
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
