part of 'main.dart';

// ================= DAĞITIM ŞEBEKESİ / ENH =================
// Kurgu: 1) Tesis Tipi = yalnızca AG / OG / Müşterek
//        2) Tesis Elemanı = seçilen tesis tipine uygun ulusal/şebeke uygulama elemanları
// Aydınlatma, ayrı bir tesis tipi değildir; AG veya müşterek tesis içindeki uygun
// aydınlatma/dağıtım elemanı olarak değerlendirilir.

class _DagitimTipBilgi {
  final String teknik;
  final String fiziki;
  final String kullanim;
  final String tecHizat;
  final String mekanik;
  final String dikkat;
  final String kaynak;
  const _DagitimTipBilgi({required this.teknik, required this.fiziki, required this.kullanim, required this.tecHizat, required this.mekanik, required this.dikkat, required this.kaynak});
}

class DagitimSebekeEkrani extends StatefulWidget {
  const DagitimSebekeEkrani({super.key});
  @override State<DagitimSebekeEkrani> createState() => _DagitimSebekeEkraniState();
}

class _DagitimSebekeEkraniState extends State<DagitimSebekeEkrani> {
  // Birinci seçim KESİNLİKLE sadece üç şebeke tipidir.
  String tesis = 'AG';
  String eleman = 'AG betonarme dağıtım direği';
  String? sonuc;

  List<String> elemanlar(String t) {
    switch (t) {
      case 'OG':
        return const [
          'OG Taşıyıcı — T-10(Sw)', 'OG Taşıyıcı — T-12(Sw)', 'OG Taşıyıcı — T-14(Sw)', 'OG Taşıyıcı — T-16(Sw)', 'OG Taşıyıcı — T-18(Sw)', 'OG Taşıyıcı — T-20(Sw)',
          'OG Durdurucu — D-10(Sw)', 'OG Durdurucu — D-12(Sw)', 'OG Durdurucu — D-14(Sw)', 'OG Durdurucu — D-16(Sw)', 'OG Durdurucu — D-18(Sw)', 'OG Durdurucu — D-20(Sw)',
          'OG Nihayet — N-10(Sw)', 'OG Nihayet — N-12(Sw)', 'OG Nihayet — N-14(Sw)', 'OG Nihayet — N-16(Sw)', 'OG Nihayet — N-18(Sw)', 'OG Nihayet — N-20(Sw)',
          'OG Zaviye — Z-10(Sw)', 'OG Zaviye — Z-12(Sw)', 'OG Zaviye — Z-14(Sw)', 'OG Zaviye — Z-16(Sw)', 'OG Zaviye — Z-18(Sw)', 'OG Zaviye — Z-20(Sw)',
          'OG santrifüj betonarme direk', 'OG çelik direk (tip proje kapsamında)', 'OG direk üstü ayırıcı / teçhizat taşıyıcı düzeni', 'OG yeraltı kablo sistemi / kablo başlık-ek düzeni', 'OG dağıtım merkezi / bina tipi tesis',
        ];
      case 'Müşterek':
        return const [
          'Müşterek A Tipi Taşıyıcı — 8I', 'Müşterek A Tipi Taşıyıcı — 10I', 'Müşterek A Tipi Taşıyıcı — 12I',
          'Müşterek A Tipi Taşıyıcı / Küçük Açı — 8U', 'Müşterek A Tipi Taşıyıcı / Küçük Açı — 10U', 'Müşterek A Tipi Taşıyıcı / Küçük Açı — 12U',
          'Müşterek Kafes Tipi — K1', 'Müşterek Kafes Tipi — K2', 'Müşterek Kafes Tipi — K3', 'Müşterek Kafes Tipi — K4', 'Müşterek Kafes Tipi — K5',
          'OG–AG müşterek betonarme direk', 'OG–AG müşterek çelik direk (tip proje kapsamında)', 'OG–AG müşterek direk üstü dağıtım düzeni', 'OG–AG müşterek hat + aydınlatma donanımı', 'OG–AG müşterek yeraltı/havai geçiş düzeni',
        ];
      default:
        return const [
          'AG A Tipi Taşıyıcı — 8I', 'AG A Tipi Taşıyıcı — 10I', 'AG A Tipi Taşıyıcı — 12I',
          'AG A Tipi Taşıyıcı / Küçük Açı — 8U', 'AG A Tipi Taşıyıcı / Küçük Açı — 10U', 'AG A Tipi Taşıyıcı / Küçük Açı — 12U',
          'AG Kafes Tipi Köşe/Açı — K1', 'AG Kafes Tipi Köşe/Açı — K2', 'AG Kafes Tipi Köşe/Açı — K3', 'AG Kafes Tipi Köşe/Açı — K4', 'AG Kafes Tipi Köşe/Açı — K5',
          'AG betonarme dağıtım direği — 9,3 m', 'AG betonarme dağıtım direği — 11 m', 'AG betonarme dağıtım direği — 13 m',
          'AG taşıyıcı direk', 'AG durdurucu direk', 'AG nihayetlendirici direk', 'AG branşman / ayırım direği',
          'AG trafo direği — T15 (yaklaşık 120 kVA sınıfı)', 'AG trafo direği — T25 (160–250 kVA sınıfı)', 'AG trafo direği — T35 (250–315 kVA sınıfı)', 'AG trafo direği — T50 (400 kVA sınıfı)',
          'AG direk tipi dağıtım panosu / box', 'AG harici dağıtım panosu – kaide tipi', 'AG bina içi / dahili dağıtım panosu', 'AG saha dağıtım kutusu / box', 'AG aydınlatma panosu / box',
          'AG çelik aydınlatma direği', 'AG betonarme aydınlatma direği', 'AG yeraltı kablo dağıtım düzeni',
        ];
    }
  }

