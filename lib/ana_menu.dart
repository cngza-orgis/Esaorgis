part of 'main.dart';

void bilgiPopup(BuildContext context, String baslik, String metin) {
  showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: cInputBg(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: cIcon(),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              baslik,
              style: TextStyle(
                color: cText(),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Text(
          metin,
          style: TextStyle(
            color: cText(),
            height: 1.45,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(
            'KAPAT',
            style: TextStyle(
              color: cIcon(),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}

void _hakkindaPopup(BuildContext context) {
  bilgiPopup(
    context,
    'Hakkında / Yasal Uyarı',
    'E.S.A. (Elektrik Saha Asistanı), sahadaki elektrik fen adamlarına hızlı bir referans ve pratik bir asistan olması amacıyla tasarlanmıştır.\n\n'
            'Sorumluluk Reddi (Uyarı): Bu uygulamadaki hesaplamalar teknik referans ve ön değerlendirme amacı taşır. Güncel standart, yönetmelik, dağıtım şirketi şartnamesi, proje koşulları, üretici verileri, saha ölçümleri ve yetkili kişi kontrolleri ayrıca değerlendirilmelidir. Nihai projelendirme, uygulama, ölçüm, kabul ve güvenlik kontrolleri kullanıcının mesleki sorumluluğundadır. Teknik olarak uygun olmayan seçimlerde gösterilen teorik hesaplamalar sahada uygulanabilirlik anlamına gelmez.\n\n'
            'Tüm araçlar çevrimdışı çalışır; internet bağlantısı veya kullanıcı izni gerektirmez.\n\n'
            'Sürüm 2.4.2\n\n' +
        teknikKaynakNotu,
  );
}

// ============================================================
// ANA MENÜ
// ============================================================

class _Arac {
  final String title;
  final IconData icon;
  final Widget page;

  const _Arac(
    this.title,
    this.icon,
    this.page,
  );
}

class AnaMenu extends StatefulWidget {
  const AnaMenu({super.key});

  @override
  State<AnaMenu> createState() => _AnaMenuState();
}

class _AnaMenuState extends State<AnaMenu> {

  static const Color lacivert = Color(0xFF073B7A);
  static const Color koyuLacivert = Color(0xFF061F40);
  static const Color mavi = Color(0xFF0B5CC9);

  static const List<String> _sahaNotlari = [
    'Hiçbir iş, insan hayatından daha önemli ve acil değildir.',
    'Enerjili ekipmanda çalışmaya başlamadan önce enerjinin kesildiğini doğrula; yalnızca şalterin açık olmasına güvenme.',
    'Ölçmeden karar verme: Gerilim, akım ve faz sırasını uygun ölçü aletiyle sahada doğrula.',
    'Bir kablonun kesitini yalnızca güce bakarak seçme; akım taşıma kapasitesi, gerilim düşümü ve döşeme koşullarını birlikte değerlendir.',
    'Klemens ve bağlantılarda gevşeklik, ısınma ve renk değişimi çoğu zaman daha büyük bir arızanın erken belirtisidir.',
    'Sigorta seçerken yalnızca anma akımını değil, kablo kapasitesini ve koruma koordinasyonunu da kontrol et.',
    'Akım trafosunda oran kadar doğruluk sınıfı, burden ve kısa devre dayanımı da önemlidir.',
    'OG ölçü ve koruma devrelerinde çekirdek görevini karıştırma; ölçü ve koruma ihtiyaçlarını ayrı değerlendir.',
    'Bir ekipmanın uygun görünmesi, her projede uygun olduğu anlamına gelmez; proje şartları ve üretici verileri kontrol edilmelidir.',
    'Pano içinde etiketleme ve devre tanımlaması, arıza ve bakım sırasında yapılan hataları ciddi ölçüde azaltır.',
    'Gerilim düşümü sınırda ise yalnızca bir üst kesite geçmek yerine hat uzunluğu, döşeme şekli ve yük karakterini yeniden kontrol et.',
    'Paralel kablo uygulamalarında fazlar ve nötrler arasında mümkün olduğunca eşit empedans ve aynı döşeme koşulları sağlanmalıdır.',
    'Kompanzasyonda hedef yalnızca yüksek cos φ değildir; kapasitif çalışmaya düşmemek de aynı derecede önemlidir.',
    'Topraklama iletkeni ve bağlantıları görünür bir detay değil, elektrik güvenliğinin temel parçalarındandır.',
    'İş başlamadan önce doğru ekipman, doğru kişisel koruyucu donanım ve doğru çalışma yöntemi belirlenmelidir.',
    'Sahada aceleyle yapılan küçük bir bağlantı hatası, sonradan uzun bir arıza ve duruş süresine dönüşebilir.',
    'Bir ölçüm sonucunu kaydetmek, aynı arızanın tekrarında teşhis süresini önemli ölçüde kısaltır.',
    'Kablo makarasını sahaya indirmeden önce etiket, tip, kesit ve metraj bilgisini kontrol etmek basit ama etkili bir kalite adımıdır.',
    'ALPEK ve açık iletken seçiminde akım değerinin yanında faz, nötr ve mekanik koşullar da değerlendirilmelidir.',
    'Şantiyede geçici tesisatlarda bile düzen, etiketleme ve mekanik koruma kalıcı tesisat kadar önemlidir.',
    'Bir cihazın enerjisini kesmek kadar, yeniden enerjilendirilmesini önlemek de güvenli çalışma prosedürünün parçasıdır.',
    'Teknik hesapta kullanılan varsayımı sonuçla birlikte belirtmek, hesabın daha sonra doğru yorumlanmasını sağlar.',
    'Sözleşme gücü ile talep gücü aynı kavram değildir; hesapta kullanılan güç tanımını her zaman açıkça belirt.',
    'Standart bir değer seçerken hesaplanan değerin hemen altına değil, koşullara uygun en yakın üst standart değere bakmak güvenli seçim yaklaşımının temelidir.',
    'Kullanılmayan bir devreyi enerjisiz bırakmak yeterli değildir; devrenin yanlışlıkla tekrar enerjilendirilmesini de önle.',
    'Kişisel koruyucu donanım bir formalite değil, son savunma katmanıdır; önce tehlikeyi ortadan kaldır, sonra koruyucu önlemleri uygula.',
    'Sahada şüpheli bir durumda durmak zaman kaybı değil, doğru mühendislik davranışıdır.',
  ];

  int _sahaNotuIndex = 0;

  @override
  void initState() {
    super.initState();
    _sahaNotuIndex = DateTime.now().millisecondsSinceEpoch % _sahaNotlari.length;
  }

  String get _sahaNotu => _sahaNotlari[_sahaNotuIndex];

  static final List<_Arac> araclar = [
    const _Arac(
      'Hat ve Şebeke Araçları',
      Icons.cable_rounded,
      HatSebekeMenu(),
    ),
    const _Arac(
      'Pano Malzeme Seçimi',
      Icons.developer_board_rounded,
      PanoMenu(),
    ),
    const _Arac(
      'Kompanzasyon Merkezi',
      Icons.electric_bolt_rounded,
      KompMenu(),
    ),
    const _Arac(
      'Motor Hesapları',
      Icons.settings_rounded,
      MotorMenu(),
    ),
    const _Arac(
      'GES / Solar Sistemler',
      Icons.solar_power_rounded,
      GesMenu(),
    ),
    const _Arac(
      'Topraklama',
      Icons.vertical_align_bottom_rounded,
      TopraklamaEkrani(),
    ),
    const _Arac(
      'Şantiye Araçları',
      Icons.construction_rounded,
      SantiyeMenu(),
    ),
    const _Arac(
      'Faturalama',
      Icons.receipt_long_rounded,
      FaturalamaMenu(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkNotifier,
      builder: (context, isDark, _) {
        final bg = isDark ? const Color(0xFF101923) : const Color(0xFFF4F7FB);

        return Scaffold(
          backgroundColor: bg,
          body: SafeArea(
            child: Column(
              children: [
                _ustBar(context, isDark),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                    child: Column(
                      children: [
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 9,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 1.08,
                          ),
                          itemBuilder: (context, index) {
                            if (index < araclar.length) {
                              final arac = araclar[index];
                              return _AracKarti(
                                arac: arac,
                                isDark: isDark,
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    materialRoute(arac.page),
                                  );
                                  if (!mounted) return;
                                  setState(() {
                                    _sahaNotuIndex = (_sahaNotuIndex + 1) % _sahaNotlari.length;
                                  });
                                },
                              );
                            }

                            // 3. sütun / 3. satır: Teknik Bilgiler
                            return _TeknikBilgilerKarti(
                              isDark: isDark,
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  materialRoute(const TeknikBilgilerEkrani()),
                                );
                                if (!mounted) return;
                                setState(() {
                                  _sahaNotuIndex = (_sahaNotuIndex + 1) % _sahaNotlari.length;
                                });
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        _SahaNotuCard(
                          isDark: isDark,
                          text: _sahaNotu,
                        ),
                      ],
                    ),
                  ),
                ),
                _altBilgi(context, isDark),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _ustBar(
    BuildContext context,
    bool isDark,
  ) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
      ),
      decoration: BoxDecoration(
        color: isDark ? koyuLacivert : lacivert,
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Elektrik Saha Asistanı',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          IconButton(
            tooltip: isDark ? 'Açık tema' : 'Koyu tema',
            onPressed: () {
              isDarkNotifier.value = !isDarkNotifier.value;
            },
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: Colors.white,
              size: 27,
            ),
          ),
        ],
      ),
    );
  }

  Widget _altBilgi(
    BuildContext context,
    bool isDark,
  ) {
    return InkWell(
      borderRadius: BorderRadius.zero,
      onTap: () => _hakkindaPopup(context),
      child: Container(
        height: 58,
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
        ),
        decoration: BoxDecoration(
          color: isDark ? koyuLacivert : lacivert,
          borderRadius: BorderRadius.zero,
        ),
        child: Row(
          children: [
            Container(
              width: 39,
              height: 39,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.info_outline_rounded,
                color: lacivert,
                size: 26,
              ),
            ),
            const SizedBox(width: 11),
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hakkında / Yasal Uyarı',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Sürüm 2.4.2',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.white,
              size: 27,
            ),
          ],
        ),
      ),
    );
  }
}


// ============================================================
// TEKNİK BİLGİLER KÜTÜPHANESİ
// ============================================================

class _TeknikKonu {
  final String baslik;
  final String kategori;
  final String metin;
  const _TeknikKonu(this.baslik, this.kategori, this.metin);
}

class TeknikBilgilerEkrani extends StatefulWidget {
  const TeknikBilgilerEkrani({super.key});
  @override
  State<TeknikBilgilerEkrani> createState() => _TeknikBilgilerEkraniState();
}

class _TeknikBilgilerEkraniState extends State<TeknikBilgilerEkrani> {
  final arama = TextEditingController();
  String filtre = '';

  static const konular = <_TeknikKonu>[
    _TeknikKonu('Güç, Akım ve Gerilim', 'Elektrik Temelleri', 'Güç, akım ve gerilim arasındaki temel ilişkiler; monofaze ve trifaze sistemlerde kullanılan temel hesap yaklaşımı.'),
    _TeknikKonu('Güç Faktörü (cos φ)', 'Elektrik Temelleri', 'Güç faktörü aktif, reaktif ve görünür güç ilişkisini ifade eder. ESA ön kabullerinde aksi belirtilmedikçe varsayılan cos φ değeri 0,80 olarak kullanılır.'),
    _TeknikKonu('Sözleşme Gücü ve Talep Gücü', 'Elektrik Temelleri', 'Sözleşme gücü ile talep gücü aynı kavram değildir. Sözleşme gücü bağlantı/tarife ilişkili bir değeri, talep gücü ise hesapta esas alınan yük talebini ifade eder.'),
    _TeknikKonu('Akım Trafosu', 'Trafo ve Ölçü Sistemleri', 'Akım trafosu primer devredeki yüksek akımı ölçü ve koruma devrelerinin uygun seviyesine dönüştürür. Oran, sekonder akımı, doğruluk sınıfı, burden, Ith ve Idyn birlikte değerlendirilmelidir.'),
    _TeknikKonu('5P10 / 10P10', 'Trafo ve Ölçü Sistemleri', 'Koruma sınıfı gösterimidir. 5P veya 10P doğruluk sınırını, 10 ise ilgili koruma doğruluk limit faktörünü ifade eden teknik işaretlemedir. Kesin seçim koruma rölesi ve kısa devre hesabıyla doğrulanmalıdır.'),
    _TeknikKonu('0,2S / 0,5S', 'Trafo ve Ölçü Sistemleri', 'Ölçü çekirdeğinin doğruluk sınıfını ifade eder. Ölçme devresinin amacı, sayaç/analizör gereksinimi ve ilgili şartnameye göre değerlendirilir.'),
    _TeknikKonu('1 A / 5 A Sekonder', 'Trafo ve Ölçü Sistemleri', 'Akım trafosu sekonder anma akımı projeye göre 1 A veya 5 A olabilir. Örneğin 30/1 A seçimi mümkündür; bağlı cihazların giriş akımı ve toplam burden ile birlikte kontrol edilmelidir.'),
    _TeknikKonu('Çoklu Sekonder / Çekirdek', 'Trafo ve Ölçü Sistemleri', 'Akım trafoları iki veya üç ayrı sekonder çekirdeğe sahip olabilir. Ölçü+koruma, iki ölçü veya üç ölçü gibi farklı uygulamalar mümkündür; her çekirdeğin sınıfı ve görevi ayrı belirlenir.'),
    _TeknikKonu('Ith ve Idyn', 'Trafo ve Ölçü Sistemleri', 'Ith kısa süreli termik dayanımı, Idyn ise dinamik kısa devre dayanımını ifade eder. OG akım trafosu seçiminde şebekenin kısa devre seviyesiyle uyum kontrolü yapılmalıdır.'),
    _TeknikKonu('Kablo Akım Taşıma Kapasitesi', 'Kablolar ve Hatlar', 'Kablo kapasitesi iletken malzemesi, kesit, döşeme yöntemi, ortam koşulları, devre sayısı ve düzeltme katsayılarına bağlıdır. Kesin değer ilgili standart ve üretici verileriyle doğrulanır.'),
    _TeknikKonu('Gerilim Düşümü', 'Kablolar ve Hatlar', 'Gerilim düşümü hat uzunluğu, akım, iletken empedansı, güç faktörü ve sistem tipine bağlıdır. Kesit seçiminde akım taşıma kapasitesiyle birlikte değerlendirilir.'),
    _TeknikKonu('ALPEK İletken', 'Kablolar ve Hatlar', 'ALPEK seçimi tasarım akımına göre yapılır. Gösterimde monofaze için faz+nötr, trifaze için 3 faz+nötr kesit yapısı kullanılır. KCMIL, kesit için farklı birim sistemidir.'),
    _TeknikKonu('Boru / Tava Doluluk', 'Şantiye ve Uygulama', 'Boru doluluğu kablo dış çaplarından; tava doluluğu ise kullanılabilir tava genişliği ve derinliği ile gerçek kablo dış çaplarından değerlendirilmelidir.'),
    _TeknikKonu('Reaktif Enerji', 'Kompanzasyon', 'Endüktif ve kapasitif enerji tüketimleri tarife/mevzuat koşullarına göre izlenir. Kompanzasyon hesabında yük karakteri, cos φ ve kademe yapısı birlikte değerlendirilir.'),
    _TeknikKonu('Tarife ve Fatura Analizi', 'Faturalama', 'Fatura analizinde tarife türü önemlidir. ESA çevrim dışı çalıştığı için TL→kWh tahmini, ilgili tarife için tanımlanmış gerçek fatura referanslarıyla oransal olarak kalibre edilir.'),
  ];

  @override
  void dispose() { arama.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final q = filtre.trim().toLowerCase();
    final liste = q.isEmpty ? konular : konular.where((x) => ('${x.baslik} ${x.kategori} ${x.metin}').toLowerCase().contains(q)).toList();
    return AppScaffold(
      title: 'Teknik Bilgiler',
      body: ScrollBody(children: [
        SectionCard(title: 'Teknik bilgi ara', children: [
          Field(controller: arama, label: 'Konu / terim / kısaltma', keyboardType: TextInputType.text),
          ElevatedButton.icon(
            onPressed: () => setState(() => filtre = arama.text),
            icon: const Icon(Icons.search_rounded),
            label: const Text('ARA'),
          ),
        ]),
        ...liste.map((x) => Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            title: Text(x.baslik, style: TextStyle(color: cText(), fontWeight: FontWeight.w800)),
            subtitle: Text(x.kategori, style: TextStyle(color: cIcon(), fontSize: 11, fontWeight: FontWeight.w700)),
            trailing: Icon(Icons.chevron_right_rounded, color: cIcon()),
            onTap: () => bilgiPopup(context, x.baslik, x.metin),
          ),
        )),
        if (liste.isEmpty) const AdviceCard(title: 'Sonuç bulunamadı', text: 'Arama ifadenizle eşleşen teknik konu bulunamadı.'),
      ]),
    );
  }
}

