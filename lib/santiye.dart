part of 'main.dart';

// ================================================================
// ŞANTİYE ARAÇLARI
// ================================================================
//
// Bu dosyada yalnızca Şantiye Araçları grubuna ait araçlar bulunur.
//
// Hat ve Şebeke Araçları'na taşınan araçlar:
//   - Açık İletken
//   - Yer Altı Kablo
//   - Alpek İletken
//
// ================================================================

// ================================================================
// ORTAK YARDIMCI FONKSİYONLAR
// ================================================================

double _santiyeDouble(String value) {
  return double.tryParse(
        value.trim().replaceAll('.', '').replaceAll(',', '.'),
      ) ??
      0;
}

String _santiyeFmt(
  double value, {
  int digits = 1,
}) {
  return value.toStringAsFixed(digits).replaceAll('.', ',');
}

// ================================================================
// 1. BORU / TAVA DOLULUK
// ================================================================
//
// BORU:
// Kabloların toplam dairesel alanı / borunun iç dairesel alanı.
//
// TAVA:
// Kabloların toplam dairesel alanı / kullanılabilir tava alanı.
//
// ÖNEMLİ:
// Bu araç geometrik doluluk hesabı yapar.
// Kablo dış çapı gerçek kablo verisinden alınmalıdır.
//
// ================================================================

class BoruTavaEkrani extends StatefulWidget {
  const BoruTavaEkrani({super.key});

  @override
  State<BoruTavaEkrani> createState() => _BoruTavaEkraniState();
}

class _BoruTavaEkraniState extends State<BoruTavaEkrani> {
  String uygulama = 'Boru';
  String gerilim = 'AG';
  String iletken = 'Bakır';
  String kesit = '1x1,5 mm²';

  final TextEditingController adet = TextEditingController(text: '1');

  final TextEditingController kabloCap = TextEditingController(text: '10');

  final TextEditingController boruCap = TextEditingController(text: '25');

  final TextEditingController tavaGenislik = TextEditingController(text: '300');

  final TextEditingController tavaDerinlik = TextEditingController(text: '50');

  double? doluluk;
  double? kabloAlan;
  double? toplamKabloAlan;
  double? tasiyiciAlan;

  String? hesapDetayi;

  // --------------------------------------------------------------
  // Kablo listesi
  // --------------------------------------------------------------

