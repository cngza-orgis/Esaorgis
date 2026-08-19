part of 'main.dart';

// ============================================================
// AÇIK İLETKEN
// Hat ve Şebeke Araçları
// ============================================================
//
// Kullanıcıdan yalnızca:
//   1) Gerilim seviyesi (AG / OG)
//   2) Tasarım akımı (A)
//
// alınır.
//
// İletken tipi seçimi YOKTUR.
//
// AG seçilirse yalnızca AG açık iletkenleri,
// OG seçilirse yalnızca OG açık iletkenleri gösterilir.
//
// Liste:
//   - İletken adı
//   - Kesit
//   - AWG
//
// Not:
// Bu ekran ön seçim / teknik karşılaştırma amacı taşır.
// Kesin seçimde ilgili şebeke işletmecisinin şartnamesi,
// mekanik hesaplar, açıklık, sıcaklık, kısa devre,
// gerilim düşümü ve üretici verileri ayrıca kontrol edilmelidir.
// ============================================================

class AcikIletkenEkrani extends StatefulWidget {
  const AcikIletkenEkrani({super.key});

  @override
  State<AcikIletkenEkrani> createState() => _AcikIletkenEkraniState();
}

class _AcikIletkenEkraniState extends State<AcikIletkenEkrani> {
  String gerilim = 'AG';
  final akimController = TextEditingController();

  String? hataMesaji;
  List<_AcikIletkenData> sonuclar = [];

