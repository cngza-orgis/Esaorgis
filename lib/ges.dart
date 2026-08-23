part of 'main.dart';

class GesAnaEkrani extends StatefulWidget {
  const GesAnaEkrani({super.key});

  @override
  State<GesAnaEkrani> createState() => _GesAnaEkraniState();
}

class _GesAnaEkraniState extends State<GesAnaEkrani> {
  int sekme = 0;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'GES / Solar Sistemler',
      info: true,
      onInfo: () => bilgiPopup(
        context,
        'GES / Solar Sistemler',
        'Otomatik tasarım ve manuel sistem analizini tek çalışma alanında sunar. '
            'Gerçek proje; panel/inverter üretici verileri, DC/AC koruma, kablo, '
            'gölgeleme, statik ve bağlantı koşulları ile doğrulanmalıdır.',
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
            child: Row(
              children: [
                Expanded(
                  child: _seg('Otomatik Tasarım', 0),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _seg('Manuel Analiz', 1),
                ),
              ],
            ),
          ),
          Expanded(
            child: sekme == 0 ? const _GesOtomatikTab() : const _GesManuelTab(),
          ),
        ],
      ),
    );
  }

  Widget _seg(String text, int i) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => setState(() => sekme = i),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: sekme == i ? cIcon() : cCard(),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: cIcon().withValues(alpha: .35),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: sekme == i ? Colors.white : cText(),
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

// ================================================================
// GES OTOMATİK TASARIM EKRANI
// ================================================================

class GesOtomatikEkrani extends StatelessWidget {
  const GesOtomatikEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'GES — Otomatik Tasarım',
      info: true,
      onInfo: () => bilgiPopup(
        context,
        'GES Otomatik Tasarım',
        'Talep gücüne göre ön sistem tasarımı ve malzeme zinciri oluşturur. '
            'Çoklu inverter yapısında her inverterin AC çıkışı ayrı hat olarak '
            'AG pano barasına bağlanacak şekilde değerlendirilir.',
      ),
      body: const _GesOtomatikTab(),
    );
  }
}

// ================================================================
// GES MANUEL ANALİZ EKRANI
// ================================================================

class GesManuelEkrani extends StatelessWidget {
  const GesManuelEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'GES — Manuel Sistem Analizi',
      info: true,
      onInfo: () => bilgiPopup(
        context,
        'GES Manuel Analiz',
        'Mevcut panel, akü ve inverter bilgilerini kontrol eder.',
      ),
      body: const _GesManuelTab(),
    );
  }
}

// ================================================================
// GES - OTOMATİK SEKME
// ================================================================

class _GesOtomatikTab extends StatefulWidget {
  const _GesOtomatikTab();

  @override
  State<_GesOtomatikTab> createState() => _GesOtomatikTabState();
}

// ================================================================
// STANDART İNVERTER SEÇİMİ
// ================================================================

int standartInvertorBul(double kw) {
  const values = [
    5,
    10,
    15,
    20,
    25,
    30,
    40,
    50,
    60,
    75,
    100,
    125,
    150,
    200,
    250,
    320,
    350,
  ];

  final double target = kw <= 0 ? 5.0 : kw;

  return values.firstWhere(
    (v) => v >= target,
    orElse: () => values.last,
  );
}

int inverterAdediVeGuc(double gerekliAcKw) {
  if (gerekliAcKw <= 0) {
    return 1;
  }

  return (gerekliAcKw / 350).ceil();
}

// ================================================================
// İNVERTER AC HAT MODELİ
// ================================================================
//
// Çoklu inverter yapısında:
//
// İnverter 1 -> AC Hat 1 -> AG Pano Barası
// İnverter 2 -> AC Hat 2 -> AG Pano Barası
// İnverter 3 -> AC Hat 3 -> AG Pano Barası
// ...
//
// Her inverterin AC hattı bağımsız değerlendirilir.
//
// ================================================================

class _GesAcHat {
  final int inverterNo;
  final double gucKw;
  final double akimA;
  final String kablo;
  final int paralelAdet;

  const _GesAcHat({
    required this.inverterNo,
    required this.gucKw,
    required this.akimA,
    required this.kablo,
    required this.paralelAdet,
  });
}

// ================================================================
// OTOMATİK TAB STATE
// ================================================================

class _GesOtomatikTabState extends State<_GesOtomatikTab> {
  final _gucCtrl = TextEditingController();

  String sistemTipi = 'Şebeke Bağlantılı (On-Grid)';

  double panelW = 500;

  String bolge = 'Marmara';

  final _alanBoyCtrl = TextEditingController();

  final _alanEnCtrl = TextEditingController();

  double gunesSaat = 3.8;

  double? catiGuc;

  double kuruluGuc = 0;

  double alan = 0;

  int panelAdet = 0;

  int invertor = 0;

  int invertorAdedi = 1;

  double inverterToplamAc = 0;

  double tahminiYillikUretim = 0;

  double toplamAcAkim = 0;

  String depolama = "";

  String dcKablo = "";

  String panelBaglanti = "";

  String akuBaglanti = "";

  bool hesaplandi = false;

  List<_GesAcHat> acHatlari = const [];

  // ==============================================================
  // AC ÖN HESAP PARAMETRELERİ
  // ==============================================================

  static const double _acGerilim = esaAgThreePhaseVoltage;

  double acCosPhi = esaDefaultPowerFactor;
  String acSistemTipi = 'Trifaze';
  double inverterDcGerilim = 1000;

  static const List<double> inverterDcGerilimleri = [
    60,
    96,
    120,
    150,
    200,
    250,
    300,
    400,
    500,
    600,
    800,
    1000,
    1100,
    1200,
    1500,
  ];

  @override
  void dispose() {
    _gucCtrl.dispose();
    _alanBoyCtrl.dispose();
    _alanEnCtrl.dispose();
    super.dispose();
  }

  // ==============================================================
  // İNVERTER AC AKIMI
  // ==============================================================

  double _inverterAcAkimi(double gucKw) {
    if (gucKw <= 0) {
      return 0;
    }

    final double fazSayisiCarpani = acSistemTipi == 'Monofaze' ? 1.0 : sqrt(3);
    return gucKw * 1000 / (fazSayisiCarpani * _acGerilim * acCosPhi);
  }

  // ==============================================================
  // İNVERTER BAŞINA AC HAT OLUŞTURMA
  // ==============================================================

  List<_GesAcHat> _acHatlariniOlustur({
    required int inverterSayisi,
    required double inverterGucuKw,
  }) {
    if (inverterSayisi <= 0 || inverterGucuKw <= 0) {
      return const [];
    }

    final List<_GesAcHat> liste = [];

    for (int i = 1; i <= inverterSayisi; i++) {
      final double akim = _inverterAcAkimi(
        inverterGucuKw,
      );

      // Her inverter için ayrı kablo seçilir.
      //
      // Not:
      // Kesin seçimde üretici maksimum AC çıkış akımı,
      // döşeme şekli, ortam sıcaklığı, gruplanma,
      // gerilim düşümü ve kısa devre şartları
      // ayrıca doğrulanmalıdır.

      final String kablo = standartKabloBulNYY(
        akim,
        true,
      );

      const int paralel = 1;

      liste.add(
        _GesAcHat(
          inverterNo: i,
          gucKw: inverterGucuKw,
          akimA: akim,
          kablo: kablo,
          paralelAdet: paralel,
        ),
      );
    }

    return liste;
  }

  // ==============================================================
  // ANA HESAPLAMA
  // ==============================================================

