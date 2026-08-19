part of 'main.dart';

// ============================================================
// YERALTI KABLO
// Hat ve Şebeke Araçları
// ============================================================
//
// Kullanıcı yalnızca:
//   1) Gerilim seviyesi (AG / OG)
//   2) Tasarım akımı (A)
//
// girer.
//
// AG seçildiğinde yalnızca AG yeraltı kabloları,
// OG seçildiğinde yalnızca OG yeraltı kabloları gösterilir.
//
// Sonuçlarda:
//   - Kablo adı
//   - Kesit
//   - AWG
//   - Referans akım taşıma kapasitesi
//
// gösterilir.
//
// NOT:
// Bu ekran ön seçim amacı taşır.
// Kesin kablo seçimi; döşeme şekli, ortam/toprak sıcaklığı,
// gruplanma, toprak termik özellikleri, kısa devre dayanımı,
// gerilim düşümü, kablo tipi ve üretici katalog değerleri
// ile ilgili standart/şartnameler esas alınarak doğrulanmalıdır.
// ============================================================

class YeraltiKabloEkrani extends StatefulWidget {
  const YeraltiKabloEkrani({super.key});

  @override
  State<YeraltiKabloEkrani> createState() => _YeraltiKabloEkraniState();
}

class _YeraltiKabloEkraniState extends State<YeraltiKabloEkrani> {
  String gerilim = 'AG';
  String iletken = 'Bakır';
  String faz = 'Trifaze';

  final akimController = TextEditingController();

  String? hataMesaji;
  List<_YeraltiKabloData> sonuclar = [];

  @override
  void dispose() {
    akimController.dispose();
    super.dispose();
  }

  // ==========================================================
  // AG YERALTI KABLOLARI
  // ==========================================================

  static const List<_YeraltiKabloData> agKablolari = [
    _YeraltiKabloData(
      ad: 'NYY 4G10',
      kesit: 10.0,
      awg: '8 AWG',
      kapasite: 55.0,
    ),
    _YeraltiKabloData(
      ad: 'NYY 4G16',
      kesit: 16.0,
      awg: '5 AWG',
      kapasite: 70.0,
    ),
    _YeraltiKabloData(
      ad: 'NYY 4G25',
      kesit: 25.0,
      awg: '3 AWG',
      kapasite: 95.0,
    ),
    _YeraltiKabloData(
      ad: 'NYY 4G35',
      kesit: 35.0,
      awg: '2 AWG',
      kapasite: 115.0,
    ),
    _YeraltiKabloData(
      ad: 'NYY 4G50',
      kesit: 50.0,
      awg: '1/0 AWG',
      kapasite: 145.0,
    ),
    _YeraltiKabloData(
      ad: 'NYY 4G70',
      kesit: 70.0,
      awg: '2/0 AWG',
      kapasite: 180.0,
    ),
    _YeraltiKabloData(
      ad: 'NYY 4G95',
      kesit: 95.0,
      awg: '3/0 AWG',
      kapasite: 220.0,
    ),
    _YeraltiKabloData(
      ad: 'NYY 4G120',
      kesit: 120.0,
      awg: '4/0 AWG',
      kapasite: 255.0,
    ),
    _YeraltiKabloData(
      ad: 'NYY 4G150',
      kesit: 150.0,
      awg: '300 kcmil',
      kapasite: 290.0,
    ),
    _YeraltiKabloData(
      ad: 'NYY 4G185',
      kesit: 185.0,
      awg: '350 kcmil',
      kapasite: 330.0,
    ),
    _YeraltiKabloData(
      ad: 'NYY 4G240',
      kesit: 240.0,
      awg: '500 kcmil',
      kapasite: 385.0,
    ),
    _YeraltiKabloData(
      ad: 'NYY 4G300',
      kesit: 300.0,
      awg: '600 kcmil',
      kapasite: 440.0,
    ),
    _YeraltiKabloData(
      ad: 'NYY 4G400',
      kesit: 400.0,
      awg: '750 kcmil',
      kapasite: 515.0,
    ),
    _YeraltiKabloData(
      ad: 'NYY 4G500',
      kesit: 500.0,
      awg: '1000 kcmil',
      kapasite: 595.0,
    ),
    _YeraltiKabloData(
      ad: 'NYY 4G630',
      kesit: 630.0,
      awg: '1250 kcmil',
      kapasite: 690.0,
    ),
  ];