class _TeknikBilgilerKarti extends StatelessWidget {
  final bool isDark;
  final VoidCallback onTap;

  const _TeknikBilgilerKarti({required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return _AracKarti(
      arac: const _Arac('Teknik Bilgiler', Icons.menu_book_rounded, TeknikBilgilerEkrani()),
      isDark: isDark,
      onTap: onTap,
    );
  }
}

class _SahaNotuCard extends StatelessWidget {
  final bool isDark;
  final String text;

  const _SahaNotuCard({required this.isDark, required this.text});

  @override
  Widget build(BuildContext context) {
    final card = isDark ? const Color(0xFF182431) : Colors.white;
    final fg = isDark ? const Color(0xFFE8F1FB) : const Color(0xFF103A68);
    final accent = isDark ? const Color(0xFF2C9BEF) : const Color(0xFF0B5CC9);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 13),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF304355) : const Color(0xFFDCE6F2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.tips_and_updates_rounded, color: accent, size: 23),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Saha Notu',
                  style: TextStyle(
                    color: accent,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  text,
                  style: TextStyle(
                    color: fg,
                    fontSize: 12,
                    height: 1.35,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TeknikBilgilerBanner extends StatelessWidget {
  final bool isDark;
  final VoidCallback onTap;
  const _TeknikBilgilerBanner({required this.isDark, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final bg = isDark ? const Color(0xFF182431) : Colors.white;
    final fg = isDark ? const Color(0xFFE8F1FB) : const Color(0xFF103A68);
    final icon = isDark ? const Color(0xFF2C9BEF) : const Color(0xFF0B5CC9);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12), border: Border.all(color: isDark ? const Color(0xFF304355) : const Color(0xFFDCE6F2))),
          child: Row(children: [
            Icon(Icons.menu_book_rounded, color: icon, size: 28),
            const SizedBox(width: 11),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Teknik Bilgiler', style: TextStyle(color: fg, fontWeight: FontWeight.w900, fontSize: 14)),
              const SizedBox(height: 2),
              Text('Çevrim dışı teknik kütüphane • terim, hesap ve ekipman bilgileri', style: TextStyle(color: fg.withValues(alpha: .72), fontSize: 11)),
            ])),
            Icon(Icons.search_rounded, color: icon),
          ]),
        ),
      ),
    );
  }
}