  void hesapla() {
    FocusManager.instance.primaryFocus?.unfocus();

    final double p = double.tryParse(
          _gucCtrl.text.replaceAll(',', '.'),
        ) ??
        0;

    if (p <= 0 || panelW <= 0) {
      setState(() {
        hesaplandi = false;
        acHatlari = const [];
      });
      return;
    }

    // ============================================================
    // DC GÜÇ
    // ============================================================

    final double kG = p * 1.2;

    final int pAdet = ((kG * 1000) / panelW).ceil();

    // ============================================================
    // İNVERTER KURGUSU
    // ============================================================

    final double hedefAc = p;

    final int invCount = inverterAdediVeGuc(
      hedefAc,
    );

    final double grupAcKw = hedefAc / invCount;

    final int inv = standartInvertorBul(
      grupAcKw,
    );

    // ÖNEMLİ:
    // invCount ve inv int olduğu için sonuç double'a
    // açık şekilde çevriliyor.
    final double invTotal = invCount.toDouble() * inv.toDouble();

    // ============================================================
    // PANEL DC PARAMETRELERİ
    // ============================================================

    const double vmp = 40.0;

    final double imp = panelW / vmp;

    String pBaglanti = "";

    if (sistemTipi == 'Şebeke Bağlantılı (On-Grid)') {
      final int seriAdet = min(
        pAdet,
        14,
      );

      final int paralelAdet = (pAdet / seriAdet).ceil();

      pBaglanti = "$seriAdet Seri x "
          "$paralelAdet Paralel Grup\n"
          "(~${(seriAdet * vmp).toInt()}V DC / "
          "~${(paralelAdet * imp).toInt()}A)";
    } else {
      const int seriAdet = 3;

      final int paralelAdet = (pAdet / seriAdet).ceil();

      pBaglanti = "$seriAdet Seri x "
          "$paralelAdet Paralel Grup\n"
          "(~${(seriAdet * vmp).toInt()}V DC / "
          "~${(paralelAdet * imp).toInt()}A)";
    }

    // ============================================================
    // DEPOLAMA
    // ============================================================

    String depo = "-";

    String aBaglanti = "-";

    if (sistemTipi == 'Şebeke Bağlantılı (On-Grid)') {
      depo = t(
        "- (Şebekeye Satış / Mahsuplaşma)",
        "- (Grid Tied / Net Metering)",
      );
    } else if (sistemTipi == 'Şebekesiz Doğrudan Kullanım (Aküsüz)') {
      depo = t(
        "- (Sadece Gündüz Doğrudan Kullanım)",
        "- (Daytime Direct Use Only)",
      );
    } else if (sistemTipi == 'Şebekesiz + Akülü (Off-Grid)') {
      final double depokWh = p * 4;

      depo = "${depokWh.toStringAsFixed(1)} kWh "
          "${t('Kapasite İhtiyacı', 'Required Capacity')}";

      int akuAdet = (depokWh / 2.4).ceil();

      while (akuAdet % 4 != 0) {
        akuAdet++;
      }

      final int paralelKol = akuAdet ~/ 4;

      aBaglanti = "$akuAdet Adet (12V 200Ah)\n"
          "4 Seri x $paralelKol Paralel -> 48V Sistem";
    }

    // ============================================================
    // ÇATI
    // ============================================================

    final double boy = double.tryParse(
          _alanBoyCtrl.text.replaceAll(',', '.'),
        ) ??
        0;

    final double en = double.tryParse(
          _alanEnCtrl.text.replaceAll(',', '.'),
        ) ??
        0;

    final double catiAlan = boy > 0 && en > 0 ? boy * en : 0;

    final double catiUygunPanel =
        catiAlan > 0 ? (catiAlan / (2.5 * 1.15)).floorToDouble() : 0;

    final double catiGucHesabi =
        catiUygunPanel > 0 ? catiUygunPanel * panelW / 1000 : 0;

    // ============================================================
    // YILLIK ÜRETİM
    // ============================================================

    final double yillikUretim =
        (pAdet * panelW / 1000) * gunesSaat * 365 * 0.80;

    // ============================================================
    // ÇOKLU İNVERTER AC HATLARI
    // ============================================================

    final List<_GesAcHat> yeniAcHatlari = _acHatlariniOlustur(
      inverterSayisi: invCount,
      inverterGucuKw: inv.toDouble(),
    );

    // AG pano barasına gelen bütün inverter hatlarının
    // toplam akımı.
    final double yeniToplamAcAkim = yeniAcHatlari.fold<double>(
      0,
      (
        sum,
        hat,
      ) =>
          sum + hat.akimA,
    );

    // ============================================================
    // DC KABLO
    // ============================================================

    final String yeniDcKablo =
        p <= 10 ? "4 mm² Solar Kablo" : "6 mm² Solar Kablo";

    // ============================================================
    // STATE
    // ============================================================

    setState(() {
      catiGuc = catiGucHesabi > 0 ? catiGucHesabi : null;

      kuruluGuc = (pAdet * panelW) / 1000;

      panelAdet = pAdet;

      invertor = inv;

      invertorAdedi = invCount;

      inverterToplamAc = invTotal;

      toplamAcAkim = yeniToplamAcAkim;

      acHatlari = yeniAcHatlari;

      tahminiYillikUretim = yillikUretim;

      depolama = depo;

      alan = pAdet * 2.5 * 1.15;

      dcKablo = yeniDcKablo;

      panelBaglanti = pBaglanti;

      akuBaglanti = aBaglanti;

      hesaplandi = true;
    });
  }

  // ==============================================================
  // AC HAT SONUÇ KARTI
  // ==============================================================