  _DagitimTipBilgi? kodBilgi() {
    final kod = eleman.replaceFirst('OG Taşıyıcı — ', '').replaceFirst('OG Durdurucu — ', '').replaceFirst('OG Nihayet — ', '').replaceFirst('OG Zaviye — ', '').replaceFirst('Müşterek — ', '').replaceFirst('Müşterek A Tipi Taşıyıcı — ', '').replaceFirst('Müşterek A Tipi Taşıyıcı / Küçük Açı — ', '').replaceFirst('Müşterek Kafes Tipi — ', '').replaceFirst('AG A Tipi Taşıyıcı — ', '').replaceFirst('AG A Tipi Taşıyıcı / Küçük Açı — ', '').replaceFirst('AG Kafes Tipi Köşe/Açı — ', '');
    final ogKodlari = {'T-10(Sw)','T-12(Sw)','T-14(Sw)','T-16(Sw)','T-18(Sw)','T-20(Sw)','D-10(Sw)','D-12(Sw)','D-14(Sw)','D-16(Sw)','D-18(Sw)','D-20(Sw)','N-10(Sw)','N-12(Sw)','N-14(Sw)','N-16(Sw)','N-18(Sw)','N-20(Sw)','Z-10(Sw)','Z-12(Sw)','Z-14(Sw)','Z-16(Sw)','Z-18(Sw)','Z-20(Sw)'};
    final ortak = {'8U','8I','10I','10U','12I','12U','K1','K2','K3','K4','K5'};
    if (!ogKodlari.contains(kod) && !ortak.contains(kod)) return null;
    String rol = 'A tipi / müşterek taşıyıcı-köşe direk';
    if (kod.endsWith('I')) rol = 'A tipi I kesitli taşıyıcı direk';
    if (kod.endsWith('U')) rol = 'A tipi U kesitli / küçük açılı taşıyıcı direk';
    if (kod.startsWith('K')) rol = 'Kafes tipi köşe/açı direk';
    if (kod.startsWith('T-')) rol = 'OG taşıyıcı demir direk (Swallow)';
    if (kod.startsWith('D-')) rol = 'OG durdurucu demir direk (Swallow)';
    if (kod.startsWith('N-')) rol = 'OG nihayet demir direk (Swallow)';
    if (kod.startsWith('Z-')) rol = 'OG zaviye demir direk (Swallow)';
    return _DagitimTipBilgi(
      teknik: '$rol — tip kodu $kod. Kod, direğin görev ailesini ve ilgili tipteki sınıf/ölçü bilgisini tanımlar. TEDAŞ malzeme poz kırılımında ilgili tip ailesi yer alır.',
      fiziki: 'Seçilen tipin boyu/sınıfı, tepe kuvveti ve diğer mekanik değerleri ilgili tip proje/şartname ve ürün garantili değerlerinden alınır. Travers/konsol, izolatör ve bağlantı hırdavatı direk görevine göre eşleştirilir.',
      kullanim: 'Taşıyıcı tipler hat güzergâhında normal iletken taşıma; durdurucu tipler iletken gerilmesinin kesildiği/sonlandırıldığı; nihayet tipler hat sonu; zaviye tipler hat yön değişim noktalarında kullanılır. Müşterek kodlar AG+OG ortak direk düzenlerine aittir.',
      tecHizat: 'İletkenler, travers/konsol, izolatörler, bağlama ve gerdirme hırdavatı, topraklama; görev noktasına göre ayırıcı/sigorta/başlık ve diğer hat teçhizatı.',
      mekanik: 'Açıklık, iletken çekme kuvveti, rüzgâr/buz yükü, sarkma, direk tepe yükü, zemin ve temel/gömme koşulları birlikte kontrol edilir.',
      dikkat: 'Tip kodu tek başına yeterli değildir. Direğin gerçek mekanik sınıfı, hat geometrisi, iletken tipi ve proje yükleme durumları ile doğrulanmalıdır.',
      kaynak: 'TEDAŞ-MLZ/2018-066.A direk malzeme poz kırılımı ve ilgili direk/tip proje teknik dokümanları.',
    );
  }

