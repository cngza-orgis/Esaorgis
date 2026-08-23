part of 'main.dart';

// ================================================================
// FATURALAMA / FATURA ANALİZİ / KABLO / SİGORTA ARAÇLARI
// ================================================================
//
// Bu dosya main.dart dosyasının PART dosyasıdır.
// Bu nedenle:
//   part of 'main.dart';
//
// satırı zorunludur.
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
  String gerilim = 'AG';
  String sistem = 'Trifaze';

  double? kapasite;
  String? detay;

  bool gucKontrolu = false;
  final TextEditingController _gucCtrl = TextEditingController();
  double pf = esaDefaultPowerFactor;
  double? hesaplananAkim;
  bool? kapasiteUygun;

  @override
  void dispose() {
    _gucCtrl.dispose();
    super.dispose();
  }

  double _anaKesit(String s) {
    final String clean = s.replaceAll(',', '.');

    final RegExp uc = RegExp(r'(\d+)x\((\d+(?:\.\d+)?)');
    final Match? ucMatch = uc.firstMatch(clean);
    if (ucMatch != null) {
      return double.tryParse(ucMatch.group(2)!) ?? 0;
    }

    final RegExp tek = RegExp(r'(\d+)x(\d+(?:\.\d+)?)');
    final Match? tekMatch = tek.firstMatch(clean);
    if (tekMatch != null) {
      return double.tryParse(tekMatch.group(2)!) ?? 0;
    }

    return 0;
  }

  int _paralel(String s) {
    final Match? m = RegExp(r'^(\d+)x\(').firstMatch(s);
    if (m == null) return 1;
    return int.tryParse(m.group(1)!) ?? 1;
  }

  double _base(double sec) {
    if (malzeme == 'Bakır' && (doseme == 'Havada' || doseme == 'Toprakta')) {
      final value = nyyKapasiteSecimeGore(
        kesit,
        toprakta: doseme == 'Toprakta',
      );
      return value ?? 0;
    }

    if (malzeme == 'Alüminyum' && (doseme == 'Havada' || doseme == 'Toprakta')) {
      final value = nayyKapasiteSecimeGore(
        kesit,
        toprakta: doseme == 'Toprakta',
      );
      return value ?? 0;
    }

    return 0;
  }

  /// Faz 13 standardı: AG monofaze seçiminde kullanıcıya 1x, 2x ve 3x
  /// NYY yapıları aynı merkezî listeden gösterilir. AG trifaze seçiminde
  /// 4x10 sonrası 3x16+10 yapısına geçen merkezî trifaze listesi kullanılır.
  List<String> get _kabloSecimListesi {
    if (gerilim == 'AG' && sistem == 'Monofaze') {
      return merkeziAgMonofazeNyyKablolar;
    }
    if (gerilim == 'AG' && sistem == 'Trifaze') {
      return merkeziAgTrifazeNyyKablolar;
    }
    return standartKabloSecimListesi;
  }

  void _secimListesiniUygunla() {
    final liste = _kabloSecimListesi;
    if (liste.isNotEmpty && !liste.contains(kesit)) {
      kesit = liste.first;
    }
  }

  void hesapla() {
    final double sec = _anaKesit(kesit);
    final int n = _paralel(kesit);

    if (sec <= 0) {
      setState(() {
        kapasite = null;
        detay = null;
        hesaplananAkim = null;
        kapasiteUygun = null;
      });
      return;
    }

    // 2x10 / 4x10 ifadesindeki damar adedi KHA'yı çarpmaz.
    // Sadece gerçek paralel kablo grupları (2x(...), 3x(...)) kapasiteyi artırır.
    final double b = _base(sec);

    // Boru/tava için bu fazda rastgele bir katsayı uygulamıyoruz.
    // Uygun yerleşim/düzeltme modeli sonraki fazda ayrı kurulacak.
    final double? corrected = doseme == 'Havada' || doseme == 'Toprakta' ? b : null;

    double? current;
    if (gucKontrolu && gerilim == 'AG') {
      final double p = double.tryParse(
            _gucCtrl.text.trim().replaceAll(',', '.'),
          ) ??
          0;
      if (p > 0 && pf > 0) {
        current = sistem == 'Trifaze'
            ? p * 1000 / (sqrt(3) * esaAgThreePhaseVoltage * pf)
            : p * 1000 / (esaAgSinglePhaseVoltage * pf);
      }
    }

    setState(() {
      kapasite = corrected;
      hesaplananAkim = current;
      kapasiteUygun = current != null && corrected != null
          ? corrected >= current
          : null;

      if (corrected == null) {
        detay = 'Seçilen döşeme şekli için bu fazda doğrulanmış KHA modeli yok. '
            'Boru/tava hesabı ayrı yerleşim ve düzeltme modeliyle yapılacaktır.';
      } else {
        detay = 'Temel KHA: ${corrected.toStringAsFixed(0)} A • '
            'Kesit: ${kesit.trim()} • Döşeme: $doseme • '
            'Gerilim: $gerilim • Sistem: $sistem • Paralel grup: $n';
      }
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
                  label: 'Gerilim Seviyesi',
                  value: gerilim,
                  items: const ['AG', 'OG'],
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() {
                      gerilim = v;
                      if (gerilim != 'AG') gucKontrolu = false;
                      _secimListesiniUygunla();
                      kapasite = null;
                      hesaplananAkim = null;
                      kapasiteUygun = null;
                    });
                  },
                ),
                Drop(
                  label: 'Sistem Tipi',
                  value: sistem,
                  items: const ['Trifaze', 'Monofaze'],
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() {
                      sistem = v;
                      _secimListesiniUygunla();
                      kapasite = null;
                      hesaplananAkim = null;
                      kapasiteUygun = null;
                    });
                  },
                ),
              ),
              twoCol(
                Drop(
                  label: 'İletken Malzemesi',
                  value: malzeme,
                  items: const ['Bakır', 'Alüminyum'],
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
                  items: const ['Havada', 'Toprakta', 'Boruda', 'Kablo Tavasında'],
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
                items: _kabloSecimListesi,
                onChanged: (v) {
                  if (v == null) return;
                  setState(() {
                    kesit = v;
                    kapasite = null;
                  });
                },
              ),
              if (gerilim == 'AG') ...[
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: gucKontrolu,
                  title: const Text('Güçten hesaplanan akımı kapasiteyle karşılaştır'),
                  subtitle: const Text('Yalnızca AG için isteğe bağlı kontrol.'),
                  onChanged: (v) {
                    setState(() {
                      gucKontrolu = v ?? false;
                      hesaplananAkim = null;
                      kapasiteUygun = null;
                    });
                  },
                ),
                if (gucKontrolu) ...[
                  Field(controller: _gucCtrl, label: 'Güç (kW)'),
                  Text(
                    'Güç faktörü (Cos φ): ${pf.toStringAsFixed(2)}',
                    style: TextStyle(color: cText(), fontWeight: FontWeight.w700),
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
                        hesaplananAkim = null;
                        kapasiteUygun = null;
                      });
                    },
                  ),
                ],
              ],
              calcButton('KAPASİTEYİ HESAPLA', hesapla),
            ],
          ),
          if (kapasite != null)
            uiResultCard(
              'Taşıma kapasitesi',
              fmt2(kapasite!),
              'A',
            ),
          if (hesaplananAkim != null)
            uiResultCard(
              'Güçten hesaplanan akım',
              fmt2(hesaplananAkim!),
              'A',
            ),
          if (kapasiteUygun != null)
            uiResultCard(
              'Kapasite kontrolü',
              kapasiteUygun! ? 'UYGUN' : 'YETERSİZ',
              kapasiteUygun!
                  ? 'Hesaplanan akım, seçilen kablonun ön KHA değerini aşmıyor.'
                  : 'Hesaplanan akım, seçilen kablonun ön KHA değerini aşıyor.',
            ),
          if (detay != null)
            uiResultCard(
              'Hesap özeti',
              detay!,
              'Ön değerlendirme',
            ),
          const AdviceCard(
            title: 'Teknik not',
            text: 'Kablo kapasitesi; kablo yapısı, iletken malzemesi, döşeme biçimi, '
                'ortam sıcaklığı, gruplanma ve düzeltme katsayılarına bağlıdır. '
                'Buradaki sonuç ön değerlendirmedir; kesin saha kesiti ilgili standart, '
                'üretici tablosu ve gerçek döşeme koşullarıyla doğrulanmalıdır.',
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
  double pf = esaDefaultPowerFactor;

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
        ? p * 1000 / (sqrt(3) * esaAgThreePhaseVoltage * pf)
        : p * 1000 / (esaAgSinglePhaseVoltage * pf);

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
          Drop(
            label: 'Güç faktörü (cosφ)',
            value: pf.toStringAsFixed(2),
            items: const ['0.80', '0.85', '0.90', '0.95', '0.98', '1.00'],
            onChanged: (v) {
              if (v == null) return;
              setState(() {
                pf = double.tryParse(v) ?? esaDefaultPowerFactor;
                current = null;
                fuse = null;
              });
            },
          ),
          const SizedBox(height: 10),
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
                'Ön Seçim Sigorta / TMŞ',
                'Preselected Fuse / MCCB',
              ),
              fuse.toString(),
              'A',
            ),
          if (fuse != null)
            uiResultCard(
              t(
                'Ön Seçim Kablo',
                'Preselected Cable',
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
