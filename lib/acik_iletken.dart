part of 'main.dart';

// ============================================================
// AÇIK İLETKEN
// Hat ve Şebeke Araçları
// ============================================================
//
// Kullanıcıdan:
//   1) Gerilim seviyesi (AG / OG)
//   2) Tasarım akımı (A)
//
// alınır.
//
// ÖNEMLİ GÖSTERİM STANDARDI:
//
// Kullanıcı arayüzünde iletkenin:
//   - Gerçek tip adı
//   - Kesit alanı
//   - Yaklaşık akım kapasitesi
//
// gösterilir.
//
// AWG / KCMIL / TS EN 50182 teknik kodları ana kullanıcı
// ekranında gösterilmez.
//
// Örnek:
//   DOĞRU:
//     Rose
//     Tam Alüminyum İletken
//     Kesit: 21,10 mm²
//
//   YANLIŞ:
//     AAC 16
//     4 AWG
//     21-AL1
//
// Teknik standart kodları kullanıcı arayüzündeki ana seçim
// alanının yerine geçmez.
//
// Kesin seçimde ilgili dağıtım şirketi/TEDAŞ şartnameleri,
// mekanik hesaplar, açıklık, sıcaklık, kısa devre,
// gerilim düşümü ve üretici verileri ayrıca doğrulanmalıdır.
// ============================================================

class AcikIletkenEkrani extends StatefulWidget {
  const AcikIletkenEkrani({super.key});

  @override
  State<AcikIletkenEkrani> createState() => _AcikIletkenEkraniState();
}

class _AcikIletkenEkraniState extends State<AcikIletkenEkrani> {
  String gerilim = 'AG';

  final TextEditingController akimController = TextEditingController();

  String? hataMesaji;

  List<_AcikIletkenData> sonuclar = [];

  // ==========================================================
  // AG AÇIK İLETKENLER
  // ==========================================================
  //
  // Kullanıcıya gerçek tip isimleri gösterilir.
  //
  // Not:
  // Buradaki kapasite değerleri ön seçim/referans amacıyla
  // kullanılmaktadır. Kesin akım taşıma kapasitesi;
  // gerçek işletme koşulları, sıcaklık, açıklık, montaj,
  // mekanik şartlar ve ilgili teknik şartname ile doğrulanır.
  //
  // TEDAŞ malzeme listesinde tam alüminyum iletken tipleri:
  // Rose, Lily, Pansy, Poppy, Aster, Phlox, Oxlip
  // olarak tanımlanmaktadır.
  // ==========================================================

  static const List<_AcikIletkenData> agIletkenler = [
    _AcikIletkenData(
      ad: 'Rose',
      tipAciklama: 'Tam Alüminyum İletken',
      kesit: 21.1,
      kapasite: 85.0,
    ),
    _AcikIletkenData(
      ad: 'Lily',
      tipAciklama: 'Tam Alüminyum İletken',
      kesit: 26.6,
      kapasite: 110.0,
    ),
    _AcikIletkenData(
      ad: 'Pansy',
      tipAciklama: 'Tam Alüminyum İletken',
      kesit: 42.4,
      kapasite: 135.0,
    ),
    _AcikIletkenData(
      ad: 'Poppy',
      tipAciklama: 'Tam Alüminyum İletken',
      kesit: 53.5,
      kapasite: 170.0,
    ),
    _AcikIletkenData(
      ad: 'Aster',
      tipAciklama: 'Tam Alüminyum İletken',
      kesit: 67.4,
      kapasite: 210.0,
    ),
    _AcikIletkenData(
      ad: 'Phlox',
      tipAciklama: 'Tam Alüminyum İletken',
      kesit: 85.0,
      kapasite: 250.0,
    ),
    _AcikIletkenData(
      ad: 'Oxlip',
      tipAciklama: 'Tam Alüminyum İletken',
      kesit: 107.2,
      kapasite: 290.0,
    ),
  ];

  // ==========================================================
  // OG AÇIK İLETKENLER
  // ==========================================================
  //
  // OG tarafında da kullanıcıya teknik kod yerine gerçek tip
  // adı gösterilir.
  //
  // Çelik özlü alüminyum iletkenlerde kullanıcı ekranında
  // Swallow, Pigeon, Partridge ve Hawk gibi tip adları
  // kullanılır.
  //
  // TEDAŞ malzeme listesinde bu tipler ayrı bir "çelik özlü
  // örgülü alüminyum iletkenler" grubu olarak tanımlanmaktadır.
  //
  // Burada AWG / kcmil gösterilmez.
  // ==========================================================

  static const List<_AcikIletkenData> ogIletkenler = [
    _AcikIletkenData(
      ad: 'Swallow',
      tipAciklama: 'Çelik Özlü Alüminyum İletken',
      kesit: 31.1,
      kapasite: 135.0,
    ),
    _AcikIletkenData(
      ad: 'Pigeon',
      tipAciklama: 'Çelik Özlü Alüminyum İletken',
      kesit: 99.3,
      kapasite: 250.0,
    ),
    _AcikIletkenData(
      ad: 'Partridge',
      tipAciklama: 'Çelik Özlü Alüminyum İletken',
      kesit: 156.9,
      kapasite: 330.0,
    ),
    _AcikIletkenData(
      ad: 'Hawk',
      tipAciklama: 'Çelik Özlü Alüminyum İletken',
      kesit: 281.1,
      kapasite: 490.0,
    ),
  ];

  // ==========================================================
  // SAYISAL FORMAT
  // ==========================================================

  String _fmtKesit(double value) {
    return value.toStringAsFixed(1).replaceAll('.', ',');
  }