  // ==========================================================
  // OG YERALTI KABLOLARI
  // ==========================================================

  static const List<_YeraltiKabloData> ogKablolari = [
    _YeraltiKabloData(
      ad: 'XLPE 1x35 Al 12/20 kV',
      kesit: 35.0,
      awg: '2 AWG',
      kapasite: 135.0,
    ),
    _YeraltiKabloData(
      ad: 'XLPE 1x50 Al 12/20 kV',
      kesit: 50.0,
      awg: '1/0 AWG',
      kapasite: 160.0,
    ),
    _YeraltiKabloData(
      ad: 'XLPE 1x70 Al 12/20 kV',
      kesit: 70.0,
      awg: '2/0 AWG',
      kapasite: 200.0,
    ),
    _YeraltiKabloData(
      ad: 'XLPE 1x95 Al 12/20 kV',
      kesit: 95.0,
      awg: '3/0 AWG',
      kapasite: 235.0,
    ),
    _YeraltiKabloData(
      ad: 'XLPE 1x120 Al 12/20 kV',
      kesit: 120.0,
      awg: '4/0 AWG',
      kapasite: 270.0,
    ),
    _YeraltiKabloData(
      ad: 'XLPE 1x150 Al 12/20 kV',
      kesit: 150.0,
      awg: '300 kcmil',
      kapasite: 305.0,
    ),
    _YeraltiKabloData(
      ad: 'XLPE 1x185 Al 12/20 kV',
      kesit: 185.0,
      awg: '350 kcmil',
      kapasite: 345.0,
    ),
    _YeraltiKabloData(
      ad: 'XLPE 1x240 Al 12/20 kV',
      kesit: 240.0,
      awg: '500 kcmil',
      kapasite: 400.0,
    ),
    _YeraltiKabloData(
      ad: 'XLPE 1x300 Al 12/20 kV',
      kesit: 300.0,
      awg: '600 kcmil',
      kapasite: 455.0,
    ),
    _YeraltiKabloData(
      ad: 'XLPE 1x400 Al 12/20 kV',
      kesit: 400.0,
      awg: '750 kcmil',
      kapasite: 530.0,
    ),
    _YeraltiKabloData(
      ad: 'XLPE 1x500 Al 12/20 kV',
      kesit: 500.0,
      awg: '1000 kcmil',
      kapasite: 610.0,
    ),
    _YeraltiKabloData(
      ad: 'XLPE 1x630 Al 12/20 kV',
      kesit: 630.0,
      awg: '1250 kcmil',
      kapasite: 700.0,
    ),
  ];

  // ==========================================================
  // ANALİZ
  // ==========================================================

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

    List<_YeraltiKabloData> liste;
    if (gerilim == 'OG') {
      liste = ogKablolari.map((k) {
        final al = iletken == 'Alüminyum';
        final ad = al ? k.ad.replaceAll('Cu', 'Al') : k.ad.replaceAll('Al', 'Cu');
        final cap = al ? k.kapasite * 0.78 : k.kapasite;
        return _YeraltiKabloData(ad: ad, kesit: k.kesit, awg: k.awg, kapasite: cap);
      }).toList();
    } else {
      liste = agKablolari.map((k) {
        final prefix = iletken == 'Alüminyum' ? 'NAYY' : 'NYY';
        final damar = faz == 'Monofaze' ? '2x' : '4G';
        final ad = k.ad.replaceFirst(RegExp(r'NYY'), prefix).replaceFirst(RegExp(r'4G'), damar);
        final cap = iletken == 'Alüminyum' ? k.kapasite * 0.78 : k.kapasite;
        return _YeraltiKabloData(ad: ad, kesit: k.kesit, awg: k.awg, kapasite: cap);
      }).toList();
    }

