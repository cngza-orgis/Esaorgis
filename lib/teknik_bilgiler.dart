part of 'main.dart';

class TeknikBilgilerEkrani extends StatefulWidget {
  const TeknikBilgilerEkrani({super.key});

  @override
  State<TeknikBilgilerEkrani> createState() => _TeknikBilgilerEkraniState();
}

class _TeknikBilgilerEkraniState extends State<TeknikBilgilerEkrani> {
  final arama = TextEditingController();

  List<EsaTeknikKonu> get konular {
    return esaTeknikKutuphanesiGenisletilmis;
  }

  @override
  void dispose() {
    arama.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Teknik Bilgiler',
      info: true,
      onInfo: () => bilgiPopup(
        context,
        'Teknik Bilgiler',
        'ESA Teknik Kütüphanesi; teknik terimler, elektrik '
            'sistemleri, koruma, kablo, GES, motor, trafo, '
            'kompanzasyon ve saha uygulamalarına yönelik '
            'başvuru bilgilerini içerir. Kesin proje ve cihaz '
            'seçimlerinde yürürlükteki standart, şartname, '
            'mevzuat ve üretici verileri ayrıca doğrulanmalıdır.',
      ),
      body: ScrollBody(
        children: [
          _sozlukKart(context),
          const SizedBox(height: 14),
          _kategoriKart(
            context,
            baslik: 'AG / OG Sistemleri',
            ikon: Icons.account_tree_rounded,
            konular: _kategoriKonular('ag_og'),
          ),
          _kategoriKart(
            context,
            baslik: 'Akım Trafoları',
            ikon: Icons.swap_horiz_rounded,
            konular: _kategoriKonular('akim_trafolari'),
          ),
          _kategoriKart(
            context,
            baslik: 'Elektrik Temelleri',
            ikon: Icons.electrical_services_rounded,
            konular: _kategoriKonular('elektrik_temelleri'),
          ),
          _kategoriKart(
            context,
            baslik: 'GES / Solar',
            ikon: Icons.wb_sunny_rounded,
            konular: _kategoriKonular('ges'),
          ),
          _kategoriKart(
            context,
            baslik: 'Gerilim Trafoları',
            ikon: Icons.bolt_rounded,
            konular: _kategoriKonular('gerilim_trafolari'),
          ),
          _kategoriKart(
            context,
            baslik: 'Kablolar ve İletkenler',
            ikon: Icons.cable_rounded,
            konular: _kategoriKonular('kablo'),
          ),
          _kategoriKart(
            context,
            baslik: 'Kompanzasyon',
            ikon: Icons.battery_charging_full_rounded,
            konular: _kategoriKonular('kompanzasyon'),
          ),
          _kategoriKart(
            context,
            baslik: 'Koruma ve Anahtarlama',
            ikon: Icons.shield_rounded,
            konular: _kategoriKonular('koruma'),
          ),
          _kategoriKart(
            context,
            baslik: 'Ölçüm ve Faturalama',
            ikon: Icons.receipt_long_rounded,
            konular: _kategoriKonular('olcum'),
          ),
          _kategoriKart(
            context,
            baslik: 'Topraklama',
            ikon: Icons.foundation_rounded,
            konular: _kategoriKonular('topraklama'),
          ),
          const SizedBox(height: 8),
          _teknikSeviyeKarti(),
        ],
      ),
    );
  }

  // ============================================================
  // TEKNİK TERİMLER SÖZLÜĞÜ
  // ============================================================
  Widget _sozlukKart(BuildContext context) {
    return _menuKart(
      context,
      ikon: Icons.menu_book_rounded,
      baslik: 'Teknik Terimler Sözlüğü',
      aciklama: 'Elektriksel kısaltmalar, semboller, teknik terimler '
          've hızlı başvuru açıklamaları.',
      trailing: const Icon(Icons.chevron_right_rounded),
      buyuk: true,
      onTap: () => _sozlukEkrani(context),
    );
  }

  // ============================================================
  // KATEGORİ KARTI
  // ============================================================
  Widget _kategoriKart(
    BuildContext context, {
    required String baslik,
    required IconData ikon,
    required List<EsaTeknikKonu> konular,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: _menuKart(
        context,
        ikon: ikon,
        baslik: baslik,
        aciklama: null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${konular.length} konu',
              style: TextStyle(
                fontSize: 14,
                color: cText().withValues(alpha: .58),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right_rounded,
              color: cText().withValues(alpha: .58),
            ),
          ],
        ),
        onTap: () => _kategoriEkrani(
          context,
          baslik,
          ikon,
          konular,
        ),
      ),
    );
  }

  // ============================================================
  // ANA MENÜ KARTI
  // ============================================================
  Widget _menuKart(
    BuildContext context, {
    required IconData ikon,
    required String baslik,
    required String? aciklama,
    required Widget trailing,
    required VoidCallback onTap,
    bool buyuk = false,
  }) {
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          constraints: BoxConstraints(
            minHeight: buyuk ? 128 : 82,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: buyuk ? 20 : 18,
            vertical: buyuk ? 18 : 16,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFDCE6F2),
              width: 1.1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: buyuk ? 54 : 48,
                height: buyuk ? 54 : 48,
                decoration: BoxDecoration(
                  color: cIcon().withValues(alpha: .08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  ikon,
                  color: cIcon(),
                  size: buyuk ? 32 : 28,
                ),
              ),
              SizedBox(width: buyuk ? 18 : 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      baslik,
                      style: TextStyle(
                        fontSize: buyuk ? 20 : 18,
                        fontWeight: FontWeight.w800,
                        color: cText(),
                      ),
                    ),
                    if (aciklama != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        aciklama,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.35,
                          color: cText().withValues(alpha: .68),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 10),
              trailing,
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // KATEGORİ SINIFLANDIRMASI
  // ============================================================
  //
  // Bilgi dosyalarındaki mevcut EsaTeknikKonu kayıtlarına dokunulmaz.
  // Yalnızca ana ekrandaki eski kategori görünümüne yerleştirilir.
  List<EsaTeknikKonu> _kategoriKonular(String grup) {
    return konular.where((k) {
      final metin = [
        k.kategori,
        k.baslik,
        k.ozet,
        k.ilgiliAraclar,
      ].join(' ').toLowerCase();

      switch (grup) {
        case 'ag_og':
          return metin.contains('ag') ||
              metin.contains('og') ||
              metin.contains('alçak gerilim') ||
              metin.contains('orta gerilim');

        case 'akim_trafolari':
          return metin.contains('akım trafosu') ||
              metin.contains('akım trafoları') ||
              metin.contains('ct') ||
              metin.contains('ölçü akım');

        case 'elektrik_temelleri':
          return metin.contains('temel') ||
              metin.contains('elektrik teor') ||
              metin.contains('ohm') ||
              metin.contains('güç faktörü') ||
              metin.contains('aktif güç') ||
              metin.contains('reaktif güç');

        case 'ges':
          return metin.contains('ges') ||
              metin.contains('solar') ||
              metin.contains('pv') ||
              metin.contains('fotovolta') ||
              metin.contains('mppt') ||
              metin.contains('panel');

        case 'gerilim_trafolari':
          return metin.contains('gerilim trafosu') ||
              metin.contains('gerilim trafoları') ||
              metin.contains('vt') ||
              metin.contains('ölçü gerilim');

        case 'kablo':
          return metin.contains('kablo') ||
              metin.contains('iletken') ||
              metin.contains('nayy') ||
              metin.contains('nyy') ||
              metin.contains('xlpe');

        case 'kompanzasyon':
          return metin.contains('kompanzasyon') ||
              metin.contains('kondansat') ||
              metin.contains('harmonik') ||
              metin.contains('thd') ||
              metin.contains('reaktör') ||
              metin.contains('reaktif');

        case 'koruma':
          return metin.contains('koruma') ||
              metin.contains('sigorta') ||
              metin.contains('mccb') ||
              metin.contains('mcb') ||
              metin.contains('rccb') ||
              metin.contains('rcd') ||
              metin.contains('selektivite') ||
              metin.contains('şalt');

        case 'olcum':
          return metin.contains('ölçüm') ||
              metin.contains('ölçü') ||
              metin.contains('fatura') ||
              metin.contains('sayaç') ||
              metin.contains('ct') ||
              metin.contains('vt');

        case 'topraklama':
          return metin.contains('toprak') ||
              metin.contains('pe ') ||
              metin.contains('pen') ||
              metin.contains('tn-s') ||
              metin.contains('tt sistemi');

        default:
          return false;
      }
    }).toList();
  }

  // ============================================================
  // KATEGORİ DETAY EKRANI
  // ============================================================
  void _kategoriEkrani(
    BuildContext context,
    String baslik,
    IconData ikon,
    List<EsaTeknikKonu> liste,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (_) {
        return SafeArea(
          child: FractionallySizedBox(
            heightFactor: .94,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    18,
                    20,
                    10,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: cIcon().withValues(alpha: .09),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          ikon,
                          color: cIcon(),
                          size: 25,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              baslik,
                              style: const TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              '${liste.length} teknik konu',
                              style: TextStyle(
                                color: cText().withValues(alpha: .60),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: liste.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              'Bu kategori için henüz teknik '
                              'konu bulunmuyor.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: cText().withValues(alpha: .65),
                              ),
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(
                            20,
                            14,
                            20,
                            24,
                          ),
                          itemCount: liste.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final konu = liste[index];

                            return Material(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(14),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(14),
                                onTap: () => _konu(konu),
                                child: Padding(
                                  padding: const EdgeInsets.all(13),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.menu_book_rounded,
                                        color: cIcon(),
                                        size: 23,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              konu.baslik,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 15,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              konu.ozet,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: cText().withValues(
                                                  alpha: .67,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(
                                        Icons.chevron_right_rounded,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // SÖZLÜK EKRANI
  // ============================================================
  void _sozlukEkrani(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (_) {
        return SafeArea(
          child: FractionallySizedBox(
            heightFactor: .94,
            child: StatefulBuilder(
              builder: (context, modalSetState) {
                final q = arama.text.trim().toLowerCase();

                final liste = q.isEmpty
                    ? esaTeknikSozluk
                    : esaTeknikSozluk
                        .where(
                          (e) => e.aranabilirMetin.toLowerCase().contains(q),
                        )
                        .toList();

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        18,
                        20,
                        10,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.menu_book_rounded,
                            color: cIcon(),
                            size: 28,
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              'Teknik Terimler Sözlüğü',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: TextField(
                        controller: arama,
                        onChanged: (_) {
                          modalSetState(() {});
                        },
                        decoration: InputDecoration(
                          hintText: 'Terim, kısaltma veya açıklama ara...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: arama.text.isEmpty
                              ? null
                              : IconButton(
                                  onPressed: () {
                                    arama.clear();
                                    modalSetState(() {});
                                  },
                                  icon: const Icon(
                                    Icons.clear,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(
                          20,
                          8,
                          20,
                          24,
                        ),
                        itemCount: liste.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final e = liste[index];

                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 4,
                            ),
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: cIcon().withValues(alpha: .09),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.abc_rounded,
                                color: cIcon(),
                              ),
                            ),
                            title: Text(
                              e.terim,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            subtitle: Text(
                              e.acilim.isEmpty
                                  ? e.tanim
                                  : '${e.acilim} — ${e.tanim}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: const Icon(
                              Icons.chevron_right_rounded,
                            ),
                            onTap: () => _sozlukDetay(e),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // SÖZLÜK DETAY
  // ============================================================
  void _sozlukDetay(EsaTeknikSozlukMaddesi e) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      builder: (_) => SafeArea(
        child: FractionallySizedBox(
          heightFactor: .70,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.terim,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (e.acilim.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      e.acilim,
                      style: TextStyle(
                        color: cIcon(),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                  const SizedBox(height: 18),
                  _baslik('Tanım'),
                  Text(e.tanim),
                  const SizedBox(height: 14),
                  _baslik('Saha karşılığı'),
                  Text(e.saha),
                  const SizedBox(height: 14),
                  _baslik('İlgili konular'),
                  Text(e.ilgili),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // TEKNİK KONU DETAY
  // ============================================================
  void _konu(EsaTeknikKonu k) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      builder: (_) => SafeArea(
        child: FractionallySizedBox(
          heightFactor: .94,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    k.baslik,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    k.kategori,
                    style: TextStyle(
                      color: cIcon(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 18),
                  _baslik('Kısa bilgi'),
                  Text(k.ozet),
                  const SizedBox(height: 14),
                  _baslik('Nedir?'),
                  Text(k.nedir),
                  const SizedBox(height: 14),
                  _baslik('Nasıl değerlendirilir?'),
                  Text(k.nasil),
                  const SizedBox(height: 14),
                  _baslik('Saha uygulaması'),
                  Text(k.saha),
                  const SizedBox(height: 14),
                  _baslik('Dikkat'),
                  Text(
                    k.dikkat,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _baslik('İlgili ESA araçları'),
                  Text(k.ilgiliAraclar),
                  const SizedBox(height: 14),
                  _baslik('Kaynak'),
                  Text(k.kaynak),
                  const SizedBox(height: 18),
                  const AdviceCard(
                    title: 'Teknik doğrulama notu',
                    text: 'Bu içerik teknik başvuru ve saha '
                        'yönlendirmesi içindir. Kesin seçimlerde '
                        'yürürlükteki standart, şartname, mevzuat '
                        've üretici verileri ayrıca kontrol '
                        'edilmelidir.',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _teknikSeviyeKarti() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        18,
        16,
        18,
        18,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF4D9257),
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            color: Color(0xFF4D9257),
            size: 30,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Teknik kullanım seviyesi',
                  style: TextStyle(
                    color: Color(0xFF4D9257),
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Bu kütüphane özellikle elektrik alanına yeni '
                  'başlayan kullanıcının temel kavramları '
                  'anlamasına yardımcı olacak şekilde '
                  'hazırlanmıştır. İleri seviye seçimlerde '
                  'ilgili teknik dokümanlar ayrıca incelenmelidir.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.45,
                    color: cText(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _baslik(String s) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        s,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