// ============================================================
// ANA MENÜ KARTI
// ============================================================

class _AracKarti extends StatelessWidget {
  final _Arac arac;
  final bool isDark;
  final VoidCallback onTap;

  const _AracKarti({
    required this.arac,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = isDark ? const Color(0xFF182431) : Colors.white;

    final iconBg = isDark ? const Color(0xFF20364D) : const Color(0xFFEAF3FF);

    final text = isDark ? const Color(0xFFE8F1FB) : const Color(0xFF103A68);

    final icon = isDark ? const Color(0xFF2C9BEF) : const Color(0xFF0B5CC9);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            6,
            8,
            6,
            7,
          ),
          decoration: BoxDecoration(
            color: card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark ? const Color(0xFF304355) : const Color(0xFFDCE6F2),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x16000000),
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  arac.icon,
                  color: icon,
                  size: 25,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                arac.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: text,
                  fontSize: 11.5,
                  height: 1.12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// ALT MENÜ ALTYAPISI
// ============================================================

class MenuItemData {
  final String title;
  final String desc;
  final IconData icon;
  final Widget page;

  const MenuItemData(
    this.title,
    this.desc,
    this.icon,
    this.page,
  );
}

class SubMenu extends StatelessWidget {
  final String title;
  final List<MenuItemData> items;

  const SubMenu({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: title,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            10,
            10,
            10,
            10,
          ),
          child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 9,
              mainAxisSpacing: 9,
              childAspectRatio: 0.86,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];

              return _AltMenuKarti(
                item: item,
                onTap: () => Navigator.push(
                  context,
                  materialRoute(item.page),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _AltMenuKarti extends StatelessWidget {
  final MenuItemData item;
  final VoidCallback onTap;

  const _AltMenuKarti({
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    final card = dark ? const Color(0xFF182431) : Colors.white;

    final iconBg = dark ? const Color(0xFF20364D) : const Color(0xFFEAF3FF);

    final text = dark ? const Color(0xFFE8F1FB) : const Color(0xFF103A68);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            5,
            7,
            5,
            6,
          ),
          decoration: BoxDecoration(
            color: card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: dark ? const Color(0xFF304355) : const Color(0xFFDCE6F2),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x16000000),
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  item.icon,
                  color: cIcon(),
                  size: 23,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                item.title,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: text,
                  fontSize: 11.1,
                  height: 1.1,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                item.desc,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: text.withValues(alpha: .68),
                  fontSize: 8.7,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// HAT VE ŞEBEKE ARAÇLARI
// ============================================================

class HatSebekeMenu extends StatelessWidget {
  const HatSebekeMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return SubMenu(
      title: t(
        'Hat ve Şebeke Araçları',
        '',
      ),
      items: [
        // ------------------------------------------------------
        // 1 - HAT ANALİZİ
        // ------------------------------------------------------
        MenuItemData(
          t('Hat Analizi', ''),
          t(
            'Kesit, döşeme ve gerilim düşümü analizi',
            '',
          ),
          Icons.analytics,
          const HatAnaliziVeGerilimDusumuEkrani(),
        ),

        // ------------------------------------------------------
        // 2 - GERİLİM DÜŞÜMÜ
        // ------------------------------------------------------
        MenuItemData(
          t('Gerilim Düşümü', ''),
          t(
            'Kesit girerek doğrudan gerilim düşümünü kontrol et',
            '',
          ),
          Icons.trending_down,
          const HatAnaliziVeGerilimDusumuEkrani(
            initialTab: 1,
          ),
        ),

        // ------------------------------------------------------
        // 3 - KABLO TAŞIMA KAPASİTESİ
        // ------------------------------------------------------
        MenuItemData(
          t('Kablo Taşıma Kapasitesi', ''),
          t(
            'Kesit ve döşeme şekline göre ön kapasite kontrolü',
            '',
          ),
          Icons.power,
          const KabloKapasitesiEkrani(),
        ),

        // ------------------------------------------------------
        // 4 - KABLO VE SİGORTA
        // ------------------------------------------------------
        MenuItemData(
          t('Kablo ve Sigorta Seçimi', ''),
          t(
            'Güç üzerinden standart koruma ön seçimi',
            '',
          ),
          Icons.shield,
          const SigortaEkrani(),
        ),

        // ------------------------------------------------------
        // 5 - AYDINLATMA
        // ------------------------------------------------------
        MenuItemData(
          t('Aydınlatma Hesabı', ''),
          t(
            'Mekân ve armatür verileriyle aydınlatma ön hesabı',
            '',
          ),
          Icons.lightbulb_rounded,
          const AydinlatmaHesabiEkrani(),
        ),

        // ------------------------------------------------------
        // 6 - DAĞITIM ŞEBEKE / ENH
        // ------------------------------------------------------
        MenuItemData(
          t('Şebeke / ENH Teknik Rehberi', ''),
          t(
            'AG, OG ve müşterek şebekelerde uygun direk, box ve tesis elemanlarını teknik-fiziki bilgilerle incele',
            '',
          ),
          Icons.account_tree_rounded,
          const DagitimSebekeEkrani(),
        ),

        // ------------------------------------------------------
        // 7 - AÇIK İLETKEN
        // Yeni dosya: acik_iletken.dart
        // ------------------------------------------------------
        MenuItemData(
          t('Açık İletken', ''),
          t(
            'Havai AG açık iletken kesiti için ön seçim',
            '',
          ),
          Icons.swap_horiz,
          const AcikIletkenEkrani(),
        ),

        // ------------------------------------------------------
        // 8 - YERALTI KABLO
        // Yeni dosya: yeralti_kablo.dart
        //
        // ESKİ:
        // const OgKabloEkrani()
        //
        // YENİ:
        // const YeraltiKabloEkrani()
        // ------------------------------------------------------
        MenuItemData(
          t('Yer Altı Kablolar', ''),
          t(
            'Gerilim seviyesine ve akıma göre AG/OG yeraltı kablo ön seçimi',
            '',
          ),
          Icons.cable_rounded,
          const YeraltiKabloEkrani(),
        ),

        // ------------------------------------------------------
        // 9 - ALPEK
        // Yeni dosya: alpek_iletken.dart
        // ------------------------------------------------------
        MenuItemData(
          t('Alpek İletken', ''),
          t(
            'Sistem tipi ve akıma göre ALPEK iletken kesiti ön seçimi',
            '',
          ),
          Icons.alt_route,
          const AlpekIletkenEkrani(),
        ),
      ],
    );
  }
}

// ============================================================
// PANO MALZEME SEÇİMİ
// ============================================================

class PanoMenu extends StatelessWidget {
  const PanoMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return SubMenu(
      title: t(
        'Pano Malzeme Seçimi',
        '',
      ),
      items: [
        MenuItemData(
          t('AG Pano Malzeme', ''),
          t(
            '1 kW–2000 kW aralığında ön malzeme seçimi',
            '',
          ),
          Icons.developer_board,
          const AnaPanoSecimiEkrani(),
        ),
        MenuItemData(
          t('OG Hücre / Ölçü Gereksinimi', ''),
          t(
            'Giriş, ölçü, çıkış ve trafo koruma düzeni',
            '',
          ),
          Icons.electrical_services,
          const OgGereksinimEkrani(),
        ),
        MenuItemData(
          t('OG Trafo Standart Pano', ''),
          t(
            'Trafo AG buşinginden pano çıkış barasına kadar ön liste',
            '',
          ),
          Icons.account_tree,
          const OgTrafoStandartPanoEkrani(),
        ),
        MenuItemData(
          t('Ölçü Trafo Hesaplama', ''),
          t(
            'Akım ve gerilim trafosu ön seçimi ve ölçü gereksinimleri',
            '',
          ),
          Icons.transform,
          const OlcuTrafoEkrani(),
        ),
      ],
    );
  }
}

// ============================================================
// KOMPANZASYON
// ============================================================

class KompMenu extends StatelessWidget {
  const KompMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return SubMenu(
      title: t(
        'Kompanzasyon Merkezi',
        '',
      ),
      items: [
        MenuItemData(
          t('Fatura / Arıza Kontrol', ''),
          t(
            'T, T1, T2, T3, RI, RC ilk/son endeksleri ile reaktif analiz ve onarım yönlendirmesi',
            '',
          ),
          Icons.receipt_long,
          const KompanzasyonAnaEkrani(),
        ),
        MenuItemData(
          t('Mevcut Sistem Analizi', ''),
          t(
            'Mevcut pano, kademe, kondansatör, reaktör, CT ve sürücü durumunu analiz eder',
            '',
          ),
          Icons.query_stats_rounded,
          const KompMevcutSistemAnaliziEkrani(),
        ),
        MenuItemData(
          t('Pano Tasarım / Kademe', ''),
          t(
            'Mevcut sistem analizi mantığında kapsamlı kademe, koruma, CT, bara, kablo ve pano ön tasarımı',
            '',
          ),
          Icons.view_module,
          const KompPanoTasarimEkrani(),
        ),
      ],
    );
  }
}

// ============================================================
// MOTOR
// ============================================================

class MotorMenu extends StatelessWidget {
  const MotorMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return SubMenu(
      title: t(
        'Motor Hesapları',
        '',
      ),
      items: [
        MenuItemData(
          t('Motor Koruma ve Yol Verme', ''),
          t(
            'Motor akımı, koruma ve yol verme ön hesabı',
            '',
          ),
          Icons.security,
          const MotorKorumaEkrani(),
        ),
        MenuItemData(
          t('Trifaze → Monofaze', ''),
          t(
            'Daimi ve ilk hareket kondansatörü ön hesabı',
            '',
          ),
          Icons.transform,
          const MotorMonofazeEkrani(),
        ),
      ],
    );
  }
}

// ============================================================
// GES
// ============================================================

class GesMenu extends StatelessWidget {
  const GesMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return SubMenu(
      title: t(
        'GES / Solar Sistemler',
        '',
      ),
      items: [
        MenuItemData(
          t('Otomatik Tasarım', ''),
          t(
            'Otomatik GES hesabı',
            '',
          ),
          Icons.auto_awesome,
          const GesOtomatikEkrani(),
        ),
        MenuItemData(
          t('Manuel Sistem Analizi', ''),
          t(
            'Panel, akü ve inverter uyumluluğu',
            '',
          ),
          Icons.query_stats,
          const GesManuelEkrani(),
        ),
        MenuItemData(
          t('Çatı Alanından Tasarım', ''),
          t(
            'En × boy alanından panel ve güç ön hesabı',
            '',
          ),
          Icons.roofing,
          const GesCatiTasarimEkrani(),
        ),
      ],
    );
  }
}

// ============================================================
// ŞANTİYE ARAÇLARI
//
// DİKKAT:
// Açık İletken
// Yeraltı Kablo
// Alpek İletken
//
// BU MENÜDEN ÇIKARILDI.
//
// Burada yalnızca gerçekten şantiye işlerine ait araçlar
// kalacak.
// ============================================================

class SantiyeMenu extends StatelessWidget {
  const SantiyeMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return SubMenu(
      title: t(
        'Şantiye Araçları',
        '',
      ),
      items: [
        MenuItemData(
          t('Boru / Tava Doluluk', ''),
          t(
            'AG/OG, Cu/Al ve kablo yapısına göre doluluk ön hesabı',
            '',
          ),
          Icons.align_horizontal_left,
          const BoruTavaEkrani(),
        ),
        MenuItemData(
          t('Makarada Kalan Kablo', ''),
          t(
            'Makara geometrisinden yaklaşık kalan metraj ve ağırlık',
            '',
          ),
          Icons.all_inbox,
          const MakaraEkrani(),
        ),
      ],
    );
  }
}

// ============================================================
// FATURALAMA
// ============================================================

class FaturalamaMenu extends StatelessWidget {
  const FaturalamaMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return SubMenu(
      title: t(
        'Faturalama',
        '',
      ),
      items: [
        MenuItemData(
          t('Fatura Tahminleme', ''),
          t(
            'Cihaz sepetinden aylık kWh ve isteğe bağlı tutar',
            '',
          ),
          Icons.shopping_cart_rounded,
          const CihazSepetiEkrani(),
        ),
        MenuItemData(
          t('Fatura Analizi', ''),
          t(
            'Fatura tutarı + kWh üzerinden kalem analizi',
            '',
          ),
          Icons.receipt_long_rounded,
          const FaturaAnaliziEkrani(),
        ),
      ],
    );
  }
}