    final uygunlar = liste.where((kablo) => kablo.kapasite >= akim).toList();

    setState(() {
      hataMesaji = null;
      sonuclar = uygunlar;
    });
  }

  // ==========================================================
  // KABLO SONUÇ KARTI
  // ==========================================================

  Widget _kabloCard(_YeraltiKabloData kablo) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cCard(),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: cIcon(),
          width: 1.1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.cable,
            color: cIcon(),
            size: 24,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  kablo.ad,
                  style: TextStyle(
                    color: cText(),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Kesit: ${fmt2(kablo.kesit)} mm²',
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
                kablo.awg,
                style: TextStyle(
                  color: cIcon(),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '≈ ${fmt2(kablo.kapasite)} A',
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

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: t(
        'Yer Altı Kablolar',
        'Underground Cable',
      ),
      info: true,
      onInfo: () => bilgiPopup(
        context,
        'Yeraltı Kablo — Bilgi / Yardım',
        'Gerilim seviyesine, iletken malzemesine ve AG için faz sistemine göre uygun yer altı kablolarını listeler. Kesin kablo seçimi; döşeme şekli, ortam ve toprak sıcaklığı, gruplanma, kısa devre dayanımı, gerilim düşümü ve üretici katalog değerleriyle doğrulanmalıdır.',
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
              twoCol(
                Drop(label: 'İletken', value: iletken, items: const ['Bakır','Alüminyum'], onChanged: (v) => setState(() { iletken = v ?? 'Bakır'; sonuclar = []; })),
                gerilim == 'AG'
                    ? Drop(label: 'Faz Sistemi', value: faz, items: const ['Trifaze','Monofaze'], onChanged: (v) => setState(() { faz = v ?? 'Trifaze'; sonuclar = []; }))
                    : const SizedBox(),
              ),
              calcButton(
                'UYGUN KABLOLARI GÖSTER',
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
              title: '$gerilim Yeraltı Kabloları',
              children: [
                Text(
                  'Tasarım akımını karşılayan kablolar',
                  style: TextStyle(
                    color: cText().withValues(alpha: .72),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 10),
                ...sonuclar.map(_kabloCard),
              ],
            ),
          ],
          if (hataMesaji == null &&
              sonuclar.isEmpty &&
              akimController.text.isNotEmpty)
            AdviceCard(
              title: 'Uygun kablo bulunamadı',
              text:
                  '$gerilim için tanımlı listedeki kabloların referans kapasitesi girilen tasarım akımını karşılamıyor. Daha büyük kesit veya farklı kablo çözümü değerlendirilmelidir.',
              error: true,
            ),
          AdviceCard(
            title: 'Teknik Not',
            text:
                'Gösterilen akım değerleri ön seçim amacıyla kullanılan referans değerleridir. Gerçek kablo kapasitesi; iletken malzemesi, kablo yapısı, döşeme şekli, ortam/toprak sıcaklığı, gruplanma, termik koşullar ve üretici katalog değerlerine göre değişir. Kesin seçim ilgili standartlar, TEDAŞ / dağıtım şirketi şartnameleri ve üretici verileriyle doğrulanmalıdır.',
          ),
        ],
      ),
    );
  }
}

// ============================================================
// VERİ MODELİ
// ============================================================

class _YeraltiKabloData {
  final String ad;
  final double kesit;
  final String awg;
  final double kapasite;

  const _YeraltiKabloData({
    required this.ad,
    required this.kesit,
    required this.awg,
    required this.kapasite,
  });
}