  @override
  void dispose() {
    akimController.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------
  // AG AÇIK İLETKENLER
  // ------------------------------------------------------------
  //
  // Liste yapısı ileride TEDAŞ / dağıtım şirketi / üretici
  // katalog verileriyle genişletilebilir.
  //
  // AWG değeri yaklaşık standart karşılıktır.
  // ------------------------------------------------------------

  static const List<_AcikIletkenData> agIletkenler = [
    _AcikIletkenData(
      ad: 'AAC 16',
      kesit: 16.0,
      awg: '5 AWG',
      kapasite: 85.0,
    ),
    _AcikIletkenData(
      ad: 'AAC 25',
      kesit: 25.0,
      awg: '3 AWG',
      kapasite: 110.0,
    ),
    _AcikIletkenData(
      ad: 'AAC 35',
      kesit: 35.0,
      awg: '2 AWG',
      kapasite: 135.0,
    ),
    _AcikIletkenData(
      ad: 'AAC 50',
      kesit: 50.0,
      awg: '1/0 AWG',
      kapasite: 170.0,
    ),
    _AcikIletkenData(
      ad: 'AAC 70',
      kesit: 70.0,
      awg: '2/0 AWG',
      kapasite: 210.0,
    ),
    _AcikIletkenData(
      ad: 'AAC 95',
      kesit: 95.0,
      awg: '3/0 AWG',
      kapasite: 250.0,
    ),
    _AcikIletkenData(
      ad: 'AAC 120',
      kesit: 120.0,
      awg: '4/0 AWG',
      kapasite: 290.0,
    ),
    _AcikIletkenData(
      ad: 'AAC 150',
      kesit: 150.0,
      awg: '300 kcmil',
      kapasite: 330.0,
    ),
    _AcikIletkenData(
      ad: 'AAC 185',
      kesit: 185.0,
      awg: '350 kcmil',
      kapasite: 370.0,
    ),
    _AcikIletkenData(
      ad: 'AAC 240',
      kesit: 240.0,
      awg: '500 kcmil',
      kapasite: 430.0,
    ),
  ];

  // ------------------------------------------------------------
  // OG AÇIK İLETKENLER
  // ------------------------------------------------------------

  static const List<_AcikIletkenData> ogIletkenler = [
    _AcikIletkenData(
      ad: 'AAC 35',
      kesit: 35.0,
      awg: '2 AWG',
      kapasite: 135.0,
    ),
    _AcikIletkenData(
      ad: 'AAC 50',
      kesit: 50.0,
      awg: '1/0 AWG',
      kapasite: 170.0,
    ),
    _AcikIletkenData(
      ad: 'AAC 70',
      kesit: 70.0,
      awg: '2/0 AWG',
      kapasite: 210.0,
    ),
    _AcikIletkenData(
      ad: 'AAC 95',
      kesit: 95.0,
      awg: '3/0 AWG',
      kapasite: 250.0,
    ),
    _AcikIletkenData(
      ad: 'AAC 120',
      kesit: 120.0,
      awg: '4/0 AWG',
      kapasite: 290.0,
    ),
    _AcikIletkenData(
      ad: 'AAC 150',
      kesit: 150.0,
      awg: '300 kcmil',
      kapasite: 330.0,
    ),
    _AcikIletkenData(
      ad: 'AAC 185',
      kesit: 185.0,
      awg: '350 kcmil',
      kapasite: 370.0,
    ),
    _AcikIletkenData(
      ad: 'AAC 240',
      kesit: 240.0,
      awg: '500 kcmil',
      kapasite: 430.0,
    ),
    _AcikIletkenData(
      ad: 'AAC 300',
      kesit: 300.0,
      awg: '600 kcmil',
      kapasite: 490.0,
    ),
    _AcikIletkenData(
      ad: 'AAC 400',
      kesit: 400.0,
      awg: '750 kcmil',
      kapasite: 570.0,
    ),
  ];

  // ------------------------------------------------------------
  // HESAPLA / FİLTRELE
  // ------------------------------------------------------------

  void analizEt() {
    final akim = double.tryParse(
          akimController.text.trim().replaceAll(',', '.'),
        ) ??
        0;

    if (akim <= 0) {
      setState(() {
        hataMesaji = 'Lütfen geçerli bir tasarım akımı girin.';
        sonuclar = [];
      });
      return;
    }

    final liste = gerilim == 'AG' ? agIletkenler : ogIletkenler;

    // Girilen akımı taşıyabilecek ilk uygun iletken ve
    // onun üzerindeki alternatifler gösterilir.
    final uygunlar =
        liste.where((iletken) => iletken.kapasite >= akim).toList();

    setState(() {
      hataMesaji = null;
      sonuclar = uygunlar;
    });
  }

  // ------------------------------------------------------------
  // İLETKEN KARTI
  // ------------------------------------------------------------

  Widget _iletkenCard(_AcikIletkenData iletken) {
    final uygun = iletken.kapasite >=
        (double.tryParse(
              akimController.text.trim().replaceAll(',', '.'),
            ) ??
            0);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cCard(),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: uygun ? Colors.green.shade700 : cIcon(),
          width: 1.1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.electrical_services,
            color: cIcon(),
            size: 24,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  iletken.ad,
                  style: TextStyle(
                    color: cText(),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Kesit: ${fmt2(iletken.kesit)} mm²',
                  style: TextStyle(
                    color: cText().withValues(alpha: .82),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                iletken.awg,
                style: TextStyle(
                  color: cIcon(),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '≈ ${fmt2(iletken.kapasite)} A',
                style: TextStyle(
                  color: cText().withValues(alpha: .72),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: t(
        'Açık İletken',
        'Bare Conductor',
      ),
      info: true,
      onInfo: () => bilgiPopup(
        context,
        'Açık İletken — Bilgi / Yardım',
        'Bu araç, seçilen AG veya OG gerilim seviyesine göre açık iletken seçeneklerini gösterir. Kullanıcı yalnızca gerilim seviyesini ve tasarım akımını girer. Kesin iletken seçimi; akım taşıma kapasitesi yanında açıklık, mekanik yükler, sıcaklık, kısa devre dayanımı, gerilim düşümü ve ilgili dağıtım şirketi şartnameleri dikkate alınarak yapılmalıdır.',
      ),
      body: ScrollBody(
        children: [
          SectionCard(
            title: 'Giriş',
            children: [
              twoCol(
                Drop(
                  label: 'Gerilim Seviyesi',
                  value: gerilim,
                  items: const ['AG', 'OG'],
                  onChanged: (v) {
                    if (v == null) return;

                    setState(() {
                      gerilim = v;
                      sonuclar = [];
                      hataMesaji = null;
                    });
                  },
                ),
                Field(
                  controller: akimController,
                  label: 'Tasarım Akımı (A)',
                ),
              ),
              calcButton(
                'UYGUN İLETKENLERİ GÖSTER',
                analizEt,
              ),
            ],
          ),
          if (hataMesaji != null)
            AdviceCard(
              title: 'Giriş Hatası',
              text: hataMesaji!,
              error: true,
            ),
          if (sonuclar.isNotEmpty) ...[
            SectionCard(
              title: '$gerilim Açık İletkenler',
              children: [
                Text(
                  'Tasarım akımını karşılayan iletkenler',
                  style: TextStyle(
                    color: cText().withValues(alpha: .72),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 10),
                ...sonuclar.map(_iletkenCard),
              ],
            ),
          ],
          if (hataMesaji == null &&
              sonuclar.isEmpty &&
              akimController.text.isNotEmpty)
            AdviceCard(
              title: 'Uygun iletken bulunamadı',
              text:
                  '$gerilim için tanımlı listedeki iletkenlerin kapasitesi girilen tasarım akımını karşılamıyor. Daha yüksek kesit veya farklı iletken çözümü değerlendirilmelidir.',
              error: true,
            ),
          AdviceCard(
            title: 'Teknik Not',
            text:
                'Buradaki akım değerleri ön seçim amacıyla kullanılan referans değerlerdir. Kesin iletken seçimi; gerçek işletme koşulları, ortam sıcaklığı, açıklık, mekanik yükler, izin verilen sıcaklık, kısa devre dayanımı, gerilim düşümü ve ilgili TEDAŞ / dağıtım şirketi şartnameleri ile üretici verileri esas alınarak doğrulanmalıdır.',
          ),
        ],
      ),
    );
  }
}

// ============================================================
// AÇIK İLETKEN VERİ MODELİ
// ============================================================

class _AcikIletkenData {
  final String ad;
  final double kesit;
  final String awg;
  final double kapasite;

  const _AcikIletkenData({
    required this.ad,
    required this.kesit,
    required this.awg,
    required this.kapasite,
  });
}