  List<String> get _kabloListesi {
    final mevcut = List<String>.from(standartKabloSecimListesi);

    if (mevcut.isNotEmpty) {
      return mevcut;
    }

    return const <String>[
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
      '3x1,5 mm²',
      '3x2,5 mm²',
      '3x4 mm²',
      '3x6 mm²',
      '3x10 mm²',
      '3x16 mm²',
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

  List<String> get _filtreliKabloListesi {
    final liste = _kabloListesi.toSet().toList();

    if (liste.isNotEmpty && !liste.contains(kesit)) {
      kesit = liste.first;
    }

    return liste;
  }

  // --------------------------------------------------------------
  // BORU HESABI
  // --------------------------------------------------------------

  void _hesaplaBoru() {
    final n = _santiyeDouble(adet.text);
    final dk = _santiyeDouble(kabloCap.text);
    final db = _santiyeDouble(boruCap.text);

    if (n <= 0 || dk <= 0 || db <= 0) {
      setState(() {
        doluluk = null;
        hesapDetayi = null;
      });
      return;
    }

    if (db <= dk) {
      setState(() {
        doluluk = null;
        hesapDetayi = 'Boru iç çapı, kablonun dış çapından büyük olmalıdır.';
      });
      return;
    }

    final tekKabloAlan = pi * pow(dk / 2, 2).toDouble();

    final toplamAlan = tekKabloAlan * n;

    final boruAlan = pi * pow(db / 2, 2).toDouble();

    final sonuc = toplamAlan / boruAlan * 100;

    setState(() {
      doluluk = sonuc;
      kabloAlan = tekKabloAlan;
      toplamKabloAlan = toplamAlan;
      tasiyiciAlan = boruAlan;

      hesapDetayi = 'Boru iç kesit alanı: '
          '${_santiyeFmt(boruAlan)} mm²\n'
          'Tek kablo dış kesit alanı: '
          '${_santiyeFmt(tekKabloAlan)} mm²\n'
          'Toplam kablo alanı: '
          '${_santiyeFmt(toplamAlan)} mm²\n'
          'Kablo adedi: '
          '${_santiyeFmt(n, digits: 0)}';
    });
  }

  // --------------------------------------------------------------
  // TAVA HESABI
  // --------------------------------------------------------------

  void _hesaplaTava() {
    final n = _santiyeDouble(adet.text);
    final dk = _santiyeDouble(kabloCap.text);
    final genislik = _santiyeDouble(tavaGenislik.text);
    final derinlik = _santiyeDouble(tavaDerinlik.text);

    if (n <= 0 || dk <= 0 || genislik <= 0 || derinlik <= 0) {
      setState(() {
        doluluk = null;
        hesapDetayi = null;
      });
      return;
    }

    final tekKabloAlan = pi * pow(dk / 2, 2).toDouble();

    final toplamAlan = tekKabloAlan * n;

    final tavaAlan = genislik * derinlik;

    final sonuc = toplamAlan / tavaAlan * 100;

    setState(() {
      doluluk = sonuc;
      kabloAlan = tekKabloAlan;
      toplamKabloAlan = toplamAlan;
      tasiyiciAlan = tavaAlan;

      hesapDetayi = 'Tava kullanılabilir alanı: '
          '${_santiyeFmt(tavaAlan)} mm²\n'
          'Tek kablo dış kesit alanı: '
          '${_santiyeFmt(tekKabloAlan)} mm²\n'
          'Toplam kablo alanı: '
          '${_santiyeFmt(toplamAlan)} mm²\n'
          'Kablo adedi: '
          '${_santiyeFmt(n, digits: 0)}';
    });
  }

  void hesapla() {
    if (uygulama == 'Boru') {
      _hesaplaBoru();
    } else {
      _hesaplaTava();
    }
  }

  @override
  void dispose() {
    adet.dispose();
    kabloCap.dispose();
    boruCap.dispose();
    tavaGenislik.dispose();
    tavaDerinlik.dispose();
    super.dispose();
  }

  // --------------------------------------------------------------
  // BUILD
  // --------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: t(
        'Boru / Tava Doluluk',
        'Conduit / Tray Fill',
      ),
      info: true,
      onInfo: () => bilgiPopup(
        context,
        'Boru / Tava Doluluk',
        'Bu araç boru ve kablo tavasındaki geometrik doluluk oranını '
            'hesaplar. Boru hesabında borunun iç kesit alanı, tava '
            'hesabında ise tava genişliği ile kullanılabilir derinliğin '
            'oluşturduğu alan esas alınır. Kablo alanı gerçek kablo dış '
            'çapından hesaplanmalıdır. Sonuç tek başına nihai tesisat '
            'uygunluğu anlamına gelmez; gerçek kablo dış çapı, yerleşim, '
            'ısı dağılımı, bükülme yarıçapı ve ilgili standart/şartname '
            'hükümleri ayrıca değerlendirilmelidir.',
      ),
      body: ScrollBody(
        children: [
          SectionCard(
            title: t(
              'Kablo / Kanal',
              'Cable / Containment',
            ),
            children: [
              Drop(
                label: t(
                  'Uygulama',
                  'Application',
                ),
                value: uygulama,
                items: const [
                  'Boru',
                  'Tava',
                ],
                onChanged: (v) {
                  if (v == null) return;

                  setState(() {
                    uygulama = v;
                    doluluk = null;
                    hesapDetayi = null;
                  });
                },
              ),
              twoCol(
                Drop(
                  label: t(
                    'Gerilim Seviyesi',
                    'Voltage Level',
                  ),
                  value: gerilim,
                  items: const [
                    'AG',
                    'OG',
                  ],
                  onChanged: (v) {
                    if (v == null) return;

                    setState(() {
                      gerilim = v;
                      doluluk = null;
                      hesapDetayi = null;
                    });
                  },
                ),
                Drop(
                  label: t(
                    'İletken',
                    'Conductor',
                  ),
                  value: iletken,
                  items: const [
                    'Bakır',
                    'Alüminyum',
                  ],
                  onChanged: (v) {
                    if (v == null) return;

                    setState(() {
                      iletken = v;
                      doluluk = null;
                      hesapDetayi = null;
                    });
                  },
                ),
              ),
              Drop(
                label: t(
                  'Kesit / Yapı',
                  'Section / Configuration',
                ),
                value: _filtreliKabloListesi.contains(kesit)
                    ? kesit
                    : _filtreliKabloListesi.isNotEmpty
                        ? _filtreliKabloListesi.first
                        : '',
                items: _filtreliKabloListesi,
                onChanged: (v) {
                  if (v == null) return;

                  setState(() {
                    kesit = v;
                    doluluk = null;
                    hesapDetayi = null;
                  });
                },
              ),
              Field(
                controller: adet,
                label: t(
                  'Kablo Adedi',
                  'Number of Cables',
                ),
              ),
              Field(
                controller: kabloCap,
                label: t(
                  'Kablo Dış Çapı (mm)',
                  'Cable Outer Diameter (mm)',
                ),
              ),
              if (uygulama == 'Boru')
                Field(
                  controller: boruCap,
                  label: t(
                    'Boru İç Çapı (mm)',
                    'Conduit Inner Diameter (mm)',
                  ),
                ),
              if (uygulama == 'Tava')
                twoCol(
                  Field(
                    controller: tavaGenislik,
                    label: t(
                      'Tava Genişliği (mm)',
                      'Tray Width (mm)',
                    ),
                  ),
                  Field(
                    controller: tavaDerinlik,
                    label: t(
                      'Kullanılabilir Derinlik (mm)',
                      'Usable Depth (mm)',
                    ),
                  ),
                ),
              calcButton(
                t(
                  'DOLULUĞU HESAPLA',
                  'CALCULATE FILL',
                ),
                hesapla,
              ),
            ],
          ),
          if (doluluk != null) ...[
            uiResultCard(
              t(
                'Geometrik Doluluk',
                'Geometric Fill',
              ),
              _santiyeFmt(doluluk!),
              '%',
            ),
            if (hesapDetayi != null)
              uiResultCard(
                t(
                  'Hesap Özeti',
                  'Calculation Summary',
                ),
                hesapDetayi!,
                t(
                  'Detay',
                  'Details',
                ),
              ),
          ],
          if (hesapDetayi != null && doluluk == null)
            AdviceCard(
              title: t(
                'Kontrol',
                'Check',
              ),
              text: hesapDetayi!,
            ),
          AdviceCard(
            title: t(
              'Teknik not',
              'Technical note',
            ),
            text: t(
              'Boru hesabında borunun iç çapı, tava hesabında ise '
                  'tavanın kullanılabilir genişlik ve derinliği esas '
                  'alınır. Kablo alanı gerçek kablo dış çapından '
                  'hesaplanmalıdır. Geometrik doluluk sonucu tek başına '
                  'tesisatın kesin uygunluğu anlamına gelmez. Gerçek '
                  'kablo dış çapı, kablo yerleşimi, ısı dağılımı, '
                  'bükülme yarıçapı ve ilgili standart/şartname '
                  'hükümleri ayrıca kontrol edilmelidir.',
              'Conduit calculation uses the inner diameter, while '
                  'tray calculation uses the usable width and depth. '
                  'Cable area must be calculated from the actual outer '
                  'diameter.',
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// 2. MAKARADA KALAN KABLO
// ================================================================
//
// Teorik hesap:
//
// Vmakara = π/4 × (D² - d²) × W
//
// Vkablo(1m) = π/4 × dk² × 1000
//
// L = Vmakara / Vkablo(1m)
//
// Sonuç tahmini / teorik metrajdır.
// ================================================================

class MakaraEkrani extends StatefulWidget {
  const MakaraEkrani({super.key});

  @override
  State<MakaraEkrani> createState() => _MakaraEkraniState();
}

class _MakaraEkraniState extends State<MakaraEkrani> {
  String gerilim = 'AG';
  String iletken = 'Bakır';

  final TextEditingController disCap = TextEditingController(text: '1200');

  final TextEditingController gobekCap = TextEditingController(text: '500');

  final TextEditingController genislik = TextEditingController(text: '600');

  final TextEditingController kabloCap = TextEditingController(text: '30');

  double? metraj;
  double? makaraHacmi;
  double? kabloBirimHacmi;

  String? detay;

  void hesapla() {
    final D = _santiyeDouble(disCap.text);
    final d = _santiyeDouble(gobekCap.text);
    final W = _santiyeDouble(genislik.text);
    final dk = _santiyeDouble(kabloCap.text);

    if (D <= 0 || d <= 0 || W <= 0 || dk <= 0) {
      setState(() {
        metraj = null;
        makaraHacmi = null;
        kabloBirimHacmi = null;
        detay = null;
      });
      return;
    }

    if (D <= d) {
      setState(() {
        metraj = null;
        makaraHacmi = null;
        kabloBirimHacmi = null;
        detay = 'Makara dış çapı, göbek çapından büyük olmalıdır.';
      });
      return;
    }

    if (dk >= (D - d)) {
      setState(() {
        metraj = null;
        makaraHacmi = null;
        kabloBirimHacmi = null;
        detay = 'Kablo dış çapı, makaranın kullanılabilir sarım '
            'çap aralığından küçük olmalıdır.';
      });
      return;
    }

    final hacim = pi / 4 * (pow(D, 2).toDouble() - pow(d, 2).toDouble()) * W;

    final birimHacim = pi / 4 * pow(dk, 2).toDouble() * 1000;

    final sonuc = hacim / birimHacim;

    setState(() {
      metraj = sonuc;
      makaraHacmi = hacim;
      kabloBirimHacmi = birimHacim;

      detay = 'Makara sarım hacmi: '
          '${_santiyeFmt(hacim, digits: 0)} mm³\n'
          '1 m kablo teorik hacmi: '
          '${_santiyeFmt(birimHacim, digits: 0)} mm³/m\n'
          'Gerilim seviyesi: $gerilim\n'
          'İletken: $iletken';
    });
  }

  @override
  void dispose() {
    disCap.dispose();
    gobekCap.dispose();
    genislik.dispose();
    kabloCap.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: t(
        'Makarada Kalan Kablo',
        'Cable Remaining on Reel',
      ),
      info: true,
      onInfo: () => bilgiPopup(
        context,
        'Makarada Kalan Kablo',
        'Bu araç makara geometrisi ile kablo dış çapını kullanarak '
            'teorik kalan kablo metrajını hesaplar. Makaranın dış çapı, '
            'göbek çapı, genişliği ve kablonun gerçek dış çapı esas '
            'alınır. Sarım boşlukları ve gerçek sarım düzeni nedeniyle '
            'sonuç tahmini kabul edilmelidir.',
      ),
      body: ScrollBody(
        children: [
          SectionCard(
            title: t(
              'Makara',
              'Reel',
            ),
            children: [
              twoCol(
                Drop(
                  label: t(
                    'Gerilim Seviyesi',
                    'Voltage Level',
                  ),
                  value: gerilim,
                  items: const [
                    'AG',
                    'OG',
                  ],
                  onChanged: (v) {
                    if (v == null) return;

                    setState(() {
                      gerilim = v;
                      metraj = null;
                      detay = null;
                    });
                  },
                ),
                Drop(
                  label: t(
                    'İletken',
                    'Conductor',
                  ),
                  value: iletken,
                  items: const [
                    'Bakır',
                    'Alüminyum',
                  ],
                  onChanged: (v) {
                    if (v == null) return;

                    setState(() {
                      iletken = v;
                      metraj = null;
                      detay = null;
                    });
                  },
                ),
              ),
              Field(
                controller: disCap,
                label: t(
                  'Makara Dış Çapı (mm)',
                  'Reel Outer Diameter (mm)',
                ),
              ),
              Field(
                controller: gobekCap,
                label: t(
                  'Göbek Çapı (mm)',
                  'Core Diameter (mm)',
                ),
              ),
              Field(
                controller: genislik,
                label: t(
                  'Makara Genişliği (mm)',
                  'Reel Width (mm)',
                ),
              ),
              Field(
                controller: kabloCap,
                label: t(
                  'Kablo Dış Çapı (mm)',
                  'Cable Outer Diameter (mm)',
                ),
              ),
              calcButton(
                t(
                  'KALAN METRAJI HESAPLA',
                  'CALCULATE REMAINING LENGTH',
                ),
                hesapla,
              ),
            ],
          ),
          if (metraj != null) ...[
            uiResultCard(
              t(
                'Tahmini Kalan Metraj',
                'Estimated Remaining Length',
              ),
              _santiyeFmt(
                metraj!,
                digits: 1,
              ),
              'm',
            ),
            if (detay != null)
              uiResultCard(
                t(
                  'Hesap Detayı',
                  'Calculation Details',
                ),
                detay!,
                t(
                  'Teorik hesap',
                  'Theoretical calculation',
                ),
              ),
          ],
          if (detay != null && metraj == null)
            AdviceCard(
              title: t(
                'Kontrol',
                'Check',
              ),
              text: detay!,
            ),
          AdviceCard(
            title: t(
              'Teknik not',
              'Technical note',
            ),
            text: t(
              'Hesap, makaranın kablo sarılabilir geometrik hacmi ile '
                  'kablonun birim uzunluk hacminin karşılaştırılmasına '
                  'dayanır. Kablo dış çapı mümkünse üretici teknik '
                  'verisinden alınmalıdır. Sarım boşlukları, sarım düzeni, '
                  'flanşlar ve üretim toleransları nedeniyle sonuç teorik '
                  've tahmini kabul edilmelidir.',
              'The calculation compares the reel winding volume with '
                  'the cable volume per unit length. The result is '
                  'theoretical and estimated because of winding gaps '
                  'and reel geometry.',
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// SON
// ================================================================