  Widget _acHatCard(
    _GesAcHat hat,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        bottom: 8,
      ),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cCard(),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: cIcon().withValues(
            alpha: .30,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.electrical_services_rounded,
                color: cIcon(),
                size: 22,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'İnverter ${hat.inverterNo} → AG Pano Barası',
                  style: TextStyle(
                    color: cText(),
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'İnverter gücü: '
            '${fmt2(hat.gucKw)} kW',
            style: TextStyle(
              color: cText(),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'Hesaplanan AC akımı: '
            '${fmt2(hat.akimA)} A',
            style: TextStyle(
              color: cText(),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'AC kablo ön seçimi: '
            '${hat.kablo}',
            style: TextStyle(
              color: cText(),
              fontSize: 12,
            ),
          ),
          if (hat.paralelAdet > 1) ...[
            const SizedBox(height: 3),
            Text(
              'Paralel kablo: '
              '${hat.paralelAdet} hat',
              style: TextStyle(
                color: cIcon(),
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ==============================================================
  // BUILD
  // ==============================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cInputBg(),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            twoCol(
              Field(
                controller: _gucCtrl,
                label: t(
                  'Talep Gücü (kW)',
                  'Demand Power (kW)',
                ),
              ),
              Drop(
                label: t(
                  'Sistem Tipi',
                  'System Type',
                ),
                value: sistemTipi,
                items: const [
                  'Şebeke Bağlantılı (On-Grid)',
                  'Şebekesiz + Akülü (Off-Grid)',
                  'Şebekesiz Doğrudan Kullanım (Aküsüz)',
                ],
                onChanged: (v) {
                  setState(() {
                    sistemTipi = v ?? sistemTipi;
                    hesaplandi = false;
                  });
                },
              ),
            ),
            const SizedBox(height: 10),
            twoCol(
              Drop(
                label: 'AC Sistem Tipi',
                value: acSistemTipi,
                items: const ['Monofaze', 'Trifaze'],
                onChanged: (v) {
                  setState(() {
                    acSistemTipi = v ?? acSistemTipi;
                    hesaplandi = false;
                  });
                },
              ),
              Drop(
                label: 'İnverter DC Giriş Gerilimi',
                value: inverterDcGerilim.toStringAsFixed(0),
                items: inverterDcGerilimleri
                    .map((e) => e.toStringAsFixed(0))
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    inverterDcGerilim =
                        double.tryParse(v ?? '') ?? inverterDcGerilim;
                    hesaplandi = false;
                  });
                },
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 6),
              decoration: BoxDecoration(
                color: cCard(),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: cIcon().withValues(alpha: .28)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Güç Faktörü (cosφ)',
                          style: TextStyle(
                            color: cText(),
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Text(
                        acCosPhi.toStringAsFixed(2),
                        style: TextStyle(
                          color: cIcon(),
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: acCosPhi.clamp(.70, 1.00),
                    min: .70,
                    max: 1.00,
                    divisions: 30,
                    activeColor: cIcon(),
                    inactiveColor: cIcon().withValues(alpha: .18),
                    label: acCosPhi.toStringAsFixed(2),
                    onChanged: (v) {
                      setState(() {
                        acCosPhi = double.parse(v.toStringAsFixed(2));
                        hesaplandi = false;
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('0.70', style: TextStyle(color: cText().withValues(alpha: .72), fontSize: 11)),
                        Text('0.80 varsayılan', style: TextStyle(color: cIcon(), fontSize: 11, fontWeight: FontWeight.w800)),
                        Text('1.00', style: TextStyle(color: cText().withValues(alpha: .72), fontSize: 11)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'AC inverter akımı hesabında seçilen değer kullanılır.',
                    style: TextStyle(color: cText().withValues(alpha: .68), fontSize: 11.3, height: 1.3),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            twoCol(
              Drop(
                label: 'Türkiye Coğrafi Bölgesi',
                value: bolge,
                items: const [
                  'Marmara',
                  'Ege',
                  'Akdeniz',
                  'İç Anadolu',
                  'Karadeniz',
                  'Doğu Anadolu',
                  'Güneydoğu Anadolu',
                ],
                onChanged: (v) {
                  if (v == null) return;

                  setState(() {
                    bolge = v;

                    gunesSaat = {
                          'Marmara': 3.8,
                          'Ege': 4.5,
                          'Akdeniz': 5.0,
                          'İç Anadolu': 4.2,
                          'Karadeniz': 3.2,
                          'Doğu Anadolu': 4.0,
                          'Güneydoğu Anadolu': 5.5,
                        }[bolge] ??
                        3.8;

                    hesaplandi = false;
                  });
                },
              ),
              Drop(
                label: 'Günlük Güneşlenme',
                value: gunesSaat.toString(),
                items: const [
                  '3.0',
                  '3.2',
                  '3.5',
                  '3.8',
                  '4.0',
                  '4.2',
                  '4.5',
                  '5.0',
                  '5.5',
                  '6.0',
                ],
                onChanged: (v) {
                  if (v == null) return;

                  setState(() {
                    gunesSaat = double.tryParse(v) ?? 3.8;

                    hesaplandi = false;
                  });
                },
              ),
            ),
            twoCol(
              Field(
                controller: _alanBoyCtrl,
                label: 'Çatı Boyu (m)',
              ),
              Field(
                controller: _alanEnCtrl,
                label: 'Çatı Eni (m)',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${t('Kullanılacak Panel Gücü', 'Panel Rating (Wp)')}: '
              '${panelW.toInt()} Wp',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: cText(),
              ),
            ),
            Slider(
              value: panelW,
              min: 0,
              max: 1000,
              divisions: 100,
              activeColor: cIcon(),
              onChanged: (v) {
                setState(() {
                  panelW = v;
                  hesaplandi = false;
                });
              },
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: hesapla,
              child: Text(
                t(
                  'SİSTEM OLUŞTUR',
                  'GENERATE SYSTEM',
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (hesaplandi)
              Column(
                children: [
                  uiResultCard(
                    'AC Sistem / Güç Faktörü',
                    '$acSistemTipi • cosφ ${acCosPhi.toStringAsFixed(2)}',
                    'AC inverter akımı hesabında kullanıcı tarafından seçilen değer kullanılır.',
                  ),

                  uiResultCard(
                    'İnverter DC Giriş Gerilimi',
                    '${inverterDcGerilim.toStringAsFixed(0)} V DC',
                    'String tasarımı inverterin izin verilen DC gerilim/akım sınırları ile ayrıca doğrulanmalıdır.',
                  ),

                  uiResultCard(
                    t(
                      'İnvertör Kurgusu',
                      'Inverter Configuration',
                    ),
                    '$invertorAdedi × '
                        '$invertor kW = '
                        '${inverterToplamAc.toStringAsFixed(0)} kW AC',
                    'Her inverter ayrı AC çıkış hattı ile AG pano barasına bağlanır.',
                  ),

                  uiResultCard(
                    t(
                      'Panel Gücü ve Sayısı',
                      'Panel Pwr. & Count',
                    ),
                    kuruluGuc.toStringAsFixed(2),
                    'kWp DC (${panelAdet.toString()} Adet)',
                  ),

                  uiResultCard(
                    'Tahmini Yıllık Üretim',
                    fmt2(
                      tahminiYillikUretim,
                    ),
                    'kWh/yıl • seçilen güneşlenme değeri ve %80 performans oranı ile ön tahmin',
                  ),

                  uiResultCard(
                    t(
                      'Panel Teknik Bilgisi',
                      'Panel Technical Data',
                    ),
                    '${panelW.toInt()} Wp • '
                        'yaklaşık 40 Vmp • '
                        '${fmt2(panelW / 40)} A',
                    '',
                  ),

                  const AdviceCard(
                    title: 'İnvertör seçimi notu',
                    text: 'Tek invertör için sabit 200 kW sınırı kullanılmaz. '
                        'Güncel ürünlerde 320/350 kW sınıfı string inverterler '
                        'bulunabilir; daha yüksek santral güçlerinde paralel '
                        'inverterler, blok tasarımı ve OG/MV istasyonu birlikte '
                        'değerlendirilir. Kesin adet; DC/AC oranı, MPPT '
                        'gerilim/akım sınırları, şebeke bağlantı koşulları ve '
                        'üretici tasarım yazılımı ile doğrulanmalıdır.',
                  ),

                  uiResultCard(
                    t(
                      'Panel Bağlantı Şekli',
                      'Panel Array Connection',
                    ),
                    panelBaglanti,
                    '',
                  ),

                  if (sistemTipi == 'Şebekesiz + Akülü (Off-Grid)')
                    uiResultCard(
                      t(
                        'Gerekli Depolama (Battery/Akü)',
                        'Required Battery Storage',
                      ),
                      depolama,
                      '',
                    ),

                  if (sistemTipi == 'Şebekesiz + Akülü (Off-Grid)')
                    uiResultCard(
                      t(
                        'Akü Bankası Kurgusu',
                        'Battery Bank Connection',
                      ),
                      akuBaglanti,
                      '',
                    ),

                  if (sistemTipi != 'Şebekesiz + Akülü (Off-Grid)')
                    uiResultCard(
                      t(
                        'Gerekli Depolama Durumu',
                        'Required Battery Storage',
                      ),
                      depolama,
                      '',
                    ),

                  uiResultCard(
                    t(
                      'Gerekli Çatı / Saha Alanı',
                      'Est. Roof/Field Area',
                    ),
                    alan.toStringAsFixed(1),
                    'm² (yürüyüş yolu payı %15)',
                  ),

                  if (catiGuc != null)
                    uiResultCard(
                      'Girilen Çatı Alanıyla Tahmini Güç',
                      fmt2(catiGuc!),
                      'kWp DC',
                    ),

                  uiResultCard(
                    t(
                      'DC Solar Kablo Kesiti',
                      'DC Solar Cable Section',
                    ),
                    dcKablo,
                    '',
                  ),

                  // ==================================================
                  // İNVERTER AC HATLARI
                  // ==================================================

                  SectionCard(
                    title: 'İnverter AC Hatları',
                    children: [
                      Text(
                        'Çoklu inverter yapısında her inverterin AC çıkışı '
                        'ayrı bir hat olarak AG pano barasına bağlanır. '
                        'Her hat kendi inverterinin AC akımına göre '
                        'ayrı değerlendirilir.',
                        style: TextStyle(
                          color: cText().withValues(
                            alpha: .72,
                          ),
                          fontSize: 11.5,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ...acHatlari.map(
                        _acHatCard,
                      ),
                    ],
                  ),

                  // ==================================================
                  // AG PANO BARA
                  // ==================================================

                  uiResultCard(
                    'AG Pano Bara Toplam AC Akımı',
                    fmt2(
                      toplamAcAkim,
                    ),
                    'A • tüm inverter AC hatlarının toplam ön hesap akımı',
                  ),

                  const AdviceCard(
                    title: 'AC kablo ve bara teknik notu',
                    text: 'Çoklu inverterli GES sistemlerinde her inverterin '
                        'AC çıkışı ayrı bir devre olarak AG pano barasına '
                        'getirilmelidir. Her inverter hattının kablo ve '
                        'koruma elemanları ilgili inverterin kendi AC çıkış '
                        'akımına göre değerlendirilir. AG pano barası ve '
                        'ana çıkış ise bağlı inverter hatlarının toplam '
                        'yüküne göre ayrıca değerlendirilir. '
                        'Bu ekrandaki kablo seçimi ön seçim niteliğindedir. '
                        'Kesin seçimde inverter üreticisinin maksimum AC '
                        'çıkış akımı, kablo üretici akım taşıma tabloları, '
                        'döşeme şekli, ortam sıcaklığı, gruplanma, gerilim '
                        'düşümü, kısa devre dayanımı ve proje şartları '
                        'kontrol edilmelidir.',
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

// ================================================================
// GES - MANUEL SEKME
// ================================================================

class _GesManuelTab extends StatefulWidget {
  const _GesManuelTab();

  @override
  State<_GesManuelTab> createState() => _GesManuelTabState();
}

class _GesManuelTabState extends State<_GesManuelTab> {
  final _panelGucuCtrl = TextEditingController();

  final _panelAdetCtrl = TextEditingController();

  final _akuAhCtrl = TextEditingController();

  final _akuAdetCtrl = TextEditingController();

  final _invGucuCtrl = TextEditingController();

  String akuTipi = 'Jel';

  String invTipi = 'Off-Grid';

  String uretimBilgisi = "";

  String hataVeTavsiyeler = "";

  bool hesaplandi = false;

  @override
  void dispose() {
    _panelGucuCtrl.dispose();
    _panelAdetCtrl.dispose();
    _akuAhCtrl.dispose();
    _akuAdetCtrl.dispose();
    _invGucuCtrl.dispose();
    super.dispose();
  }

  void analizEt() {
    FocusManager.instance.primaryFocus?.unfocus();

    final double pGuc = double.tryParse(
          _panelGucuCtrl.text.replaceAll(',', '.'),
        ) ??
        0;

    final int pAdet = int.tryParse(
          _panelAdetCtrl.text,
        ) ??
        0;

    final double aAh = double.tryParse(
          _akuAhCtrl.text.replaceAll(',', '.'),
        ) ??
        0;

    final int aAdet = int.tryParse(
          _akuAdetCtrl.text,
        ) ??
        0;

    final double iGuc = double.tryParse(
          _invGucuCtrl.text.replaceAll(',', '.'),
        ) ??
        0;

    if (pGuc == 0 || pAdet == 0 || iGuc == 0) {
      setState(
        () => hesaplandi = false,
      );
      return;
    }

    final double toplamPanelkW = (pGuc * pAdet) / 1000;

    final double gunlukUretimkWh = toplamPanelkW * 4.5;

    final double toplamAkukWh = (12 * aAh * aAdet) / 1000;

    final List<String> tavsiyeler = [];

    // ============================================================
    // İNVERTER / AKÜ KONTROLÜ
    // ============================================================

    if (invTipi == 'On-Grid' && aAdet > 0) {
      tavsiyeler.add(
        t(
          "On-Grid (Şebeke Bağlantılı) sistemlerde genellikle akü kullanılmaz. "
              "Akü kullanacaksanız invertör tipini 'Hibrit' olarak değiştirmeniz tavsiye edilir.",
          "Batteries aren't typically used in On-Grid systems. "
              "Choose 'Hybrid' if batteries are needed.",
        ),
      );
    }

    // ============================================================
    // PANEL / İNVERTER KAPASİTE KONTROLÜ
    // ============================================================

    if (toplamPanelkW > iGuc * 1.3) {
      tavsiyeler.add(
        t(
          "Panel gücünüz "
              "(${toplamPanelkW.toStringAsFixed(1)} kW), "
              "invertör kapasitenizin ($iGuc kW) çok üzerinde. "
              "Güvenli çalışma için invertör gücünü en az "
              "${toplamPanelkW.toStringAsFixed(1)} kW seviyesine çıkarmanız tavsiye edilir.",
          "Panel power exceeds inverter capacity significantly. "
              "Upgrade the inverter.",
        ),
      );
    } else if (iGuc > toplamPanelkW * 2) {
      tavsiyeler.add(
        t(
          "İnvertör gücünüz ($iGuc kW), mevcut panel gücüne göre gereğinden fazla büyük. "
              "Bu durum düşük verimle çalışmaya sebep olabilir.",
          "Inverter capacity is oversized for the panels, which may reduce efficiency.",
        ),
      );
    }

    // ============================================================
    // DEPOLAMA KONTROLÜ
    // ============================================================

    if (invTipi != 'On-Grid') {
      if (aAdet == 0) {
        tavsiyeler.add(
          t(
            "Off-Grid / Hibrit sistemlerde enerji depolaması (akü) olmadan sistem güneşsiz anlarda çalışmaz. "
                "Şebeke desteği yoksa Akü eklemeniz tavsiye edilir.",
            "Off-Grid/Hybrid systems require batteries for operation without sun/grid.",
          ),
        );
      } else {
        if (toplamAkukWh < gunlukUretimkWh * 0.3) {
          tavsiyeler.add(
            t(
              "Akü kapasiteniz "
                  "(${toplamAkukWh.toStringAsFixed(1)} kWh) "
                  "üretilen enerjiyi depolamak için yetersiz kalabilir. "
                  "Akü sayısını veya kapasitesini artırmanız tavsiye edilir.",
              "Battery capacity is insufficient for the generated energy. "
                  "Consider expanding the battery bank.",
            ),
          );
        }

        if (akuTipi == 'Jel') {
          tavsiyeler.add(
            t(
              "Bilgi: Jel akülerin döngü ömrünü korumak için toplam kapasitesinin en fazla %50'sini "
                  "(Half-Cycle) kullanmanız önerilir.",
              "Info: To preserve cycle life, use max 50% of Gel battery capacity.",
            ),
          );
        }
      }
    }

    final String hataMetni = tavsiyeler.isEmpty
        ? t(
            "Sistem tasarımı teknik açıdan uyumlu ve dengeli görünüyor.",
            "System design looks technically compatible and balanced.",
          )
        : tavsiyeler
            .map(
              (e) => "• $e",
            )
            .join("\n\n");

    setState(() {
      uretimBilgisi = t(
        "Kurulu Panel Gücü: "
            "${toplamPanelkW.toStringAsFixed(2)} kW\n"
            "Tahmini Günlük Üretim: "
            "${gunlukUretimkWh.toStringAsFixed(2)} kWh\n"
            "Toplam Depolama (Akü): "
            "${toplamAkukWh.toStringAsFixed(2)} kWh",
        "Total Panel Power: "
            "${toplamPanelkW.toStringAsFixed(2)} kW\n"
            "Est. Daily Prod.: "
            "${gunlukUretimkWh.toStringAsFixed(2)} kWh\n"
            "Total Storage (Bat): "
            "${toplamAkukWh.toStringAsFixed(2)} kWh",
      );

      hataVeTavsiyeler = hataMetni;

      hesaplandi = true;
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cInputBg(),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _panelGucuCtrl,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      color: cText(),
                    ),
                    decoration: customInputDec(
                      t(
                        'Panel Gücü (Wp)',
                        'Panel Power (Wp)',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _panelAdetCtrl,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      color: cText(),
                    ),
                    decoration: customInputDec(
                      t(
                        'Panel Adedi',
                        'Panel Count',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _invGucuCtrl,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      color: cText(),
                    ),
                    decoration: customInputDec(
                      t(
                        'İnvertör Gücü (kW)',
                        'Inv. Power (kW)',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Drop(
                    label: t(
                      'İnvertör Tipi',
                      'Inv. Type',
                    ),
                    value: invTipi,
                    items: const [
                      'Off-Grid',
                      'On-Grid',
                      'Hibrit',
                    ],
                    onChanged: (v) {
                      if (v == null) {
                        return;
                      }

                      setState(() {
                        invTipi = v;
                        hesaplandi = false;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _akuAhCtrl,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      color: cText(),
                    ),
                    decoration: customInputDec(
                      t(
                        '1 Akü Akımı (Ah)',
                        '1 Bat. Current (Ah)',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _akuAdetCtrl,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      color: cText(),
                    ),
                    decoration: customInputDec(
                      t(
                        'Akü Adedi',
                        'Battery Count',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Drop(
              label: t(
                'Akü Tipi (Teknoloji)',
                'Battery Tech',
              ),
              value: akuTipi,
              items: const [
                'Jel',
                'Lityum',
              ],
              onChanged: (v) {
                if (v == null) {
                  return;
                }

                setState(() {
                  akuTipi = v;
                  hesaplandi = false;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: analizEt,
              child: Text(
                t(
                  'SİSTEMİ ANALİZ ET',
                  'ANALYZE SYSTEM',
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (hesaplandi)
              Column(
                children: [
                  ...resultSectionCardsFromText(
                    uretimBilgisi,
                    fallbackTitle: 'Sistem Performansı',
                    icons: const [Icons.solar_power_outlined],
                  ),
                  ResultCard(
                    title: 'Değerlendirme',
                    value: hataVeTavsiyeler,
                    subtitle: hataVeTavsiyeler.contains(
                      '•',
                    )
                        ? 'Teknik kontrol / revizyon gerekli'
                        : 'Ön değerlendirmede belirgin uyumsuzluk görülmedi',
                    good: !hataVeTavsiyeler.contains(
                      '•',
                    ),
                    error: hataVeTavsiyeler.contains(
                      '•',
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

// ================================================================
// ÇATI ALANINDAN TASARIM
// ================================================================

class GesCatiTasarimEkrani extends StatefulWidget {
  const GesCatiTasarimEkrani({
    super.key,
  });

  @override
  State<GesCatiTasarimEkrani> createState() => _GesCatiTasarimEkraniState();
}

class _GesCatiTasarimEkraniState extends State<GesCatiTasarimEkrani> {
  final en = TextEditingController(
    text: '20',
  );

  final boy = TextEditingController(
    text: '30',
  );

  final panel = TextEditingController(
    text: '550',
  );

  final yatirim = TextEditingController();

  final maliyetKwp = TextEditingController(
    text: '650',
  );

  String bolge = 'İç Anadolu';

  String sonuc = '';

  final factors = const {
    'Marmara': 3.7,
    'Ege': 4.2,
    'Akdeniz': 4.5,
    'İç Anadolu': 4.3,
    'Karadeniz': 3.2,
    'Doğu Anadolu': 4.0,
    'Güneydoğu Anadolu': 4.6,
  };

  @override
  void dispose() {
    en.dispose();
    boy.dispose();
    panel.dispose();
    yatirim.dispose();
    maliyetKwp.dispose();
    super.dispose();
  }

  // ==============================================================
  // ÇATI HESAPLAMA
  // ==============================================================

  void hesapla() {
    final double w = double.tryParse(
          en.text.replaceAll(
            ',',
            '.',
          ),
        ) ??
        0;

    final double h = double.tryParse(
          boy.text.replaceAll(
            ',',
            '.',
          ),
        ) ??
        0;

    final double pw = double.tryParse(
          panel.text.replaceAll(
            ',',
            '.',
          ),
        ) ??
        0;

    final double usdKwp = double.tryParse(
          maliyetKwp.text.replaceAll(
            ',',
            '.',
          ),
        ) ??
        0;

    if (w <= 0 || h <= 0 || pw <= 0 || usdKwp <= 0) {
      setState(
        () => sonuc = 'Giriş değerlerini kontrol edin.',
      );
      return;
    }

    final double area = w * h;

    final double usable = area * 0.875;

    const double pArea = 2.2;

    final int n = (usable / pArea).floor();

    final double dc = n * pw / 1000;

    final int invCount = inverterAdediVeGuc(
      dc * 0.9,
    );

    final int invUnit = standartInvertorBul(
      min(
        dc * 0.9,
        350,
      ),
    );

    // HATA DÜZELTİLDİ:
    // int × int sonucu double değişkene doğrudan atanmaz.
    final double invTotal = invCount.toDouble() * invUnit.toDouble();

    final double daily = dc * (factors[bolge] ?? 4.0) * 0.8;

    final double annual = daily * 365;

    final double tahminiMaliyet = dc * usdKwp;

    final double userBudget = double.tryParse(
          yatirim.text.replaceAll(
            ',',
            '.',
          ),
        ) ??
        0;

    final double fark = userBudget > 0 ? tahminiMaliyet - userBudget : 0;

    final double oran =
        userBudget > 0 ? (tahminiMaliyet / userBudget * 100) : 0;

    setState(
      () {
        sonuc = 'Çatı alanı: '
            '${fmt2(area)} m²\n'
            'Yürüyüş/servis payı sonrası kullanılabilir alan: '
            '${fmt2(usable)} m²\n'
            'Panel adedi: $n\n'
            'Kurulu DC güç: '
            '${fmt2(dc)} kWp\n'
            'İnvertör kurgusu: '
            '$invCount × $invUnit kW = '
            '${fmt2(invTotal)} kW AC\n'
            'AC kurgu: Her inverter ayrı AC hat ile AG pano barasına bağlanır.\n'
            'Tahmini yıllık üretim: '
            '${fmt2(annual)} kWh/yıl\n\n'
            'Yaklaşık yatırım maliyeti: '
            '${fmt2(tahminiMaliyet)} USD '
            '(${fmt2(usdKwp)} USD/kWp varsayımı)\n'
            '${userBudget > 0 ? 'Kullanıcı yatırım bütçesi: ${fmt2(userBudget)} USD\n'
                'Bütçe farkı: ${fmt2(fark)} USD\n'
                'Tahmini maliyet / bütçe: %${fmt2(oran)}' : 'Kullanıcı yatırım bütçesi girilmedi.'}\n\n'
            'DC koruma: string sigortası + DC ayırıcı + SPD değerlendirmesi\n'
            'AC koruma: AC şalter/sigorta + ayırıcı + SPD değerlendirmesi';
      },
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return AppScaffold(
      title: 'Çatı Alanından Tasarım',
      info: true,
      onInfo: () => bilgiPopup(
        context,
        'Çatı Alanından Tasarım',
        'Çatı eni ve boyundan kurulabilecek yaklaşık panel gücünü çıkarır. '
            'Servis/yürüyüş alanı için %12,5 varsayımı kullanılır. '
            'Maliyet USD/kWp varsayımıdır ve kullanıcı tarafından güncellenebilir; '
            'çevrimdışı uygulamada canlı piyasa fiyatı iddia edilmez. '
            'Çoklu inverter yapısında her inverterin AC çıkışı ayrı hat olarak '
            'AG pano barasına değerlendirilmelidir.',
      ),
      body: ScrollBody(
        children: [
          SectionCard(
            title: 'Çatı Bilgileri',
            children: [
              twoCol(
                Field(
                  controller: en,
                  label: 'Çatı Eni (m)',
                ),
                Field(
                  controller: boy,
                  label: 'Çatı Boyu (m)',
                ),
              ),
              twoCol(
                Field(
                  controller: panel,
                  label: 'Panel Gücü (Wp)',
                ),
                Drop(
                  label: 'Türkiye Bölgesi',
                  value: bolge,
                  items: factors.keys.toList(),
                  onChanged: (v) {
                    if (v == null) {
                      return;
                    }

                    setState(
                      () => bolge = v,
                    );
                  },
                ),
              ),
              twoCol(
                Field(
                  controller: maliyetKwp,
                  label: 'Maliyet varsayımı (USD/kWp)',
                ),
                Field(
                  controller: yatirim,
                  label: 'Kullanıcı yatırım bütçesi (USD) — isteğe bağlı',
                ),
              ),
              calcButton(
                'OTOMATİK TASARLA',
                hesapla,
              ),
            ],
          ),
          if (sonuc.isNotEmpty) ...[
            const SizedBox(height: 4),
            ...resultSectionCardsFromText(
              sonuc,
              fallbackTitle: 'Çatı Tasarımı Sonucu',
              fallbackNote: 'Üretim ve maliyet değerleri ön tasarım niteliğindedir. Panel yerleşimi, gölgelenme, statik koşullar, inverter/koruma seçimi ve saha uygulaması ayrıca doğrulanmalıdır.',
              icons: const [
                Icons.roofing,
                Icons.solar_power_outlined,
                Icons.electrical_services_outlined,
              ],
            ),
          ],
          const AdviceCard(
            title: 'Teknik not',
            text:
                'Üretim değeri bölgesel bir ön tahmindir; gerçek sonuç panel yönü/eğimi, '
                'gölgelenme, sıcaklık, inverter verimi ve saha koşullarına göre değişir. '
                'Çoklu inverter sistemlerinde her inverterin AC çıkış hattı ayrı '
                'değerlendirilmeli, AG pano barası toplam akıma göre ayrıca kontrol edilmelidir.',
          ),
        ],
      ),
    );
  }
}

// ================================================================
// FAZ 9 — GES AYRI ARAÇLAR
// ================================================================

class GesStringTasarimEkrani extends StatefulWidget {
  const GesStringTasarimEkrani({super.key});
  @override
  State<GesStringTasarimEkrani> createState() => _GesStringTasarimEkraniState();
}

class _GesStringTasarimEkraniState extends State<GesStringTasarimEkrani> {
  final panelVmp = TextEditingController(text: '40');
  final panelVoc = TextEditingController(text: '49');
  final panelImp = TextEditingController(text: '13');
  final panelAdet = TextEditingController(text: '20');
  String sistem = 'Trifaze';
  double invVmax = 1000;
  String sonuc = '';

  @override
  void dispose() {
    panelVmp.dispose();
    panelVoc.dispose();
    panelImp.dispose();
    panelAdet.dispose();
    super.dispose();
  }

  void hesapla() {
    final vmp = double.tryParse(panelVmp.text.replaceAll(',', '.')) ?? 0;
    final voc = double.tryParse(panelVoc.text.replaceAll(',', '.')) ?? 0;
    final imp = double.tryParse(panelImp.text.replaceAll(',', '.')) ?? 0;
    final n = int.tryParse(panelAdet.text) ?? 0;
    if (vmp <= 0 || voc <= 0 || imp <= 0 || n <= 0) {
      setState(() => sonuc = 'Giriş değerlerini kontrol edin.');
      return;
    }
    int maxSeries = max(1, (invVmax / voc).floor());
    int minSeries = max(1, (invVmax * 0.65 / vmp).ceil());
    int series = min(maxSeries, max(minSeries, 1));
    if (series > n) series = n;
    int parallel = (n / series).ceil();
    final actualVmp = series * vmp;
    final actualVoc = series * voc;
    final actualCurrent = parallel * imp;
    final voltageOk = actualVoc <= invVmax;
    setState(() {
      sonuc = 'Önerilen kurgu: $series seri × $parallel paralel\n'
          'Vmp string: ${fmt2(actualVmp)} V\n'
          'Voc string: ${fmt2(actualVoc)} V\n'
          'Toplam DC akım: ${fmt2(actualCurrent)} A\n'
          'İnverter DC gerilim sınırı: ${fmt2(invVmax)} V\n'
          'Gerilim kontrolü: ${voltageOk ? 'Uygun ön aralık' : 'Uygun değil'}\n'
          'Not: MPPT çalışma aralığı, maksimum DC akım, soğukta Voc artışı ve üretici sınırları ayrıca kontrol edilmelidir.';
    });
  }

  @override
  Widget build(BuildContext context) => _GesToolScaffold(
        title: 'GES String Tasarımı',
        info:
            'Panel seri/paralel kurgusunu inverter DC gerilim sınırına göre ön hesaplar. Kesin tasarımda üretici MPPT ve maksimum DC akım sınırları doğrulanmalıdır.',
        child: Column(children: [
          twoCol(Field(controller: panelVmp, label: 'Panel Vmp (V)'),
              Field(controller: panelVoc, label: 'Panel Voc (V)')),
          twoCol(Field(controller: panelImp, label: 'Panel Imp (A)'),
              Field(controller: panelAdet, label: 'Toplam Panel Adedi')),
          twoCol(
            Drop(
                label: 'Sistem Tipi',
                value: sistem,
                items: const ['Monofaze', 'Trifaze'],
                onChanged: (v) => setState(() => sistem = v ?? sistem)),
            Drop(
                label: 'İnverter DC Vmax',
                value: invVmax.toStringAsFixed(0),
                items: _gesDcVoltajListe(),
                onChanged: (v) =>
                    setState(() => invVmax = double.tryParse(v ?? '') ?? 1000)),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
              onPressed: hesapla, child: const Text('STRING HESAPLA')),
          if (sonuc.isNotEmpty) ...[
            const SizedBox(height: 16),
            ...resultSectionCardsFromText(
              sonuc,
              fallbackTitle: 'String Tasarımı Sonucu',
              fallbackNote: 'Ön tasarım sonucudur; üretici MPPT gerilim/akım sınırları, soğukta Voc artışı ve gerçek saha koşulları ile doğrulanmalıdır.',
              icons: const [Icons.account_tree_rounded, Icons.electrical_services_outlined],
            ),
          ],
        ]),
      );
}

class GesInverterAnaliziEkrani extends StatefulWidget {
  const GesInverterAnaliziEkrani({super.key});
  @override
  State<GesInverterAnaliziEkrani> createState() =>
      _GesInverterAnaliziEkraniState();
}

class _GesInverterAnaliziEkraniState extends State<GesInverterAnaliziEkrani> {
  final guc = TextEditingController(text: '100');
  final dcGuc = TextEditingController(text: '120');
  final dcAkimi = TextEditingController(text: '180');
  String sistem = 'Trifaze';
  double acGerilim = esaAgThreePhaseVoltage;
  double cosPhi = esaDefaultPowerFactor;
  String sonuc = '';
  @override
  void dispose() {
    guc.dispose();
    dcGuc.dispose();
    dcAkimi.dispose();
    super.dispose();
  }

  void hesapla() {
    final acKw = double.tryParse(guc.text.replaceAll(',', '.')) ?? 0;
    final dckw = double.tryParse(dcGuc.text.replaceAll(',', '.')) ?? 0;
    final dca = double.tryParse(dcAkimi.text.replaceAll(',', '.')) ?? 0;
    if (acKw <= 0 || dckw <= 0) {
      setState(() => sonuc = 'Giriş değerlerini kontrol edin.');
      return;
    }
    final carp = sistem == 'Monofaze' ? 1.0 : sqrt(3);
    final ia = acKw * 1000 / (carp * acGerilim * cosPhi);
    final oran = dckw / acKw;
    setState(() => sonuc =
        'Hesaplanan AC akım: ${fmt2(ia)} A\nDC/AC oranı: ${fmt2(oran)}\nGirilen maksimum DC akım: ${fmt2(dca)} A\nAC sistem: $sistem • ${fmt2(acGerilim)} V • cosφ ${cosPhi.toStringAsFixed(2)}\nNot: İnverterin gerçek sürekli AC çıkış akımı ve DC giriş limitleri üretici datasheet üzerinden doğrulanmalıdır.');
  }

  @override
  Widget build(BuildContext context) => _GesToolScaffold(
        title: 'GES İnverter Analizi',
        info:
            'İnverterin AC/DC gücü, sistem tipi, AC gerilimi ve cosφ üzerinden ön analiz yapar.',
        child: Column(children: [
          twoCol(Field(controller: guc, label: 'AC İnverter Gücü (kW)'),
              Field(controller: dcGuc, label: 'Toplam DC Güç (kWp)')),
          twoCol(
              Field(controller: dcAkimi, label: 'Maks. DC Giriş Akımı (A)'),
              Drop(
                  label: 'Sistem Tipi',
                  value: sistem,
                  items: const ['Monofaze', 'Trifaze'],
                  onChanged: (v) => setState(() => sistem = v ?? sistem))),
          twoCol(
              Drop(
                  label: 'AC Gerilim',
                  value: acGerilim.toStringAsFixed(0),
                  items: esaAcVoltageOptions,
                  onChanged: (v) => setState(() => acGerilim =
                      double.tryParse(v ?? '') ?? esaAgThreePhaseVoltage)),
              Drop(
                  label: 'AC Güç Faktörü (cosφ)',
                  value: cosPhi.toStringAsFixed(2),
                  items: const ['0.80', '0.85', '0.90', '0.95', '0.98', '1.00'],
                  onChanged: (v) => setState(() => cosPhi =
                      double.tryParse(v ?? '') ?? esaDefaultPowerFactor))),
          const SizedBox(height: 12),
          ElevatedButton(
              onPressed: hesapla, child: const Text('İNVERTERİ ANALİZ ET')),
          if (sonuc.isNotEmpty) ...[
            const SizedBox(height: 16),
            ...resultSectionCardsFromText(
              sonuc,
              fallbackTitle: 'İnverter Analiz Sonucu',
              fallbackNote: 'Kesin seçim üretici datasheet, MPPT gerilim/akım limitleri ve şebeke bağlantı koşulları ile doğrulanmalıdır.',
              icons: const [Icons.power_rounded, Icons.analytics_outlined],
            ),
          ],
        ]),
      );
}

// ============================================================================
// GES TARIMSAL SİSTEM TASARIMI
// Kullanıcıdan yalnızca saha için gerekli temel bilgiler alınır.
// Panel/sürücü/motor ön boyutlandırması arka planda yapılır.
// Kesin seçim; pompa eğrisi, boru hattı kayıpları, üretici verileri ve
// saha koşulları ile ayrıca doğrulanmalıdır.
// ============================================================================

class GesTicarimTasarimEkrani extends StatefulWidget {
  const GesTicarimTasarimEkrani({super.key});

  @override
  State<GesTicarimTasarimEkrani> createState() => _GesTicariState();
}

class _GesTicariState extends State<GesTicarimTasarimEkrani> {
  final derinlik = TextEditingController(text: '50');
  final saatlikSu = TextEditingController(text: '10');
  final calismaSuresi = TextEditingController(text: '6');
  final kotFarki = TextEditingController(text: '5');
  final manuelMotor = TextEditingController();

  String motorModu = 'Otomatik';
  String sonuc = '';

  @override
  void dispose() {
    derinlik.dispose();
    saatlikSu.dispose();
    calismaSuresi.dispose();
    kotFarki.dispose();
    manuelMotor.dispose();
    super.dispose();
  }

  double _sayi(String value) {
    return double.tryParse(value.replaceAll(',', '.').trim()) ?? 0;
  }

  double _standartMotorKw(double kw) {
    const motorlar = <double>[
      0.37,
      0.55,
      0.75,
      1.1,
      1.5,
      2.2,
      3.0,
      4.0,
      5.5,
      7.5,
      11,
      15,
      18.5,
      22,
      30,
      37,
      45,
      55,
      75,
      90,
      110,
      132,
      160,
      200,
    ];

    for (final m in motorlar) {
      if (m >= kw) return m;
    }
    return motorlar.last;
  }

  void hesapla() {
    FocusManager.instance.primaryFocus?.unfocus();

    final hDerinlik = _sayi(derinlik.text);
    final qSaat = _sayi(saatlikSu.text);
    final saat = _sayi(calismaSuresi.text);
    final kot = _sayi(kotFarki.text);

    if (hDerinlik <= 0 || qSaat <= 0 || saat <= 0 || kot < 0) {
      setState(() {
        sonuc =
            'Lütfen derinlik, debi, çalışma süresi ve kot bilgilerini kontrol edin.';
      });
      return;
    }

    if (motorModu == 'Manuel') {
      final manuel = _sayi(manuelMotor.text);
      if (manuel <= 0) {
        setState(() {
          sonuc = 'Manuel motor gücü seçildi. Motor gücünü kW olarak girin.';
        });
        return;
      }
    }

    // Bu aşamada yalnızca statik yükseklik biliniyor.
    // Boru uzunluğu/çapı, vana ve fittings bilgisi verilmediği için
    // sürtünme kayıpları kesin olarak hesaplanamaz.
    final toplamBasma = hDerinlik + kot;

    // Q [m3/h] -> m3/s
    final debiM3s = qSaat / 3600.0;

    // Hidrolik güç: P = rho*g*Q*H
    const rho = 1000.0;
    const g = 9.81;

    final hidrolikW = rho * g * debiM3s * toplamBasma;
    final hidrolikKw = hidrolikW / 1000.0;

    // Pompa + motor toplam verimi için ön tasarım katsayısı.
    // Gerçek değer üretici/pompa çalışma noktasından alınmalıdır.
    const toplamVerim = 0.65;

    final hesaplananMotorKw = hidrolikKw / toplamVerim;

    final secilenMotorKw = motorModu == 'Manuel'
        ? _sayi(manuelMotor.text)
        : _standartMotorKw(hesaplananMotorKw);

    // Tarımsal solar pompa sisteminde PV gücü motor gücünün üzerinde
    // ön boyutlandırılır. 1.30 burada ön tasarım katsayısıdır.
    const pvMotorOrani = 1.30;
    final gerekliPvKw = secilenMotorKw * pvMotorOrani;

    // Referans panel: kesin panel modeli değildir.
    const panelWp = 550.0;
    const panelVmp = 41.5;
    const panelVoc = 49.5;
    const panelImp = 13.25;

    final panelAdet = (gerekliPvKw * 1000 / panelWp).ceil();

    // Sürücü üreticisi verilmediği için string gerilim kesinleştirilmez.
    // 1000 V sınıfı bir DC üst sınır ve yaklaşık 500 V çalışma hedefi,
    // yalnızca string ön değerlendirmesi için kullanılır.
    const referansMinVmp = 500.0;
    const referansMaxVoc = 1000.0;

    int seri = (referansMinVmp / panelVmp).ceil();
    if (seri < 1) seri = 1;

    while (seri * panelVoc > referansMaxVoc && seri > 1) {
      seri--;
    }

    if (seri > panelAdet) {
      seri = panelAdet;
    }

    final paralel = (panelAdet / seri).ceil();
    final stringVmp = seri * panelVmp;
    final stringVoc = seri * panelVoc;
    final toplamPvAkimi = paralel * panelImp;
    final kuruluPvKw = panelAdet * panelWp / 1000.0;

    final gunlukSu = qSaat * saat;

    // Günlük enerji hesabı PV tarafında konuma ve kayıplara bağlıdır.
    // Tarımsal pompa için burada 4.5 eşdeğer güneş saati ve %80 sistem
    // performansı yalnızca ön tahmin olarak kullanılır.
    const gunesSaati = 4.5;
    const sistemPerformansi = 0.80;

    final tahminiGunlukPvEnerji = kuruluPvKw * gunesSaati * sistemPerformansi;

    // AC/DC mimarisi ön seçimdir; kesin seçim motor/pompa ve sürücü
    // üretici verileriyle doğrulanmalıdır.
    final motorMimarisi = secilenMotorKw <= 2.2
        ? 'DC solar pompa motoru + MPPT kontrolörü (ön mimari)'
        : 'AC trifaze dalgıç pompa motoru + MPPT-VFD (ön mimari)';

    final surucuTipi = secilenMotorKw <= 2.2
        ? 'MPPT solar pompa kontrolörü'
        : 'Trifaze solar pompa sürücüsü / MPPT-VFD';

    const surucuSiniflari = <double>[
      0.75,
      1.1,
      1.5,
      2.2,
      3.0,
      4.0,
      5.5,
      7.5,
      11,
      15,
      18.5,
      22,
      30,
      37,
      45,
      55,
      75,
      90,
      110,
      132,
      160,
      200,
    ];

    final surucuKw = surucuSiniflari.firstWhere(
      (v) => v >= secilenMotorKw,
      orElse: () => surucuSiniflari.last,
    );

    final pvMotorUygun = kuruluPvKw >= gerekliPvKw;
    final manuelMotorYeterli =
        motorModu != 'Manuel' || _sayi(manuelMotor.text) >= hesaplananMotorKw;

    setState(() {
      sonuc = 'SAHA GİRDİLERİ\n'
          'Su çekim derinliği: ${fmt2(hDerinlik)} m\n'
          'Saatlik su ihtiyacı: ${fmt2(qSaat)} m³/h\n'
          'Günlük çalışma süresi: ${fmt2(saat)} saat\n'
          'Çıkış kot farkı: ${fmt2(kot)} m\n\n'
          'HİDROLİK HESAP\n'
          'Günlük su ihtiyacı: ${fmt2(gunlukSu)} m³/gün\n'
          'Ön toplam basma yüksekliği: ${fmt2(toplamBasma)} m\n'
          'Hidrolik güç: ${fmt2(hidrolikKw)} kW\n'
          'Ön toplam verim katsayısı: %${fmt2(toplamVerim * 100)}\n'
          'Hesaplanan motor gücü: ${fmt2(hesaplananMotorKw)} kW\n\n'
          'MOTOR / SÜRÜCÜ\n'
          'Motor seçim yöntemi: $motorModu\n'
          'Ön seçilen motor gücü: ${fmt2(secilenMotorKw)} kW\n'
          'Sürücü: $surucuTipi\n'
          'Sürücü gücü: Motor nominal gücü ve üretici şartlarına göre '
          'en az ${fmt2(secilenMotorKw)} kW sınıfında değerlendirilmelidir.\n\n'
          'PV SİSTEMİ\n'
          'Ön gerekli PV gücü: ${fmt2(gerekliPvKw)} kWp\n'
          'Referans panel: 550 Wp\n'
          'Panel adedi: $panelAdet adet\n'
          'Kurulu PV gücü: ${fmt2(kuruluPvKw)} kWp\n'
          'Seri panel: $seri adet\n'
          'Paralel string: $paralel adet\n'
          'String Vmp: ${fmt2(stringVmp)} V\n'
          'String Voc: ${fmt2(stringVoc)} V\n'
          'Toplam PV akımı: ${fmt2(toplamPvAkimi)} A\n\n'
          'ENERJİ ÖN TAHMİNİ\n'
          'Tahmini günlük PV enerjisi: '
          '${fmt2(tahminiGunlukPvEnerji)} kWh/gün\n'
          'Kullanılan eşdeğer güneşlenme: '
          '${fmt2(gunesSaati)} saat/gün\n'
          'Kullanılan sistem performansı: %${fmt2(sistemPerformansi * 100)}\n\n'
          'TEKNİK UYGUNLUK\n'
          '${pvMotorUygun ? 'PV ön boyutu motor gücünü karşılıyor.' : 'PV ön boyutu motor gücünü karşılamıyor.'}\n\n'
          'TEKNİK UYARI\n'
          'Bu hesapta yalnızca statik basma yüksekliği kullanılmıştır. '
          'Boru çapı/uzunluğu, fittings, vana ve filtre kayıpları verilmediği '
          'için sürtünme kayıpları hesaba katılmamıştır. Gerçek pompa seçiminde '
          'pompa eğrisi, çalışma noktası, motor nominal akımı, sürücü MPPT '
          'aralığı, maksimum DC gerilimi/akımı ve soğukta Voc artışı ayrıca '
          'doğrulanmalıdır. String sayıları da kullanılan sürücünün gerçek '
          'MPPT ve DC giriş sınırlarıyla kesinleştirilmelidir.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return _GesToolScaffold(
      title: 'GES Tarımsal Sistem Tasarımı',
      info: 'Tarımsal sulama için kullanıcıdan saha girdilerini alır; '
          'debi ve basma yüksekliğinden hidrolik gücü, motoru, solar pompa '
          'sürücüsünü ve PV ön boyutunu hesaplar. Kesin seçim pompa eğrisi '
          've üretici verileriyle doğrulanmalıdır.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionCard(
            title: 'Saha Bilgileri',
            children: [
              twoCol(
                Field(
                  controller: derinlik,
                  label: 'Suyun çekileceği derinlik (m)',
                ),
                Field(
                  controller: saatlikSu,
                  label: 'Saatlik su ihtiyacı (m³/h)',
                ),
              ),
              twoCol(
                Field(
                  controller: calismaSuresi,
                  label: 'Günlük çalışma süresi (saat)',
                ),
                Field(
                  controller: kotFarki,
                  label: 'Çıkış kot farkı (m)',
                ),
              ),
              Drop(
                label: 'Motor gücü',
                value: motorModu,
                items: const ['Otomatik', 'Manuel'],
                onChanged: (v) {
                  if (v == null) return;
                  setState(() {
                    motorModu = v;
                    sonuc = '';
                  });
                },
              ),
              if (motorModu == 'Manuel') ...[
                const SizedBox(height: 10),
                Field(
                  controller: manuelMotor,
                  label: 'Manuel motor gücü (kW)',
                ),
              ],
              const SizedBox(height: 14),
              calcButton(
                'TARIMSAL SİSTEMİ HESAPLA',
                hesapla,
              ),
            ],
          ),
          if (sonuc.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...resultSectionCardsFromText(
              sonuc,
              fallbackTitle: 'Tarımsal Sistem Hesap Sonucu',
              fallbackNote: 'Ön teknik boyutlandırmadır. Pompa çalışma noktası, boru kayıpları, motor/sürücü üretici verileri ve saha koşullarıyla kesinleştirilmelidir.',
              icons: const [
                Icons.water_drop_rounded,
                Icons.speed_rounded,
                Icons.settings_rounded,
                Icons.solar_power_rounded,
                Icons.bolt_rounded,
                Icons.verified_rounded,
                Icons.info_outline_rounded,
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ============================================================================
// GES KARAVAN / MOBİL SİSTEM
// Fatura Analizi benzeri yük sepeti mantığı:
// cihaz -> güç -> adet -> çalışma süresi -> sepete ekle.
// ============================================================================

class _KaravanYuk {
  final String cihaz;
  final double gucW;
  final int adet;
  final double saat;

  const _KaravanYuk({
    required this.cihaz,
    required this.gucW,
    required this.adet,
    required this.saat,
  });

  double get gunlukWh => gucW * adet * saat;
  double get bagliW => gucW * adet;
}

class GesKaravanTasarimEkrani extends StatefulWidget {
  const GesKaravanTasarimEkrani({super.key});

  @override
  State<GesKaravanTasarimEkrani> createState() => _GesKaravanState();
}

class _GesKaravanState extends State<GesKaravanTasarimEkrani> {
  final cihazGucu = TextEditingController(text: '100');
  final cihazAdedi = TextEditingController(text: '1');
  final calismaSaati = TextEditingController(text: '4');

  String cihaz = 'Buzdolabı';
  String akuGerilimi = '12 V';
  String sonuc = '';

  final List<_KaravanYuk> yukler = [];

  static const Map<String, double> _cihazGucTablosu = {
    'Buzdolabı': 80,
    'LED Aydınlatma': 10,
    'Televizyon': 60,
    'Laptop': 65,
    'Telefon Şarjı': 15,
    'Su Pompası': 60,
    'Kahve Makinesi': 1000,
    'Mikrodalga': 1200,
    'Klima': 1200,
    'Fan': 40,
    'İnverterli Küçük Ev Aleti': 500,
    'Diğer': 100,
  };

  @override
  void dispose() {
    cihazGucu.dispose();
    cihazAdedi.dispose();
    calismaSaati.dispose();
    super.dispose();
  }

  double _sayi(String value) {
    return double.tryParse(value.replaceAll(',', '.').trim()) ?? 0;
  }

  void _cihazDegisti(String? v) {
    if (v == null) return;
    setState(() {
      cihaz = v;
      cihazGucu.text = (_cihazGucTablosu[v] ?? 100).toStringAsFixed(0);
      sonuc = '';
    });
  }

  void _sepeteEkle() {
    FocusManager.instance.primaryFocus?.unfocus();

    final guc = _sayi(cihazGucu.text);
    final adet = int.tryParse(cihazAdedi.text.trim()) ?? 0;
    final saat = _sayi(calismaSaati.text);

    if (guc <= 0 || adet <= 0 || saat <= 0) {
      setState(() {
        sonuc = 'Cihaz gücü, adet ve çalışma süresini kontrol edin.';
      });
      return;
    }

    setState(() {
      yukler.add(
        _KaravanYuk(
          cihaz: cihaz,
          gucW: guc,
          adet: adet,
          saat: saat,
        ),
      );
      sonuc = '';
    });
  }

  void _sepetiTemizle() {
    setState(() {
      yukler.clear();
      sonuc = '';
    });
  }

  void hesapla() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (yukler.isEmpty) {
      setState(() {
        sonuc = 'Önce en az bir cihazı sepete ekleyin.';
      });
      return;
    }

    final toplamGunlukWh = yukler.fold<double>(0, (sum, e) => sum + e.gunlukWh);

    // Tüm yüklerin aynı anda çalıştığı en kötü durum üst sınırı.
    final eszamanliW = yukler.fold<double>(0, (sum, e) => sum + e.bagliW);

    final akuV = int.tryParse(akuGerilimi.replaceAll(' V', '').trim()) ?? 12;

    const panelW = 450.0;
    const panelVmp = 41.0;
    const panelVoc = 49.0;
    const panelImp = 11.0;

    // Karavan için ön PV hesabı:
    // 4 eşdeğer güneş saati ve %80 performans katsayısı.
    const gunesSaati = 4.0;
    const sistemVerimi = 0.80;

    final gerekliPvW = toplamGunlukWh / (gunesSaati * sistemVerimi);

    final panelAdet = (gerekliPvW / panelW).ceil();

    // Akü nominal enerjisi:
    // yaklaşık %50 kullanılabilir kapasite + %90 sistem varsayımı.
    final gerekliAkuWh = toplamGunlukWh / (0.50 * 0.90);

    final akuAh = gerekliAkuWh * 1000 / akuV;

    // Aküye göre yaklaşık PV string ön kurgusu.
    // Kesin seçim MPPT üretici sınırlarıyla doğrulanmalıdır.
    int seri = (akuV * 1.5 / panelVmp).ceil();
    if (seri < 1) seri = 1;

    final paralel = (panelAdet / seri).ceil();

    final stringVmp = seri * panelVmp;
    final stringVoc = seri * panelVoc;
    final toplamPvAkimi = paralel * panelImp;
    final kuruluPvW = panelAdet * panelW;

    const inverterSiniflari = <int>[
      300,
      600,
      1000,
      1500,
      2000,
      3000,
      5000,
      6000,
      8000,
      10000,
    ];

    final inverterHedefW = eszamanliW * 1.25;

    final inverterW = inverterSiniflari.firstWhere(
      (v) => v >= inverterHedefW,
      orElse: () => inverterSiniflari.last,
    );

    final mpptTeorikAkimi = kuruluPvW / akuV;

    final mpptOnSecim = (mpptTeorikAkimi * 1.25).ceil();

    final pvKarsilama = kuruluPvW >= gerekliPvW;

    setState(() {
      sonuc = 'YÜK SEPETİ\n'
          'Cihaz kalemi: ${yukler.length} adet\n'
          'Günlük toplam tüketim: '
          '${fmt2(toplamGunlukWh / 1000)} kWh/gün\n'
          'Bağlı yük üst sınırı: '
          '${fmt2(eszamanliW / 1000)} kW\n\n'
          'PV SİSTEMİ\n'
          'Gerekli PV gücü: '
          '${fmt2(gerekliPvW / 1000)} kWp\n'
          'Referans panel: 450 Wp\n'
          'Panel adedi: $panelAdet adet\n'
          'Kurulu PV gücü: '
          '${fmt2(kuruluPvW / 1000)} kWp\n'
          'Seri panel: $seri adet\n'
          'Paralel string: $paralel adet\n'
          'String Vmp: ${fmt2(stringVmp)} V\n'
          'String Voc: ${fmt2(stringVoc)} V\n'
          'Toplam PV akımı: ${fmt2(toplamPvAkimi)} A\n\n'
          'AKÜ BANKASI\n'
          'Akü sistemi: $akuV V\n'
          'Yaklaşık gerekli nominal enerji: '
          '${fmt2(gerekliAkuWh / 1000)} kWh\n'
          'Yaklaşık akü kapasitesi: '
          '${fmt2(akuAh)} Ah\n\n'
          'MPPT / İNVERTER\n'
          'MPPT teorik akımı: '
          '${fmt2(mpptTeorikAkimi)} A\n'
          'MPPT ön seçim: '
          '$mpptOnSecim A sınıfı veya üstü\n'
          'İnverter eşzamanlı yük üst sınıfı: '
          '$inverterW W\n'
          'İnverter hedefi: '
          '${fmt2(inverterHedefW / 1000)} kW ve üzeri\n\n'
          'SONUÇ\n'
          '${pvKarsilama ? 'Ön PV boyutu günlük enerji ihtiyacını karşılıyor.' : 'Ön PV boyutu günlük enerji ihtiyacını karşılamıyor.'}\n\n'
          'TEKNİK UYARI\n'
          'Karavan sisteminde inverter seçimi yalnızca toplam bağlı güce göre '
          'kesinleştirilmez. Kompresör, pompa, klima ve benzeri cihazların '
          'kalkış akımları ayrıca dikkate alınmalıdır. Akü kapasitesi gerçek '
          'kullanılabilir DoD, sıcaklık, akü üretici verisi ve hedef otonomiye '
          'göre doğrulanmalıdır. MPPT maksimum PV gerilimi/akımı, soğukta '
          'Voc artışı ve panel seri-paralel kurgusu kullanılan cihazın üretici '
          'sınırlarıyla kesinleştirilmelidir.';
    });
  }

  Widget _yukKarti(_KaravanYuk yuk, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 2,
        ),
        leading: CircleAvatar(
          backgroundColor: cIcon().withValues(alpha: .12),
          child: Icon(
            Icons.electrical_services_rounded,
            color: cIcon(),
          ),
        ),
        title: Text(
          yuk.cihaz,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        subtitle: Text(
          '${fmt2(yuk.gucW)} W × ${yuk.adet} adet × '
          '${fmt2(yuk.saat)} saat = '
          '${fmt2(yuk.gunlukWh / 1000)} kWh/gün',
        ),
        trailing: IconButton(
          tooltip: 'Sepetten çıkar',
          icon: const Icon(Icons.delete_outline_rounded),
          onPressed: () {
            setState(() {
              yukler.removeAt(index);
              sonuc = '';
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _GesToolScaffold(
      title: 'GES Karavan / Mobil Sistem Tasarımı',
      info: 'Karavan ve mobil sistemlerde cihazları yük sepetine ekleyerek '
          'günlük enerji ihtiyacını, PV gücünü, panel dizisini, akü kapasitesini, '
          'MPPT ve inverter ön boyutunu hesaplar.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionCard(
            title: 'Yük Sepetine Cihaz Ekle',
            children: [
              twoCol(
                Drop(
                  label: 'Cihaz',
                  value: cihaz,
                  items: _cihazGucTablosu.keys.toList(),
                  onChanged: _cihazDegisti,
                ),
                Field(
                  controller: cihazGucu,
                  label: 'Cihaz Gücü (W)',
                ),
              ),
              twoCol(
                Field(
                  controller: cihazAdedi,
                  label: 'Adet',
                ),
                Field(
                  controller: calismaSaati,
                  label: 'Günlük çalışma (saat)',
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _sepeteEkle,
                icon: const Icon(Icons.add_shopping_cart_rounded),
                label: const Text('SEPETE EKLE'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SectionCard(
            title: 'Yük Sepeti',
            children: [
              if (yukler.isEmpty)
                Text(
                  'Henüz cihaz eklenmedi.',
                  style: TextStyle(
                    color: cText().withValues(alpha: .70),
                  ),
                )
              else ...[
                ...yukler.asMap().entries.map(
                      (e) => _yukKarti(e.value, e.key),
                    ),
                const SizedBox(height: 4),
                OutlinedButton.icon(
                  onPressed: _sepetiTemizle,
                  icon: const Icon(Icons.delete_sweep_outlined),
                  label: const Text('SEPETİ TEMİZLE'),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          SectionCard(
            title: 'Sistem Bilgileri',
            children: [
              Drop(
                label: 'Akü Sistem Gerilimi',
                value: akuGerilimi,
                items: const ['12 V', '24 V', '48 V'],
                onChanged: (v) {
                  if (v == null) return;
                  setState(() {
                    akuGerilimi = v;
                    sonuc = '';
                  });
                },
              ),
              const SizedBox(height: 12),
              calcButton(
                'KARAVAN SİSTEMİNİ HESAPLA',
                hesapla,
              ),
            ],
          ),
          if (sonuc.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...resultSectionCardsFromText(
              sonuc,
              fallbackTitle: 'Karavan / Mobil Sistem Hesap Sonucu',
              fallbackNote: 'Ön boyutlandırmadır. MPPT/inverter üretici sınırları, akü üretici verileri, gerçek yük profili ve kalkış akımlarıyla kesinleştirilmelidir.',
              icons: const [
                Icons.shopping_cart_outlined,
                Icons.solar_power_rounded,
                Icons.battery_charging_full_rounded,
                Icons.power_rounded,
                Icons.verified_rounded,
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _GesToolScaffold extends StatelessWidget {
  final String title;
  final String info;
  final Widget child;
  const _GesToolScaffold(
      {required this.title, required this.info, required this.child});
  @override
  Widget build(BuildContext context) => AppScaffold(
      title: title,
      info: true,
      onInfo: () => bilgiPopup(context, title, info),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: cInputBg(), borderRadius: BorderRadius.circular(8)),
              child: child)));
}

List<String> _gesDcVoltajListe() => const [
      '60',
      '96',
      '120',
      '150',
      '200',
      '250',
      '300',
      '400',
      '500',
      '600',
      '800',
      '1000',
      '1100',
      '1200',
      '1500'
    ];
