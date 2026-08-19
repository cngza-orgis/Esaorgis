part of 'main.dart';

// ================================================================
// ALPEK İLETKEN
// Kullanıcı:
//   1) Sistem tipi: Monofaze / Trifaze
//   2) Tasarım akımı
//
// Sistem tipine göre uygun ALPEK kesitleri gösterilir.
// İlk uygun kesit ayrıca önerilir.
//
// NOT:
// Bu ekran hızlı teknik ön seçim içindir.
// Kesin seçimde ilgili TEDAŞ/dağıtım şirketi şartnamesi,
// üretici katalog verileri, açıklık, sıcaklık, mekanik yükler,
// gerilim düşümü ve kısa devre koşulları doğrulanmalıdır.
// ================================================================

class AlpekIletkenEkrani extends StatefulWidget {
  const AlpekIletkenEkrani({super.key});

  @override
  State<AlpekIletkenEkrani> createState() => _AlpekIletkenEkraniState();
}

class _AlpekIletkenEkraniState extends State<AlpekIletkenEkrani> {
  final TextEditingController akimController = TextEditingController();

  String sistemTipi = 'Trifaze';

  List<_AlpekSecenek> uygunKesitler = <_AlpekSecenek>[];
  _AlpekSecenek? onerilen;

  String? hataMesaji;