  _DagitimTipBilgi bilgi() {
    final kod = kodBilgi();
    if (kod != null) return kod;
    if (eleman.startsWith('AG betonarme dağıtım direği')) {
      return const _DagitimTipBilgi(
        teknik: 'AG betonarme direk; havai AG dağıtımında kullanılan betonarme destek elemanıdır. Kaynak referansındaki saha terminolojisinde 9,3 m, 11 m ve 13 m sınıfları örneklenmektedir; kesin tip ve tepe kuvveti ilgili tip proje/şartname ve statik hesapla belirlenir.',
        fiziki: 'Betonarme gövde, boy, tepe/taban geometrisi, tepe kuvveti, gömme derinliği ve topraklama bağlantısı seçilen tipe göre değişir. Kaynakta 13 m / 1500 kgf örneği verilmiş olsa da bu değer genel seçim değeri değildir.',
        kullanim: 'AG havai dağıtım hatları, servis ve saha dağıtım güzergâhları; açıklık, iletken yükü ve zemin şartları uygun olduğunda.',
        tecHizat: 'AG iletkenleri, travers/konsol, izolatör/hırdavat, servis bağlantıları, topraklama ve gerektiğinde direk tipi pano/box.',
        mekanik: 'Tepe kuvveti, iletken çekmesi, rüzgâr/buz, açıklık, sarkma, gömme ve temel koşulları kontrol edilmelidir.',
        dikkat: 'Kaynak sayfadaki boy/kuvvet örnekleri saha referansıdır; kesin seçim TEDAŞ tip proje, şartname, statik hesap ve üretici garantili değerlerden yapılmalıdır.',
        kaynak: 'Ecomühendis Elektrik Direkleri referansı + TEDAŞ direk/tip proje/teknik şartname dokümanları.',
      );
    }
    if (eleman.startsWith('AG trafo direği')) {
      return const _DagitimTipBilgi(
        teknik: 'Trafo direği, dağıtım trafosunun direk üzerinde taşınması ve OG/AG bağlantılarının tesis edilmesi için kullanılan taşıyıcı sistemdir. Kaynak referansında T15, T25, T35 ve T50 isimlendirmeleri ve yaklaşık kVA sınıfları verilmektedir.',
        fiziki: 'Direk/travers, trafo sabitleme elemanları, çapraz/payanda, OG teçhizat, parafudr, AG pano bağlantısı ve topraklama düzeni birlikte ele alınır.',
        kullanim: 'Direk üstü dağıtım trafosu uygulamalarında; saha yerleşimi, trafo gücü, direk taşıma kapasitesi ve tip proje koşulları uygun olduğunda.',
        tecHizat: 'OG ayırıcı/teçhizat, sigorta veya koruma, parafudr, trafo, trafo sabitleme, AG pano, kablo/tava veya boru, koruma ve işletme topraklaması.',
        mekanik: 'Trafo ağırlığı, tepe yükü, moment, rüzgâr, iletken çekmeleri, temel/gömme ve tüm teçhizatın birleşik yükleri kontrol edilmelidir.',
        dikkat: 'T15/T25/T35/T50 isimleri kaynak referansındaki saha terminolojisidir; kVA eşlemesi kesin malzeme seçimi yerine geçmez. Güncel tip proje ve TEDAŞ/dağıtım şirketi şartları esas alınmalıdır.',
        kaynak: 'Ecomühendis Elektrik Direkleri referansı + TEDAŞ trafo/direk tip proje ve teknik şartname dokümanları.',
      );
    }
    if (eleman.startsWith('AG çelik aydınlatma direği') || eleman.startsWith('AG betonarme aydınlatma direği')) {
      return const _DagitimTipBilgi(
        teknik: 'Aydınlatma direği, genel aydınlatma armatürünü taşıyan ve aydınlatma besleme/kumanda sistemi ile birlikte değerlendirilen destek elemanıdır.',
        fiziki: 'Direk boyu, tepe geometrisi, armatür kolu, flanş/gömme tipi, malzeme ve korozyon koruması seçilen tip projeye/ürüne göre değişir.',
        kullanim: 'Yol, cadde, meydan, saha ve genel aydınlatma uygulamalarında; armatür fotometrisi ve direk mekanik yükleri uygun olduğunda.',
        tecHizat: 'Armatür, direk kolu, besleme kablosu, sigorta/koruma, bağlantı kutusu veya box ve topraklama.',
        mekanik: 'Armatür rüzgâr alanı, direk boyu, kol momenti, rüzgâr yükü, temel ve ankraj/gömme koşulları kontrol edilmelidir.',
        dikkat: 'Aydınlatma direği tipi sadece boyuna göre seçilmemelidir; rüzgâr bölgesi, armatür ve temel/ankraj hesabı birlikte değerlendirilmelidir.',
        kaynak: 'Ecomühendis Elektrik Direkleri referansı + TEDAŞ genel aydınlatma/direk tip proje ve teknik şartnameleri.',
      );
    }
    if (eleman.startsWith('AG A Tipi') || eleman.startsWith('AG Kafes Tipi')) {
      return const _DagitimTipBilgi(
        teknik: 'A tipi direk ailesi; saha referansında taşıyıcı kullanım için I ve U biçimli seçeneklerle, kafes tipi ise köşe/açı kullanımında K1–K5 aileleriyle tarif edilmektedir.',
        fiziki: 'I/U ve K tipinin boy, tepe kuvveti, kesit/geometri ve bağlantı detayları tipe göre değişir. Kaynak referansında 8I, 10I, 12I ile 8U, 10U, 12U ve K1–K5 örnekleri yer almaktadır.',
        kullanim: 'I tipi normal taşıyıcı hat noktalarında; U tipi küçük açılı noktalarda; K tipi köşe/açı ve daha yüksek mekanik yüklerin bulunduğu noktalarda referans alınır.',
        tecHizat: 'Travers, izolatör, iletken, bağlama/gergi hırdavatı, topraklama ve projeye göre branşman/ayırma donanımı.',
        mekanik: 'Tepe kuvveti, iletken çekmesi, açıklık, açı, rüzgâr/buz, temel ve gömme koşulları birlikte kontrol edilir.',
        dikkat: 'A/U/K isimlendirmesi burada saha referansı olarak kullanılmıştır; kesin tip kodu ve mekanik sınıf güncel tip proje/şartname ve malzeme pozuyla doğrulanmalıdır.',
        kaynak: 'Ecomühendis Elektrik Direkleri referansı + TEDAŞ tip proje/teknik şartname dokümanları.',
      );
    }
    switch (eleman) {
      case 'OG santrifüj betonarme direk':
        return const _DagitimTipBilgi(
          teknik: '36 kV ve altı havai OG dağıtım/ENH tesislerinde kullanılan santrifüj betonarme direk ailesidir. Direk sınıfı, boyu, tepe kuvveti ve diğer garantili özellikler ilgili TEDAŞ tip projesi/şartnamesi ve proje hesabından seçilir.',
          fiziki: 'Betonarme gövde; direk boyu, tepe çapı, taban çapı, ağırlık, tepe yükü/kuvveti, gömme boyu ve işaretleme gibi fiziksel özellikler seçilen ulusal tip/imalatçı garantili özellikler listesine göre değişir. Uygulamada travers/konsol bağlantıları ve topraklama bağlantı noktaları bulunur.',
          kullanim: 'Havai OG dağıtım hatlarında ve ENH/şebeke tip projelerinde; direğin mekanik sınıfı ile iletken, açıklık, rüzgâr/buz ve arazi şartları birlikte uygun olduğunda kullanılır.',
          tecHizat: 'Travers/konsol, izolatör, iletken, askı/gergi hırdavatı, topraklama ve projeye göre ayırıcı, sigorta, kesici veya diğer hat teçhizatı.',
          mekanik: 'Tepe yükü, iletken çekme kuvveti, rüzgâr/buz yükü, açıklık, sarkma, direkler arası mesafe, zemin/gömme ve temel koşulları kontrol edilmelidir.',
          dikkat: 'Direk boyu/sınıfı yalnızca isimden seçilmemeli; ilgili tip proje, yükleme durumu ve onaylı proje ile doğrulanmalıdır.',
          kaynak: 'TEDAŞ proje/onay dokümanları ve TEDAŞ santrifüj betonarme direk teknik şartnamesi; ilgili OG hat tip projeleri.',
        );
      case 'OG çelik direk (tip proje kapsamında)':
        return const _DagitimTipBilgi(
          teknik: 'Çelik direk; OG havai tesislerde belirli tip proje ve mekanik ihtiyaçlarda kullanılan taşıyıcı sistemdir. Çelik kalite, kesit, kaplama ve taşıma kapasitesi proje/ürün garantili özelliklerine göre belirlenir.',
          fiziki: 'Kesit geometrisi, boy, et kalınlığı, taban plakası/bağlantı biçimi, korozyon koruması ve ağırlık seçilen tip veya imalatçı garantili özelliklere bağlıdır.',
          kullanim: 'Betonarme direğin uygun olmadığı veya özel mekanik/yerleşim şartlarının bulunduğu, tip proje tarafından izin verilen tesislerde.',
          tecHizat: 'Travers/konsol, izolatör, iletken, hırdavat, topraklama ve projeye göre anahtarlama/koruma teçhizatı.',
          mekanik: 'Direk tepe yükü, taban momenti, rüzgâr/buz, iletken çekmesi, açıklık ve temel/ankraj hesabı birlikte kontrol edilir.',
          dikkat: '“Çelik direk” genel bir ürün adıdır; gerçek kesit ve sınıf mutlaka onaylı tip proje/ürün garantili özelliklerden alınmalıdır.',
          kaynak: 'TEDAŞ tip proje/teknik şartname sistemi ve ilgili ulusal standartlar.',
        );
      case 'OG direk üstü ayırıcı / teçhizat taşıyıcı düzeni':
        return const _DagitimTipBilgi(
          teknik: 'OG direk üstü teçhizat taşıyıcı düzeni; ayırıcı, sigorta veya benzeri OG şebeke cihazlarının direk üzerinde tesis edilmesi için taşıyıcı/konstrüksiyon sistemini ifade eder.',
          fiziki: 'Taşıyıcı travers/konsol, cihaz bağlantıları, faz aralıkları, işletme kolu ve topraklama bağlantıları ilgili tip projeye göre düzenlenir.',
          kullanim: 'Havai OG dağıtım hatlarında hat ayırma, koruma veya işletme amacıyla direk üstü cihaz tesis edilen noktalarda.',
          tecHizat: 'Ayırıcı/anahtarlama cihazı, sigorta veya koruma elemanı, izolatörler, travers/konsol, işletme mekanizması ve topraklama.',
          mekanik: 'Cihaz ağırlığı, kısa devre etkileri, rüzgâr/buz, iletken çekmeleri ve direk taşıma kapasitesi birlikte kontrol edilir.',
          dikkat: 'Cihazın kendisi ile direk/konsol taşıma sistemi ayrı ayrı uygunluk kontrolünden geçirilmelidir.',
          kaynak: 'TEDAŞ ilgili OG teçhizat ve tip proje dokümanları. Direk kodları malzeme poz kırılımı ile birlikte doğrulanmalıdır.',
        );
      case 'OG yeraltı kablo sistemi / kablo başlık-ek düzeni':
        return const _DagitimTipBilgi(
          teknik: 'OG yeraltı dağıtım sistemi; uygun OG kablosu, kablo başlığı, ek ve bağlantı elemanlarından oluşan tesis düzenidir.',
          fiziki: 'Kablo tipi/kesiti, damar yapısı, ekran/topraklama düzeni, minimum bükülme yarıçapı, döşeme şekli ve mekanik koruma proje ve ilgili kablo şartnamesine göre belirlenir.',
          kullanim: 'Yerleşim, çevre veya güzergâh şartlarının havai tesis yerine yeraltı tesisini gerektirdiği OG dağıtım uygulamalarında.',
          tecHizat: 'OG kablo, başlık, ek kiti, topraklama bağlantıları, kablo kanalı/borusu ve gerektiğinde mekanik koruma.',
          mekanik: 'Döşeme derinliği, çekme kuvveti, bükülme yarıçapı, ısıl koşullar, kısa devre dayanımı ve güzergâh koruması kontrol edilir.',
          dikkat: 'Kablo kesiti yalnızca akıma göre seçilmez; kısa devre, gerilim düşümü, döşeme ve ısıl koşullar da değerlendirilir.',
          kaynak: 'TEDAŞ ilgili OG kablo, başlık/ek ve proje dokümanları.',
        );
      case 'OG dağıtım merkezi / bina tipi tesis':
        return const _DagitimTipBilgi(
          teknik: 'OG dağıtım merkezi/bina tipi tesis; OG hücre, trafo ve yardımcı donanımların bina veya özel tesis hacminde toplandığı dağıtım yapısıdır.',
          fiziki: 'Bina hacmi, hücre yerleşimi, kablo giriş/çıkışları, havalandırma, yangın güvenliği, erişim, kapı ve bakım açıklıkları proje ve ilgili şartnamelere göre düzenlenir.',
          kullanim: 'Kentsel, endüstriyel veya açık hava direk tipi çözümün uygun olmadığı dağıtım tesislerinde.',
          tecHizat: 'OG hücreler, trafo, ölçü/koruma elemanları, kablo başlıkları, topraklama, yardımcı AC/DC sistemler ve gerekli güvenlik donanımları.',
          mekanik: 'Bina taşıyıcılığı, ekipman ağırlıkları, kablo güzergâhları, havalandırma ve bakım erişimleri kontrol edilir.',
          dikkat: 'Bina tipi tesis boyutları ve yerleşimi tip proje ve dağıtım şirketinin onay şartlarına göre kesinleştirilmelidir.',
          kaynak: 'TEDAŞ proje/onay ve OG dağıtım merkezi/hücre şartnameleri.',
        );
      case 'AG betonarme dağıtım direği':
        return const _DagitimTipBilgi(
          teknik: 'AG havai dağıtım şebekesinde kullanılan betonarme direk ailesidir. Direk boyu ve sınıfı; hat düzeni, açıklık, iletken yükleri ve tip projeye göre seçilir.',
          fiziki: 'Betonarme gövde, direk boyu/sınıfı, tepe yükü, gömme düzeni, travers/konsol ve topraklama bağlantıları seçilen tipe göre değişir.',
          kullanim: 'AG havai dağıtım hatları, servis/dağıtım güzergâhları ve ilgili tip projelerde.',
          tecHizat: 'AG iletkenleri, travers/konsol, izolatör/hırdavat, servis bağlantıları, topraklama ve gerektiğinde direk tipi pano/box.',
          mekanik: 'İletken çekmesi, açıklık, rüzgâr, direk tepe yükü, sarkma, zemin ve gömme koşulları kontrol edilir.',
          dikkat: 'Direğin kesin sınıfı ve boyu, gerçek hat geometrisi ve yük durumuna göre seçilmelidir.',
          kaynak: 'TEDAŞ AG dağıtım hattı ve direk tip proje/teknik şartname dokümanları.',
        );
      case 'AG direk tipi dağıtım panosu / box':
        return const _DagitimTipBilgi(
          teknik: 'Direk tipi AG dağıtım panosu; transformatör direğine tesis edilen ve AG dağıtım şebekesini besleyen mahfazalı panodur. TEDAŞ AG pano şartnamesinde direk tipi pano, transformatör direğine monte edilen pano olarak tanımlanır.',
          fiziki: 'Metal veya CTP mahfaza, direk üzerine montaj için profil mesnet/balkon, giriş-çıkış düzeni, baralar, sigortalı yük ayırıcıları ve yardımcı bağlantı elemanları bulunabilir. Pano gücü ve cihaz boyutları seçilen tipe göre değişir.',
          kullanim: 'Harici AG dağıtımda, özellikle uygun transformatör/direk düzeninde direk üzerinde pano tesis edilmesi gereken uygulamalarda.',
          tecHizat: 'AG anahtarlama/koruma cihazları, baralar, sigortalı yük ayırıcıları, klemensler, bağlantı kabloları, kablo pabuçları ve montaj donanımı.',
          mekanik: 'Pano ağırlığı, direk taşıma kapasitesi, balkon/mesnet, bağlantı elemanları, çevresel koşullar ve mahfaza koruması kontrol edilir.',
          dikkat: 'Direk tipi pano her AG tesisinde otomatik olarak uygun değildir; pano gücü, montaj yeri ve direk kapasitesi şartname/proje ile doğrulanmalıdır.',
          kaynak: 'TEDAŞ-MLZ/2003-006.CD ve TEDAŞ AG dağıtım panoları teknik şartnamesi.',
        );
      case 'AG harici dağıtım panosu – kaide tipi':
        return const _DagitimTipBilgi(
          teknik: 'Harici AG dağıtım panosu; AG şebekesinin dağıtım ve korunması için dış ortamda kaide üzerine veya uygun montaj düzeninde tesis edilen komple panodur.',
          fiziki: 'Harici mahfaza, kaide/baza, kablo giriş-çıkışları, baralar ve koruma/anahtarlama cihazları bulunur. TEDAŞ dokümanlarında harici tip için direk tipi veya kaide tipi kullanım ayrımı yer alır.',
          kullanim: 'Dağıtım transformatörü çıkışlarında, saha dağıtım noktalarında ve direk tipi çözümün kullanılmadığı harici AG tesislerde.',
          tecHizat: 'AG anahtarlama ve koruma cihazları, DSYA, baralar, klemensler, bağlantı elemanları, kaide ve topraklama.',
          mekanik: 'Kaide taşıma kapasitesi, pano sabitlemesi, çevresel etki, kablo güzergâhı ve erişim/bakım alanı kontrol edilir.',
          dikkat: 'Pano gücü, çıkış sayısı, cihaz boyutları ve kaide tipi seçilen teknik şartname eki/malzeme listesine göre belirlenmelidir.',
          kaynak: 'TEDAŞ-MLZ/2003-006.B/C ve ilgili AG pano ekleri.',
        );
      case 'AG bina içi / dahili dağıtım panosu':
        return const _DagitimTipBilgi(
          teknik: 'AG dahili pano; bina içi AG dağıtım ve koruma amacıyla kullanılan pano tipidir.',
          fiziki: 'Pano mahfazası, giriş/çıkış düzeni, baralar, devre kesiciler/ayırıcılar, klemensler ve yardımcı donanımların yerleşimi proje ve pano tipine göre belirlenir.',
          kullanim: 'Bina içi AG dağıtım noktaları ve tesisin dahili elektrik dağıtım bölümlerinde.',
          tecHizat: 'Ana şalter, devre kesiciler, sigortalar, baralar, klemensler, ölçü/koruma ve yardımcı donanımlar.',
          mekanik: 'Montaj yüzeyi, pano ağırlığı, kablo girişleri, IP/çevre koşulları ve bakım erişimi kontrol edilir.',
          dikkat: 'Kullanım yeri bina içi/dışı, pano tipi ve koruma derecesi gerçek proje koşullarına göre belirlenmelidir.',
          kaynak: 'TEDAŞ AG pano teknik şartnamesi ve TS EN 61439 serisi referansları.',
        );
      case 'AG saha dağıtım kutusu / box':
        return const _DagitimTipBilgi(
          teknik: 'AG saha dağıtım kutusu/box; AG devrelerinin saha içerisinde dağıtılması, korunması veya bağlantılarının yapılması için kullanılan mahfazalı kutu/donanımdır.',
          fiziki: 'Mahfaza malzemesi, montaj şekli, giriş-çıkış sayısı, terminal düzeni ve koruma derecesi ürün/şartnameye göre değişir.',
          kullanim: 'AG yeraltı dağıtım, saha bağlantıları ve uygun tip proje/ürün uygulamalarında.',
          tecHizat: 'Klemensler, sigorta/koruma elemanları, bağlantı baraları veya üreticiye özgü iç donanım.',
          mekanik: 'Mahfaza dayanımı, dış ortam etkileri, kablo girişleri ve montaj sabitlemesi kontrol edilir.',
          dikkat: 'Box adı tek başına standart bir ürün tanımı değildir; ürünün ilgili standart ve dağıtım şirketi malzeme şartnamesine uygunluğu doğrulanmalıdır.',
          kaynak: 'TEDAŞ AG dağıtım panoları ve ilgili saha malzemesi şartnameleri.',
        );
      case 'AG aydınlatma panosu / box':
        return const _DagitimTipBilgi(
          teknik: 'AG aydınlatma panosu; genel aydınlatma devrelerinin beslenmesi, korunması ve kumandası için kullanılan AG pano tipidir.',
          fiziki: 'Metal veya CTP mahfaza, giriş-çıkış düzeni, koruma/kumanda cihazları ve gerektiğinde astronomik röle gibi yardımcı elemanlar bulunabilir.',
          kullanim: 'Genel aydınlatma sistemlerinde ve dağıtım şebekesinden aydınlatma devrelerinin beslendiği saha noktalarında.',
          tecHizat: 'Anahtarlama/koruma cihazları, kontaktör, sigorta/devre kesici, klemens, kumanda elemanları ve gerekiyorsa astronomik röle.',
          mekanik: 'Harici ortam şartları, pano montajı, kablo girişleri, mahfaza koruması ve topraklama kontrol edilir.',
          dikkat: 'Aydınlatma direği tipi ve pano/box seçimi tesisin gerçek dağıtım yapısına göre ayrıca doğrulanmalıdır.',
          kaynak: 'TEDAŞ AG dağıtım panoları teknik şartnamesi; ilgili aydınlatma tip proje dokümanları.',
        );
      case 'AG yeraltı kablo dağıtım düzeni':
        return const _DagitimTipBilgi(
          teknik: 'AG yeraltı dağıtım düzeni; AG kablolarının kanal/boru veya uygun yeraltı güzergâhında dağıtılması ve saha kutuları/panolarla bağlantılanmasıdır.',
          fiziki: 'Kablo kesiti, damar yapısı, güzergâh, boru/kanal, mekanik koruma, bükülme yarıçapı ve bağlantı noktaları proje verilerine göre belirlenir.',
          kullanim: 'Havai hattın uygun olmadığı veya yeraltı dağıtımın tercih edildiği AG şebeke güzergâhlarında.',
          tecHizat: 'AG kablo, ek/başlık, box/pano, kablo kanalı/borusu, mekanik koruma ve topraklama.',
          mekanik: 'Döşeme koşulları, çekme kuvveti, bükülme yarıçapı, çevresel/ısıl koşullar ve güzergâh güvenliği kontrol edilir.',
          dikkat: 'Kablo kesiti akım taşıma, gerilim düşümü, kısa devre ve döşeme koşulları birlikte değerlendirilerek belirlenmelidir.',
          kaynak: 'TEDAŞ AG dağıtım ve kablo uygulama dokümanları.',
        );
      case 'OG–AG müşterek betonarme direk':
        return const _DagitimTipBilgi(
          teknik: 'OG–AG müşterek betonarme direk; aynı direk güzergâhında OG ve AG devrelerinin birlikte tesis edildiği havai şebeke düzeninin taşıyıcı elemanıdır.',
          fiziki: 'Direk boyu/sınıfı, tepe yükü, travers/konsol yerleşimi, OG ve AG iletkenlerinin düşey/yatay konumu, topraklama ve gerekirse aydınlatma bağlantısı tip projeye göre belirlenir.',
          kullanim: 'OG ve AG güzergâhlarının aynı koridorda yürütülmesinin uygun olduğu müşterek havai dağıtım tesislerinde.',
          tecHizat: 'OG ve AG travers/konsolları, izolatörler, iletkenler, hırdavat, topraklama, bağlantı ve gerektiğinde aydınlatma donanımı.',
          mekanik: 'Toplam iletken çekmeleri, direk tepe yükü, rüzgâr/buz, açıklık, sarkma ve iki gerilim seviyesinin birlikte oluşturduğu yükler kontrol edilir.',
          dikkat: 'OG ve AG için gerekli emniyet mesafeleri ve fiziksel yerleşim tip proje/onaylı proje olmadan kesinleştirilmemelidir.',
          kaynak: 'TEDAŞ YG/AG müşterek direkli hat ve ilgili tip proje dokümanları.',
        );
      case 'OG–AG müşterek çelik direk (tip proje kapsamında)':
        return const _DagitimTipBilgi(
          teknik: 'OG–AG müşterek tesislerde, yalnızca ilgili tip proje tarafından öngörülen mekanik ve geometrik koşullarda kullanılabilen çelik taşıyıcı sistemdir.',
          fiziki: 'Çelik kesit, boy, et kalınlığı, bağlantı/ankraj ve korozyon koruması seçilen tipe göre belirlenir; OG ve AG donanımlarının fiziksel ayrımı korunur.',
          kullanim: 'Özel mekanik veya yerleşim gereksinimlerinin bulunduğu ve tip proje ile izin verilen müşterek havai hatlarda.',
          tecHizat: 'OG/AG travers-konsolları, izolatörler, iletkenler, hırdavat, topraklama ve gerekiyorsa aydınlatma donanımı.',
          mekanik: 'Toplam yatay/düşey yükler, taban momenti, rüzgâr/buz, iletken çekmeleri ve ankraj/temel hesabı kontrol edilir.',
          dikkat: 'Genel bir “çelik direk” yerine mutlaka proje/tip proje ile tanımlı ürün kullanılmalıdır.',
          kaynak: 'TEDAŞ müşterek hat tip projeleri ve ilgili teknik şartnameler.',
        );
      case 'OG–AG müşterek direk üstü dağıtım düzeni':
        return const _DagitimTipBilgi(
          teknik: 'OG ve AG devrelerinin aynı direk üzerinde, ilgili tip proje tarafından belirlenen fiziksel ayrım ve donanım düzeni ile birlikte taşındığı dağıtım yapısıdır.',
          fiziki: 'OG/AG traversleri, izolatörleri, iletken seviyeleri, servis çıkışları, topraklama ve varsa direk üstü pano/teçhizat yerleşimi birlikte düzenlenir.',
          kullanim: 'Müşterek havai dağıtım hatlarında ve aynı güzergâhta iki gerilim seviyesinin birlikte yürütülmesinin uygun olduğu noktalarda.',
          tecHizat: 'OG/AG iletkenleri, travers/konsollar, izolatörler, hırdavat, topraklama ve gerektiğinde direk üstü AG pano/aydınlatma donanımı.',
          mekanik: 'İki sistemin toplam yükü, açıklık, sarkma, rüzgâr/buz ve direk sınıfı birlikte kontrol edilir.',
          dikkat: 'Fiziksel yerleşim ve emniyet mesafeleri tip projeye göre uygulanmalıdır.',
          kaynak: 'TEDAŞ YG/AG müşterek direkli hat tip proje dokümanları.',
        );
      case 'OG–AG müşterek hat + aydınlatma donanımı':
        return const _DagitimTipBilgi(
          teknik: 'OG–AG müşterek şebekeye, uygun tip proje ve proje koşullarında genel aydınlatma donanımının da dahil edildiği tesis düzenidir.',
          fiziki: 'OG/AG iletkenleri ile aydınlatma kolu/armatür ve besleme elemanlarının birbirine göre fiziksel yerleşimi, emniyet mesafeleri ve direk kapasitesi birlikte değerlendirilir.',
          kullanim: 'Müşterek dağıtım hattının aynı güzergâhta genel aydınlatma ihtiyacını da karşılamasının uygun olduğu tesislerde.',
          tecHizat: 'OG/AG hat donanımı, aydınlatma armatürü/kolu, aydınlatma besleme iletkenleri, pano/koruma ve topraklama.',
          mekanik: 'Ek aydınlatma yükü, rüzgâr alanı, direk tepe yükü, iletken çekmeleri ve direk sınıfı ayrıca kontrol edilir.',
          dikkat: 'Aydınlatma eklenmesi direğin mekanik ve elektriksel uygunluğunu değiştirebilir; ayrı kontrol gerekir.',
          kaynak: 'TEDAŞ müşterek hat ve genel aydınlatma tip proje/teknik dokümanları.',
        );
      case 'OG–AG müşterek yeraltı/havai geçiş düzeni':
        return const _DagitimTipBilgi(
          teknik: 'Müşterek şebekenin belirli bir kesiminde havai ve yeraltı tesis elemanlarının geçiş/bağlantı düzenidir.',
          fiziki: 'Kablo başlıkları, geçiş bağlantıları, direk/taşıyıcı, OG/AG fiziksel ayrımı, mekanik koruma ve topraklama düzeni proje ile belirlenir.',
          kullanim: 'Havai güzergâhın yeraltı tesise geçtiği veya tersi yönde geçiş yapılan müşterek şebeke noktalarında.',
          tecHizat: 'OG/AG kabloları, başlık/ek, direk/taşıyıcı, koruma elemanları, topraklama ve geçiş donanımı.',
          mekanik: 'Kablo çekme/bükülme, geçiş noktası mekanik yükleri, rüzgâr ve direk yükleri kontrol edilir.',
          dikkat: 'Geçiş noktası için ilgili tip proje ve kablo başlık/ek sistemi şartları ayrıca kontrol edilmelidir.',
          kaynak: 'TEDAŞ müşterek hat ve OG/AG yeraltı geçiş uygulama dokümanları.',
        );
      default:
        return const _DagitimTipBilgi(
          teknik: 'Seçilen eleman için teknik bilgi kaydı bulunamadı.',
          fiziki: 'Ürün/tesis tipi ayrıca doğrulanmalıdır.',
          kullanim: 'İlgili tip proje ve şartname kontrol edilmelidir.',
          tecHizat: 'Proje koşullarına göre belirlenir.',
          mekanik: 'Mekanik hesap yapılmadan kesin seçim yapılmamalıdır.',
          dikkat: 'Bu ekran referans niteliğindedir.',
          kaynak: 'İlgili TEDAŞ ve ulusal standart dokümanları.',
        );
    }
  }

