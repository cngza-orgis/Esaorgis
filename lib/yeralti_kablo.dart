part of 'main.dart';

// ============================================================
// YERALTI KABLO
// Hat ve Şebeke Araçları
// ============================================================
// Faz 4:
// - Yerel kapasite tabloları kaldırıldı.
// - Kablo verisi cable_database.dart merkezine taşındı.
// - AG monofaze 1x / 2x / 3x yapıları merkezi listeden gelir.
// - AG trifaze 4x10'dan sonra 3x16+10 yapısına geçer.
// - AWG / KCMIL kullanıcı ekranından kaldırılmıştır.
// - Alüminyum/Bakır seçimi ayrı bir yerel tablo yerine merkezi KHA
//   sorgusuyla yapılır.
// ============================================================

class YeraltiKabloEkrani extends StatefulWidget {
  const YeraltiKabloEkrani({super.key});

  @override
  State<YeraltiKabloEkrani> createState() => _YeraltiKabloEkraniState();
}

class _YeraltiKabloEkraniState extends State<YeraltiKabloEkrani> {
  String gerilim = 'AG';
  String iletken = 'Bakır';
  String faz = 'Trifaze';

  final akimController = TextEditingController();

  String? hataMesaji;
  List<_YeraltiKabloData> sonuclar = <_YeraltiKabloData>[];

  @override
  void dispose() {
    akimController.dispose();
    super.dispose();
  }

  List<_YeraltiKabloData> _agListe() {
    final bool al = iletken == 'Alüminyum';
    final List<String> secimler = faz == 'Monofaze'
        ? merkeziAgMonofazeNyyKablolar
        : merkeziAgTrifazeNyyKablolar;

    // AG monofaze kullanıcı listesi merkezi kaynaktan 1x/2x/3x yapılarını
    // birlikte üretir. Teknik kapasitesi olmayan bir yapı için sonuç üretmek
    // yerine merkezi kapasite sorgusu null döndürdüğünde seçim gizlenir.

    final List<_YeraltiKabloData> result = <_YeraltiKabloData>[];

    for (final String secim in secimler) {
      final double? hava = al
          ? nayyKapasiteSecimeGore(secim, toprakta: false)
          : nyyKapasiteSecimeGore(secim, toprakta: false);
      final double? toprak = al
          ? nayyKapasiteSecimeGore(secim, toprakta: true)
          : nyyKapasiteSecimeGore(secim, toprakta: true);
      if (toprak == null) continue;

      final String ad = al
          ? secim.replaceFirst('mm²', 'mm² NAYY')
          : '$secim NYY';

      result.add(
        _YeraltiKabloData(
          ad: ad,
          kapasiteA: toprak,
          havaKapasiteA: hava,
          toprakKapasiteA: toprak,
        ),
      );
    }

    return result;
  }

  List<_YeraltiKabloData> _ogListe() {
    final bool al = iletken == 'Alüminyum';
    final List<double> kesitler = ogKhaKesitleri;

    return kesitler.map((kesit) {
      final double? hava = ogKapasiteSecimeGore(
        kesit: kesit,
        al: al,
        toprakta: false,
      );
      final double? toprak = ogKapasiteSecimeGore(
        kesit: kesit,
        al: al,
        toprakta: true,
      );

      return _YeraltiKabloData(
        ad: '1x${_fmtKesit(kesit)} mm² ${al ? 'NA2XSY' : 'N2XSY'} ${esaCurrentOgCableVoltageClass}',
        kapasiteA: toprak ?? hava ?? 0,
        havaKapasiteA: hava,
        toprakKapasiteA: toprak,
      );
    }).where((item) => item.kapasiteA > 0).toList();
  }

  void analizEt() {
    final double akim =
        double.tryParse(akimController.text.trim().replaceAll(',', '.')) ?? 0;

    if (akim <= 0) {
      setState(() {
        hataMesaji = 'Lütfen geçerli bir tasarım akımı girin.';
        sonuclar = <_YeraltiKabloData>[];
      });
      return;
    }

    final List<_YeraltiKabloData> liste =
        gerilim == 'OG' ? _ogListe() : _agListe();
    final List<_YeraltiKabloData> uygunlar =
        liste.where((kablo) => kablo.kapasiteA >= akim).toList();

    setState(() {
      hataMesaji = null;
      sonuclar = uygunlar;
    });
  }

  String _fmtKesit(double value) {
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toStringAsFixed(2).replaceAll('.', ',');
  }

  String _fmtAkim(double value) => value.toStringAsFixed(0);