  @override
  void dispose() {
    akimController.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------
  // ALPEK veri tabanı
  //
  // Monofaze:
  // 2x16, 2x25, 2x35, 2x50, 2x70, 2x95, 2x120
  //
  // Trifaze:
  // 4x16, 4x25, 4x35, 4x50, 4x70, 4x95, 4x120, 4x150
  //
  // Akım değerleri hızlı ön seçim içindir.
  // ------------------------------------------------------------

  List<_AlpekSecenek> _monofazeAlpek() {
    return const <_AlpekSecenek>[
      _AlpekSecenek(
        ad: 'ALPEK',
        kesit: '1x16+16 mm²',
        akimKapasitesi: 63.0,
      ),
      _AlpekSecenek(
        ad: 'ALPEK',
        kesit: '1x25+25 mm²',
        akimKapasitesi: 80.0,
      ),
      _AlpekSecenek(
        ad: 'ALPEK',
        kesit: '1x35+35 mm²',
        akimKapasitesi: 100.0,
      ),
      _AlpekSecenek(
        ad: 'ALPEK',
        kesit: '1x50+50 mm²',
        akimKapasitesi: 125.0,
      ),
      _AlpekSecenek(
        ad: 'ALPEK',
        kesit: '1x70+70 mm²',
        akimKapasitesi: 160.0,
      ),
      _AlpekSecenek(
        ad: 'ALPEK',
        kesit: '1x95+95 mm²',
        akimKapasitesi: 195.0,
      ),
      _AlpekSecenek(ad: 'ALPEK', kesit: '1x120+120 mm²', akimKapasitesi: 225.0),
      _AlpekSecenek(ad: 'ALPEK', kesit: '1x150+150 mm²', akimKapasitesi: 260.0),
      _AlpekSecenek(ad: 'ALPEK', kesit: '1x185+185 mm²', akimKapasitesi: 300.0),
      _AlpekSecenek(ad: 'ALPEK', kesit: '1x240+240 mm²', akimKapasitesi: 345.0),
    ];
  }

  List<_AlpekSecenek> _trifazeAlpek() {
    return const <_AlpekSecenek>[
      _AlpekSecenek(
        ad: 'ALPEK',
        kesit: '3x16+16 mm²',
        akimKapasitesi: 50.0,
      ),
      _AlpekSecenek(
        ad: 'ALPEK',
        kesit: '3x25+25 mm²',
        akimKapasitesi: 63.0,
      ),
      _AlpekSecenek(
        ad: 'ALPEK',
        kesit: '3x35+35 mm²',
        akimKapasitesi: 80.0,
      ),
      _AlpekSecenek(
        ad: 'ALPEK',
        kesit: '3x50+50 mm²',
        akimKapasitesi: 100.0,
      ),
      _AlpekSecenek(
        ad: 'ALPEK',
        kesit: '3x70+70 mm²',
        akimKapasitesi: 125.0,
      ),
      _AlpekSecenek(
        ad: 'ALPEK',
        kesit: '3x95+95 mm²',
        akimKapasitesi: 160.0,
      ),
      _AlpekSecenek(
        ad: 'ALPEK',
        kesit: '3x120+120 mm²',
        akimKapasitesi: 195.0,
      ),
      _AlpekSecenek(ad: 'ALPEK', kesit: '3x150+150 mm²', akimKapasitesi: 225.0),
      _AlpekSecenek(ad: 'ALPEK', kesit: '3x185+185 mm²', akimKapasitesi: 265.0),
      _AlpekSecenek(ad: 'ALPEK', kesit: '3x240+240 mm²', akimKapasitesi: 305.0),
    ];
  }

  // ------------------------------------------------------------
  // Hesaplama
  // ------------------------------------------------------------

  void hesapla() {
    final String temizAkim = akimController.text.trim().replaceAll(',', '.');

    final double? akim = double.tryParse(temizAkim);

    if (akim == null || akim <= 0) {
      setState(() {
        uygunKesitler = <_AlpekSecenek>[];
        onerilen = null;
        hataMesaji = 'Lütfen geçerli bir tasarım akımı girin.';
      });
      return;
    }

    final List<_AlpekSecenek> tumKesitler =
        sistemTipi == 'Monofaze' ? _monofazeAlpek() : _trifazeAlpek();

    final List<_AlpekSecenek> uygun = tumKesitler
        .where(
          (_AlpekSecenek item) => item.akimKapasitesi >= akim,
        )
        .toList();

    setState(() {
      hataMesaji = null;
      uygunKesitler = uygun;
      onerilen = uygun.isNotEmpty ? uygun.first : null;
    });
  }

  // ------------------------------------------------------------
  // Yardımcı sonuç satırı
  // ------------------------------------------------------------

  String _awg(String kesit) {
    final match = RegExp(r'(?:1x|3x)(\d+(?:\.\d+)?)').firstMatch(kesit);
    final s = double.tryParse(match?.group(1) ?? '0') ?? 0;
    if (s >= 240) return '≈ 500 kcmil';
    if (s >= 185) return '≈ 350 kcmil';
    if (s >= 150) return '≈ 300 kcmil';
    if (s >= 120) return '≈ 4/0 AWG';
    if (s >= 95) return '≈ 3/0 AWG';
    if (s >= 70) return '≈ 2/0 AWG';
    if (s >= 50) return '≈ 1/0 AWG';
    if (s >= 35) return '≈ 2 AWG';
    if (s >= 25) return '≈ 3 AWG';
    if (s >= 16) return '≈ 5 AWG';
    return '≈ 8 AWG';
  }

  Widget _kesitSatiri(
    _AlpekSecenek secenek,
    double tasarimAkimi,
  ) {
    final bool onerilenMi = identical(secenek, onerilen);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: cCard(),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: onerilenMi
              ? Colors.green.shade700
              : cIcon().withValues(alpha: 0.45),
          width: onerilenMi ? 1.5 : 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            onerilenMi ? Icons.check_circle : Icons.electrical_services,
            color: onerilenMi ? Colors.green.shade700 : cIcon(),
            size: 21,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${secenek.ad} — ${secenek.kesit} (${_awg(secenek.kesit)})',
                  style: TextStyle(
                    color: cText(),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Ön seçim akım kapasitesi: '
                  '${secenek.akimKapasitesi.toStringAsFixed(0)} A',
                  style: TextStyle(
                    color: cText().withValues(alpha: 0.72),
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),
          if (onerilenMi)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'ÖNERİ',
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // EKRAN
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: t(
        'ALPEK İletken Seçimi',
        'ABC Cable Selection',
      ),
      info: true,
      onInfo: () => bilgiPopup(
        context,
        t(
          'ALPEK İletken Seçimi — Bilgi',
          'ABC Cable Selection — Information',
        ),
        t(
          'Bu araç, girilen tasarım akımına ve seçilen '
              'sistem tipine göre ALPEK kesitleri için hızlı '
              'ön seçim yapar. Monofaze sistemlerde 2 damarlı, '
              'trifaze sistemlerde 4 damarlı ALPEK seçenekleri '
              'gösterilir.\n\n'
              'KCMIL (kcmil), iletken kesitinin circular mil tabanlı birimidir; mm² ile aynı kesit büyüklüğünü farklı birim sistemiyle ifade eder.\n\n'
              'Kesin seçim; gerçek üretici akım taşıma değerleri, '
              'iletken sıcaklığı, ortam sıcaklığı, açıklık, '
              'mekanik yükler, gerilim düşümü, kısa devre '
              'dayanımı ve ilgili dağıtım şirketi/TEDAŞ '
              'şartlarıyla doğrulanmalıdır.',
          'This tool provides a preliminary ALPEK section '
              'selection based on design current and system type. '
              'Single-phase systems use phase + neutral and '
              'three-phase systems use 3-phase + neutral options.\n\n'
              'Final selection must be verified against actual '
              'manufacturer current ratings, conductor temperature, '
              'ambient temperature, span, mechanical loads, '
              'voltage drop, short-circuit withstand and applicable '
              'utility/TEDAS requirements.',
        ),
      ),
      body: ScrollBody(
        children: [
          SectionCard(
            title: t(
              'ALPEK Giriş Bilgileri',
              'ALPEK Input Data',
            ),
            children: [
              twoCol(
                Drop(
                  label: t(
                    'Sistem Tipi',
                    'System Type',
                  ),
                  value: sistemTipi,
                  items: const <String>[
                    'Monofaze',
                    'Trifaze',
                  ],
                  onChanged: (String? value) {
                    if (value == null) return;

                    setState(() {
                      sistemTipi = value;
                      uygunKesitler = <_AlpekSecenek>[];
                      onerilen = null;
                      hataMesaji = null;
                    });
                  },
                ),
                Field(
                  controller: akimController,
                  label: t(
                    'Tasarım Akımı (A)',
                    'Design Current (A)',
                  ),
                ),
              ),
              calcButton(
                t(
                  'ALPEK KESİTLERİNİ GÖSTER',
                  'SHOW ALPEK SECTIONS',
                ),
                hesapla,
              ),
              if (hataMesaji != null)
                AdviceCard(
                  title: t(
                    'Giriş Hatası',
                    'Input Error',
                  ),
                  text: hataMesaji!,
                  error: true,
                ),
            ],
          ),

          // ----------------------------------------------------
          // ÖNERİLEN KESİT
          // ----------------------------------------------------

          if (onerilen != null)
            SectionCard(
              title: t(
                'Önerilen ALPEK',
                'Recommended ALPEK',
              ),
              children: [
                ResultCard(
                  title: t(
                    'İlk Uygun Kesit',
                    'First Suitable Section',
                  ),
                  value: '${onerilen!.ad} — ${onerilen!.kesit}',
                  subtitle: '${t('Tasarım akımı', 'Design current')}: '
                      '${double.tryParse(akimController.text.replaceAll(',', '.'))?.toStringAsFixed(1) ?? '-'} A\n'
                      '${t('Ön seçim kapasitesi', 'Preliminary capacity')}: '
                      '${onerilen!.akimKapasitesi.toStringAsFixed(0)} A',
                  good: true,
                ),
              ],
            ),

          // ----------------------------------------------------
          // UYGUN KESİTLER
          // ----------------------------------------------------

          if (uygunKesitler.isNotEmpty)
            SectionCard(
              title: t(
                'Akıma Göre Uygun ALPEK Kesitleri',
                'Suitable ALPEK Sections by Current',
              ),
              children: [
                ...uygunKesitler.map(
                  (_AlpekSecenek secenek) => _kesitSatiri(
                    secenek,
                    double.tryParse(
                          akimController.text.replaceAll(',', '.'),
                        ) ??
                        0,
                  ),
                ),
              ],
            ),

          // ----------------------------------------------------
          // AKIM SINIRI AŞILDIYSA
          // ----------------------------------------------------

          if (hataMesaji == null &&
              uygunKesitler.isEmpty &&
              onerilen == null &&
              akimController.text.trim().isNotEmpty)
            AdviceCard(
              title: t(
                'Standart kesit aralığı yetersiz',
                'Standard section range is insufficient',
              ),
              text: t(
                'Girilen tasarım akımı için bu ekranda '
                    'tanımlı standart ALPEK kesitleri içinde '
                    'uygun bir kesit bulunamadı. Daha büyük '
                    'standart kesit, paralel hat veya farklı '
                    'şebeke çözümü değerlendirilmelidir.',
                'No suitable standard ALPEK section was found '
                    'for the entered design current. A larger '
                    'standard section, parallel circuit or another '
                    'network solution should be evaluated.',
              ),
              error: true,
            ),

          // ----------------------------------------------------
          // TEKNİK NOT
          // ----------------------------------------------------

          AdviceCard(
            title: t(
              'Teknik not',
              'Technical note',
            ),
            text: t(
              'Bu ekran hızlı ön seçim amacıyla hazırlanmıştır. '
                  'Akım kapasitesi değerleri nihai proje uygunluğu '
                  'yerine geçmez. Kesin ALPEK seçimi; üretici '
                  'katalog değerleri, ortam ve iletken sıcaklığı, '
                  'açıklık, direk aralığı, rüzgâr/buz yükleri, '
                  'sarkma, gerilim düşümü, kısa devre koşulları '
                  've ilgili dağıtım şirketi/TEDAŞ teknik '
                  'şartlarıyla doğrulanmalıdır.',
              'This screen is intended for preliminary selection. '
                  'Current capacity values do not replace final '
                  'project verification. Final ALPEK selection must '
                  'be checked against manufacturer data, conductor '
                  'and ambient temperature, span, pole spacing, '
                  'wind/ice loads, sag, voltage drop, short-circuit '
                  'conditions and applicable utility/TEDAS '
                  'technical requirements.',
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// ALPEK VERİ SINIFI
// ================================================================

class _AlpekSecenek {
  final String ad;
  final String kesit;
  final double akimKapasitesi;

  const _AlpekSecenek({
    required this.ad,
    required this.kesit,
    required this.akimKapasitesi,
  });
}
