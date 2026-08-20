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
ΔU = 2 × I × R × L

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
  String iletkenTipi = 'NYY-Bakır Kablo';
  String doseme = 'Havada';

  String kabloKesiti = '3x1,5 mm²';

  double pf = 0.80;

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

  static const double agVolt = 400.0;
  static const double agMonoVolt = 230.0;
  static const double ogVolt = 20300.0;

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
        '3 AWG - SWALLOW',
        '1/0 AWG - RAVEN',
        '3/0 AWG - PİGEON',
        '266.8 MCM - PATRİDGE',
        '477 MCM - HAWK',
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
      return const [
        '1x0,75 mm²',
        '1x1 mm²',
        '1x1,5 mm²',
        '1x2,5 mm²',
        '1x4 mm²',
        '1x6 mm²',
        '1x10 mm²',
        '1x16 mm²',
        '1x25 mm²',
        '1x35 mm²',
        '1x50 mm²',
        '1x70 mm²',
        '1x95 mm²',
        '1x120 mm²',
        '1x150 mm²',
        '1x185 mm²',
        '1x240 mm²',
        '2x0,75 mm²',
        '2x1 mm²',
        '2x1,5 mm²',
        '2x2,5 mm²',
        '2x4 mm²',
        '2x6 mm²',
        '2x10 mm²',
        '2x16 mm²',
        '2x25 mm²',
        '2x35 mm²',
        '2x50 mm²',
        '2x70 mm²',
        '2x95 mm²',
        '2x120 mm²',
        '2x150 mm²',
        '2x185 mm²',
        '2x240 mm²',
      ];
    }

    return const [
      '3x1,5 mm²',
      '3x2,5 mm²',
      '3x4 mm²',
      '3x6 mm²',
      '3x10 mm²',
      '4x1,5 mm²',
      '4x2,5 mm²',
      '4x4 mm²',
      '4x6 mm²',
      '4x10 mm²',
      '4x16 mm²',
      '3x16+10 mm²',
      '3x25+16 mm²',
      '3x35+16 mm²',
      '3x50+25 mm²',
      '3x70+35 mm²',
      '3x95+50 mm²',
      '3x120+70 mm²',
      '3x150+70 mm²',
      '3x185+95 mm²',
      '3x240+120 mm²',
      '2x(3x16+10) mm²',
      '2x(3x25+16) mm²',
      '2x(3x35+16) mm²',
      '2x(3x50+25) mm²',
      '2x(3x70+35) mm²',
      '2x(3x95+50) mm²',
      '2x(3x120+70) mm²',
      '2x(3x150+70) mm²',
      '2x(3x185+95) mm²',
      '2x(3x240+120) mm²',
      '3x(3x25+16) mm²',
      '3x(3x35+16) mm²',
      '3x(3x50+25) mm²',
      '3x(3x70+35) mm²',
      '3x(3x95+50) mm²',
      '3x(3x120+70) mm²',
      '3x(3x150+70) mm²',
      '3x(3x185+95) mm²',
      '3x(3x240+120) mm²',
    ];
  }

  List<String> _nayyKesitler(String faz) {
    if (faz == 'Monofaze') {
      return const [
        '1x10 mm²',
        '1x16 mm²',
        '1x25 mm²',
        '1x35 mm²',
        '1x50 mm²',
        '1x70 mm²',
        '1x95 mm²',
        '1x120 mm²',
        '1x150 mm²',
        '1x185 mm²',
        '1x240 mm²',
        '2x10 mm²',
        '2x16 mm²',
        '2x25 mm²',
        '2x35 mm²',
        '2x50 mm²',
        '2x70 mm²',
        '2x95 mm²',
        '2x120 mm²',
        '2x150 mm²',
        '2x185 mm²',
        '2x240 mm²',
      ];
    }

    return const [
      '3x25 mm²',
      '3x35 mm²',
      '3x50 mm²',
      '3x70 mm²',
      '3x95 mm²',
      '3x120 mm²',
      '3x150 mm²',
      '3x185 mm²',
      '3x240 mm²',
      '3x25+16 mm²',
      '3x35+16 mm²',
      '3x50+25 mm²',
      '3x70+35 mm²',
      '3x95+50 mm²',
      '3x120+70 mm²',
      '3x150+70 mm²',
      '3x185+95 mm²',
      '3x240+120 mm²',
    ];
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

  String _kesitAnahtari(double value) {
    if (value <= 0) {
      return '';
    }

    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toString();
  }

  /* ======================================================================
   * NYY DOĞRULANMIŞ KAPASİTELER
   * ==================================================================== */

  double? _nyyHavaDogrulanmis(double kesit) {
    const data = <String, double>{
      '1.5': 30.0,
      '2.5': 41.0,
      '4': 55.0,
      '6': 70.0,
      '10': 98.0,
      '16': 132.0,
      '25': 176.0,
      '35': 218.0,
      '50': 276.0,
      '70': 347.0,
      '95': 416.0,
      '120': 488.0,
    };

    return data[_kesitAnahtari(kesit)];
  }

  double? _nyyToprakDogrulanmis(double kesit) {
    const data = <String, double>{
      '1.5': 29.0,
      '2.5': 39.0,
      '4': 52.0,
      '6': 67.0,
      '10': 93.0,
      '16': 125.0,
      '25': 167.0,
      '35': 207.0,
      '50': 262.0,
      '70': 330.0,
      '95': 395.0,
      '120': 464.0,
    };

    return data[_kesitAnahtari(kesit)];
  }

  /* ======================================================================
   * NAYY DOĞRULANMIŞ KAPASİTELER
   * ==================================================================== */

  double? _nayyHavaDogrulanmis(double kesit) {
    const data = <String, double>{
      '10': 45.0,
      '16': 60.0,
      '25': 87.0,
      '35': 107.0,
      '50': 131.0,
      '70': 166.0,
      '95': 205.0,
      '120': 239.0,
      '150': 273.0,
      '185': 317.0,
      '240': 378.0,
    };

    return data[_kesitAnahtari(kesit)];
  }

  double? _nayyToprakDogrulanmis(double kesit) {
    const data = <String, double>{
      '10': 55.0,
      '16': 75.0,
      '25': 106.0,
      '35': 127.0,
      '50': 151.0,
      '70': 185.0,
      '95': 222.0,
      '120': 253.0,
      '150': 284.0,
      '185': 322.0,
      '240': 375.0,
    };

    return data[_kesitAnahtari(kesit)];
  }

  /* ======================================================================
   * OG KAPASİTELERİ
   * ==================================================================== */

  double? _ogKabloDogrulanmis(double kesit) {
    final key = _kesitAnahtari(kesit);

    final isCu = iletkenTipi == 'N2XSY Kablo';

    const cuHava = <String, double>{
      '35': 193.0,
      '50': 231.0,
      '70': 289.0,
      '95': 354.0,
      '120': 409.0,
      '150': 464.0,
      '185': 532.0,
      '240': 631.0,
      '300': 722.0,
      '400': 837.0,
      '500': 961.0,
    };

    const cuToprak = <String, double>{
      '35': 181.0,
      '50': 213.0,
      '70': 258.0,
      '95': 309.0,
      '120': 349.0,
      '150': 390.0,
      '185': 438.0,
      '240': 506.0,
      '300': 565.0,
      '400': 635.0,
      '500': 711.0,
    };

    const alHava = <String, double>{
      '35': 151.0,
      '50': 182.0,
      '70': 226.0,
      '95': 278.0,
      '120': 321.0,
      '150': 364.0,
      '185': 420.0,
      '240': 501.0,
      '300': 578.0,
      '400': 679.0,
      '500': 789.0,
    };

    const alToprak = <String, double>{
      '35': 143.0,
      '50': 167.0,
      '70': 205.0,
      '95': 243.0,
      '120': 277.0,
      '150': 311.0,
      '185': 351.0,
      '240': 408.0,
      '300': 459.0,
      '400': 521.0,
      '500': 592.0,
    };

    if (isCu) {
      return doseme == 'Toprakta' ? cuToprak[key] : cuHava[key];
    }

    return doseme == 'Toprakta' ? alToprak[key] : alHava[key];
  }

  /* ======================================================================
   * AÇIK İLETKEN
   * ==================================================================== */

  double? _acikIletkenAkimi(String secim) {
    const ag = <String, double>{
      'ROSE (R)': 110.0,
      'LILIY (L)': 125.0,
      'PANSY (P)': 165.0,
      'POPY (Po)': 193.0,
      'ASTER (A)': 225.0,
      'PHLOX (Ph)': 262.0,
      'OXLIP (O)': 306.0,
    };

    const og = <String, double>{
      '3 AWG - SWALLOW': 120.0,
      '1/0 AWG - RAVEN': 195.0,
      '3/0 AWG - PİGEON': 275.0,
      '266.8 MCM - PATRİDGE': 345.0,
      '477 MCM - HAWK': 540.0,
    };

    return gerilim == 'AG' ? ag[secim] : og[secim];
  }

  double? _acikIletkenR(String secim) {
    const ag = <String, double>{
      'ROSE (R)': 1.354,
      'LILIY (L)': 1.074,
      'PANSY (P)': 0.6752,
      'POPY (Po)': 0.5351,
      'ASTER (A)': 0.4245,
      'PHLOX (Ph)': 0.3366,
      'OXLIP (O)': 0.2671,
    };

    const og = <String, double>{
      '3 AWG - SWALLOW': 1.0742,
      '1/0 AWG - RAVEN': 0.5362,
      '3/0 AWG - PİGEON': 0.3366,
      '266.8 MCM - PATRİDGE': 0.214,
      '477 MCM - HAWK': 0.1194,
    };

    return gerilim == 'AG' ? ag[secim] : og[secim];
  }

  /* ======================================================================
   * YAKLAŞIK KAPASİTE MOTORU
   *
   * Burada doğrulanmış veri bulunmayan kesitlerde, aynı malzeme ve döşeme
   * grubundaki bilinen noktalardan logaritmik/power-law yaklaşımı yapılır.
   *
   * Bu değer "katalog değeri" değildir.
   * Sonuç ekranında yaklaşık olarak gösterilir.
   * ==================================================================== */

  double? _powerLawKapasite({
    required double kesit,
    required List<double> kesitler,
    required List<double> kapasiteler,
  }) {
    if (kesit <= 0 ||
        kesitler.length != kapasiteler.length ||
        kesitler.length < 2) {
      return null;
    }

    final noktalar = <List<double>>[];

    for (var i = 0; i < kesitler.length; i++) {
      if (kesitler[i] > 0 && kapasiteler[i] > 0) {
        noktalar.add([
          kesitler[i],
          kapasiteler[i],
        ]);
      }
    }

    if (noktalar.length < 2) {
      return null;
    }

    if (kesit < noktalar.first[0]) {
      final x1 = noktalar[0][0];
      final y1 = noktalar[0][1];
      final x2 = noktalar[1][0];
      final y2 = noktalar[1][1];

      final exponent = log(y2 / y1) / log(x2 / x1);

      if (!exponent.isFinite || exponent <= 0) {
        return null;
      }

      final sonuc = y1 * pow(kesit / x1, exponent);

      if (!sonuc.isFinite || sonuc <= 0) {
        return null;
      }

      return sonuc;
    }

    for (var i = 0; i < noktalar.length - 1; i++) {
      final x1 = noktalar[i][0];
      final y1 = noktalar[i][1];
      final x2 = noktalar[i + 1][0];
      final y2 = noktalar[i + 1][1];

      if (kesit >= x1 && kesit <= x2) {
        final exponent = log(y2 / y1) / log(x2 / x1);

        if (!exponent.isFinite || exponent <= 0) {
          return null;
        }

        final sonuc = y1 * pow(kesit / x1, exponent);

        if (!sonuc.isFinite || sonuc <= 0) {
          return null;
        }

        return sonuc;
      }
    }

    final son = noktalar.length - 1;

    final x1 = noktalar[son - 1][0];
    final y1 = noktalar[son - 1][1];
    final x2 = noktalar[son][0];
    final y2 = noktalar[son][1];

    final exponent = log(y2 / y1) / log(x2 / x1);

    if (!exponent.isFinite || exponent <= 0) {
      return null;
    }

    final sonuc = y2 * pow(kesit / x2, exponent);

    if (!sonuc.isFinite || sonuc <= 0) {
      return null;
    }

    return sonuc;
  }

  double? _nyyYaklasik(double kesit) {
    const kesitler = [
      1.5,
      2.5,
      4.0,
      6.0,
      10.0,
      16.0,
      25.0,
      35.0,
      50.0,
      70.0,
      95.0,
      120.0,
    ];

    final kapasiteler = doseme == 'Toprakta'
        ? const [
            29.0,
            39.0,
            52.0,
            67.0,
            93.0,
            125.0,
            167.0,
            207.0,
            262.0,
            330.0,
            395.0,
            464.0,
          ]
        : const [
            30.0,
            41.0,
            55.0,
            70.0,
            98.0,
            132.0,
            176.0,
            218.0,
            276.0,
            347.0,
            416.0,
            488.0,
          ];

    return _powerLawKapasite(
      kesit: kesit,
      kesitler: kesitler,
      kapasiteler: kapasiteler,
    );
  }

  double? _nayyYaklasik(double kesit) {
    const kesitler = [
      10.0,
      16.0,
      25.0,
      35.0,
      50.0,
      70.0,
      95.0,
      120.0,
      150.0,
      185.0,
      240.0,
    ];

    final kapasiteler = doseme == 'Toprakta'
        ? const [
            55.0,
            75.0,
            106.0,
            127.0,
            151.0,
            185.0,
            222.0,
            253.0,
            284.0,
            322.0,
            375.0,
          ]
        : const [
            45.0,
            60.0,
            87.0,
            107.0,
            131.0,
            166.0,
            205.0,
            239.0,
            273.0,
            317.0,
            378.0,
          ];

    return _powerLawKapasite(
      kesit: kesit,
      kesitler: kesitler,
      kapasiteler: kapasiteler,
    );
  }

  double? _ogYaklasik(double kesit) {
    const kesitler = [
      35.0,
      50.0,
      70.0,
      95.0,
      120.0,
      150.0,
      185.0,
      240.0,
      300.0,
      400.0,
      500.0,
    ];

    if (iletkenTipi == 'N2XSY Kablo') {
      final kapasiteler = doseme == 'Toprakta'
          ? const [
              181.0,
              213.0,
              258.0,
              309.0,
              349.0,
              390.0,
              438.0,
              506.0,
              565.0,
              635.0,
              711.0,
            ]
          : const [
              193.0,
              231.0,
              289.0,
              354.0,
              409.0,
              464.0,
              532.0,
              631.0,
              722.0,
              837.0,
              961.0,
            ];

      return _powerLawKapasite(
        kesit: kesit,
        kesitler: kesitler,
        kapasiteler: kapasiteler,
      );
    }

    final kapasiteler = doseme == 'Toprakta'
        ? const [
            143.0,
            167.0,
            205.0,
            243.0,
            277.0,
            311.0,
            351.0,
            408.0,
            459.0,
            521.0,
            592.0,
          ]
        : const [
            151.0,
            182.0,
            226.0,
            278.0,
            321.0,
            364.0,
            420.0,
            501.0,
            578.0,
            679.0,
            789.0,
          ];

    return _powerLawKapasite(
      kesit: kesit,
      kesitler: kesitler,
      kapasiteler: kapasiteler,
    );
  }

  /* ======================================================================
   * ALPEK YAKLAŞIK KAPASİTE
   *
   * Buradaki model doğrudan üretici katalog değeri değildir.
   * Alüminyum iletken için mevcut NAYY verilerinden türetilen kontrollü
   * bir yaklaşım kullanılır.
   * ==================================================================== */

  double? _alpekYaklasik(double kesit) {
    const kesitler = [
      35.0,
      50.0,
      70.0,
      95.0,
      120.0,
    ];

    const hava = [
      107.0,
      131.0,
      166.0,
      205.0,
      239.0,
    ];

    const toprak = [
      127.0,
      151.0,
      185.0,
      222.0,
      253.0,
    ];

    return _powerLawKapasite(
      kesit: kesit,
      kesitler: kesitler,
      kapasiteler: doseme == 'Toprakta' ? toprak : hava,
    );
  }

  /* ======================================================================
   * ANA KAPASİTE MOTORU
   * ==================================================================== */

  _HatKapasiteSonucu _kapasiteSonucu(String secim) {
    // Tavada ve boruda kapasite için bu dosyada doğrulanmış teknik veri
    // bulunmadığından, Havada/Toprakta tablolarını yanlışlıkla bu döşemelere
    // uygulamıyoruz. Teknik olarak desteklenmeyen bir kapasiteyi üretmek
    // yerine sonucu açıkça "model yok" olarak bırakmak daha güvenlidir.
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

    final paralel = _paralelSayisi(secim);

    if (iletkenTipi == 'NYY-Bakır Kablo') {
      final dogrulanmis = doseme == 'Toprakta'
          ? _nyyToprakDogrulanmis(kesit)
          : _nyyHavaDogrulanmis(kesit);

      if (dogrulanmis != null && dogrulanmis > 0) {
        return _HatKapasiteSonucu(
          akim: dogrulanmis * paralel,
          dogrulanmis: true,
          yaklasik: false,
          kaynak: 'NYY bakır için teknik kapasite tablosu',
        );
      }

      final yaklasik = _nyyYaklasik(kesit);

      if (yaklasik != null && yaklasik > 0) {
        return _HatKapasiteSonucu(
          akim: yaklasik * paralel,
          dogrulanmis: false,
          yaklasik: true,
          kaynak:
              'NYY bakır için mevcut teknik kapasite noktalarından yaklaşık hesap',
        );
      }
    }

    if (iletkenTipi == 'NAYY-Aluminyum Kablo') {
      final dogrulanmis = doseme == 'Toprakta'
          ? _nayyToprakDogrulanmis(kesit)
          : _nayyHavaDogrulanmis(kesit);

      if (dogrulanmis != null && dogrulanmis > 0) {
        return _HatKapasiteSonucu(
          akim: dogrulanmis * paralel,
          dogrulanmis: true,
          yaklasik: false,
          kaynak: 'NAYY alüminyum için teknik kapasite tablosu',
        );
      }

      final yaklasik = _nayyYaklasik(kesit);

      if (yaklasik != null && yaklasik > 0) {
        return _HatKapasiteSonucu(
          akim: yaklasik * paralel,
          dogrulanmis: false,
          yaklasik: true,
          kaynak:
              'NAYY alüminyum için mevcut teknik kapasite noktalarından yaklaşık hesap',
        );
      }
    }

    if (iletkenTipi == 'N2XSY Kablo' || iletkenTipi == 'NA2XSY Kablo') {
      final dogrulanmis = _ogKabloDogrulanmis(kesit);

      if (dogrulanmis != null && dogrulanmis > 0) {
        return _HatKapasiteSonucu(
          akim: dogrulanmis,
          dogrulanmis: true,
          yaklasik: false,
          kaynak: 'OG kablo teknik kapasite tablosu',
        );
      }

      final yaklasik = _ogYaklasik(kesit);

      if (yaklasik != null && yaklasik > 0) {
        return _HatKapasiteSonucu(
          akim: yaklasik,
          dogrulanmis: false,
          yaklasik: true,
          kaynak:
              'OG kablo için mevcut teknik kapasite noktalarından yaklaşık hesap',
        );
      }
    }

    if (iletkenTipi == 'Açık İletken') {
      final value = _acikIletkenAkimi(secim);

      if (value != null && value > 0) {
        return _HatKapasiteSonucu(
          akim: value,
          dogrulanmis: true,
          yaklasik: false,
          kaynak: 'Açık iletken teknik kapasite tablosu',
        );
      }
    }

    if (iletkenTipi == 'Alpek İletken') {
      final yaklasik = _alpekYaklasik(kesit);

      if (yaklasik != null && yaklasik > 0) {
        return _HatKapasiteSonucu(
          akim: yaklasik,
          dogrulanmis: false,
          yaklasik: true,
          kaynak:
              'ALPEK için mevcut alüminyum iletken verilerinden yaklaşık hesap',
        );
      }
    }

    return const _HatKapasiteSonucu(
      akim: null,
      dogrulanmis: false,
      yaklasik: false,
      kaynak: 'Bu iletken için kapasite modeli oluşturulamadı.',
    );
  }

  /* ======================================================================
   * R DEĞERLERİ
   *
   * Birim: ohm/km
   * ==================================================================== */

  double? _nyyR(double kesit) {
    const data = <String, double>{
      '1.5': 14.5,
      '2.5': 8.87,
      '4': 5.52,
      '6': 3.69,
      '10': 2.19,
      '16': 1.38,
      '25': 0.870,
      '35': 0.627,
      '50': 0.463,
      '70': 0.321,
      '95': 0.232,
      '120': 0.184,
      '150': 0.150,
      '185': 0.121,
      '240': 0.0926,
    };

    return data[_kesitAnahtari(kesit)];
  }

  double? _nayyR(double kesit) {
    const data = <String, double>{
      '10': 3.08,
      '16': 1.91,
      '25': 1.20,
      '35': 0.868,
      '50': 0.641,
      '70': 0.443,
      '95': 0.320,
      '120': 0.253,
      '150': 0.206,
      '185': 0.164,
      '240': 0.125,
    };

    return data[_kesitAnahtari(kesit)];
  }

  /* ======================================================================
   * FİZİKSEL R HESABI
   *
   * Bakır:
   * rho20 ≈ 0.0175 ohm.mm²/m
   *
   * Alüminyum:
   * rho20 ≈ 0.0282 ohm.mm²/m
   *
   * Sıcaklık düzeltmesi yaklaşık olarak uygulanır.
   * ==================================================================== */

  double _fizikselR({
    required double kesit,
    required bool bakir,
  }) {
    final rho = bakir ? 0.0175 : 0.0282;

    final alpha = bakir ? 0.00393 : 0.00403;

    final referansSicaklik = 20.0;

    final hedefSicaklik = doseme == 'Toprakta' ? 70.0 : 70.0;

    final rhoSicaklik = rho * (1 + alpha * (hedefSicaklik - referansSicaklik));

    return rhoSicaklik * 1000 / kesit;
  }

  /* ======================================================================
   * X DEĞERLERİ
   * ==================================================================== */

  double? _nyyX(double kesit) {
    const data = <String, double>{
      '1.5': 0.115,
      '2.5': 0.110,
      '4': 0.105,
      '6': 0.100,
      '10': 0.095,
      '16': 0.090,
      '25': 0.085,
      '35': 0.082,
      '50': 0.080,
      '70': 0.078,
      '95': 0.076,
      '120': 0.075,
      '150': 0.074,
      '185': 0.073,
      '240': 0.072,
    };

    return data[_kesitAnahtari(kesit)];
  }

  double _yaklasikX({
    required double kesit,
  }) {
    if (kesit <= 0) {
      return 0.08;
    }

    final value = 0.075 + (0.12 / sqrt(kesit));

    if (!value.isFinite || value <= 0) {
      return 0.08;
    }

    return value;
  }

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

    if (iletkenTipi == 'NYY-Bakır Kablo') {
      final r = _nyyR(kesit);
      final x = _nyyX(kesit);

      final kullanilanR = r ??
          _fizikselR(
            kesit: kesit,
            bakir: true,
          );

      final kullanilanX = x ?? _yaklasikX(kesit: kesit);

      return _HatEmpedansSonucu(
        rOhmKm: kullanilanR / paralel,
        xOhmKm: kullanilanX / paralel,
        rYaklasik: r == null,
        xYaklasik: x == null,
        kaynak: paralel > 1
            ? 'R/X verileri $paralel paralel kablo için eşdeğer empedansa dönüştürüldü.'
            : (r == null
                ? 'R fiziksel iletken modeliyle yaklaşık hesaplandı.'
                : 'R teknik direnç tablosundan alındı.'),
      );
    }

    if (iletkenTipi == 'NAYY-Aluminyum Kablo') {
      final r = _nayyR(kesit);

      final kullanilanR = r ??
          _fizikselR(
            kesit: kesit,
            bakir: false,
          );

      return _HatEmpedansSonucu(
        rOhmKm: kullanilanR / paralel,
        xOhmKm: _yaklasikX(kesit: kesit) / paralel,
        rYaklasik: r == null,
        xYaklasik: true,
        kaynak: paralel > 1
            ? 'Alüminyum R/X verileri $paralel paralel kablo için eşdeğer empedansa dönüştürüldü.'
            : (r == null
                ? 'Alüminyum R fiziksel modelle yaklaşık hesaplandı.'
                : 'Alüminyum R teknik direnç tablosundan alındı.'),
      );
    }

    if (iletkenTipi == 'Açık İletken') {
      final r = _acikIletkenR(secim);

      if (r != null && r > 0) {
        return _HatEmpedansSonucu(
          rOhmKm: r,
          xOhmKm: _yaklasikX(kesit: kesit),
          rYaklasik: false,
          xYaklasik: true,
          kaynak: 'Açık iletken direnç verisi.',
        );
      }
    }

    if (iletkenTipi == 'Alpek İletken') {
      return _HatEmpedansSonucu(
        rOhmKm: _fizikselR(
              kesit: kesit,
              bakir: false,
            ) /
            paralel,
        xOhmKm: _yaklasikX(kesit: kesit) / paralel,
        rYaklasik: true,
        xYaklasik: true,
        kaynak: paralel > 1
            ? 'ALPEK için fiziksel iletken modeli ve paralel kablo eşdeğeri kullanıldı.'
            : 'ALPEK için fiziksel iletken modeli.',
      );
    }

    if (iletkenTipi == 'N2XSY Kablo') {
      return _HatEmpedansSonucu(
        rOhmKm: _fizikselR(
              kesit: kesit,
              bakir: true,
            ) /
            paralel,
        xOhmKm: 0.10 / paralel,
        rYaklasik: true,
        xYaklasik: true,
        kaynak: paralel > 1
            ? 'OG bakır kablo için yaklaşık empedans modeli ve paralel kablo eşdeğeri kullanıldı.'
            : 'OG bakır kablo için yaklaşık empedans modeli.',
      );
    }

    if (iletkenTipi == 'NA2XSY Kablo') {
      return _HatEmpedansSonucu(
        rOhmKm: _fizikselR(
              kesit: kesit,
              bakir: false,
            ) /
            paralel,
        xOhmKm: 0.10 / paralel,
        rYaklasik: true,
        xYaklasik: true,
        kaynak: paralel > 1
            ? 'OG alüminyum kablo için yaklaşık empedans modeli ve paralel kablo eşdeğeri kullanıldı.'
            : 'OG alüminyum kablo için yaklaşık empedans modeli.',
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
        : 2.0 * current * r * distanceM;

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

    final u = gerilim == 'OG' ? ogVolt : (three ? agVolt : agMonoVolt);

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
            'Seçilen kesit için kapasite motoru sonuç üretemedi.',
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
                'Önerilen Kesit',
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

  double pf = 0.80;

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

  String _kesitAnahtari(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toString();
  }

  double? _rTablo(double s) {
    if (iletkenTipi == 'Bakır') {
      const data = <String, double>{
        '1.5': 14.5,
        '2.5': 8.87,
        '4': 5.52,
        '6': 3.69,
        '10': 2.19,
        '16': 1.38,
        '25': 0.870,
        '35': 0.627,
        '50': 0.463,
        '70': 0.321,
        '95': 0.232,
        '120': 0.184,
        '150': 0.150,
        '185': 0.121,
        '240': 0.0926,
      };

      return data[_kesitAnahtari(s)];
    }

    const data = <String, double>{
      '10': 3.08,
      '16': 1.91,
      '25': 1.20,
      '35': 0.868,
      '50': 0.641,
      '70': 0.443,
      '95': 0.320,
      '120': 0.253,
      '150': 0.206,
      '185': 0.164,
      '240': 0.125,
    };

    return data[_kesitAnahtari(s)];
  }

  double _fizikselR(double s) {
    final rho = iletkenTipi == 'Bakır' ? 0.0175 : 0.0282;

    final alpha = iletkenTipi == 'Bakır' ? 0.00393 : 0.00403;

    const hedefSicaklik = 70.0;

    final rho70 = rho * (1 + alpha * (hedefSicaklik - 20.0));

    return rho70 * 1000.0 / s;
  }

  double _yaklasikX(double s) {
    if (s <= 0) {
      return 0.08;
    }

    final x = 0.075 + 0.12 / sqrt(s);

    return x.isFinite && x > 0 ? x : 0.08;
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

    final u = three ? 400.0 : 230.0;

    final i = three ? p * 1000.0 / (sqrt(3.0) * u * pf) : p * 1000.0 / (u * pf);

    final rTablo = _rTablo(s);

    final rOhmKm = rTablo ?? _fizikselR(s);

    final xOhmKm = _yaklasikX(s);

    if (rOhmKm <= 0 || !rOhmKm.isFinite) {
      setState(() {
        hesaplandi = true;
        hesaplananYuzde = double.nan;
        hesaplananVolt = double.nan;
        durumText = 'Empedans hesabı yapılamadı';
        kaynak = 'İletken direnci hesaplanamadı.';
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

    final du =
        three ? sqrt(3.0) * i * ((r * pf) + (x * sinPhi)) * l : 2.0 * i * r * l;

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

      yaklasik = rTablo == null;

      kaynak = rTablo == null
          ? 'R değeri fiziksel iletken modeliyle yaklaşık hesaplandı.'
          : 'R değeri teknik direnç tablosundan alındı.';

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
          text:
              'Gerilim düşümü hesabında önce mevcut teknik direnç verileri kullanılır. '
              'Kesit için doğrulanmış direnç değeri bulunmadığında iletken özdirenci ve sıcaklık modeliyle yaklaşık direnç hesaplanabilir. '
              'Yaklaşık sonuçlar üretici katalog değeri olarak değerlendirilmemelidir.',
        ),
      ],
    );
  }
}
