part of 'main.dart';

class HatAnaliziVeGerilimDusumuEkrani extends StatefulWidget {
  final int initialTab;

  const HatAnaliziVeGerilimDusumuEkrani({
    super.key,
    this.initialTab = 0,
  });

  @override
  State<HatAnaliziVeGerilimDusumuEkrani> createState() =>
      _HatAnaliziVeGerilimDusumuEkraniState();
}

class _HatAnaliziVeGerilimDusumuEkraniState
    extends State<HatAnaliziVeGerilimDusumuEkrani> {
  late int sekme;

  @override
  void initState() {
    super.initState();

    final initial = widget.initialTab;
    sekme = initial < 0 ? 0 : (initial > 1 ? 1 : initial);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Hat Analizi',
      info: true,
      onInfo: () => bilgiPopup(
        context,
        'Hat Analizi — Bilgi / Yardım',
        '''Bu araç AG ve OG hatlarda akım, taşıma kapasitesi ve gerilim düşümü için ön mühendislik kontrolü yapar.

Akım hesabı:

Trifaze:
I = P / (√3 × U × cosφ)

Monofaze:
I = P / (U × cosφ)

Gerilim düşümü:

Trifaze:
ΔU = √3 × I × (R × cosφ + X × sinφ) × L

Monofaze:
ΔU = 2 × I × (R × cosφ + X × sinφ) × L

Gerilim düşümü yüzdesi:
ΔU% = 100 × ΔU / U

Taşıma kapasitesi motorunda öncelik sırası:

1. Doğrulanmış teknik kapasite verisi
2. Mevcut teknik verilerden kontrollü yaklaşık değer
3. Fiziksel/elektriksel model ile yaklaşık değer

Yaklaşık değerler kesin üretici katalog değeri olarak değerlendirilmez ve sonuç ekranında ayrıca belirtilir.

Eksik bir değer nedeniyle analiz mümkün olduğunca yarıda bırakılmaz. Ancak teknik parametrelerin yetersiz olduğu durumlarda sonuç açıkça "hesap modeli yetersiz" olarak belirtilir.

Nihai kablo seçimi yapılırken ilgili TEDAŞ/dağıtım şirketi şartnameleri, TS/EN/IEC standartları, üretici katalogları, ortam sıcaklığı, gruplanma, döşeme şekli, termik düzeltme katsayıları, kısa devre dayanımı ve koruma koordinasyonu ayrıca kontrol edilmelidir.''',
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
            child: Row(
              children: [
                Expanded(
                  child: _sekmeButton('Hat Analizi', 0),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _sekmeButton('Gerilim Düşümü', 1),
                ),
              ],
            ),
          ),
          Expanded(
            child:
                sekme == 0 ? const _HatAnaliziTab() : const _GerilimDusumuTab(),
          ),
        ],
      ),
    );
  }

  Widget _sekmeButton(String text, int index) {
    final aktif = sekme == index;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        setState(() {
          sekme = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: aktif ? cIcon() : cCard(),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: cIcon().withValues(alpha: .35),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: aktif ? Colors.white : cText(),
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

/* ========================================================================
 * KAPASİTE SONUCU
 * ====================================================================== */

class _HatKapasiteSonucu {
  final double? akim;
  final bool dogrulanmis;
  final bool yaklasik;
  final String kaynak;

  const _HatKapasiteSonucu({
    required this.akim,
    required this.dogrulanmis,
    required this.yaklasik,
    required this.kaynak,
  });

  bool get mevcut => akim != null && akim! > 0;
}

/* ========================================================================
 * GERİLİM DÜŞÜMÜ SONUCU
 * ====================================================================== */

class _HatEmpedansSonucu {
  final double rOhmKm;
  final double xOhmKm;
  final bool rYaklasik;
  final bool xYaklasik;
  final String kaynak;

  const _HatEmpedansSonucu({
    required this.rOhmKm,
    required this.xOhmKm,
    required this.rYaklasik,
    required this.xYaklasik,
    required this.kaynak,
  });

  bool get herhangiYaklasik => rYaklasik || xYaklasik;
}

/* ========================================================================
 * HAT ANALİZİ
 * ====================================================================== */

class _HatAnaliziTab extends StatefulWidget {
  const _HatAnaliziTab();

  @override
  State<_HatAnaliziTab> createState() => _HatAnaliziTabState();
}

class _HatAnaliziTabState extends State<_HatAnaliziTab> {
  final TextEditingController _gucCtrl = TextEditingController();
  final TextEditingController _mesafeCtrl = TextEditingController();

  String gerilim = 'AG';
  String fazTipi = 'Trifaze';
  String ogGerilim = '${(esaDefaultOgVoltage / 1000).toStringAsFixed(1)}';
  String iletkenTipi = 'NYY-Bakır Kablo';
  String doseme = 'Havada';

  String kabloKesiti = '3x1,5 mm²';

  double pf = esaDefaultPowerFactor;

  double akim = 0;
  double? kapasite;

  bool kapasiteYaklasik = false;
  String kapasiteKaynak = '';

  double gerilimDusumu = double.nan;
  double gerilimDusumuVolt = double.nan;

  bool gerilimDusumuYaklasik = false;
  String gerilimDusumuKaynak = '';

  String durum = '';
  String gerekce = '';

  String? onerilenKesit;
  double? onerilenKapasite;
  bool onerilenKapasiteYaklasik = false;
  String onerilenKapasiteKaynak = '';
  String? onerilenDoseme;

  bool hesaplandi = false;

  static const double agVolt = esaAgThreePhaseVoltage;
  static const double agMonoVolt = esaAgSinglePhaseVoltage;

  static const double izinVerilenDusum = 5.0;

  static const List<String> _agKabloTipleri = [
    'NYY-Bakır Kablo',
    'NAYY-Aluminyum Kablo',
    'Açık İletken',
    'Alpek İletken',
  ];

  static const List<String> _ogKabloTipleri = [
    'N2XSY Kablo',
    'NA2XSY Kablo',
    'Açık İletken',
    'Alpek İletken',
  ];

  @override
  void initState() {
    super.initState();

    final liste = _kesitler;

    if (liste.isNotEmpty) {
      kabloKesiti = liste.first;
    }
  }

  @override
  void dispose() {
    _gucCtrl.dispose();
    _mesafeCtrl.dispose();
    super.dispose();
  }

  List<String> get _tipler {
    return gerilim == 'AG' ? _agKabloTipleri : _ogKabloTipleri;
  }

  /* ======================================================================
   * KESİT LİSTELERİ
   * ==================================================================== */

  List<String> get _kesitler {
    if (gerilim == 'AG' && iletkenTipi == 'NYY-Bakır Kablo') {
      return _nyyKesitler(fazTipi);
    }

    if (gerilim == 'AG' && iletkenTipi == 'NAYY-Aluminyum Kablo') {
      return _nayyKesitler(fazTipi);
    }

    if (gerilim == 'OG' &&
        (iletkenTipi == 'N2XSY Kablo' || iletkenTipi == 'NA2XSY Kablo')) {
      return const [
        '1x35/16 mm²',
        '1x50/16 mm²',
        '1x70/16 mm²',
        '1x95/16 mm²',
        '1x120/16 mm²',
        '1x150/25 mm²',
        '1x185/25 mm²',
        '1x240/25 mm²',
        '1x300/25 mm²',
        '1x400/35 mm²',
        '1x500/35 mm²',
      ];
    }

    if (iletkenTipi == 'Açık İletken') {
      if (gerilim == 'AG') {
        return const [
          'ROSE (R)',
          'LILIY (L)',
          'PANSY (P)',
          'POPY (Po)',
          'ASTER (A)',
          'PHLOX (Ph)',
          'OXLIP (O)',
        ];
      }

      return const [
        'SWALLOW',
        'RAVEN',
        'PİGEON',
        'PATRİDGE',
        'HAWK',
      ];
    }

    if (iletkenTipi == 'Alpek İletken') {
      return const [
        '35 mm² ALPEK',
        '50 mm² ALPEK',
        '70 mm² ALPEK',
        '95 mm² ALPEK',
        '120 mm² ALPEK',
      ];
    }

    return const [];
  }

  List<String> _nyyKesitler(String faz) {
    if (faz == 'Monofaze') {
      return merkeziAgMonofazeNyyKablolar;
    }

    return merkeziAgTrifazeNyyKablolar;
  }

  List<String> _nayyKesitler(String faz) {
    return faz == 'Monofaze'
        ? merkeziAgMonofazeNayyKablolar()
        : merkeziAgTrifazeNayyKablolar();
  }

  /* ======================================================================
   * SEÇİMLER
   * ==================================================================== */

  void _setGerilim(String value) {
    setState(() {
      gerilim = value;

      iletkenTipi = value == 'AG' ? 'NYY-Bakır Kablo' : 'N2XSY Kablo';

      final liste = _kesitler;

      kabloKesiti = liste.isNotEmpty ? liste.first : '';

      _temizleSonuc();
    });
  }

  void _setFaz(String value) {
    setState(() {
      fazTipi = value;

      final liste = _kesitler;

      kabloKesiti = liste.isNotEmpty ? liste.first : '';

      _temizleSonuc();
    });
  }

  void _setIletken(String value) {
    setState(() {
      iletkenTipi = value;

      final liste = _kesitler;

      kabloKesiti = liste.isNotEmpty ? liste.first : '';

      _temizleSonuc();
    });
  }

  void _temizleSonuc() {
    hesaplandi = false;

    akim = 0;
    kapasite = null;

    kapasiteYaklasik = false;
    kapasiteKaynak = '';

    gerilimDusumu = double.nan;
    gerilimDusumuVolt = double.nan;

    gerilimDusumuYaklasik = false;
    gerilimDusumuKaynak = '';

    durum = '';
    gerekce = '';

    onerilenKesit = null;
    onerilenKapasite = null;
    onerilenKapasiteYaklasik = false;
    onerilenKapasiteKaynak = '';
    onerilenDoseme = null;
  }

  /* ======================================================================
   * KESİT PARÇALAMA MOTORU
   * ==================================================================== */

  String _temizKesitMetni(String value) {
    return value
        .replaceAll('mm²', '')
        .replaceAll('mm2', '')
        .replaceAll('MM²', '')
        .replaceAll('MM2', '')
        .replaceAll(',', '.')
        .trim();
  }

  double _sayisalKesit(String value) {
    final temiz = _temizKesitMetni(value);

    final parantez = RegExp(
      r'^(\d+)\s*x\s*\(\s*3\s*x\s*([0-9.]+)',
      caseSensitive: false,
    ).firstMatch(temiz);

    if (parantez != null) {
      return double.tryParse(parantez.group(2) ?? '') ?? 0;
    }

    final normal = RegExp(
      r'^\d+\s*x\s*([0-9]+(?:\.[0-9]+)?)',
      caseSensitive: false,
    ).firstMatch(temiz);

    if (normal != null) {
      return double.tryParse(normal.group(1) ?? '') ?? 0;
    }

    final sadeceSayi = RegExp(
      r'([0-9]+(?:\.[0-9]+)?)',
    ).firstMatch(temiz);

    return double.tryParse(
          sadeceSayi?.group(1) ?? '',
        ) ??
        0;
  }

  int _paralelSayisi(String value) {
    final temiz = _temizKesitMetni(value);

    final match = RegExp(
      r'^(\d+)\s*x\s*\(',
    ).firstMatch(temiz);

    if (match != null) {
      return int.tryParse(
            match.group(1) ?? '',
          ) ??
          1;
    }

    return 1;
  }

  /* ======================================================================
   * NYY KAPASİTE VERİSİ
   *
   * NYY kapasite verisinin tek kaynağı cable_database.dart'dır. Böylece
   * Hat Analizi ile Kablo Taşıma Kapasitesi aracı aynı KHA verisini kullanır.
   * ==================================================================== */

  /* ======================================================================
   * AÇIK İLETKEN
   * ==================================================================== */

  double? _acikIletkenAkimi(String secim) {
    final normalized = secim.trim().toLowerCase();
    final liste =
        gerilim == 'AG' ? merkeziAgAcikIletkenler : merkeziOgAcikIletkenler;
    for (final MerkeziAcikIletken item in liste) {
      if (item.ad.trim().toLowerCase() == normalized) return item.kapasiteA;
    }
    return null;
  }

  double? _acikIletkenR(String secim) =>
      merkeziAcikIletkenROhmKm(secim, og: gerilim == 'OG');

  /* ======================================================================
   * KAPASİTE MOTORU
   *
   * Merkezi veri tabanında doğrulanmış karşılığı bulunmayan kesitler için
   * burada yaklaşık KHA üretilmez. Böylece aynı kablo farklı araçlarda
   * farklı matematiksel tahminlerle görünmez.
   * ==================================================================== */

  /* ======================================================================
   * ANA KAPASİTE MOTORU
   * ==================================================================== */

  _HatKapasiteSonucu _kapasiteSonucu(String secim) {
    if (doseme != 'Havada' && doseme != 'Toprakta') {
      return const _HatKapasiteSonucu(
        akim: null,
        dogrulanmis: false,
        yaklasik: false,
        kaynak:
            'Seçilen döşeme şekli için doğrulanmış taşıma kapasitesi modeli bulunmuyor.',
      );
    }

    final kesit = _sayisalKesit(secim);

    if (kesit <= 0) {
      return const _HatKapasiteSonucu(
        akim: null,
        dogrulanmis: false,
        yaklasik: false,
        kaynak: 'Kesit bilgisi çözümlenemedi.',
      );
    }

    final bool toprakta = doseme == 'Toprakta';

    // NYY Cu: mevcut cable_database.dart içindeki merkezi kapasite motoru.
    if (iletkenTipi == 'NYY-Bakır Kablo') {
      final value = nyyKapasiteSecimeGore(
        secim,
        toprakta: toprakta,
      );

      if (value != null && value > 0 && value.isFinite) {
        return _HatKapasiteSonucu(
          akim: value,
          dogrulanmis: true,
          yaklasik: false,
          kaynak: 'Merkezî cable_database.dart NYY Cu kapasite verisi — '
              '${toprakta ? 'toprakta' : 'havada'}.',
        );
      }

      return _HatKapasiteSonucu(
        akim: null,
        dogrulanmis: false,
        yaklasik: false,
        kaynak: 'Merkezî NYY Cu kapasite tablosunda "$secim" kaydı bulunamadı.',
      );
    }

    // NAYY Al: mevcut cable_database.dart içindeki merkezi kapasite motoru.
    if (iletkenTipi == 'NAYY-Aluminyum Kablo') {
      final value = nayyKapasiteSecimeGore(
        secim,
        toprakta: toprakta,
      );

      if (value != null && value > 0 && value.isFinite) {
        return _HatKapasiteSonucu(
          akim: value,
          dogrulanmis: true,
          yaklasik: false,
          kaynak: 'Merkezî cable_database.dart NAYY Al kapasite verisi — '
              '${toprakta ? 'toprakta' : 'havada'}.',
        );
      }

      return _HatKapasiteSonucu(
        akim: null,
        dogrulanmis: false,
        yaklasik: false,
        kaynak:
            'Merkezî NAYY Al kapasite tablosunda "$secim" kaydı bulunamadı.',
      );
    }

    if (iletkenTipi == 'Açık İletken') {
      final value = _acikIletkenAkimi(secim);

      if (value != null && value > 0 && value.isFinite) {
        return _HatKapasiteSonucu(
          akim: value,
          dogrulanmis: true,
          yaklasik: false,
          kaynak: 'Açık iletken teknik kapasite tablosu.',
        );
      }
    }

    if (iletkenTipi == 'Alpek İletken') {
      final liste =
          fazTipi == 'Trifaze' ? merkeziAlpekTrifaze : merkeziAlpekMonofaze;

      final secimTemiz = secim.replaceAll(' ', '').toLowerCase();

      for (final item in liste) {
        if (item.etiket.replaceAll(' ', '').toLowerCase() == secimTemiz ||
            (item.fazKesitiMm2 - kesit).abs() < 0.001) {
          final merkezi = item.kapasiteA;

          if (merkezi > 0 && merkezi.isFinite) {
            return _HatKapasiteSonucu(
              akim: merkezi,
              dogrulanmis: true,
              yaklasik: false,
              kaynak: 'ALPEK merkezî kapasite verisi.',
            );
          }
        }
      }
    }

    return const _HatKapasiteSonucu(
      akim: null,
      dogrulanmis: false,
      yaklasik: false,
      kaynak: 'Bu iletken için doğrulanmış kapasite modeli bulunamadı.',
    );
  }

  /* ======================================================================
   * AG EMPEDANS VERİSİ
   *
   * NYY/NAYY R20, 50 Hz X ve mümkün olan yerlerde dış çap artık merkezî
   * cable_database.dart kaynağından alınır.
   * ==================================================================== */

  /* ======================================================================
   * EMPEDANS MOTORU
   * ==================================================================== */

  _HatEmpedansSonucu _empedansSonucu(String secim) {
    final kesit = _sayisalKesit(secim);
    final paralel = _paralelSayisi(secim);

    if (kesit <= 0 || paralel <= 0) {
      return const _HatEmpedansSonucu(
        rOhmKm: 0,
        xOhmKm: 0,
        rYaklasik: true,
        xYaklasik: true,
        kaynak: 'Kesit çözümlenemedi.',
      );
    }

    if (iletkenTipi == 'NYY-Bakır Kablo' ||
        iletkenTipi == 'NAYY-Aluminyum Kablo') {
      final bool al = iletkenTipi == 'NAYY-Aluminyum Kablo';
      final merkezi = merkeziAgEmpedansVerisi(
        secim: secim,
        al: al,
      );

      if (merkezi == null) {
        return const _HatEmpedansSonucu(
          rOhmKm: 0,
          xOhmKm: 0,
          rYaklasik: true,
          xYaklasik: true,
          kaynak:
              'Seçilen AG kablo yapısı için merkezî R/X verisi bulunmuyor; yaklaşık empedans üretilmedi.',
        );
      }

      final kaynak = paralel > 1
          ? '${merkezi.kaynak}; $paralel paralel kablo için eşdeğer empedans.'
          : merkezi.kaynak;

      return _HatEmpedansSonucu(
        rOhmKm: merkezi.r20OhmKm / paralel,
        xOhmKm: merkezi.x50HzOhmKm / paralel,
        rYaklasik: false,
        xYaklasik: false,
        kaynak: kaynak,
      );
    }

    if (iletkenTipi == 'Açık İletken') {
      final r = _acikIletkenR(secim);
      if (r != null && r > 0) {
        return _HatEmpedansSonucu(
          rOhmKm: r / paralel,
          xOhmKm: 0,
          rYaklasik: false,
          xYaklasik: true,
          kaynak:
              'Merkezî açık iletken R verisi mevcut; doğrulanmış X verisi bulunmadığından reaktif empedans bileşeni hesaplanmadı.',
        );
      }
    }

    if (iletkenTipi == 'Alpek İletken') {
      return const _HatEmpedansSonucu(
        rOhmKm: 0,
        xOhmKm: 0,
        rYaklasik: true,
        xYaklasik: true,
        kaynak:
            'ALPEK için merkezî kapasite verisi mevcut ancak doğrulanmış R/X verisi bulunmadığından gerilim düşümü empedans modeli oluşturulmadı.',
      );
    }

    if (iletkenTipi == 'N2XSY Kablo' || iletkenTipi == 'NA2XSY Kablo') {
      final bool al = iletkenTipi == 'NA2XSY Kablo';
      final double systemVoltageV =
          (double.tryParse(ogGerilim.replaceAll(',', '.')) ?? 0) * 1000.0;
      final merkezi = merkeziOgEmpedansVerisi(
        kesit: kesit,
        al: al,
        systemVoltageV: systemVoltageV,
      );

      if (merkezi == null) {
        return const _HatEmpedansSonucu(
          rOhmKm: 0,
          xOhmKm: 0,
          rYaklasik: true,
          xYaklasik: true,
          kaynak:
              'Seçilen OG gerilim sınıfı ve kablo kesiti için doğrulanmış R/X verisi bulunmuyor; yaklaşık empedans üretilmedi.',
        );
      }

      final double r = merkezi.r20OhmKm;
      final double x = merkezi.x50HzOhmKm;
      return _HatEmpedansSonucu(
        rOhmKm: r / paralel,
        xOhmKm: x / paralel,
        rYaklasik: false,
        xYaklasik: false,
        kaynak: paralel > 1
            ? '${merkezi.kaynak} R/X verisi $paralel paralel kablo için eşdeğer empedansa dönüştürüldü.'
            : '${merkezi.kaynak} — R20 ve trefoil indüktansından 50 Hz X hesaplandı.',
      );
    }

    return const _HatEmpedansSonucu(
      rOhmKm: 0,
      xOhmKm: 0,
      rYaklasik: true,
      xYaklasik: true,
      kaynak: 'Empedans modeli bulunamadı.',
    );
  }

  /* ======================================================================
   * GERİLİM DÜŞÜMÜ
   * ==================================================================== */

  double? _gerilimDusumuYuzde({
    required double current,
    required double distanceM,
    required double voltage,
    required bool threePhase,
    required String secim,
  }) {
    if (current <= 0 || distanceM <= 0 || voltage <= 0) {
      return null;
    }

    final empedans = _empedansSonucu(secim);

    if (empedans.rOhmKm <= 0) {
      return null;
    }

    final r = empedans.rOhmKm / 1000.0;
    final x = empedans.xOhmKm / 1000.0;

    final sinPhi = sqrt(
      max(
        0.0,
        1.0 - pf * pf,
      ),
    );

    final du = threePhase
        ? sqrt(3.0) * current * ((r * pf) + (x * sinPhi)) * distanceM
        : 2.0 * current * ((r * pf) + (x * sinPhi)) * distanceM;

    if (!du.isFinite || du < 0) {
      return null;
    }

    return du / voltage * 100.0;
  }

  /* ======================================================================
   * ADAYLAR
   * ==================================================================== */

  List<String> _adaylar() {
    return _kesitler.where((value) => value.trim().isNotEmpty).toList();
  }

  /* ======================================================================
   * ÖNERİ MOTORU
   * ==================================================================== */

  String? _onerilenSecimiBul({
    required double requiredCurrent,
    required double distanceM,
    required double voltage,
    required bool threePhase,
  }) {
    final adaylar = _adaylar();

    for (final aday in adaylar) {
      final kapasiteSonucu = _kapasiteSonucu(aday);
      final cap = kapasiteSonucu.akim;

      // Kapasite hesabı üretilemeyen aday teknik olarak doğrulanamaz.
      if (cap == null || cap <= 0) {
        continue;
      }

      // Önce taşıma kapasitesi şartı sağlanmalı.
      if (cap < requiredCurrent) {
        continue;
      }

      // Ardından aynı aday için gerilim düşümü kontrol edilir.
      final du = _gerilimDusumuYuzde(
        current: requiredCurrent,
        distanceM: distanceM,
        voltage: voltage,
        threePhase: threePhase,
        secim: aday,
      );

      // Gerilim düşümü hesaplanamıyorsa aday nihai öneri olamaz.
      if (du == null) {
        continue;
      }

      // Hem taşıma kapasitesi hem gerilim düşümü uygun olan
      // ilk aday teknik öneri olarak kabul edilir.
      if (du <= izinVerilenDusum) {
        onerilenKapasite = cap;
        onerilenKapasiteYaklasik = kapasiteSonucu.yaklasik;
        onerilenKapasiteKaynak = kapasiteSonucu.kaynak;

        return aday;
      }
    }

    // Hiçbir aday hem akım hem gerilim düşümü kriterini sağlayamadıysa
    // uygun olmayan bir kesiti "önerilen" olarak göstermiyoruz.
    return null;
  }

  String _onerilenDoseme() {
    return doseme;
  }

  /* ======================================================================
   * ANA HESAP
   * ==================================================================== */

  void hesapla() {
    FocusManager.instance.primaryFocus?.unfocus();

    final p = double.tryParse(
          _gucCtrl.text.replaceAll(',', '.').trim(),
        ) ??
        0.0;

    final l = double.tryParse(
          _mesafeCtrl.text.replaceAll(',', '.').trim(),
        ) ??
        0.0;

    if (p <= 0 || l <= 0 || pf <= 0) {
      setState(() {
        _temizleSonuc();
      });

      return;
    }

    final three = fazTipi == 'Trifaze';

    final u = gerilim == 'OG'
        ? (double.tryParse(ogGerilim.replaceAll(',', '.')) ??
                (esaDefaultOgVoltage / 1000)) *
            1000
        : (three ? agVolt : agMonoVolt);

    final i = three ? p * 1000.0 / (sqrt(3.0) * u * pf) : p * 1000.0 / (u * pf);

    final secim = kabloKesiti;

    if (secim.isEmpty || secim == '-') {
      setState(() {
        akim = i;
        kapasite = null;

        durum = 'KESİT SEÇİLMEDİ';

        gerekce = 'Geçerli bir kablo kesiti seçilmedi.';

        hesaplandi = true;
      });

      return;
    }

    final kapasiteSonucu = _kapasiteSonucu(secim);

    final cap = kapasiteSonucu.akim;

    final du = _gerilimDusumuYuzde(
      current: i,
      distanceM: l,
      voltage: u,
      threePhase: three,
      secim: secim,
    );

    final empedans = _empedansSonucu(secim);

    final bulunanOneri = _onerilenSecimiBul(
      requiredCurrent: i,
      distanceM: l,
      voltage: u,
      threePhase: three,
    );

    final duOk = du != null && du <= izinVerilenDusum;

    final capOk = cap != null && cap >= i;

    final uygun = capOk && duOk;

    final yeniGerilimYaklasik = empedans.herhangiYaklasik;

    String yeniDurum;
    String yeniGerekce;

    if (uygun) {
      yeniDurum = 'UYGUN';

      final kapasiteMetni = kapasiteSonucu.yaklasik
          ? 'yaklaşık ${cap.toStringAsFixed(1)} A'
          : '${cap.toStringAsFixed(1)} A';

      yeniGerekce = 'Hesaplanan hat akımı ${i.toStringAsFixed(1)} A, '
          'taşıma kapasitesi $kapasiteMetni değerindedir. '
          'Gerilim düşümü %${du.toStringAsFixed(2)} ile '
          '%$izinVerilenDusum sınırı içerisindedir.';

      if (kapasiteSonucu.yaklasik) {
        yeniGerekce += ' Kapasite değeri yaklaşık modelden türetilmiştir.';
      }

      if (yeniGerilimYaklasik) {
        yeniGerekce +=
            ' Gerilim düşümü empedansının bir kısmı yaklaşık modelle hesaplanmıştır.';
      }
    } else {
      yeniDurum = 'UYGUN DEĞİL';

      final nedenler = <String>[];

      if (!capOk) {
        if (cap == null) {
          nedenler.add(
            kapasiteSonucu.kaynak.isNotEmpty
                ? kapasiteSonucu.kaynak
                : 'Seçilen kesit için kapasite motoru sonuç üretemedi.',
          );
        } else {
          final kapasiteMetni = kapasiteSonucu.yaklasik
              ? 'yaklaşık ${cap.toStringAsFixed(1)} A'
              : '${cap.toStringAsFixed(1)} A';

          nedenler.add(
            'Hesaplanan akım ${i.toStringAsFixed(1)} A, '
            'taşıma kapasitesi $kapasiteMetni değerindedir.',
          );
        }
      }

      if (du == null) {
        nedenler.add(
          'Gerilim düşümü hesaplanamadı.',
        );
      } else if (!duOk) {
        nedenler.add(
          'Gerilim düşümü %${du.toStringAsFixed(2)} ile '
          '%$izinVerilenDusum sınırını aşıyor.',
        );
      }

      yeniGerekce = nedenler.join(' ');

      if (kapasiteSonucu.yaklasik) {
        yeniGerekce += ' Kapasite yaklaşık model kullanılarak belirlenmiştir.';
      }

      if (yeniGerilimYaklasik) {
        yeniGerekce +=
            ' Gerilim düşümü hesabında yaklaşık empedans kullanılmıştır.';
      }
    }

    setState(() {
      akim = i;

      kapasite = cap;
      kapasiteYaklasik = kapasiteSonucu.yaklasik;
      kapasiteKaynak = kapasiteSonucu.kaynak;

      gerilimDusumu = du ?? double.nan;

      gerilimDusumuVolt = du == null ? double.nan : du / 100.0 * u;

      gerilimDusumuYaklasik = yeniGerilimYaklasik;

      gerilimDusumuKaynak = empedans.kaynak;

      durum = yeniDurum;
      gerekce = yeniGerekce;

      if (uygun) {
        onerilenKesit = secim;
        onerilenKapasite = cap;
        onerilenKapasiteYaklasik = kapasiteSonucu.yaklasik;
        onerilenKapasiteKaynak = kapasiteSonucu.kaynak;
        onerilenDoseme = doseme;
      } else {
        onerilenKesit = bulunanOneri;

        onerilenDoseme = bulunanOneri == null ? null : _onerilenDoseme();
      }

      hesaplandi = true;
    });
  }

  /* ======================================================================
   * SEÇİM ALANI
   * ==================================================================== */

  Widget _secimAlani({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    final safeValue =
        items.contains(value) ? value : (items.isNotEmpty ? items.first : '');

    return Drop(
      label: label,
      value: safeValue,
      items: items,
      onChanged: onChanged,
    );
  }

  /* ======================================================================
   * KAPASİTE KARTI
   * ==================================================================== */

  Widget _akimKapasiteKarti() {
    final String capText;

    if (kapasite == null) {
      capText = 'Hesaplanamadı';
    } else if (kapasiteYaklasik) {
      capText = '≈ ${kapasite!.toStringAsFixed(1)} A';
    } else {
      capText = '${kapasite!.toStringAsFixed(1)} A';
    }

    final String altText;

    if (kapasite == null) {
      altText = kapasiteKaynak.isEmpty
          ? 'Kapasite hesabı yapılamadı.'
          : kapasiteKaynak;
    } else if (kapasiteYaklasik) {
      altText = kapasite! >= akim
          ? 'Yaklaşık kapasite yeterli. $kapasiteKaynak.'
          : 'Yaklaşık kapasite yetersiz. $kapasiteKaynak.';
    } else {
      altText = kapasite! >= akim
          ? 'Doğrulanmış kapasite yeterli. $kapasiteKaynak.'
          : 'Doğrulanmış kapasite yetersiz. $kapasiteKaynak.';
    }

    return uiResultCard(
      'Hesaplanan Akım / Taşıma Kapasitesi',
      '${akim.toStringAsFixed(1)} A / $capText',
      altText,
    );
  }

  /* ======================================================================
   * GERİLİM DÜŞÜMÜ KARTI
   * ==================================================================== */

  Widget _gerilimDusumuKarti() {
    if (gerilimDusumu.isNaN) {
      return uiResultCard(
        'Gerilim düşümü',
        'Hesaplanamadı',
        gerilimDusumuKaynak.isEmpty
            ? 'Empedans modeli sonuç üretmedi.'
            : gerilimDusumuKaynak,
      );
    }

    final uygun = gerilimDusumu <= izinVerilenDusum;

    final yaklasikMetin = gerilimDusumuYaklasik
        ? ' Yaklaşık empedans modeli kullanılmıştır.'
        : '';

    return uiResultCard(
      'Gerilim düşümü',
      '%${gerilimDusumu.toStringAsFixed(2)}',
      uygun
          ? 'Sınır içinde. Gerilim düşümü ${gerilimDusumuVolt.toStringAsFixed(1)} V.$yaklasikMetin'
          : 'İzin verilen %$izinVerilenDusum sınırını aşıyor. Gerilim düşümü ${gerilimDusumuVolt.toStringAsFixed(1)} V.$yaklasikMetin',
    );
  }

  /* ======================================================================
   * DURUM KARTI
   * ==================================================================== */

  Widget _durumKarti() {
    final isGood = durum == 'UYGUN';
    final isWarning = durum == 'KESİT SEÇİLMEDİ';

    final Color borderColor = isGood
        ? Colors.green
        : isWarning
            ? Colors.amber.shade700
            : Colors.red;

    final IconData icon = isGood
        ? Icons.check_circle
        : isWarning
            ? Icons.warning_amber_rounded
            : Icons.cancel;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cCard(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor.withValues(alpha: .65),
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: borderColor,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Durum',
                  style: TextStyle(
                    color: cText(),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  durum,
                  style: TextStyle(
                    color: borderColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  gerekce,
                  style: TextStyle(
                    color: cText(),
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /* ======================================================================
   * ÖNERİ KARTI
   * ==================================================================== */

  Widget _onerilenKarti() {
    if (onerilenKesit == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cCard(),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.amber.withValues(alpha: .55),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: Colors.amber.shade700,
                ),
                const SizedBox(width: 8),
                Text(
                  'Önerilen Seçim',
                  style: TextStyle(
                    color: cText(),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Hesaplanan akımı karşılayan uygun bir kesit belirlenemedi.',
              style: TextStyle(
                color: cText(),
                fontSize: 12,
                height: 1.35,
              ),
            ),
          ],
        ),
      );
    }

    final kapasiteMetni = onerilenKapasite == null
        ? ''
        : onerilenKapasiteYaklasik
            ? '≈ ${onerilenKapasite!.toStringAsFixed(1)} A'
            : '${onerilenKapasite!.toStringAsFixed(1)} A';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cCard(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.amber.shade700.withValues(alpha: .65),
          width: 1.4,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: Colors.amber.shade700,
              ),
              const SizedBox(width: 8),
              Text(
                'Ön Seçim Kesiti',
                style: TextStyle(
                  color: cText(),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            onerilenKesit!,
            style: TextStyle(
              color: cText(),
              fontWeight: FontWeight.w900,
              fontSize: 17,
            ),
          ),
          if (onerilenKapasite != null) ...[
            const SizedBox(height: 5),
            Text(
              'Taşıma kapasitesi: $kapasiteMetni',
              style: TextStyle(
                color: cText(),
                fontSize: 12,
              ),
            ),
          ],
          if (onerilenDoseme != null) ...[
            const SizedBox(height: 3),
            Text(
              'Döşeme şekli: $onerilenDoseme',
              style: TextStyle(
                color: cText(),
                fontSize: 12,
              ),
            ),
          ],
          if (onerilenKapasiteYaklasik) ...[
            const SizedBox(height: 7),
            Text(
              'Not: Bu kapasite doğrulanmış katalog değeri değil, mevcut teknik verilerden türetilmiş yaklaşık değerdir.',
              style: TextStyle(
                color: cText(),
                fontSize: 11,
                height: 1.35,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            'Öneri, hesaplanan akımı karşılayan adaylar arasından oluşturulur. Gerilim düşümü ve kapasite değerlendirmesi birlikte dikkate alınır.',
            style: TextStyle(
              color: cText(),
              fontSize: 11,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  /* ======================================================================
   * BUILD
   * ==================================================================== */

  @override
  Widget build(BuildContext context) {
    final currentKesitler = _kesitler;

    final kesitValue =
        currentKesitler.contains(kabloKesiti) ? kabloKesiti : null;

    return ScrollBody(
      children: [
        SectionCard(
          title: 'Mevcut Hat Bilgileri',
          children: [
            twoCol(
              _secimAlani(
                label: 'Gerilim seviyesi',
                value: gerilim,
                items: const [
                  'AG',
                  'OG',
                ],
                onChanged: (v) {
                  if (v != null) {
                    _setGerilim(v);
                  }
                },
              ),
              _secimAlani(
                label: 'Sistem Tipi',
                value: fazTipi,
                items: const [
                  'Trifaze',
                  'Monofaze',
                ],
                onChanged: (v) {
                  if (v != null) {
                    _setFaz(v);
                  }
                },
              ),
            ),
            if (gerilim == 'OG') ...[
              twoCol(
                _secimAlani(
                  label: 'OG Sistem Gerilimi',
                  value: ogGerilim,
                  items: esaOgVoltageOptions
                      .map((v) => (double.parse(v) / 1000).toStringAsFixed(1))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) {
                      setState(() {
                        ogGerilim = v;
                        _temizleSonuc();
                      });
                    }
                  },
                ),
                const SizedBox.shrink(),
              ),
            ],
            twoCol(
              Field(
                controller: _gucCtrl,
                label: 'Talep Gücü (kW)',
              ),
              Field(
                controller: _mesafeCtrl,
                label: 'Tekyön Mesafe (m)',
              ),
            ),
            twoCol(
              _secimAlani(
                label: 'İletken Tipi',
                value: iletkenTipi,
                items: _tipler,
                onChanged: (v) {
                  if (v != null) {
                    _setIletken(v);
                  }
                },
              ),
              _secimAlani(
                label: 'Döşeme Şekli',
                value: doseme,
                items: const [
                  'Havada',
                  'Toprakta',
                  'Tavada',
                  'Boruda',
                ],
                onChanged: (v) {
                  if (v != null) {
                    setState(() {
                      doseme = v;
                      _temizleSonuc();
                    });
                  }
                },
              ),
            ),
            _secimAlani(
              label: 'Kablo Kesiti',
              value: kesitValue ?? '',
              items: currentKesitler,
              onChanged: (v) {
                if (v != null) {
                  setState(() {
                    kabloKesiti = v;
                    _temizleSonuc();
                  });
                }
              },
            ),
            const SizedBox(height: 4),
            Text(
              'Güç faktörü (Cos φ): ${pf.toStringAsFixed(2)}',
              style: TextStyle(
                color: cText(),
                fontWeight: FontWeight.w700,
              ),
            ),
            Slider(
              value: pf,
              min: 0.50,
              max: 1.00,
              divisions: 50,
              activeColor: cIcon(),
              onChanged: (v) {
                setState(() {
                  pf = v;
                  _temizleSonuc();
                });
              },
            ),
            calcButton(
              'Mevcut Hattı Analiz Et',
              hesapla,
            ),
          ],
        ),
        SectionCard(
          title: 'Analiz Sonucu',
          children: [
            uiResultCard(
              'Seçilen kablo / iletken',
              kabloKesiti.isEmpty ? '-' : kabloKesiti,
              'Kullanıcının mevcut hat için seçtiği kesit.',
            ),
            if (hesaplandi) ...[
              _akimKapasiteKarti(),
              _gerilimDusumuKarti(),
              _durumKarti(),
              if (durum != 'UYGUN') _onerilenKarti(),
            ],
          ],
        ),
        AdviceCard(
          title: 'Bilgi / Yardım',
          text: 'Kapasite motoru önce doğrulanmış teknik verileri kullanır. '
              'Eksik değerlerde mevcut teknik kapasite noktalarından kontrollü yaklaşık hesap yapılabilir. '
              'Yaklaşık değerler sonuç ekranında ayrıca belirtilir ve üretici katalog değeri olarak değerlendirilmez. '
              'Nihai seçimde ilgili standart, dağıtım şirketi şartnamesi, üretici katalogları, ortam sıcaklığı, gruplanma, döşeme ve düzeltme katsayıları ayrıca kontrol edilmelidir.',
        ),
      ],
    );
  }
}

/* ========================================================================
 * GERİLİM DÜŞÜMÜ SEKME
 * ====================================================================== */

class _GerilimDusumuTab extends StatefulWidget {
  const _GerilimDusumuTab();

  @override
  State<_GerilimDusumuTab> createState() => _GerilimDusumuTabState();
}

class _GerilimDusumuTabState extends State<_GerilimDusumuTab> {
  final TextEditingController _gucCtrl = TextEditingController();

  final TextEditingController _mesafeCtrl = TextEditingController();

  final TextEditingController _kesitCtrl = TextEditingController();

  String fazTipi = 'Trifaze';
  String iletkenTipi = 'Bakır';

  double pf = esaDefaultPowerFactor;

  double hesaplananYuzde = double.nan;
  double hesaplananVolt = double.nan;

  bool yaklasik = false;
  String kaynak = '';

  String durumText = '';

  bool hesaplandi = false;

  @override
  void dispose() {
    _gucCtrl.dispose();
    _mesafeCtrl.dispose();
    _kesitCtrl.dispose();
    super.dispose();
  }

  void hesapla() {
    FocusManager.instance.primaryFocus?.unfocus();

    final p = double.tryParse(
          _gucCtrl.text.replaceAll(',', '.').trim(),
        ) ??
        0.0;

    final l = double.tryParse(
          _mesafeCtrl.text.replaceAll(',', '.').trim(),
        ) ??
        0.0;

    final s = double.tryParse(
          _kesitCtrl.text.replaceAll(',', '.').trim(),
        ) ??
        0.0;

    if (p <= 0 || l <= 0 || s <= 0) {
      setState(() {
        hesaplandi = false;
      });

      return;
    }

    final three = fazTipi == 'Trifaze';

    final u = three ? esaAgThreePhaseVoltage : esaAgSinglePhaseVoltage;

    final i = three ? p * 1000.0 / (sqrt(3.0) * u * pf) : p * 1000.0 / (u * pf);

    final rOhmKm = merkeziAgBasitR20OhmKm(
      s,
      al: iletkenTipi != 'Bakır',
    );

    final xOhmKm = merkeziAgBasitX50HzOhmKm(
      s,
      al: iletkenTipi != 'Bakır',
    );

    if (rOhmKm == null ||
        rOhmKm <= 0 ||
        !rOhmKm.isFinite ||
        xOhmKm == null ||
        xOhmKm <= 0 ||
        !xOhmKm.isFinite) {
      setState(() {
        hesaplandi = true;
        hesaplananYuzde = double.nan;
        hesaplananVolt = double.nan;
        durumText = 'Empedans hesabı yapılamadı';
        kaynak =
            'Merkezî AG R/X verisi bulunamadı; yaklaşık empedans üretilmedi.';
        yaklasik = true;
      });

      return;
    }

    final r = rOhmKm / 1000.0;

    final x = xOhmKm / 1000.0;

    final sinPhi = sqrt(
      max(
        0.0,
        1.0 - pf * pf,
      ),
    );

    final du = three
        ? sqrt(3.0) * i * ((r * pf) + (x * sinPhi)) * l
        : 2.0 * i * ((r * pf) + (x * sinPhi)) * l;

    final yuzde = du / u * 100.0;

    if (!du.isFinite || !yuzde.isFinite) {
      setState(() {
        hesaplandi = true;
        hesaplananYuzde = double.nan;
        hesaplananVolt = double.nan;
        durumText = 'Gerilim düşümü hesaplanamadı';
        kaynak = 'Matematiksel model geçerli sonuç üretmedi.';
        yaklasik = true;
      });

      return;
    }

    final iyi = yuzde <= 5.0;

    setState(() {
      hesaplananYuzde = yuzde;

      hesaplananVolt = du;

      yaklasik = false;

      kaynak = 'Merkezî AG R20 ve 50 Hz X verileri kullanıldı.';

      durumText = iyi ? 'UYGUN' : 'UYGUN DEĞİL — kesit artırılmalı';

      hesaplandi = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScrollBody(
      children: [
        SectionCard(
          title: 'Gerilim Düşümü',
          children: [
            twoCol(
              Field(
                controller: _gucCtrl,
                label: 'Güç (kW)',
              ),
              Drop(
                label: 'Sistem',
                value: fazTipi,
                items: const [
                  'Trifaze',
                  'Monofaze',
                ],
                onChanged: (v) {
                  setState(() {
                    fazTipi = v ?? 'Trifaze';
                    hesaplandi = false;
                  });
                },
              ),
            ),
            twoCol(
              Field(
                controller: _mesafeCtrl,
                label: 'Tek yön mesafe (m)',
              ),
              Drop(
                label: 'İletken',
                value: iletkenTipi,
                items: const [
                  'Bakır',
                  'Alüminyum',
                ],
                onChanged: (v) {
                  setState(() {
                    iletkenTipi = v ?? 'Bakır';
                    hesaplandi = false;
                  });
                },
              ),
            ),
            Field(
              controller: _kesitCtrl,
              label: 'Kablo kesiti (mm²) — manuel',
            ),
            const SizedBox(height: 4),
            Text(
              'Güç faktörü (Cos φ): ${pf.toStringAsFixed(2)}',
              style: TextStyle(
                color: cText(),
                fontWeight: FontWeight.w700,
              ),
            ),
            Slider(
              value: pf,
              min: 0.50,
              max: 1.00,
              divisions: 50,
              activeColor: cIcon(),
              onChanged: (v) {
                setState(() {
                  pf = v;
                  hesaplandi = false;
                });
              },
            ),
            calcButton(
              'HESAPLA',
              hesapla,
            ),
          ],
        ),
        if (hesaplandi)
          ResultCard(
            title: 'Gerilim düşümü',
            value: hesaplananYuzde.isNaN
                ? 'Hesaplanmadı'
                : '%${hesaplananYuzde.toStringAsFixed(3)}',
            subtitle: hesaplananYuzde.isNaN
                ? '$durumText • $kaynak'
                : '${hesaplananVolt.toStringAsFixed(1)} V • Üst sınır: %5 • $durumText${yaklasik ? ' • Yaklaşık hesap' : ''}',
            good: !hesaplananYuzde.isNaN && durumText == 'UYGUN',
            error: !hesaplananYuzde.isNaN && durumText != 'UYGUN',
          ),
        AdviceCard(
          title: 'Bilgi / Yardım',
          text: 'Gerilim düşümü hesabında merkezî AG R/X verileri kullanılır. '
              'Seçilen kesit için doğrulanmış merkezî empedans verisi bulunmuyorsa yaklaşık R/X üretilmez ve sonuç hesaplanmadı olarak gösterilir. '
              'Nihai seçimde gerçek üretici kablo verisi ve tesis koşulları ayrıca doğrulanmalıdır.',
        ),
      ],
    );
  }
}
