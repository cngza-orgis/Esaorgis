part of 'main.dart';

// ================================================================
// FATURALAMA / FATURA ANALİZİ / KABLO / SİGORTA ARAÇLARI
// ================================================================
//
// Bu dosya main.dart dosyasının PART dosyasıdır.
//
// main.dart içerisinde:
//   part 'faturalama.dart';
//
// bulunduğu için bu dosyanın ilk satırı:
//
//   part of 'main.dart';
//
// olmalıdır.
//
// Buradaki sınıflar:
//   - CihazSepetiEkrani
//   - KabloKapasitesiEkrani
//   - SigortaEkrani
//   - FaturaAnaliziEkrani
//
// ================================================================

// ================================================================
// 1. CİHAZ SEPETİ / FATURA TAHMİNLEME
// ================================================================

class CihazSepetiEkrani extends StatefulWidget {
  const CihazSepetiEkrani({super.key});

  @override
  State<CihazSepetiEkrani> createState() => _CihazSepetiEkraniState();
}

class _SepetItem {
  final String ad;
  final double w;
  final int adet;
  final double saat;

  const _SepetItem(
    this.ad,
    this.w,
    this.adet,
    this.saat,
  );
}

class _CihazSepetiEkraniState extends State<CihazSepetiEkrani> {
  final TextEditingController adet = TextEditingController(text: '1');

  final TextEditingController saat = TextEditingController(text: '1');

  final TextEditingController digerGuc = TextEditingController();

  final TextEditingController fiyat = TextEditingController();

  String cihaz = 'Buzdolabı';

  bool ozelSure = false;

  bool maliyet = false;

  double? kwh;

  double? tl;

  final List<_SepetItem> sepet = [];

  final Map<String, double> cihazlar = const {
    'Buzdolabı': 150,
    'Derin Dondurucu': 180,
    'Çamaşır Makinesi': 700,
    'Bulaşık Makinesi': 1200,
    'Kurutma Makinesi': 2200,
    'Televizyon': 120,
    'Bilgisayar': 250,
    'Monitör': 60,
    'Modem / Router': 15,
    'Yazıcı': 80,
    'Klima': 1500,
    'Vantilatör': 70,
    'Elektrikli Süpürge': 900,
    'Ütü': 2200,
    'Saç Kurutma Makinesi': 1800,
    'Tıraş Makinesi': 15,
    'Mikrodalga Fırın': 1200,
    'Fırın': 2500,
    'Elektrikli Ocak': 2000,
    'Kettle': 2000,
    'Tost Makinesi': 1800,
    'Çay Makinesi': 1500,
    'Kahve Makinesi': 1200,
    'Ekmek Kızartma Makinesi': 1000,
    'Mutfak Robotu': 800,
    'Su Sebili': 120,
    'Doğalgaz Kombisi (elektrik)': 120,
    'Elektrikli Şofben': 5000,
    'Elektrikli Termosifon': 2000,
    'Bulaşık Kurutucu': 300,
    'Akvaryum': 100,
    'Dizüstü Bilgisayar': 65,
    'Telefon Şarjı': 10,
    'Oyun Konsolu': 150,
    'Güvenlik Kamerası Sistemi': 60,
    'Alarm Sistemi': 20,
    'LED Aydınlatma Grubu': 250,
    'Elektrikli El Aleti': 800,
    'Matkap': 700,
    'Kompresör': 1500,
    'Su Pompası': 750,
    'Hidrofor': 1100,
    'Diğer': 0,
  };