  void incele() => setState(() => sonuc = eleman);

  @override
  Widget build(BuildContext context) {
    final items = elemanlar(tesis);
    if (!items.contains(eleman)) eleman = items.first;
    final b = bilgi();
    return AppScaffold(
      title: 'Dağıtım Şebekesi / ENH',
      info: true,
      onInfo: () => bilgiPopup(context, 'Dağıtım Şebekesi / ENH',
        'Bu araçta ilk seçim yalnızca AG, OG veya Müşterek şebeke tipidir. İkinci seçim listesi otomatik olarak yalnızca seçilen şebeke tipine uygun tesis elemanlarını gösterir. Uygun olmayan direk/box/bina seçenekleri listede gösterilmez.\n\n'
        'Seçilen elemanın teknik ve fiziki bilgileri referans olarak sunulur. Ecomühendis elektrik direkleri sayfasındaki saha terminolojisi (A tipi, I/U, kafes K1–K5, taşıyıcı/durdurucu/nihayet/zaviye, betonarme ve trafo direği örnekleri) ayrıca referans olarak işlenmiştir. Kesin seçim; yürürlükteki TEDAŞ tip projeleri, teknik şartnameler, ilgili TS/EN/IEC standartları, dağıtım şirketinin güncel uygulama dokümanları ve onaylı proje üzerinden yapılmalıdır.'),
      body: ScrollBody(children: [
        SectionCard(title: '1. Tesis Tipi', children: [
          Drop(
            label: 'Şebeke Tipi',
            value: tesis,
            items: const ['AG', 'OG', 'Müşterek'],
            onChanged: (v) => setState(() {
              tesis = v!;
              eleman = elemanlar(tesis).first;
              sonuc = null;
            }),
          ),
        ]),
        SectionCard(title: '2. Uygun Tesis Elemanı / Tipi', children: [
          Text(
            'Seçilen $tesis şebeke tipine uygun ulusal/şebeke uygulama elemanları gösterilmektedir. Diğer şebeke tiplerine ait elemanlar bu listede yer almaz.',
            style: TextStyle(color: cText().withValues(alpha: .82), fontSize: 12, height: 1.4),
          ),
          const SizedBox(height: 8),
          Drop(
            label: 'Direk / Box / Bina / Sistem Tipi',
            value: eleman,
            items: items,
            onChanged: (v) => setState(() { eleman = v!; sonuc = null; }),
          ),
          calcButton('TEKNİK / FİZİKİ ÖZELLİKLERİ GÖSTER', incele),
        ]),
        if (sonuc != null) ...[
          ResultCard(title: 'Teknik Uygunluk Kontrolü', value: 'ÖN DEĞERLENDİRME', subtitle: 'Seçilen eleman, seçilen şebeke tipiyle eşleştirilmiştir. Bu sonuç proje/onay uygunluğu değildir.', good: true),
          SectionCard(title: 'Seçilen Eleman', children: [Text(eleman, style: TextStyle(color: cIcon(), fontSize: 17, fontWeight: FontWeight.bold))]),
          SectionCard(title: 'Teknik Özellikler', children: [Text(b.teknik, style: TextStyle(color: cText(), height: 1.45))]),
          SectionCard(title: 'Fiziki Özellikler', children: [Text(b.fiziki, style: TextStyle(color: cText(), height: 1.45))]),
          SectionCard(title: 'Nerede / Hangi Şartlarda Kullanılır?', children: [Text(b.kullanim, style: TextStyle(color: cText(), height: 1.45))]),
          SectionCard(title: 'Gerekli / Muhtemel Teçhizat', children: [Text(b.tecHizat, style: TextStyle(color: cText(), height: 1.45))]),
          SectionCard(title: 'Mekanik ve Saha Kontrolleri', children: [Text(b.mekanik, style: TextStyle(color: cText(), height: 1.45))]),
          AdviceCard(title: 'Dikkat Edilecek Hususlar', text: b.dikkat, error: true),
          SectionCard(title: 'Kaynak / Referans Çerçevesi', children: [
            Text(b.kaynak, style: TextStyle(color: cText(), height: 1.45)),
            const SizedBox(height: 8),
            Text('Not: Başka uygulamalar, kataloglar veya kullanıcı tarafından verilen bağlantılar yalnızca referanstır. Nihai teknik bilgi ve malzeme seçimi; yürürlükteki mevzuat, TEDAŞ teknik şartnameleri/tip projeleri, ilgili TS/EN/IEC standartları, dağıtım şirketi güncel uygulamaları ve onaylı proje koşullarına göre doğrulanmalıdır.', style: TextStyle(color: cText().withValues(alpha: .82), fontSize: 12, height: 1.4)),
          ]),
        ],
      ]),
    );
  }
}
