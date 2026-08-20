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

  static const double _acGerilim = 400.0;

  static const double _acCosPhi = 0.95;

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

    return gucKw * 1000 / (sqrt(3) * _acGerilim * _acCosPhi);
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
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(
                      14,
                    ),
                    margin: const EdgeInsets.only(
                      bottom: 12,
                    ),
                    decoration: BoxDecoration(
                      color: cCardAlpha(),
                      borderRadius: BorderRadius.circular(
                        8,
                      ),
                      border: Border.all(
                        color: cIcon().withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          t(
                            'Sistem Performansı',
                            'System Performance',
                          ),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: cIcon(),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          uretimBilgisi,
                          style: TextStyle(
                            fontSize: 14,
                            color: cText(),
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
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
          if (sonuc.isNotEmpty)
            SectionCard(
              title: 'Otomatik Tasarım Sonucu',
              children: [
                Text(
                  sonuc,
                  style: TextStyle(
                    color: cText(),
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
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
