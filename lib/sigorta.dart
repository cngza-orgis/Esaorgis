part of 'main.dart';

class SigortaSecimiEkrani extends StatefulWidget {
  const SigortaSecimiEkrani({super.key});

  @override
  State<SigortaSecimiEkrani> createState() => _SigortaSecimiEkraniState();
}

class _SigortaSecimiEkraniState extends State<SigortaSecimiEkrani> {
  final guc = TextEditingController();

  String sistem = 'Trifaze';

  // ESA merkezi varsayılan güç faktörü.
  // Varsayılan değer: 0,80
  double pf = esaDefaultPowerFactor;

  double akim = 0;
  int? sigorta;
  bool hesaplandi = false;

  @override
  void dispose() {
    guc.dispose();
    super.dispose();
  }

  void hesapla() {
    final p = double.tryParse(
          guc.text.trim().replaceAll(',', '.'),
        ) ??
        0;

    if (p <= 0 || pf <= 0) {
      setState(() {
        hesaplandi = false;
      });
      return;
    }

    final i = sistem == 'Trifaze'
        ? (p * 1000) / (sqrt(3) * esaAgThreePhaseVoltage * pf)
        : (p * 1000) / (esaAgSinglePhaseVoltage * pf);

    final f = esaSelectFirstStandardProtection(i);

    setState(() {
      akim = i;
      sigorta = f;
      hesaplandi = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Sigorta Seçimi',
      info: true,
      onInfo: () => bilgiPopup(
        context,
        'Sigorta Seçimi',
        'Teorik yük akımından standart koruma değerine '
            'ön seçim yapar. Kısa devre, açma eğrisi, '
            'selektivite ve kablo taşıma kapasitesi ayrıca '
            'doğrulanmalıdır.',
      ),
      body: ScrollBody(
        children: [
          // ============================================================
          // GİRİŞLER
          // ============================================================
          SectionCard(
            title: 'Giriş',
            children: [
              twoCol(
                Field(
                  controller: guc,
                  label: 'Güç (kW)',
                ),
                Drop(
                  label: 'Sistem',
                  value: sistem,
                  items: const [
                    'Trifaze',
                    'Monofaze',
                  ],
                  onChanged: (v) {
                    if (v == null) return;

                    setState(() {
                      sistem = v;
                      hesaplandi = false;
                    });
                  },
                ),
              ),

              const SizedBox(height: 12),

              // ========================================================
              // GÜÇ FAKTÖRÜ — STANDART ESA SLIDER
              // ========================================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(
                  12,
                  10,
                  12,
                  10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: cIcon().withValues(alpha: 0.35),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --------------------------------------------------
                    // BAŞLIK + SEÇİLEN DEĞER
                    // --------------------------------------------------
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Güç Faktörü (cosφ)',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: cText(),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: cIcon().withValues(
                              alpha: 0.12,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            pf.toStringAsFixed(2).replaceAll('.', ','),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: cIcon(),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 2),

                    // --------------------------------------------------
                    // SLIDER
                    // --------------------------------------------------
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 5,
                        activeTrackColor: cIcon(),
                        inactiveTrackColor: cIcon().withValues(alpha: 0.20),
                        thumbColor: cIcon(),
                        overlayColor: cIcon().withValues(alpha: 0.12),
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 9,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 16,
                        ),
                      ),
                      child: Slider(
                        value: pf
                            .clamp(
                              0.80,
                              1.00,
                            )
                            .toDouble(),
                        min: 0.80,
                        max: 1.00,
                        divisions: 20,
                        label: 'cosφ ${pf.toStringAsFixed(2)}',
                        onChanged: (value) {
                          setState(() {
                            pf = double.parse(
                              value.toStringAsFixed(2),
                            );

                            // Güç faktörü değiştiğinde mevcut
                            // sonuç artık geçerli değildir.
                            hesaplandi = false;
                          });
                        },
                      ),
                    ),

                    // --------------------------------------------------
                    // ALT ÖLÇEK
                    // --------------------------------------------------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '0,80',
                          style: TextStyle(
                            fontSize: 12,
                            color: cText().withValues(
                              alpha: 0.65,
                            ),
                          ),
                        ),
                        Text(
                          'Güç faktörü',
                          style: TextStyle(
                            fontSize: 12,
                            color: cText().withValues(
                              alpha: 0.65,
                            ),
                          ),
                        ),
                        Text(
                          '1,00',
                          style: TextStyle(
                            fontSize: 12,
                            color: cText().withValues(
                              alpha: 0.65,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // --------------------------------------------------
                    // BİLGİ
                    // --------------------------------------------------
                    Text(
                      'Hesaplamada kullanıcı tarafından seçilen '
                      'güç faktörü kullanılır.',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.35,
                        color: cText().withValues(
                          alpha: 0.65,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ========================================================
              // HESAPLA
              // ========================================================
              calcButton(
                'HESAPLA',
                hesapla,
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ============================================================
          // SONUÇLAR
          // ============================================================
          if (hesaplandi) ...[
            ResultCard(
              title: 'Hesaplanan akım',
              value: '${akim.toStringAsFixed(2)} A',
              detail: 'Seçilen sistem tipi, güç ve güç faktörüne '
                  'göre hesaplanan yük akımıdır.',
            ),
            if (sigorta != null)
              ResultCard(
                title: 'Ön seçim sigorta / TMŞ',
                value: '$sigorta A',
                good: true,
                detail: 'Hesaplanan akımı karşılayan doğrulanmış '
                    'ilk uygun standart koruma değeri ön '
                    'seçim olarak gösterilir.',
              )
            else
              const AdviceCard(
                title: 'Teknik uyarı',
                text: 'Hesaplanan akımı karşılayan doğrulanmış '
                    'standart koruma değeri bulunamadı; daha '
                    'yüksek değerli koruma/cihaz seçimi proje '
                    've üretici koordinasyonuyla '
                    'değerlendirilmelidir.',
                error: true,
              ),
            ResultCard(
              title: 'Seçilen güç faktörü',
              value: 'cosφ ${pf.toStringAsFixed(2).replaceAll('.', ',')}',
              detail: 'Akım hesabında kullanıcı tarafından seçilen '
                  'güç faktörü kullanılmıştır.',
            ),
          ],

          // ============================================================
          // TEKNİK NOT
          // ============================================================
          const AdviceCard(
            title: 'Teknik not',
            text: 'Sigorta veya TMŞ seçimi yalnızca akıma göre '
                'kesinleştirilmez. Kablo akım taşıma kapasitesi, '
                'kısa devre seviyesi, açma karakteristiği, '
                'selektivite ve kullanım kategorisi birlikte '
                'kontrol edilmelidir.',
          ),
        ],
      ),
    );
  }
}

// ================= EKLENEN SAHA ARAÇLARI =================