  String _fmtAkim(double value) {
    return value.toStringAsFixed(0).replaceAll('.', ',');
  }

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

    final liste = gerilim == 'AG' ? agIletkenler : ogIletkenler;

    // Girilen tasarım akımını karşılayan iletkenlerden,
    // hesaplanan değerin üzerindeki seçenekler gösterilir.
    final uygunlar = liste
        .where(
          (iletken) => iletken.kapasite >= akim,
        )
        .toList();

    setState(() {
      hataMesaji = null;
      sonuclar = uygunlar;
    });
  }

  // ==========================================================
  // İLETKEN KARTI
  // ==========================================================

  Widget _iletkenCard(
    _AcikIletkenData iletken,
  ) {
    final akim = double.tryParse(
          akimController.text.trim().replaceAll(',', '.'),
        ) ??
        0;

    final uygun = iletken.kapasite >= akim;

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
          // ----------------------------------------------------
          // İLETKEN İKONU
          // ----------------------------------------------------

          Icon(
            Icons.electrical_services,
            color: cIcon(),
            size: 24,
          ),

          const SizedBox(width: 10),

          // ----------------------------------------------------
          // İLETKEN ADI + KESİT
          // ----------------------------------------------------

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
                const SizedBox(height: 2),
                Text(
                  iletken.tipAciklama,
                  style: TextStyle(
                    color: cText().withValues(
                      alpha: .70,
                    ),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Kesit: ${_fmtKesit(iletken.kesit)} mm²',
                  style: TextStyle(
                    color: cText().withValues(
                      alpha: .88,
                    ),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // ----------------------------------------------------
          // AKIM KAPASİTESİ
          // ----------------------------------------------------

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '≈ ${_fmtAkim(iletken.kapasite)} A',
                style: TextStyle(
                  color: cIcon(),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Akım kapasitesi',
                style: TextStyle(
                  color: cText().withValues(
                    alpha: .65,
                  ),
                  fontSize: 10,
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
        'Açık İletken',
        'Bare Conductor',
      ),
      info: true,
      onInfo: () => bilgiPopup(
        context,
        'Açık İletken — Bilgi / Yardım',
        'Bu araç, seçilen AG veya OG gerilim seviyesine göre '
            'uygun açık iletken seçeneklerini ön seçim amacıyla '
            'gösterir. Kullanıcı tasarım akımını girerek bu akımı '
            'karşılayabilecek standart iletken tiplerini inceleyebilir.\n\n'
            'İletken adı kullanıcı ekranında gerçek tip adıyla '
            'gösterilir. AWG, KCMIL ve standart teknik kodlar '
            'ana seçim ekranında kullanılmaz.\n\n'
            'Kesin iletken seçimi; akım taşıma kapasitesinin yanı '
            'sıra açıklık, mekanik yükler, ortam sıcaklığı, iletken '
            'sıcaklığı, kısa devre dayanımı, gerilim düşümü, '
            'şebeke yapısı ve ilgili TEDAŞ / dağıtım şirketi '
            'şartnameleri ile üretici teknik verileri dikkate '
            'alınarak doğrulanmalıdır.',
      ),
      body: ScrollBody(
        children: [
          // ====================================================
          // GİRİŞ
          // ====================================================

          SectionCard(
            title: 'Giriş',
            children: [
              twoCol(
                Drop(
                  label: 'Gerilim Seviyesi',
                  value: gerilim,
                  items: const [
                    'AG',
                    'OG',
                  ],
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

          // ====================================================
          // HATA
          // ====================================================

          if (hataMesaji != null)
            AdviceCard(
              title: 'Giriş Hatası',
              text: hataMesaji!,
              error: true,
            ),

          // ====================================================
          // SONUÇLAR
          // ====================================================

          if (sonuclar.isNotEmpty) ...[
            SectionCard(
              title: '$gerilim Açık İletkenler',
              children: [
                Text(
                  'Tasarım akımını karşılayan standart iletkenler',
                  style: TextStyle(
                    color: cText().withValues(
                      alpha: .72,
                    ),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 10),
                ...sonuclar.map(
                  _iletkenCard,
                ),
              ],
            ),
          ],

          // ====================================================
          // UYGUN İLETKEN YOK
          // ====================================================

          if (hataMesaji == null &&
              sonuclar.isEmpty &&
              akimController.text.isNotEmpty)
            AdviceCard(
              title: 'Uygun iletken bulunamadı',
              text: '$gerilim için tanımlı standart iletkenler '
                  'içerisinde girilen tasarım akımını karşılayan '
                  'bir seçenek bulunamadı. Daha yüksek kapasiteli '
                  'standart bir iletken veya farklı bir şebeke '
                  'çözümü değerlendirilmelidir.',
              error: true,
            ),

          // ====================================================
          // TEKNİK NOT
          // ====================================================

          AdviceCard(
            title: 'Teknik Not',
            text: 'Bu araç ön seçim ve teknik karşılaştırma amacıyla '
                'kullanılır. Gösterilen akım kapasiteleri referans '
                'değerlerdir. Kesin seçimde gerçek işletme koşulları, '
                'ortam sıcaklığı, açıklık, mekanik yükler, izin '
                'verilen iletken sıcaklığı, kısa devre dayanımı, '
                'gerilim düşümü ve ilgili TEDAŞ / dağıtım şirketi '
                'şartnameleri ile üretici verileri ayrıca '
                'değerlendirilmelidir.',
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

  final String tipAciklama;

  final double kesit;

  final double kapasite;

  const _AcikIletkenData({
    required this.ad,
    required this.tipAciklama,
    required this.kesit,
    required this.kapasite,
  });
}