  final Map<String, double> ortSure = const {
    'Buzdolabı': 8,
    'Derin Dondurucu': 8,
    'Televizyon': 5,
    'Bilgisayar': 6,
    'Dizüstü Bilgisayar': 6,
    'Modem / Router': 24,
    'Yazıcı': 0.5,
    'Çamaşır Makinesi': 1,
    'Bulaşık Makinesi': 1,
    'Kurutma Makinesi': 1,
    'Klima': 6,
    'Vantilatör': 6,
    'Fırın': 1,
    'Elektrikli Ocak': 1,
    'Kettle': 0.3,
    'Tost Makinesi': 0.3,
    'Çay Makinesi': 1,
    'Kahve Makinesi': 0.5,
    'Doğalgaz Kombisi (elektrik)': 6,
    'Akvaryum': 12,
    'Güvenlik Kamerası Sistemi': 24,
    'Alarm Sistemi': 24,
    'LED Aydınlatma Grubu': 6,
    'Telefon Şarjı': 2,
    'Oyun Konsolu': 3,
    'Su Pompası': 2,
    'Hidrofor': 1,
  };

  @override
  void dispose() {
    adet.dispose();
    saat.dispose();
    digerGuc.dispose();
    fiyat.dispose();
    super.dispose();
  }

  void ekle() {
    final int n = int.tryParse(adet.text.trim()) ?? 0;

    final double h = ozelSure
        ? (double.tryParse(
              saat.text.trim().replaceAll(',', '.'),
            ) ??
            0)
        : (ortSure[cihaz] ?? 1);

    final double w = cihaz == 'Diğer'
        ? (double.tryParse(
              digerGuc.text.trim().replaceAll(',', '.'),
            ) ??
            0)
        : (cihazlar[cihaz] ?? 0);

    if (n <= 0 || w <= 0 || h < 0) {
      return;
    }

    setState(() {
      sepet.add(
        _SepetItem(
          cihaz,
          w,
          n,
          h,
        ),
      );
    });
  }

