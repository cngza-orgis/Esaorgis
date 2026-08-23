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
// Kablo dış çapı merkezi teknik kablo verisinden alınır.
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

  final TextEditingController boruCap = TextEditingController(text: '25');

  final TextEditingController tavaGenislik = TextEditingController(text: '300');

  final TextEditingController tavaDerinlik = TextEditingController(text: '50');

  double? doluluk;
  double? kabloAlan;
  double? toplamKabloAlan;
  double? tasiyiciAlan;
  int? tavayaSiganAdet;

  String? hesapDetayi;

  // --------------------------------------------------------------
  // MERKEZİ KABLO DIŞ ÇAPI
  // --------------------------------------------------------------

  double? _merkeziDisCap(String secim) {
    return merkeziKabloDisCapGetir(secim);
  }

  double? get otomatikKabloDisCap {
    return _merkeziDisCap(kesit);
  }

  String get otomatikKabloDisCapMetin {
    final cap = otomatikKabloDisCap;

    if (cap == null || cap <= 0) {
      return 'Veri bulunamadı';
    }

    return '${_santiyeFmt(cap, digits: 1)} mm';
  }

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

    return liste;
  }

  // --------------------------------------------------------------
  // BORU HESABI
  // --------------------------------------------------------------

  void _hesaplaBoru() {
    final n = _santiyeDouble(adet.text);
    final dk = otomatikKabloDisCap;
    final db = _santiyeDouble(boruCap.text);

    if (n <= 0 || dk == null || dk <= 0 || db <= 0) {
      setState(() {
        doluluk = null;
        hesapDetayi = dk == null || dk <= 0
            ? 'Seçilen kablo için doğrulanmış merkezi dış çap '
                'verisi bulunamadı. Hesaplama yapılamıyor.'
            : 'Kablo adedi ve boru iç çapı sıfırdan büyük olmalıdır.';
      });
      return;
    }

    if (db <= dk) {
      setState(() {
        doluluk = null;
        hesapDetayi = 'Boru iç çapı, kablonun dış çapından büyük olmalıdır.\n'
            'Boru iç çapı: ${_santiyeFmt(db)} mm\n'
            'Kablo dış çapı: ${_santiyeFmt(dk)} mm';
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
          '${_santiyeFmt(n, digits: 0)}\n'
          'Otomatik kablo dış çapı: '
          '${_santiyeFmt(dk)} mm';
    });
  }

  // --------------------------------------------------------------
  // TAVA HESABI
  // --------------------------------------------------------------

  void _hesaplaTava() {
    final dk = otomatikKabloDisCap;

    final genislik = _santiyeDouble(tavaGenislik.text);

    final derinlik = _santiyeDouble(tavaDerinlik.text);

    if (dk == null || dk <= 0) {
      setState(() {
        doluluk = null;
        tavayaSiganAdet = null;
        hesapDetayi = 'Seçilen kablo için doğrulanmış merkezi dış çap '
            'verisi bulunamadı. Hesaplama yapılamıyor.';
      });
      return;
    }

    if (genislik <= 0 || derinlik <= 0) {
      setState(() {
        doluluk = null;
        tavayaSiganAdet = null;
        hesapDetayi = 'Tava genişliği ve kullanılabilir derinlik '
            'sıfırdan büyük olmalıdır.';
      });
      return;
    }

    // Kullanıcının kilitlediği çalışma kuralı:
    //
    // Tava hesabı kullanıcıdan kablo adedi istemez.
    //
    // Verilen tava ölçüsü ve gerçek kablo dış çapından
    // tavaya sığabilecek maksimum kablo adedini hesaplar.
    //
    // Dairesel kablo ile dikdörtgen tava arasındaki geometrik
    // yerleşim farkını karşılamak üzere %50 kullanılabilir alan
    // yaklaşımı uygulanır.
    //
    // Bu değer rezerv değildir.
    const double geometrikKullanim = 0.50;

    final tekKabloAlan = pi * pow(dk / 2, 2).toDouble();

    final tavaAlan = genislik * derinlik;

    final kullanilabilirAlan = tavaAlan * geometrikKullanim;

    final maxAdet = (kullanilabilirAlan / tekKabloAlan).floor();

    if (maxAdet < 1) {
      setState(() {
        doluluk = null;
        tavayaSiganAdet = 0;
        kabloAlan = tekKabloAlan;
        toplamKabloAlan = 0;
        tasiyiciAlan = tavaAlan;

        hesapDetayi = 'Seçilen kablonun dış çapına göre tavaya '
            'bir adet dahi yerleşemiyor.\n'
            'Tava ölçüsü veya gerçek kablo dış çapı '
            'kontrol edilmelidir.';
      });
      return;
    }

    final toplamAlan = tekKabloAlan * maxAdet;

    final sonuc = toplamAlan / tavaAlan * 100;

    setState(() {
      doluluk = sonuc;
      tavayaSiganAdet = maxAdet;
      kabloAlan = tekKabloAlan;
      toplamKabloAlan = toplamAlan;
      tasiyiciAlan = tavaAlan;

      hesapDetayi = 'Tava toplam alanı: '
          '${_santiyeFmt(tavaAlan)} mm²\n'
          'Geometrik kullanılabilir alan (%50): '
          '${_santiyeFmt(kullanilabilirAlan)} mm²\n'
          'Tek kablo dış kesit alanı: '
          '${_santiyeFmt(tekKabloAlan)} mm²\n'
          'Hesaplanan maksimum kablo adedi: '
          '$maxAdet\n'
          'Gerçekleşen geometrik doluluk: '
          '${_santiyeFmt(sonuc)} %\n'
          'Otomatik kablo dış çapı: '
          '${_santiyeFmt(dk)} mm';
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
        'Bu araç boru ve kablo tavasındaki geometrik doluluk '
            'oranını hesaplar.\n\n'
            'KABLO DIŞ ÇAPI:\n'
            'Kablo dış çapı kullanıcı tarafından girilmez. '
            'Seçilen kablo yapısı/kesiti için merkezi teknik '
            'kablo veri tabanındaki dış çap otomatik kullanılır. '
            'Doğrulanmış veri bulunmuyorsa uygulama tahmini '
            'bir değer üretmez.\n\n'
            'BORU:\n'
            'Boru hesabında kullanıcı kablo adedini ve boru iç '
            'çapını girer. Kablo dış çapı otomatik alınır ve '
            'kabloların toplam dairesel alanı ile boru iç alanı '
            'karşılaştırılır.\n\n'
            'TAVA:\n'
            'Tava hesabında kullanıcı kablo adedi girmez. '
            'Tava genişliği, kullanılabilir derinlik ve seçilen '
            'kablonun otomatik dış çapı kullanılarak tavaya '
            'geometrik olarak sığabilecek maksimum kablo adedi '
            'hesaplanır.\n\n'
            'Tava hesabında %50 geometrik kullanılabilir alan '
            'yaklaşımı uygulanır. Bu oran rezerv değildir.\n\n'
            'Gerçek saha yerleşimi, kablo gruplaması, ısı '
            'dağılımı, bükülme yarıçapı, üretici verileri ve '
            'ilgili standart/şartname hükümleri ayrıca '
            'değerlendirilmelidir.',
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
                    tavayaSiganAdet = null;
                    hesapDetayi = null;
                  });
                },
              ),

              const SizedBox(height: 8),

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

              const SizedBox(height: 8),

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
                    tavayaSiganAdet = null;
                    hesapDetayi = null;
                  });
                },
              ),

              const SizedBox(height: 8),

              // ------------------------------------------------------
              // OTOMATİK DIŞ ÇAP
              // ------------------------------------------------------

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: cIcon().withValues(alpha: 0.30),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        t(
                          'Kablo Dış Çapı',
                          'Cable Outer Diameter',
                        ),
                        style: TextStyle(
                          fontSize: 13,
                          color: cText(),
                        ),
                      ),
                    ),
                    Text(
                      otomatikKabloDisCapMetin,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color:
                            otomatikKabloDisCap != null ? cIcon() : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 4),

              Text(
                otomatikKabloDisCap != null
                    ? t(
                        'Seçilen kablonun dış çapı merkezi teknik veriden otomatik alınır.',
                        'The cable outer diameter is obtained automatically from the central technical data.',
                      )
                    : t(
                        'Bu kablo için doğrulanmış dış çap verisi bulunamadı.',
                        'No verified outer diameter data is available for this cable.',
                      ),
                style: TextStyle(
                  fontSize: 11.5,
                  height: 1.3,
                  color: otomatikKabloDisCap != null
                      ? cText().withValues(alpha: 0.60)
                      : Colors.red.shade700,
                ),
              ),

              const SizedBox(height: 10),

              // ------------------------------------------------------
              // BORU
              // ------------------------------------------------------

              if (uygulama == 'Boru')
                twoCol(
                  Field(
                    controller: adet,
                    label: t(
                      'Kablo Adedi',
                      'Number of Cables',
                    ),
                  ),
                  Field(
                    controller: boruCap,
                    label: t(
                      'Boru İç Çapı (mm)',
                      'Conduit Inner Diameter (mm)',
                    ),
                  ),
                ),

              // ------------------------------------------------------
              // TAVA
              // ------------------------------------------------------

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

              const SizedBox(height: 12),

              calcButton(
                t(
                  'DOLULUĞU HESAPLA',
                  'CALCULATE FILL',
                ),
                hesapla,
              ),
            ],
          ),

          // ==========================================================
          // SONUÇLAR
          // ==========================================================

          if (doluluk != null) ...[
            if (uygulama == 'Tava' && tavayaSiganAdet != null)
              uiResultCard(
                t(
                  'Tavaya Sığan Kablo',
                  'Cables That Fit',
                ),
                '${tavayaSiganAdet!} adet',
                t(
                  'Maksimum yerleşim',
                  'Maximum placement',
                ),
                technicalDetails: TechnicalResultDetails(
                  nedir:
                      'Seçilen tava ölçüsü ve doğrulanmış kablo dış çapına göre geometrik olarak yerleşebilecek maksimum kablo adedidir.',
                  nasilHesaplandi:
                      "Tava alanının %50'si geometrik kullanılabilir alan kabul edilerek, bu alan tek kablonun dairesel dış kesit alanına bölünmüş ve tam sayı aşağı yuvarlanmıştır.",
                  neyeGoreSecildi:
                      'Tava genişliği, kullanılabilir derinlik ve seçilen kablonun merkezi teknik verisindeki dış çapı esas alınmıştır.',
                  nedenCikti:
                      '${tavayaSiganAdet!} adet sonucu, seçilen kablonun otomatik dış çapı ile mevcut geometrik kullanılabilir alanın oranından oluşmuştur.',
                  sahaNotu:
                      'Bu sonuç geometrik ön değerlendirmedir. Kablo gruplaması, ısı dağılımı, bükülme yarıçapı, gerçek yerleşim düzeni ve ilgili standart/şartname ayrıca doğrulanmalıdır.',
                ),
              ),
            uiResultCard(
              t(
                'Geometrik Doluluk',
                'Geometric Fill',
              ),
              _santiyeFmt(doluluk!),
              '%',
              technicalDetails: TechnicalResultDetails(
                nedir:
                    'Yerleşen kabloların toplam dairesel kesit alanının toplam taşıyıcı alanına oranıdır.',
                nasilHesaplandi:
                    'Toplam kablo dış kesit alanı taşıyıcı toplam alana bölünüp 100 ile çarpılmıştır.',
                neyeGoreSecildi:
                    'Seçilen kablonun merkezi teknik verisindeki dış çapı, hesaplanan adet ve taşıyıcı ölçüleri kullanılmıştır.',
                nedenCikti:
                    '${_santiyeFmt(doluluk!)} % değeri, hesaplanan kablo alanı ile taşıyıcı alanı arasındaki geometrik orandan oluşmuştur.',
                sahaNotu:
                    'Geometrik doluluk tek başına elektriksel veya mekanik tesisat uygunluğu anlamına gelmez; ısı, gruplanma, bükülme yarıçapı ve standart/şartname koşulları ayrıca kontrol edilmelidir.',
              ),
            ),
            uiResultCard(
              t(
                'Kablo Dış Çapı',
                'Cable Outer Diameter',
              ),
              otomatikKabloDisCapMetin,
              t(
                'Otomatik teknik veri',
                'Automatic technical data',
              ),
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
                technicalDetails: TechnicalResultDetails(
                  nedir:
                      'Hesapta kullanılan ara büyüklükleri ve sonuç zincirini gösteren özettir.',
                  nasilHesaplandi: hesapDetayi!,
                  neyeGoreSecildi:
                      'Kullanıcı girişleri ve merkezi kablo dış çapı verisi esas alınmıştır.',
                  nedenCikti:
                      'Özet, hesap motorunun ürettiği ara değerleri açıklamak için gösterilir.',
                  sahaNotu:
                      'Üretici dış çapı veya saha koşulları farklıysa sonuç yeniden hesaplanmalıdır.',
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
              uygulama == 'Tava' ? 'Tava hesaplama yöntemi' : 'Teknik not',
              uygulama == 'Tava' ? 'Tray calculation method' : 'Technical note',
            ),
            text: t(
              uygulama == 'Tava'
                  ? 'Tava hesabında kablo adedi kullanıcıdan alınmaz. Tava genişliği ve kullanılabilir derinlik ile merkezi teknik veriden alınan kablo dış çapı kullanılarak maksimum yerleşebilecek adet hesaplanır. Dairesel kabloların dikdörtgen tavada geometrik yerleşim farkı için %50 kullanılabilir alan yaklaşımı uygulanır. Bu oran rezerv değildir. Sonuç, gerçek kablo yerleşimi, dış çap toleransları, kablo gruplaması, ısı dağılımı, bükülme yarıçapı ve ilgili standart/şartname hükümleriyle ayrıca doğrulanmalıdır.'
                  : 'Boru hesabında borunun iç çapı ve kullanıcı tarafından girilen kablo adedi esas alınır. Kablo dış çapı merkezi teknik veriden otomatik alınır. Geometrik doluluk tek başına kesin tesisat uygunluğu anlamına gelmez; ilgili standart/şartname, ısı dağılımı, bükülme yarıçapı ve gerçek saha koşulları ayrıca kontrol edilmelidir.',
              uygulama == 'Tava'
                  ? 'Tray calculation does not ask for cable quantity. It calculates the maximum number from tray dimensions and the cable outer diameter obtained from central technical data, using a 50% usable-area approach for geometric packing. This is not a spare allowance.'
                  : 'Conduit calculation uses conduit inner diameter and the entered cable quantity. Cable outer diameter is obtained automatically from central technical data.',
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
//
// ================================================================

class MakaraEkrani extends StatefulWidget {
  const MakaraEkrani({super.key});

  @override
  State<MakaraEkrani> createState() => _MakaraEkraniState();
}

class _MakaraEkraniState extends State<MakaraEkrani> {
  String gerilim = 'AG';
  String iletken = 'Bakır';
  String kesit = '3x16+10 mm²';

  final TextEditingController disCap = TextEditingController(text: '1200');

  final TextEditingController gobekCap = TextEditingController(text: '500');

  final TextEditingController genislik = TextEditingController(text: '600');

  List<String> get _makaraKabloListesi {
    final liste = List<String>.from(standartKabloSecimListesi);

    if (liste.isNotEmpty) {
      return liste;
    }

    return const [
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

  double? get _makaraMerkeziCap {
    return merkeziKabloDisCapGetir(kesit);
  }

  String get _makaraDisCapMetin {
    final cap = _makaraMerkeziCap;

    if (cap == null || cap <= 0) {
      return 'Veri bulunamadı';
    }

    return '${_santiyeFmt(cap, digits: 1)} mm';
  }

  double? metraj;
  double? makaraHacmi;
  double? kabloBirimHacmi;

  String? detay;

  void hesapla() {
    final D = _santiyeDouble(disCap.text);

    final d = _santiyeDouble(gobekCap.text);

    final W = _santiyeDouble(genislik.text);

    final dk = _makaraMerkeziCap;

    if (D <= 0 || d <= 0 || W <= 0 || dk == null || dk <= 0) {
      setState(() {
        metraj = null;
        makaraHacmi = null;
        kabloBirimHacmi = null;

        detay = dk == null || dk <= 0
            ? 'Seçilen kablo için doğrulanmış merkezi dış çap '
                'verisi bulunamadı. Hesaplama yapılamıyor.'
            : null;
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
            'çap aralığından küçük olmalıdır.\n'
            'Kablo dış çapı: '
            '${_santiyeFmt(dk)} mm\n'
            'Kullanılabilir çap farkı: '
            '${_santiyeFmt(D - d)} mm';
      });
      return;
    }

    // Makaranın teorik sarım hacmi.
    final hacim = pi / 4 * (pow(D, 2).toDouble() - pow(d, 2).toDouble()) * W;

    // 1 metre kablonun teorik hacmi.
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
          'Otomatik kablo dış çapı: '
          '${_santiyeFmt(dk)} mm\n'
          'Gerilim seviyesi: $gerilim\n'
          'İletken: $iletken';
    });
  }

  @override
  void dispose() {
    disCap.dispose();
    gobekCap.dispose();
    genislik.dispose();

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
        'Bu araç makara geometrisi ile seçilen kablonun '
            'merkezi teknik veriden alınan dış çapını kullanarak '
            'teorik kalan kablo metrajını hesaplar.\n\n'
            'Kablo dış çapı kullanıcı tarafından girilmez. '
            'Kesit/yapı seçildiğinde merkezi kablo veri '
            'tabanındaki doğrulanmış değer otomatik kullanılır.\n\n'
            'Makaranın dış çapı, göbek çapı, genişliği ve '
            'kablonun gerçek dış çapı esas alınır.\n\n'
            'Sarım boşlukları, katmanlar, gerçek sarım düzeni, '
            'makara toleransları ve üretici verileri nedeniyle '
            'sonuç teorik/tahmini kabul edilmelidir.',
      ),
      body: ScrollBody(
        children: [
          SectionCard(
            title: t(
              'Makara',
              'Reel',
            ),
            children: [
              // ------------------------------------------------------
              // KABLO YAPISI / KESİT
              // ------------------------------------------------------

              Drop(
                label: t(
                  'Kablo Yapısı / Kesiti',
                  'Cable Construction / Size',
                ),
                value: _makaraKabloListesi.contains(kesit)
                    ? kesit
                    : _makaraKabloListesi.isNotEmpty
                        ? _makaraKabloListesi.first
                        : '',
                items: _makaraKabloListesi,
                onChanged: (v) {
                  if (v == null) return;

                  setState(() {
                    kesit = v;
                    metraj = null;
                    detay = null;
                  });
                },
              ),

              const SizedBox(height: 8),

              // ------------------------------------------------------
              // GERİLİM + İLETKEN
              // ------------------------------------------------------

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

              const SizedBox(height: 8),

              // ------------------------------------------------------
              // MAKARA DIŞ ÇAPI
              // ------------------------------------------------------

              Field(
                controller: disCap,
                label: t(
                  'Makara Dış Çapı (mm)',
                  'Reel Outer Diameter (mm)',
                ),
              ),

              // ------------------------------------------------------
              // GÖBEK ÇAPI
              // ------------------------------------------------------

              Field(
                controller: gobekCap,
                label: t(
                  'Göbek Çapı (mm)',
                  'Core Diameter (mm)',
                ),
              ),

              // ------------------------------------------------------
              // MAKARA GENİŞLİĞİ
              // ------------------------------------------------------

              Field(
                controller: genislik,
                label: t(
                  'Makara Genişliği (mm)',
                  'Reel Width (mm)',
                ),
              ),

              const SizedBox(height: 8),

              // ------------------------------------------------------
              // OTOMATİK KABLO DIŞ ÇAPI
              // ------------------------------------------------------

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: cIcon().withValues(
                      alpha: 0.30,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        t(
                          'Kablo Dış Çapı',
                          'Cable Outer Diameter',
                        ),
                        style: TextStyle(
                          fontSize: 13,
                          color: cText(),
                        ),
                      ),
                    ),
                    Text(
                      _makaraDisCapMetin,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: _makaraMerkeziCap != null ? cIcon() : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 4),

              Text(
                _makaraMerkeziCap != null
                    ? t(
                        'Seçilen kablonun dış çapı merkezi teknik veriden otomatik alınır.',
                        'The cable outer diameter is obtained automatically from central technical data.',
                      )
                    : t(
                        'Bu kablo için doğrulanmış dış çap verisi bulunamadı.',
                        'No verified outer diameter data is available for this cable.',
                      ),
                style: TextStyle(
                  fontSize: 11.5,
                  height: 1.3,
                  color: _makaraMerkeziCap != null
                      ? cText().withValues(alpha: 0.60)
                      : Colors.red.shade700,
                ),
              ),

              const SizedBox(height: 12),

              calcButton(
                t(
                  'KALAN METRAJI HESAPLA',
                  'CALCULATE REMAINING LENGTH',
                ),
                hesapla,
              ),
            ],
          ),

          // ==========================================================
          // SONUÇ
          // ==========================================================

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
              technicalDetails: TechnicalResultDetails(
                nedir:
                    'Makaranın mevcut geometrik hacminden, seçilen kablonun teorik birim hacmi kullanılarak hesaplanan kalan metrajdır.',
                nasilHesaplandi:
                    'Makaranın dış çapı, göbek çapı ve genişliğinden halka hacmi; kablonun dış çapından 1 metreye ait teorik silindirik hacim hesaplanmış ve oranlanmıştır.',
                neyeGoreSecildi:
                    'Makara ölçüleri ile seçilen kablonun merkezi teknik verisinden alınan dış çap kullanılmıştır.',
                nedenCikti:
                    '${_santiyeFmt(metraj!, digits: 1)} m sonucu, makara sarım hacminin birim kablo hacmine bölünmesinden oluşmuştur.',
                sahaNotu:
                    'Bu değer teorik hacim hesabıdır; gerçek sarım düzeni, sıkışma, katmanlar, makara toleransları ve üretici makara verileri ayrıca dikkate alınmalıdır.',
              ),
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
                technicalDetails: TechnicalResultDetails(
                  nedir:
                      'Makara hesabında kullanılan ara büyüklüklerin teknik özetidir.',
                  nasilHesaplandi: detay!,
                  neyeGoreSecildi:
                      'Makara ölçüleri, merkezi kablo dış çapı ve seçilen kablo/iletken bilgileri kullanılmıştır.',
                  nedenCikti:
                      'Ara değerler, teorik kalan metraj hesabının nasıl oluştuğunu göstermek için sunulur.',
                  sahaNotu:
                      'Gerçek makara doluluğu üretici makara geometrisi ve sarım yöntemiyle ayrıca doğrulanmalıdır.',
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
                  'dayanır. Kablo dış çapı merkezi teknik veriden '
                  'otomatik alınır. Sarım boşlukları, sarım düzeni, '
                  'flanşlar ve üretim toleransları nedeniyle sonuç '
                  'teorik ve tahmini kabul edilmelidir.',
              'The calculation compares the reel winding volume with '
                  'the cable volume per unit length. The cable outer '
                  'diameter is obtained automatically from central '
                  'technical data. The result is theoretical and '
                  'estimated because of winding gaps and reel geometry.',
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
