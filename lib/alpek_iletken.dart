part of 'main.dart';

// ================================================================
// ALPEK İLETKEN
// ================================================================
// Faz 4:
// - Yerel ALPEK tabloları kaldırıldı.
// - Faz ve nötr kesitleri merkezi veri modelinde ayrı alanlar olarak
//   tutulur; nötr kod içinde fazdan türetilmez.
// - Kullanıcı ekranında AWG/KCMIL gösterilmez.
// ================================================================

class AlpekIletkenEkrani extends StatefulWidget {
  const AlpekIletkenEkrani({super.key});

  @override
  State<AlpekIletkenEkrani> createState() => _AlpekIletkenEkraniState();
}

class _AlpekIletkenEkraniState extends State<AlpekIletkenEkrani> {
  final TextEditingController akimController = TextEditingController();

  String sistemTipi = 'Trifaze';
  List<MerkeziAlpekSecenek> uygunKesitler = <MerkeziAlpekSecenek>[];
  MerkeziAlpekSecenek? onerilen;
  String? hataMesaji;

  @override
  void dispose() {
    akimController.dispose();
    super.dispose();
  }

  void hesapla() {
    final double? akim = double.tryParse(
      akimController.text.trim().replaceAll(',', '.'),
    );

    if (akim == null || akim <= 0) {
      setState(() {
        uygunKesitler = <MerkeziAlpekSecenek>[];
        onerilen = null;
        hataMesaji = 'Lütfen geçerli bir tasarım akımı girin.';
      });
      return;
    }

    final List<MerkeziAlpekSecenek> kaynak =
        sistemTipi == 'Monofaze' ? merkeziAlpekMonofaze : merkeziAlpekTrifaze;
    final List<MerkeziAlpekSecenek> uygun =
        kaynak.where((e) => e.kapasiteA >= akim).toList();

    setState(() {
      uygunKesitler = uygun;
      onerilen = uygun.isNotEmpty ? uygun.first : null;
      hataMesaji = null;
    });
  }

  Widget _kart(MerkeziAlpekSecenek secenek) {
    final bool secili = identical(secenek, onerilen);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: cCard(),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: secili ? Colors.green.shade700 : cIcon().withValues(alpha: .45),
          width: secili ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Icon(secili ? Icons.check_circle : Icons.electrical_services,
              color: secili ? Colors.green.shade700 : cIcon(), size: 21),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ALPEK — ${secenek.etiket}',
                  style: TextStyle(color: cText(), fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 3),
                Text(
                  'Faz: ${_fmt(secenek.fazKesitiMm2)} mm²  •  Nötr: ${_fmt(secenek.notrKesitiMm2)} mm²  •  Kapasite: ${secenek.kapasiteA.toStringAsFixed(0)} A',
                  style: TextStyle(color: cText().withValues(alpha: .72), fontSize: 11.5),
                ),
              ],
            ),
          ),
          if (secili)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'ÖNERİ',
                style: TextStyle(color: Colors.green.shade700, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }

  String _fmt(double value) => value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toString().replaceAll('.', ',');

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: t('ALPEK İletken Seçimi', 'ABC Cable Selection'),
      info: true,
      onInfo: () => bilgiPopup(
        context,
        'ALPEK İletken Seçimi — Bilgi',
        'ALPEK seçenekleri merkezi veri tabanından gelir. Faz ve nötr kesitleri ayrı veri alanları olarak tutulur. Monofaze yapı 1 faz + 1 nötr, trifaze yapı 3 faz + 1 nötr olarak gösterilir. Kesin seçim; üretici verileri, açıklık, sıcaklık, mekanik yükler, gerilim düşümü, kısa devre ve ilgili dağıtım şirketi/TEDAŞ şartlarıyla doğrulanmalıdır.',
      ),
      body: ScrollBody(
        children: [
          SectionCard(
            title: 'ALPEK Giriş Bilgileri',
            children: [
              twoCol(
                Drop(
                  label: 'Sistem Tipi',
                  value: sistemTipi,
                  items: const ['Monofaze', 'Trifaze'],
                  onChanged: (v) => setState(() {
                    sistemTipi = v ?? 'Trifaze';
                    uygunKesitler = <MerkeziAlpekSecenek>[];
                  }),
                ),
                Field(controller: akimController, label: 'Tasarım Akımı (A)'),
              ),
              calcButton('UYGUN KESİTLERİ GÖSTER', hesapla),
            ],
          ),
          if (hataMesaji != null)
            AdviceCard(title: 'Giriş Hatası', text: hataMesaji!, error: true),
          if (uygunKesitler.isNotEmpty)
            SectionCard(
              title: 'Uygun ALPEK Seçenekleri',
              children: [
                ...uygunKesitler.map(_kart),
              ],
            ),
          if (hataMesaji == null && uygunKesitler.isEmpty && akimController.text.isNotEmpty)
            AdviceCard(
              title: 'Uygun seçenek bulunamadı',
              text: 'Girilen tasarım akımını karşılayan merkezi ALPEK seçeneği bulunamadı.',
              error: true,
            ),
          AdviceCard(
            title: 'Teknik Not',
            text: 'ALPEK akım kapasitesi değerleri ön seçim amacıyla kullanılır. Kesin seçim; gerçek üretici verileri, açıklık, ortam sıcaklığı, mekanik yükler, sarkma, gerilim düşümü ve kısa devre koşulları ile ilgili dağıtım şirketi/TEDAŞ şartlarına göre doğrulanmalıdır.',
          ),
        ],
      ),
    );
  }
}