  void hesapla() {
    final double total = sepet.fold<double>(
      0,
      (sum, e) => sum + e.w * e.adet * e.saat * 30 / 1000,
    );

    final double unit = double.tryParse(
          fiyat.text.trim().replaceAll(',', '.'),
        ) ??
        0;

    setState(() {
      kwh = total;
      tl = maliyet && unit > 0 ? total * unit : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Fatura Tahminleme',
      body: ScrollBody(
        children: [
          SectionCard(
            title: 'Cihaz Sepeti',
            children: [
              Drop(
                label: 'Cihaz',
                value: cihaz,
                items: cihazlar.keys.toList(),
                onChanged: (v) {
                  if (v == null) return;

                  setState(() {
                    cihaz = v;
                  });
                },
              ),
              twoCol(
                Field(
                  controller: adet,
                  label: 'Adet',
                ),
                Field(
                  controller: saat,
                  label: 'Çalışma süresi (saat/gün)',
                ),
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Çalışma süresini manuel girmek istiyorum',
                  style: TextStyle(
                    color: cText(),
                    fontSize: 13,
                  ),
                ),
                value: ozelSure,
                onChanged: (v) {
                  setState(() {
                    ozelSure = v ?? false;
                  });
                },
              ),
              if (cihaz == 'Diğer')
                Field(
                  controller: digerGuc,
                  label: 'Güç (W)',
                ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: ekle,
                      child: const Text(
                        'SEPETE EKLE',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: sepet.isEmpty ? null : hesapla,
                      child: const Text(
                        'HESAPLA',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (sepet.isNotEmpty)
            SectionCard(
              title: 'Sepet',
              children: sepet
                  .map(
                    (e) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        e.ad,
                        style: TextStyle(
                          color: cText(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '${fmt2(e.w)} W • '
                        '${e.adet} adet • '
                        '${fmt2(e.saat)} saat/gün',
                        style: TextStyle(
                          color: cText(),
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                        ),
                        onPressed: () {
                          setState(() {
                            sepet.remove(e);
                          });
                        },
                      ),
                    ),
                  )
                  .toList(),
            ),
          if (kwh != null)
            uiResultCard(
              'Aylık Tüketim',
              fmt2(kwh!),
              'kWh',
            ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              'İsteğe bağlı TL tutarı hesapla',
              style: TextStyle(
                color: cText(),
              ),
            ),
            value: maliyet,
            onChanged: (v) {
              setState(() {
                maliyet = v;

                if (!v) {
                  tl = null;
                }
              });
            },
          ),
          if (maliyet)
            Field(
              controller: fiyat,
              label: 'Birim fiyat (TL/kWh)',
            ),
          if (tl != null)
            uiResultCard(
              'Tahmini Aylık Tutar',
              fmt2(tl!),
              'TL',
            ),
          const AdviceCard(
            title: 'Bilgi',
            text: 'Manuel süre seçilmezse cihaz için '
                'uygulamada tanımlı ortalama günlük '
                'kullanım süresi kullanılır ve sonuç '
                'tahmini kabul edilir. Doğalgaz kombisi '
                'için yalnızca elektrik tüketen fan, '
                'pompa ve kontrol elektroniği dikkate '
                'alınır; doğalgaz tüketimi hesaplanmaz.',
          ),
        ],
      ),
    );
  }
}

// ================================================================
// 2. KABLO AKIM TAŞIMA KAPASİTESİ
// ================================================================

class KabloKapasitesiEkrani extends StatefulWidget {
  const KabloKapasitesiEkrani({super.key});

  @override
  State<KabloKapasitesiEkrani> createState() => _KabloKapasitesiEkraniState();
}

class _KabloKapasitesiEkraniState extends State<KabloKapasitesiEkrani> {
  String kesit = standartKabloSecimListesi.firstWhere(
    (e) => e == '1x1,5 mm²',
    orElse: () => standartKabloSecimListesi.first,
  );

  String malzeme = 'Bakır';

  String doseme = 'Havada';

  double? kapasite;

  String? detay;

  double _anaKesit(String s) {
    final String clean = s.replaceAll(',', '.');

    final RegExp uc = RegExp(r'(\d+)x\((\d+(?:\.\d+)?)');

    final Match? ucMatch = uc.firstMatch(clean);

    if (ucMatch != null) {
      return double.tryParse(
            ucMatch.group(2)!,
          ) ??
          0;
    }

    final RegExp tek = RegExp(r'(\d+)x(\d+(?:\.\d+)?)');

    final Match? tekMatch = tek.firstMatch(clean);

    if (tekMatch != null) {
      return double.tryParse(
            tekMatch.group(2)!,
          ) ??
          0;
    }

    return 0;
  }

  int _paralel(String s) {
    final Match? m = RegExp(r'^(\d+)x\(').firstMatch(s);

    if (m == null) {
      return 1;
    }

    return int.tryParse(
          m.group(1)!,
        ) ??
        1;
  }

  double _base(double sec) {
    const List<double> smallSections = [
      0.75,
      1.0,
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
      150.0,
      185.0,
      240.0,
    ];

    const List<double> small = [
      10.0,
      12.0,
      15.0,
      21.0,
      28.0,
      36.0,
      50.0,
      68.0,
      89.0,
      111.0,
      134.0,
      171.0,
      207.0,
      239.0,
      275.0,
      314.0,
      369.0,
    ];

    const List<double> airSections = [
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

    const List<double> air = [
      108.0,
      132.0,
      160.0,
      202.0,
      249.0,
      289.0,
      329.0,
      377.0,
      443.0,
    ];

    if (sec >= 25) {
      final int i = airSections.indexOf(sec);

      if (i >= 0) {
        return air[i];
      }
    }

    final int i = smallSections.indexOf(sec);

    if (i < 0) {
      return 0;
    }

    return small[i];
  }

  void hesapla() {
    final double sec = _anaKesit(kesit);

    final int n = _paralel(kesit);

    if (sec <= 0) {
      setState(() {
        kapasite = null;
        detay = null;
      });
      return;
    }

    double b = _base(sec) * n;

    if (malzeme == 'Alüminyum') {
      b *= 0.78;
    }

    final Map<String, double> faktorler = {
      'Havada': 1.0,
      'Toprakta': 0.82,
      'Boruda': 0.80,
      'Kablo Tavasında': 0.95,
    };

    final double f = faktorler[doseme] ?? 1.0;

    final double corrected = b * f;

    setState(() {
      kapasite = corrected;

      detay = 'Temel referans: '
          '${b.toStringAsFixed(0)} A • '
          'Döşeme katsayısı: '
          '${f.toStringAsFixed(2)} • '
          'Paralel sistem: $n';
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Kablo Akım Taşıma Kapasitesi',
      body: ScrollBody(
        children: [
          SectionCard(
            title: 'Kablo Seçimi',
            children: [
              twoCol(
                Drop(
                  label: 'İletken Malzemesi',
                  value: malzeme,
                  items: const [
                    'Bakır',
                    'Alüminyum',
                  ],
                  onChanged: (v) {
                    if (v == null) return;

                    setState(() {
                      malzeme = v;
                      kapasite = null;
                    });
                  },
                ),
                Drop(
                  label: 'Döşeme Şekli',
                  value: doseme,
                  items: const [
                    'Havada',
                    'Toprakta',
                    'Boruda',
                    'Kablo Tavasında',
                  ],
                  onChanged: (v) {
                    if (v == null) return;

                    setState(() {
                      doseme = v;
                      kapasite = null;
                    });
                  },
                ),
              ),
              Drop(
                label: 'Kablo Kesiti / Yapısı',
                value: kesit,
                items: standartKabloSecimListesi,
                onChanged: (v) {
                  if (v == null) return;

                  setState(() {
                    kesit = v;
                    kapasite = null;
                  });
                },
              ),
              calcButton(
                'KAPASİTEYİ HESAPLA',
                hesapla,
              ),
            ],
          ),
          if (kapasite != null)
            uiResultCard(
              'Yaklaşık sürekli akım taşıma kapasitesi',
              fmt2(kapasite!),
              'A',
            ),
          if (detay != null)
            uiResultCard(
              'Hesap özeti',
              detay!,
              'Ön değerlendirme',
            ),
          const AdviceCard(
            title: 'Teknik not',
            text: 'Kablo kapasitesi; kablo yapısı, '
                'iletken malzemesi, döşeme biçimi, '
                'ortam sıcaklığı, paralel sistem sayısı '
                've düzeltme katsayılarına bağlıdır. '
                'Buradaki sonuç ön değerlendirmedir; '
                'kesin saha kesiti ilgili standart, '
                'üretici tablosu ve gerçek döşeme '
                'koşullarıyla doğrulanmalıdır.',
          ),
        ],
      ),
    );
  }
}

// ================================================================
// 3. SİGORTA SEÇİMİ
// ================================================================

class SigortaEkrani extends StatefulWidget {
  const SigortaEkrani({super.key});

  @override
  State<SigortaEkrani> createState() => _SigortaEkraniState();
}

class _SigortaEkraniState extends State<SigortaEkrani> {
  final TextEditingController power = TextEditingController();

  String sistem = 'Trifaze';

  double? current;

  int? fuse;

  @override
  void dispose() {
    power.dispose();
    super.dispose();
  }

  void hesapla() {
    final double p = double.tryParse(
          power.text.trim().replaceAll(',', '.'),
        ) ??
        0;

    if (p <= 0) {
      setState(() {
        current = null;
        fuse = null;
      });
      return;
    }

    final double i = sistem == 'Trifaze'
        ? p * 1000 / (sqrt(3) * 380 * 0.9)
        : p * 1000 / (220 * 0.9);

    setState(() {
      current = i;
      fuse = standartTMSBul(i);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: t(
        'Kablo ve Sigorta Seçimi',
        'Cable & Fuse Selection',
      ),
      body: ScrollBody(
        children: [
          Row(
            children: [
              Expanded(
                child: Field(
                  controller: power,
                  label: t(
                    'Güç (kW)',
                    'Power (kW)',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Drop(
                  label: t(
                    'Sistem',
                    'System',
                  ),
                  value: sistem,
                  items: const [
                    'Trifaze',
                    'Monofaze',
                  ],
                  onChanged: (v) {
                    if (v == null) return;

                    setState(() {
                      sistem = v;
                      current = null;
                      fuse = null;
                    });
                  },
                ),
              ),
            ],
          ),
          calcButton(
            t(
              'HESAPLA',
              'CALCULATE',
            ),
            hesapla,
          ),
          if (current != null)
            uiResultCard(
              t(
                'Hesaplanan Akım',
                'Calculated Current',
              ),
              current!.toStringAsFixed(2),
              'A',
            ),
          if (fuse != null)
            uiResultCard(
              t(
                'Önerilen Sigorta / TMŞ',
                'Recommended Fuse / MCCB',
              ),
              fuse.toString(),
              'A',
            ),
          if (fuse != null)
            uiResultCard(
              t(
                'Önerilen Kablo',
                'Recommended Cable',
              ),
              standartKabloBulNYY(
                fuse!.toDouble(),
                sistem == 'Trifaze',
              ),
              '',
            ),
          AdviceCard(
            title: t(
              'Uyarı',
              'Warning',
            ),
            text: t(
              'Bu bir ön seçim aracıdır. Kısa devre hesabı, '
                  'açma eğrisi, kablo akım taşıma kapasitesi '
                  've koordinasyon ayrıca doğrulanmalıdır.',
              'This is a preselection tool. Short-circuit '
                  'calculation, trip curve, cable ampacity '
                  'and coordination must be verified separately.',
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// 4. FATURA ANALİZİ
// ================================================================
//
// YALNIZCA:
//   Fatura TL → yaklaşık kWh
//
// Bu araçta:
//   - kWh → Fatura hesabı yoktur.
//   - Dönem girişi yoktur.
//   - Gün girişi yoktur.
//   - T1 / T2 / T3 girişi yoktur.
//   - Çevrim içi veri sorgulaması yoktur.
//
// Hesaplama, toplam fatura tutarı ile tüketim arasındaki
// tanımlı oransal ilişki kullanılarak çevrim dışı
// tahminleme yöntemiyle yapılır.
//
// Sonuç yaklaşık tüketim değeridir.
// Gerçek tüketim, sayaç veya fatura üzerindeki kWh değeriyle
// doğrulanmalıdır.
//
// ================================================================

class FaturaAnaliziEkrani extends StatefulWidget {
  const FaturaAnaliziEkrani({super.key});

  @override
  State<FaturaAnaliziEkrani> createState() => _FaturaAnaliziEkraniState();
}

class _FaturaAnaliziEkraniState extends State<FaturaAnaliziEkrani> {
  final TextEditingController fatura = TextEditingController();

  String tarife = 'Mesken';
  bool analysed = false;
  double? sonucKwh;
  double? efektifBirim;
  String sonucNotu = '';

  // Çevrim dışı Mesken referansı.
  // Diğer tarifeler, gerçek fatura örnekleri ile ayrı ayrı kalibre edilecektir.
  static const double referansFaturaTl = 595.00;
  static const double referansKwh = 184.00;
  static const double referansToplamBirim = referansFaturaTl / referansKwh;

  double _oku(TextEditingController controller) {
    return double.tryParse(controller.text.trim().replaceAll(',', '.')) ?? 0;
  }

  void _faturadanKwh() {
    final hedef = _oku(fatura);

    if (hedef <= 0) {
      setState(() {
        analysed = false;
        sonucKwh = null;
        efektifBirim = null;
        sonucNotu = 'Geçerli bir fatura tutarı giriniz.';
      });
      return;
    }

    if (tarife != 'Mesken') {
      setState(() {
        analysed = false;
        sonucKwh = null;
        efektifBirim = null;
        sonucNotu = 'Bu tarife için çevrim dışı referans katsayısı henüz tanımlanmadı. Gerçek fatura örnekleriyle kalibrasyon tamamlandığında hesaplama etkinleştirilecektir.';
      });
      return;
    }

    final q = hedef / referansToplamBirim;

    setState(() {
      analysed = true;
      sonucKwh = q;
      efektifBirim = q > 0 ? hedef / q : null;
      sonucNotu = 'Bu sonuç, seçilen tarife için tanımlanmış referans tüketim–tutar ilişkisi kullanılarak çevrim dışı ve oransal tahminleme yöntemiyle hesaplanmıştır. Gerçek tüketim; tarife, kademe, vergi ve diğer fatura koşullarına göre farklılık gösterebilir. Sonuç yaklaşık bir tahmindir ve gerçek fatura veya sayaç kWh değeriyle doğrulanmalıdır.';
    });
  }

  void temizle() {
    fatura.clear();
    setState(() {
      analysed = false;
      sonucKwh = null;
      efektifBirim = null;
      sonucNotu = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Fatura Analizi',
      info: true,
      onInfo: () => bilgiPopup(
        context,
        'Fatura Analizi — Bilgi / Yardım',
        'Bu araç yalnızca TL tutarından yaklaşık kWh tüketimi tahmin eder. Dönem, gün ve kWh → fatura hesabı bulunmaz. Tarife seçimi önemlidir; her tarife için ayrı çevrim dışı referans katsayısı kullanılmalıdır. Yeni tarifeler gerçek fatura örnekleriyle kalibre edilecektir. Hesaplama oransal tahminleme yöntemidir; kesin tüketim değeri olarak kullanılmamalı, gerçek sayaç/fatura değeriyle doğrulanmalıdır.',
      ),
      body: ScrollBody(
        children: [
          SectionCard(
            title: 'Fatura Bilgileri',
            children: [
              Field(
                controller: fatura,
                label: 'Fatura tutarı (TL)',
              ),
              Drop(
                label: 'Tarife',
                value: tarife,
                items: const [
                  'Mesken',
                  'Ticarethane / Diğer',
                  'Sanayi',
                  'Tarımsal Faaliyet',
                ],
                onChanged: (v) => setState(() {
                  tarife = v!;
                  analysed = false;
                  sonucKwh = null;
                }),
              ),
              if (tarife == 'Mesken')
                const AdviceCard(
                  title: 'Hesap yöntemi',
                  text: 'Seçilen Mesken referansında toplam fatura tutarı ile tüketim arasındaki oransal ilişki kullanılır. Araç çevrim dışı çalışır.',
                ),
              if (tarife != 'Mesken')
                const AdviceCard(
                  title: 'Kalibrasyon bekliyor',
                  text: 'Bu tarife için gerçek fatura referansı henüz tanımlanmadı. Yanlış bir katsayı üretmemek için hesaplama şimdilik devre dışıdır.',
                ),
              calcButton('TL → kWh HESAPLA', _faturadanKwh),
              TextButton(
                onPressed: analysed ? temizle : null,
                child: const Text('TEMİZLE'),
              ),
            ],
          ),
          if (analysed && sonucKwh != null)
            SectionCard(
              title: 'Sonuç',
              children: [
                ResultCard(
                  title: 'Tahmini tüketim',
                  value: '${sonucKwh!.toStringAsFixed(1)} kWh',
                  subtitle: 'Seçilen tarife için çevrim dışı oransal tahmin.',
                  good: true,
                  detail: sonucNotu,
                ),
              ],
            ),
          if (analysed && sonucNotu.isNotEmpty)
            AdviceCard(
              title: 'Bilgilendirme',
              text: sonucNotu,
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    fatura.dispose();
    super.dispose();
  }
}