  Widget _kabloCard(_YeraltiKabloData kablo) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cCard(),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: cIcon(), width: 1.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.cable, color: cIcon(), size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  kablo.ad,
                  style: TextStyle(
                    color: cText(),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              Text(
                '${_fmtAkim(kablo.kapasiteA)} A',
                style: TextStyle(
                  color: cText(),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            'Döşeme: yeraltı — kapasite referansları merkezî OG KHA tablosundan alınır',
            style: TextStyle(
              color: cText().withValues(alpha: 0.72),
              fontSize: 11,
            ),
          ),
          if (kablo.havaKapasiteA != null && kablo.toprakKapasiteA != null) ...[
            const SizedBox(height: 3),
            Text(
              'Hava referansı: ${_fmtAkim(kablo.havaKapasiteA!)} A  •  Toprak referansı: ${_fmtAkim(kablo.toprakKapasiteA!)} A',
              style: TextStyle(
                color: cText().withValues(alpha: 0.64),
                fontSize: 10.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: t('Yer Altı Kablolar', 'Underground Cable'),
      info: true,
      onInfo: () => bilgiPopup(
        context,
        'Yeraltı Kablo — Bilgi / Yardım',
        'Kablo seçenekleri merkezi kablo veri tabanından alınır. AG monofaze sistemlerde 1x, 2x ve 3x yapılar; AG trifaze sistemlerde 4x yapılar ve 4x10 sonrasında 3x16+10 mm² ile başlayan 3 faz + nötr yapıları gösterilir. Kapasite; kablo yapısı ve döşeme koşuluna göre değişir. Kesin seçim için ilgili standart, dağıtım şirketi şartnamesi, üretici verileri ve saha koşulları ayrıca doğrulanmalıdır.',
      ),
      body: ScrollBody(
        children: [
          SectionCard(
            title: 'Giriş',
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
                      sonuclar = <_YeraltiKabloData>[];
                      hataMesaji = null;
                    });
                  },
                ),
                Field(controller: akimController, label: 'Tasarım Akımı (A)'),
              ),
              twoCol(
                Drop(
                  label: 'İletken',
                  value: iletken,
                  items: const ['Bakır', 'Alüminyum'],
                  onChanged: (v) => setState(() {
                    iletken = v ?? 'Bakır';
                    sonuclar = <_YeraltiKabloData>[];
                  }),
                ),
                gerilim == 'AG'
                    ? Drop(
                        label: 'Faz Sistemi',
                        value: faz,
                        items: const ['Trifaze', 'Monofaze'],
                        onChanged: (v) => setState(() {
                          faz = v ?? 'Trifaze';
                          sonuclar = <_YeraltiKabloData>[];
                        }),
                      )
                    : const SizedBox(),
              ),
              calcButton('UYGUN KABLOLARI GÖSTER', analizEt),
            ],
          ),
          if (hataMesaji != null)
            AdviceCard(title: 'Giriş Hatası', text: hataMesaji!, error: true),
          if (sonuclar.isNotEmpty) ...[
            SectionCard(
              title: '$gerilim Yeraltı Kabloları',
              children: [
                Text(
                  'Tasarım akımını karşılayan merkezi veri tabanı seçenekleri',
                  style: TextStyle(color: cText().withValues(alpha: .72), fontSize: 12),
                ),
                const SizedBox(height: 10),
                ...sonuclar.map(_kabloCard),
              ],
            ),
          ],
          if (hataMesaji == null && sonuclar.isEmpty && akimController.text.isNotEmpty)
            AdviceCard(
              title: 'Uygun kablo bulunamadı',
              text: '$gerilim için merkezi veri tabanında girilen tasarım akımını karşılayan seçenek bulunamadı. Daha büyük kesit, paralel çözüm veya farklı kablo sistemi proje koşullarıyla değerlendirilmelidir.',
              error: true,
            ),
          AdviceCard(
            title: 'Teknik Not',
            text: 'Gösterilen değerler ön seçim amacıyla kullanılan merkezi referans değerleridir. Gerçek kapasite; iletken malzemesi, kablo yapısı, döşeme şekli, ortam/toprak sıcaklığı, gruplanma, termik koşullar ve üretici katalog değerlerine göre değişebilir. Nihai seçim ilgili standartlar, TEDAŞ/dağıtım şirketi şartnameleri ve üretici verileriyle doğrulanmalıdır.',
          ),
        ],
      ),
    );
  }
}

class _YeraltiKabloData {
  final String ad;
  final double kapasiteA;
  final double? havaKapasiteA;
  final double? toprakKapasiteA;

  const _YeraltiKabloData({
    required this.ad,
    required this.kapasiteA,
    this.havaKapasiteA,
    this.toprakKapasiteA,
  });
}
