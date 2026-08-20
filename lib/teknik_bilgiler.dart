part of 'main.dart';

// ================================================================
// ELEKTRİK SAHA ASİSTANI
// TEKNİK BİLGİLER KÜTÜPHANESİ
//
// Çevrim dışı teknik başvuru kütüphanesi.
//
// SEVİYE:
// • Yeni başlayan kullanıcı için temel açıklama
// • Saha çalışanı için pratik teknik bilgi
// • Orta seviye kullanıcı için hesaplama ve seçim mantığı
//
// NOT:
// Buradaki bilgiler saha ön bilgisi ve eğitim amaçlıdır.
// Kesin teknik seçim/uygunluk değerlendirmesi; güncel mevzuat,
// standartlar, teknik şartnameler, dağıtım şirketi koşulları,
// üretici verileri ve proje şartları ile doğrulanmalıdır.
// ================================================================

// ================================================================
// TEKNİK BİLGİ MODELİ
// ================================================================

class _TeknikBilgi {
  final String baslik;
  final String konu;
  final String tanim;
  final String aciklama;
  final String? dikkat;

  const _TeknikBilgi({
    required this.baslik,
    required this.konu,
    required this.tanim,
    required this.aciklama,
    this.dikkat,
  });
}

// ================================================================
// TEKNİK TERİM MODELİ
// ================================================================

class _TeknikTerim {
  final String terim;
  final String konu;
  final String aciklama;
  final String? ayrinti;

  const _TeknikTerim({
    required this.terim,
    required this.konu,
    required this.aciklama,
    this.ayrinti,
  });
}

// ================================================================
// TEKNİK TERİMLER SÖZLÜĞÜ
// ================================================================

const List<_TeknikTerim> _teknikTerimler = [
  // ==============================================================
  // ELEKTRİK TEMELLERİ
  // ==============================================================

  _TeknikTerim(
    terim: 'AG',
    konu: 'AG / OG Sistemleri',
    aciklama: 'Alçak gerilim sistemini ifade eder.',
    ayrinti:
        'Elektrik tesislerinde alçak gerilim seviyesindeki dağıtım ve kullanım sistemleri için kullanılan genel kısaltmadır.',
  ),

  _TeknikTerim(
    terim: 'OG',
    konu: 'AG / OG Sistemleri',
    aciklama: 'Orta gerilim sistemini ifade eder.',
    ayrinti:
        'Dağıtım şebekelerinde AG seviyesinin üzerindeki orta gerilim sistemleri için kullanılan genel ifadedir.',
  ),

  _TeknikTerim(
    terim: 'P',
    konu: 'Elektrik Temelleri',
    aciklama: 'Aktif gücün sembolüdür.',
    ayrinti:
        'Elektrik sisteminde faydalı işe dönüşen güç bileşenini ifade eder. Birimi watt veya kilowatt olarak kullanılır.',
  ),

  _TeknikTerim(
    terim: 'Q',
    konu: 'Elektrik Temelleri',
    aciklama: 'Reaktif gücün sembolüdür.',
    ayrinti:
        'Elektrik ve manyetik alanların oluşturulmasıyla ilişkili güç bileşenidir. Birimi var veya kvar olarak kullanılır.',
  ),

  _TeknikTerim(
    terim: 'S',
    konu: 'Elektrik Temelleri',
    aciklama: 'Görünür gücün sembolüdür.',
    ayrinti:
        'Aktif ve reaktif güç bileşenlerinin birlikte değerlendirilmesidir. Birimi VA veya kVA olarak kullanılır.',
  ),

  _TeknikTerim(
    terim: 'cos φ',
    konu: 'Elektrik Temelleri',
    aciklama: 'Güç faktörünü ifade eder.',
    ayrinti:
        'İdeal sinüzoidal durumda aktif gücün görünür güce oranı P/S olarak ifade edilir. Faz açısının kosinüsü ile ilişkilidir.',
  ),

  _TeknikTerim(
    terim: 'φ',
    konu: 'Elektrik Temelleri',
    aciklama: 'Gerilim ile akım arasındaki faz açısını ifade eder.',
    ayrinti:
        'Endüktif yüklerde akım gerilimin gerisinde, kapasitif yüklerde ise ileride olabilir. Bu açı güç faktörünün değerlendirilmesinde önemlidir.',
  ),

  _TeknikTerim(
    terim: 'kW',
    konu: 'Elektrik Temelleri',
    aciklama: 'Kilowatt, aktif güç birimidir.',
    ayrinti: '1 kW = 1000 W.',
  ),

  _TeknikTerim(
    terim: 'kVA',
    konu: 'Elektrik Temelleri',
    aciklama: 'Kilovolt-amper, görünür güç birimidir.',
    ayrinti:
        'Özellikle transformatörlerin anma gücünün ifade edilmesinde yaygın olarak kullanılır.',
  ),

  _TeknikTerim(
    terim: 'kvar',
    konu: 'Elektrik Temelleri',
    aciklama: 'Kilovolt-amper reaktif, reaktif güç birimidir.',
    ayrinti:
        'Kompanzasyon sistemlerinde kondansatör ve reaktif yük değerlerinin ifade edilmesinde kullanılır.',
  ),

  _TeknikTerim(
    terim: 'kWh',
    konu: 'Ölçüm ve Faturalama',
    aciklama: 'Kilowatt-saat, elektrik enerjisi birimidir.',
    ayrinti:
        'Sayaçlarda aktif enerji tüketiminin ifade edilmesinde temel birimdir.',
  ),

  _TeknikTerim(
    terim: 'Faz',
    konu: 'Elektrik Temelleri',
    aciklama:
        'Alternatif akım sistemindeki birbirinden belirli açıyla ayrılmış elektriksel iletken/sistem bileşenidir.',
    ayrinti:
        'Üç fazlı sistemlerde fazlar arasında ideal olarak 120° elektriksel açı bulunur.',
  ),

  _TeknikTerim(
    terim: 'Nötr',
    konu: 'Elektrik Temelleri',
    aciklama: 'Yıldız bağlı sistemlerde nötr noktasıyla ilişkili iletkendir.',
    ayrinti:
        'Dengesiz yüklerde nötr iletkeninden akım geçebilir. Sistem yapısına göre nötrün görevi ve bağlantısı ayrıca değerlendirilmelidir.',
  ),

  _TeknikTerim(
    terim: 'Faz-faz gerilim',
    konu: 'Elektrik Temelleri',
    aciklama: 'İki faz iletkeni arasındaki gerilimdir.',
    ayrinti:
        'Üç fazlı dengeli sistemlerde faz-faz gerilim, faz-nötr gerilimden √3 oranında büyüktür.',
  ),

  _TeknikTerim(
    terim: 'Faz-nötr gerilim',
    konu: 'Elektrik Temelleri',
    aciklama: 'Bir faz ile nötr arasındaki gerilimdir.',
    ayrinti:
        'Tek fazlı yüklerin değerlendirilmesinde ve üç fazlı sistemlerde faz gerilimlerinin incelenmesinde kullanılır.',
  ),

  // ==============================================================
  // AKIM TRAFOLARI
  // ==============================================================

  _TeknikTerim(
    terim: 'CT',
    konu: 'Akım Trafoları',
    aciklama: 'Current Transformer, yani akım trafosu kısaltmasıdır.',
    ayrinti:
        'Yüksek primer akımlarının ölçü ve koruma cihazlarının kullanabileceği sekonder akımlara dönüştürülmesinde kullanılır.',
  ),

  _TeknikTerim(
    terim: 'VT',
    konu: 'Gerilim Trafoları',
    aciklama: 'Voltage Transformer, yani gerilim trafosu kısaltmasıdır.',
    ayrinti:
        'Yüksek gerilim seviyelerini ölçü ve koruma sistemlerinin kullanabileceği değerlere dönüştürür.',
  ),

  _TeknikTerim(
    terim: 'Burden',
    konu: 'Akım Trafoları',
    aciklama: 'Akım trafosu sekonder devresinin görünen yükünü ifade eder.',
    ayrinti:
        'Bağlı sayaç, röle, kablo ve diğer sekonder yüklerin toplam etkisi CT doğruluğuyla ilişkilidir.',
  ),

  _TeknikTerim(
    terim: 'ALF',
    konu: 'Akım Trafoları',
    aciklama: 'Accuracy Limit Factor, doğruluk sınır faktörüdür.',
    ayrinti:
        'Koruma amaçlı akım trafosunun belirli doğruluk sınırlarını koruyabildiği primer akım seviyesinin değerlendirilmesinde kullanılır.',
  ),

  _TeknikTerim(
    terim: 'Ith',
    konu: 'Akım Trafoları',
    aciklama: 'Kısa süreli termik dayanım akımıdır.',
    ayrinti:
        'Akım trafosunun belirli süre boyunca kısa devre koşullarında termik olarak dayanabileceği akımı ifade eder.',
  ),

  _TeknikTerim(
    terim: 'Idyn',
    konu: 'Akım Trafoları',
    aciklama: 'Dinamik dayanım akımını ifade eder.',
    ayrinti:
        'Kısa devre sırasında oluşan elektromekanik kuvvetlere karşı akım trafosunun dayanımını değerlendirmede kullanılır.',
  ),

  _TeknikTerim(
    terim: '5P10',
    konu: 'Akım Trafoları',
    aciklama: 'Koruma amaçlı akım trafosu sınıf gösterimidir.',
    ayrinti: '5P koruma sınıfını, 10 ise doğruluk sınır faktörünü ifade eder.',
  ),

  _TeknikTerim(
    terim: '10P10',
    konu: 'Akım Trafoları',
    aciklama: 'Koruma amaçlı akım trafosu sınıf gösterimlerinden biridir.',
    ayrinti: '10P koruma sınıfını, 10 ise doğruluk sınır faktörünü ifade eder.',
  ),

  _TeknikTerim(
    terim: '0,2S',
    konu: 'Akım Trafoları',
    aciklama: 'Ölçü amaçlı yüksek doğruluk sınıflarından biridir.',
    ayrinti:
        'Enerji ölçüm uygulamalarında kullanılan doğruluk sınıflarından biridir.',
  ),

  _TeknikTerim(
    terim: '0,5S',
    konu: 'Akım Trafoları',
    aciklama: 'Ölçü amaçlı doğruluk sınıflarından biridir.',
    ayrinti: 'Enerji ölçüm uygulamalarında kullanılan sınıflardan biridir.',
  ),

  _TeknikTerim(
    terim: 'Sekonder',
    konu: 'Akım Trafoları',
    aciklama: 'Ölçü trafosunun çıkış tarafıdır.',
    ayrinti:
        'Akım trafolarında sekonder devre genellikle ölçüm veya koruma cihazlarına bağlanır. Yaygın değerler 1 A ve 5 A\'dır.',
  ),

  // ==============================================================
  // KOMPANZASYON
  // ==============================================================

  _TeknikTerim(
    terim: 'Kompanzasyon',
    konu: 'Kompanzasyon',
    aciklama: 'Reaktif güç ihtiyacının uygun yöntemlerle dengelenmesidir.',
    ayrinti:
        'Özellikle endüktif yüklerin oluşturduğu reaktif güç ihtiyacını azaltmak amacıyla kondansatör, reaktör ve kontrol sistemleri kullanılabilir.',
  ),

  _TeknikTerim(
    terim: 'Endüktif yük',
    konu: 'Kompanzasyon',
    aciklama: 'Akımın gerilime göre geride kaldığı karakterdeki yüktür.',
    ayrinti:
        'Motorlar, transformatörler ve manyetik alan oluşturan birçok yük endüktif davranış gösterebilir.',
  ),

  _TeknikTerim(
    terim: 'Kapasitif yük',
    konu: 'Kompanzasyon',
    aciklama: 'Akımın gerilime göre ileride olduğu karakterdeki yüktür.',
    ayrinti:
        'Kondansatörler kapasitif reaktif güç sağlar. Aşırı kapasitif çalışma da istenmeyen bir durum olabilir.',
  ),

  _TeknikTerim(
    terim: 'Reaktif güç',
    konu: 'Kompanzasyon',
    aciklama:
        'Elektrik ve manyetik alanların oluşturulmasıyla ilişkili güç bileşenidir.',
    ayrinti:
        'İdeal sinüzoidal sistemlerde P, Q ve S arasında güç üçgeni ilişkisi bulunur.',
  ),

  _TeknikTerim(
    terim: 'Güç faktörü',
    konu: 'Kompanzasyon',
    aciklama: 'Aktif gücün görünür güce oranıdır.',
    ayrinti:
        'Sinüzoidal durumda cosφ ile ilişkilidir. Kompanzasyonun temel hedeflerinden biri uygun güç faktörü seviyesini korumaktır.',
  ),

  _TeknikTerim(
    terim: 'φ',
    konu: 'Kompanzasyon',
    aciklama: 'Gerilim ile akım arasındaki faz açısıdır.',
    ayrinti:
        'Endüktif yüklerde akım geride, kapasitif yüklerde ileride olur. Kompanzasyon bu faz ilişkisini daha uygun bir noktaya taşımayı amaçlar.',
  ),

  _TeknikTerim(
    terim: 'Qc',
    konu: 'Kompanzasyon',
    aciklama: 'Kompanzasyon kondansatörünün sağlaması gereken reaktif güçtür.',
    ayrinti:
        'İdeal sinüzoidal ön hesapta Qc = P × (tanφ₁ − tanφ₂) bağıntısı kullanılabilir.',
  ),

  _TeknikTerim(
    terim: 'Kademe',
    konu: 'Kompanzasyon',
    aciklama: 'Kompanzasyon panosundaki ayrı kondansatör grubudur.',
    ayrinti:
        'Reaktif kontrol rölesi yük durumuna göre kademeleri devreye alıp çıkararak kompanzasyon seviyesini düzenler.',
  ),

  _TeknikTerim(
    terim: 'Reaktif kontrol rölesi',
    konu: 'Kompanzasyon',
    aciklama: 'Kompanzasyon kademelerini otomatik yöneten kontrol cihazıdır.',
    ayrinti:
        'CT üzerinden alınan ölçüm ve ayarlanan hedef değer doğrultusunda kondansatör kademelerini kontrol eder.',
  ),

  // ==============================================================
  // KABLOLAR
  // ==============================================================

  _TeknikTerim(
    terim: 'NYY',
    konu: 'Kablolar ve İletkenler',
    aciklama: 'Alçak gerilim güç kablosu tiplerinden biridir.',
    ayrinti:
        'Uygulama koşullarına göre sabit tesislerde kullanılan kablo tiplerinden biridir.',
  ),

  _TeknikTerim(
    terim: 'NAYY',
    konu: 'Kablolar ve İletkenler',
    aciklama: 'Alüminyum iletkenli AG güç kablosu tipidir.',
    ayrinti:
        'Bakır yerine alüminyum iletken kullanır. Kesit, bağlantı elemanları ve döşeme koşulları birlikte değerlendirilmelidir.',
  ),

  _TeknikTerim(
    terim: 'Kesit',
    konu: 'Kablolar ve İletkenler',
    aciklama: 'İletkenin nominal kesit alanını ifade eder.',
    ayrinti:
        'Kablo seçiminde yalnızca kesit değil, iletken malzemesi, izolasyon, döşeme yöntemi ve çevre şartları da dikkate alınır.',
  ),

  _TeknikTerim(
    terim: 'Akım taşıma kapasitesi',
    konu: 'Kablolar ve İletkenler',
    aciklama: 'Kablonun belirli şartlarda sürekli taşıyabileceği akımdır.',
    ayrinti:
        'Ortam sıcaklığı, döşeme yöntemi, gruplanma, kablo yapısı ve diğer düzeltme katsayıları kapasiteyi etkiler.',
  ),

  _TeknikTerim(
    terim: 'Gerilim düşümü',
    konu: 'Kablolar ve İletkenler',
    aciklama: 'Hat boyunca oluşan gerilim azalmasıdır.',
    ayrinti:
        'Uzunluk, akım, iletken empedansı ve güç faktörü gerilim düşümünü etkiler.',
  ),

  _TeknikTerim(
    terim: 'Paralel kablo',
    konu: 'Kablolar ve İletkenler',
    aciklama: 'Aynı devre akımının birden fazla kablo ile taşınmasıdır.',
    ayrinti:
        'Yüksek akımlarda kullanılabilir. Kabloların eşit/uygun güzergâh, uzunluk ve döşeme şartlarında olması akım paylaşımı açısından önemlidir.',
  ),

  // ==============================================================
  // GES
  // ==============================================================

  _TeknikTerim(
    terim: 'Wp',
    konu: 'GES / Solar',
    aciklama: 'Fotovoltaik panelin nominal tepe gücünü ifade eder.',
    ayrinti:
        'Panel gücü standart test koşullarındaki nominal değer üzerinden ifade edilir.',
  ),

  _TeknikTerim(
    terim: 'MPPT',
    konu: 'GES / Solar',
    aciklama: 'Maximum Power Point Tracking sistemidir.',
    ayrinti:
        'İnverter, panel dizisinin çalışma noktasını mümkün olduğunca uygun güç noktasında tutmak için MPPT algoritması kullanır.',
  ),

  _TeknikTerim(
    terim: 'String',
    konu: 'GES / Solar',
    aciklama: 'Seri bağlanmış PV paneller grubudur.',
    ayrinti:
        'String gerilimi panel sayısıyla, string akımı ise paralel string yapısıyla ilişkilidir.',
  ),

  _TeknikTerim(
    terim: 'DC/AC oranı',
    konu: 'GES / Solar',
    aciklama: 'PV DC kurulu gücün inverter AC gücüne oranıdır.',
    ayrinti:
        'GES tasarımında inverter boyutlandırmasının değerlendirilmesinde kullanılan önemli parametrelerden biridir.',
  ),

  // ==============================================================
  // ÖLÇÜM / FATURALAMA
  // ==============================================================

  _TeknikTerim(
    terim: 'Aktif enerji',
    konu: 'Ölçüm ve Faturalama',
    aciklama: 'Elektrik enerjisinin faydalı iş yapan bileşenidir.',
    ayrinti: 'Sayaçlarda çoğunlukla kWh cinsinden ölçülür.',
  ),

  _TeknikTerim(
    terim: 'Reaktif enerji',
    konu: 'Ölçüm ve Faturalama',
    aciklama: 'Reaktif güç bileşeninin zamanla enerji karşılığıdır.',
    ayrinti:
        'kvarh cinsinden ifade edilir ve ilgili tarife/mevzuat koşullarında faturalama değerlendirmesine konu olabilir.',
  ),

  _TeknikTerim(
    terim: 'Talep gücü',
    konu: 'Ölçüm ve Faturalama',
    aciklama: 'Tesisin belirli koşullardaki yük talebini ifade eder.',
    ayrinti: 'Talep gücü ile sözleşme gücü aynı kavram değildir.',
  ),

  _TeknikTerim(
    terim: 'Sözleşme gücü',
    konu: 'Ölçüm ve Faturalama',
    aciklama: 'Sözleşmede tanımlanan güç değeridir.',
    ayrinti:
        'Faturalama ve bağlantı koşulları açısından ilgili sözleşme ve güncel mevzuatla birlikte değerlendirilir.',
  ),

  // ==============================================================
  // TOPRAKLAMA
  // ==============================================================

  _TeknikTerim(
    terim: 'PE',
    konu: 'Topraklama',
    aciklama: 'Koruma iletkenidir.',
    ayrinti:
        'Elektrik çarpmasına karşı koruma ve arıza akımının güvenli şekilde iletilmesi amacıyla kullanılır.',
  ),

  _TeknikTerim(
    terim: 'PEN',
    konu: 'Topraklama',
    aciklama: 'Koruma ve nötr fonksiyonlarını birlikte taşıyan iletkendir.',
    ayrinti:
        'PEN kullanımı sistem tipine ve ilgili tesisat kurallarına bağlıdır.',
  ),

  _TeknikTerim(
    terim: 'Eşpotansiyel bağlama',
    konu: 'Topraklama',
    aciklama:
        'İletken bölümlerin potansiyel farklarını azaltacak şekilde birbirine bağlanmasıdır.',
    ayrinti:
        'İnsan güvenliği ve arıza durumlarındaki potansiyel farkların azaltılması açısından önemlidir.',
  ),
];

// ================================================================
// TEKNİK BİLGİLER
// ================================================================

const List<_TeknikBilgi> _teknikBilgiler = [
  // ==============================================================
  // AG / OG
  // ==============================================================

  _TeknikBilgi(
    baslik: 'AG Sisteminin Temel Mantığı',
    konu: 'AG / OG Sistemleri',
    tanim:
        'Alçak gerilim dağıtım ve kullanım sistemlerinin genel yapısını açıklar.',
    aciklama:
        'AG sisteminde enerji; trafo çıkışından AG panoya, dağıtım hatlarına ve son tüketicilere aktarılır. Projede faz, nötr, PE/PEN yapısı, yük dağılımı ve koruma düzenleri birlikte değerlendirilir.',
    dikkat:
        'Nominal gerilim tek başına tesisin tüm elektriksel özelliklerini belirlemez.',
  ),

  _TeknikBilgi(
    baslik: 'OG Sisteminin Temel Mantığı',
    konu: 'AG / OG Sistemleri',
    tanim:
        'Orta gerilim seviyesindeki dağıtım sistemlerinin çalışma yapısıdır.',
    aciklama:
        'OG tarafında enerji; hücreler, kesiciler, ayırıcılar, ölçü trafoları ve transformatörler üzerinden dağıtılır. Koruma koordinasyonu AG tarafına göre daha farklı değerlendirilir.',
    dikkat:
        'OG tesislerinde işletme ve güvenlik prosedürleri ayrıca dikkate alınmalıdır.',
  ),

  _TeknikBilgi(
    baslik: 'OG Hücre Fonksiyonları',
    konu: 'AG / OG Sistemleri',
    tanim: 'OG hücrelerinin görevlerine göre sınıflandırılmasını açıklar.',
    aciklama:
        'Giriş, çıkış, ölçü, trafo koruma ve kuplaj gibi farklı fonksiyonlar için farklı hücre kurguları kullanılabilir.',
    dikkat: 'Hücre seçimi yalnızca fiziksel boyuta göre yapılmamalıdır.',
  ),

  _TeknikBilgi(
    baslik: 'Trafo AG Tarafı',
    konu: 'AG / OG Sistemleri',
    tanim: 'Transformatörün AG çıkışının dağıtım sistemine aktarılmasıdır.',
    aciklama:
        'Trafo AG çıkışında ana pano, bara, kablolar, koruma cihazları ve ölçüm sistemi birlikte değerlendirilir. Trafo gücü arttıkça AG tarafındaki akım da önemli ölçüde artar.',
    dikkat:
        'Trafo çıkış akımı üzerinden kablo ve bara seçimi yapılırken kısa devre hesabı da ayrıca değerlendirilmelidir.',
  ),

  // ==============================================================
  // AKIM TRAFOLARI
  // ==============================================================

  _TeknikBilgi(
    baslik: 'Akım Trafosu Seçiminin Temelleri',
    konu: 'Akım Trafoları',
    tanim:
        'Ölçü veya koruma amacına uygun CT seçiminin temel adımlarını açıklar.',
    aciklama:
        'Primer oran, sekonder oran, doğruluk sınıfı, burden, kullanım amacı, kısa devre dayanımı ve bağlı cihazların gereksinimleri birlikte değerlendirilir.',
    dikkat: 'Ölçü CTsi ile koruma CTsinin seçim kriterleri aynı değildir.',
  ),

  _TeknikBilgi(
    baslik: 'CT Oranı Nasıl Düşünülür?',
    konu: 'Akım Trafoları',
    tanim: 'Primer ve sekonder akım oranının çalışma mantığını açıklar.',
    aciklama:
        'Örneğin 400/5 A CT, primerde 400 A seviyesindeki akımı sekonderde 5 A nominal değere dönüştürür. Gerçek seçimde sürekli yük, maksimum yük ve kısa devre şartları birlikte incelenir.',
    dikkat:
        'CT oranının gereğinden büyük seçilmesi ölçüm çözünürlüğünü etkileyebilir.',
  ),

  _TeknikBilgi(
    baslik: 'Burden Neden Önemlidir?',
    konu: 'Akım Trafoları',
    tanim: 'CT sekonder yükünün doğruluk üzerindeki etkisini açıklar.',
    aciklama:
        'Sekonder kablo uzunluğu, kablo kesiti, sayaç/röle giriş yükü ve diğer bağlı elemanlar toplam burden üzerinde etkilidir.',
    dikkat:
        'Üretici tarafından verilen burden ve doğruluk şartları kontrol edilmelidir.',
  ),

  _TeknikBilgi(
    baslik: 'Ölçü CTsi ve Koruma CTsi',
    konu: 'Akım Trafoları',
    tanim: 'Ölçüm ve koruma çekirdeklerinin farklı amaçlarını açıklar.',
    aciklama:
        'Ölçü çekirdeğinde normal işletme bölgesindeki doğruluk ön plandayken koruma çekirdeğinde arıza akımlarının röleye doğru aktarılması önem kazanır.',
    dikkat:
        'Tek bir sınıf değeri bütün uygulamalar için yeterli kabul edilmemelidir.',
  ),

  // ==============================================================
  // ELEKTRİK TEMELLERİ
  // ==============================================================

  _TeknikBilgi(
    baslik: 'Aktif Güç, Reaktif Güç ve Görünür Güç',
    konu: 'Elektrik Temelleri',
    tanim: 'AC sistemlerdeki üç temel güç bileşenini açıklar.',
    aciklama:
        'Aktif güç P, faydalı işe dönüşen güçtür. Reaktif güç Q, elektrik/manyetik alanların oluşturulmasıyla ilişkili bileşendir. Görünür güç S ise aktif ve reaktif bileşenlerin birlikte değerlendirilmesidir.',
    dikkat: 'kW, kvar ve kVA birbirinin yerine kullanılmamalıdır.',
  ),

  _TeknikBilgi(
    baslik: 'Güç Üçgeni',
    konu: 'Elektrik Temelleri',
    tanim: 'P, Q ve S arasındaki geometrik ilişkiyi açıklar.',
    aciklama:
        'Dik üçgen yaklaşımında yatay eksen aktif güç P, dikey eksen reaktif güç Q, hipotenüs ise görünür güç S olarak düşünülebilir. İdeal sinüzoidal durumda S² = P² + Q² ilişkisi kullanılır.',
    dikkat:
        'Harmonikli veya bozulmuş dalga şekillerinde basit güç üçgeni yaklaşımı tek başına yeterli olmayabilir.',
  ),

  _TeknikBilgi(
    baslik: 'Faz Açısı ve cosφ',
    konu: 'Elektrik Temelleri',
    tanim:
        'Gerilim-akım faz ilişkisi ile güç faktörü arasındaki bağlantıyı açıklar.',
    aciklama:
        'İdeal sinüzoidal durumda cosφ, aktif gücün görünür güce oranıyla ilişkilidir. Faz açısı büyüdükçe aynı aktif güç için gereken görünür güç ve akım artabilir.',
    dikkat:
        'Güç faktörü değerlendirmesi yapılırken harmonik bozulma gibi etkiler de göz önüne alınmalıdır.',
  ),

  _TeknikBilgi(
    baslik: 'Üç Fazlı Güç Hesabı',
    konu: 'Elektrik Temelleri',
    tanim: 'Üç fazlı sistemlerde güç ve akım ilişkisinin temelini açıklar.',
    aciklama:
        'Dengeli sinüzoidal üç fazlı sistemlerde aktif güç için P = √3 × V × I × cosφ bağıntısı kullanılabilir. Burada V faz-faz gerilimidir.',
    dikkat:
        'Gerçek tesislerde dengesizlik, harmonikler ve ölçüm yöntemi ayrıca değerlendirilmelidir.',
  ),

  // ==============================================================
  // GES
  // ==============================================================

  _TeknikBilgi(
    baslik: 'PV Panel Gücü ve Wp',
    konu: 'GES / Solar',
    tanim: 'Fotovoltaik panelin nominal DC gücünü açıklar.',
    aciklama:
        'Wp panelin standart test koşullarındaki nominal tepe gücünü ifade eder. Toplam DC güç, panel gücü ile panel adedinin çarpımından elde edilir.',
    dikkat: 'Gerçek saha üretimi yalnızca panel Wp değerinden belirlenmez.',
  ),

  _TeknikBilgi(
    baslik: 'String ve Paralel String Yapısı',
    konu: 'GES / Solar',
    tanim: 'PV panellerin invertere bağlanma mantığını açıklar.',
    aciklama:
        'Seri bağlı paneller string oluşturur ve gerilim yükselir. Birden fazla string paralel bağlandığında toplam akım artar. İnverter MPPT gerilim ve akım sınırları buna göre kontrol edilmelidir.',
    dikkat:
        'String tasarımı panelin Voc, Vmp, Isc, Imp ve sıcaklık katsayılarıyla doğrulanmalıdır.',
  ),

  _TeknikBilgi(
    baslik: 'MPPT Çalışma Mantığı',
    konu: 'GES / Solar',
    tanim:
        'İnverterin panel dizisini uygun çalışma noktasında tutma yöntemidir.',
    aciklama:
        'PV panelin ürettiği güç ışınım ve sıcaklıkla değişir. MPPT algoritması panel dizisinin gerilim-akım çalışma noktasını mümkün olduğunca yüksek güç bölgesinde tutmaya çalışır.',
    dikkat:
        'Her inverterin MPPT gerilim ve akım sınırları üretici verisinden kontrol edilmelidir.',
  ),

  _TeknikBilgi(
    baslik: 'GES Çoklu İnverter AC Kurgusu',
    konu: 'GES / Solar',
    tanim: 'Birden fazla inverterin AG panoya bağlanma mantığını açıklar.',
    aciklama:
        'Çoklu inverter yapısında her inverterin AC çıkışı ayrı bir devre/hat olarak değerlendirilir ve AG pano barasına ayrı giriş yapılır. Her hattın kablo, koruma ve gerilim düşümü hesabı inverterin kendi çıkış akımına göre yapılır. AG pano barası ise birleşen hatların toplam yükünü taşıyacak şekilde ayrıca değerlendirilir.',
    dikkat:
        'İnverter üreticisinin maksimum AC çıkış akımı ve proje bağlantı şartları kesin seçimde esas alınmalıdır.',
  ),

  // ==============================================================
  // GERİLİM TRAFOLARI
  // ==============================================================

  _TeknikBilgi(
    baslik: 'Gerilim Trafosu Seçiminin Temelleri',
    konu: 'Gerilim Trafoları',
    tanim: 'VT seçerken dikkate alınması gereken temel parametreleri açıklar.',
    aciklama:
        'Primer/sekonder oranı, doğruluk sınıfı, burden, izolasyon seviyesi, bağlantı şekli ve kullanım amacı birlikte değerlendirilir.',
    dikkat:
        'Ölçü ve koruma amaçlı gerilim trafolarının gereksinimleri farklı olabilir.',
  ),

  _TeknikBilgi(
    baslik: 'VT Oranı',
    konu: 'Gerilim Trafoları',
    tanim: 'Gerilim trafosunun primer ve sekonder gerilim oranıdır.',
    aciklama:
        'Yüksek gerilim tarafındaki değer ölçüm cihazlarının kullanabileceği düşük gerilim seviyesine dönüştürülür.',
    dikkat:
        'Bağlı cihazların giriş gerilimi ve ilgili ölçüm şartları kontrol edilmelidir.',
  ),

  // ==============================================================
  // KABLOLAR
  // ==============================================================

  _TeknikBilgi(
    baslik: 'Kablo Akım Taşıma Kapasitesi',
    konu: 'Kablolar ve İletkenler',
    tanim:
        'Bir kablonun belirli koşullarda sürekli taşıyabileceği izin verilen akımdır.',
    aciklama:
        'Kapasite; iletken malzemesi, kesit, izolasyon, döşeme şekli, ortam sıcaklığı, gruplanma ve diğer düzeltme faktörlerinden etkilenir.',
    dikkat:
        'Sadece kablonun nominal kesitine bakılarak nihai seçim yapılmamalıdır.',
  ),

  _TeknikBilgi(
    baslik: 'Gerilim Düşümü',
    konu: 'Kablolar ve İletkenler',
    tanim: 'Kablo boyunca oluşan gerilim azalmasıdır.',
    aciklama:
        'Hat uzunluğu, akım, direnç, reaktans ve güç faktörü gerilim düşümünü etkiler. Uzun hatlarda kesit seçiminde önemli bir kriterdir.',
    dikkat:
        'Akım taşıma kapasitesi uygun olsa bile gerilim düşümü nedeniyle daha büyük kesit gerekebilir.',
  ),

  _TeknikBilgi(
    baslik: 'Döşeme Şeklinin Kabloya Etkisi',
    konu: 'Kablolar ve İletkenler',
    tanim: 'Kablonun fiziksel döşenme biçiminin akım kapasitesine etkisidir.',
    aciklama:
        'Boru, tava, kanal, toprak altı veya açık hava gibi farklı döşeme yöntemleri ısıl çalışma şartlarını değiştirir.',
    dikkat:
        'Aynı kesitteki kablo farklı döşeme koşullarında aynı akımı taşıyamayabilir.',
  ),

  _TeknikBilgi(
    baslik: 'Paralel Kablo Kullanımı',
    konu: 'Kablolar ve İletkenler',
    tanim: 'Yüksek akımların birden fazla kablo üzerinden taşınmasıdır.',
    aciklama:
        'Paralel kabloların aynı devreye ait olması halinde kabloların kesitleri, uzunlukları, güzergâhları ve döşeme şartları mümkün olduğunca dengeli tutulmalıdır.',
    dikkat:
        'Paralel kablo kullanımı sadece tek kablonun akım kapasitesini bölmek şeklinde düşünülmemelidir.',
  ),

  // ==============================================================
  // KOMPANZASYON - ANA BÖLÜM
  // ==============================================================

  _TeknikBilgi(
    baslik: 'Reaktif Güç Nasıl Oluşur?',
    konu: 'Kompanzasyon',
    tanim: 'Reaktif gücün elektrik sisteminde neden ortaya çıktığını açıklar.',
    aciklama:
        'Motor ve transformatör gibi manyetik alan oluşturan endüktif yükler, enerjinin bir bölümünü elektrik veya manyetik alanların kurulması ve geri çözülmesiyle ilişkilendirir. Bu davranış sistemde reaktif güç bileşeninin oluşmasına neden olur. Reaktif güç doğrudan faydalı mekanik işe dönüşen aktif güç değildir; ancak birçok AC cihazın çalışması için gerekli elektromanyetik alanın oluşumunda rol oynar.',
    dikkat:
        'Reaktif güç tamamen “boşa giden enerji” şeklinde tanımlanmamalıdır. Sistemin elektromanyetik çalışma yapısının bir parçasıdır.',
  ),

  _TeknikBilgi(
    baslik: 'Aktif Güç P',
    konu: 'Kompanzasyon',
    tanim: 'Elektrik enerjisinin faydalı işe dönüşen güç bileşenidir.',
    aciklama:
        'Aktif güç P ile gösterilir ve kW cinsinden ifade edilir. Motorun mekanik çıkışı, ısıtıcıdaki ısı enerjisi veya aydınlatma yükünün faydalı enerji dönüşümü aktif güçle ilişkilidir.',
    dikkat: 'Aktif güç ile görünür güç aynı değer değildir.',
  ),

  _TeknikBilgi(
    baslik: 'Reaktif Güç Q',
    konu: 'Kompanzasyon',
    tanim:
        'Elektrik ve manyetik alanların oluşturulmasıyla ilişkili güç bileşenidir.',
    aciklama:
        'Reaktif güç Q ile gösterilir ve kvar cinsinden ifade edilir. Endüktif yüklerde sistemden çekilen reaktif güç, kapasitif elemanlarla belirli ölçüde dengelenebilir.',
    dikkat:
        'Reaktif güç ihtiyacı yük karakterine ve çalışma koşullarına göre değişebilir.',
  ),

  _TeknikBilgi(
    baslik: 'Görünür Güç S',
    konu: 'Kompanzasyon',
    tanim: 'Aktif ve reaktif güç bileşenlerinin birlikte değerlendirilmesidir.',
    aciklama:
        'Görünür güç S, kVA cinsinden ifade edilir. İdeal sinüzoidal durumda S² = P² + Q² ilişkisi kullanılabilir. Aynı aktif gücü daha düşük reaktif güçle taşıyan sistemde görünür güç ve buna bağlı akım da azalabilir.',
    dikkat:
        'Harmonikli sistemlerde gerçek güç faktörü değerlendirmesi ayrıca yapılmalıdır.',
  ),

  _TeknikBilgi(
    baslik: 'Faz Açısı Nedir?',
    konu: 'Kompanzasyon',
    tanim: 'Gerilim ile akım arasındaki faz farkını ifade eder.',
    aciklama:
        'Sinüzoidal AC sistemde endüktif yüklerde akım gerilimin gerisinde, kapasitif yüklerde ise ileride bulunur. Bu faz farkı φ açısıyla ifade edilir. cosφ ise bu açının kosinüsüyle ilişkilidir.',
    dikkat:
        'Faz açısının büyümesi aynı aktif gücün taşınması için gereken akımın artmasına yol açabilir.',
  ),

  _TeknikBilgi(
    baslik: 'Faz Açısı Neden Düzeltilir?',
    konu: 'Kompanzasyon',
    tanim: 'Kompanzasyonun temel hedeflerinden birini açıklar.',
    aciklama:
        'Endüktif yükün oluşturduğu reaktif güç bileşeni kapasitif reaktif güç ile dengelendiğinde kaynak tarafından görülen toplam reaktif ihtiyaç azalır. Böylece güç faktörü daha uygun bir seviyeye getirilebilir.',
    dikkat:
        'Amaç sistemi mümkün olduğunca kapasitif hale getirmek değil, uygun çalışma aralığında tutmaktır.',
  ),

  _TeknikBilgi(
    baslik: 'Endüktif Yükler',
    konu: 'Kompanzasyon',
    tanim: 'Akımın gerilimin gerisinde kaldığı yük karakteridir.',
    aciklama:
        'Asenkron motorlar, transformatörler, balastlar ve manyetik alan oluşturan bazı cihazlar endüktif karakter gösterebilir. Bu yüklerin reaktif güç ihtiyacı kompanzasyon sisteminin boyutlandırılmasında dikkate alınır.',
    dikkat: 'Her motor aynı çalışma noktasında aynı reaktif gücü çekmez.',
  ),

  _TeknikBilgi(
    baslik: 'Kapasitif Reaktif Güç',
    konu: 'Kompanzasyon',
    tanim: 'Kapasitif elemanların sisteme sağladığı reaktif güç bileşenidir.',
    aciklama:
        'Kondansatörler kapasitif reaktif güç sağlayarak endüktif yükün reaktif ihtiyacını dengeleyebilir. Bu nedenle kompanzasyon panolarında farklı kvar değerlerinde kondansatör kademeleri kullanılır.',
    dikkat:
        'Gereğinden fazla kapasitif kompanzasyon da sistem açısından uygun değildir.',
  ),

  _TeknikBilgi(
    baslik: 'Kompanzasyon Hesabının Temeli',
    konu: 'Kompanzasyon',
    tanim:
        'İstenen güç faktörüne ulaşmak için gereken yaklaşık kondansatör gücünü açıklar.',
    aciklama:
        'İdeal sinüzoidal ön hesapta Qc = P × (tanφ₁ − tanφ₂) bağıntısı kullanılabilir. Burada P aktif güç, φ₁ mevcut faz açısı ve φ₂ hedef faz açısıdır. Hesap sonucu kondansatör grubunun yaklaşık kvar ihtiyacını verir.',
    dikkat:
        'Bu bağıntı tek başına nihai pano/kondansatör seçimi değildir. Yük profili, kademe yapısı, harmonikler ve gerçek ölçüm sonuçları ayrıca değerlendirilmelidir.',
  ),

  _TeknikBilgi(
    baslik: 'Kompanzasyon Hesabına Sayısal Örnek',
    konu: 'Kompanzasyon',
    tanim:
        'Kondansatör ihtiyacının temel hesap mantığını örnek üzerinden açıklar.',
    aciklama:
        'Örneğin aktif güç P = 100 kW, mevcut cosφ = 0,80 ve hedef cosφ = 0,95 kabul edilirse önce mevcut ve hedef açıların tanjantları belirlenir. Daha sonra Qc = P × (tanφ₁ − tanφ₂) bağıntısıyla yaklaşık kompanzasyon kvar değeri hesaplanır. Sonuç standart kademe değerlerine ve gerçek yük davranışına göre uygun bir kademe kombinasyonuna dönüştürülür.',
    dikkat:
        'Örnekteki değerler eğitim amaçlıdır; gerçek tesis için ölçüm verisi kullanılmalıdır.',
  ),

  _TeknikBilgi(
    baslik: 'Kompanzasyon Kademeleri',
    konu: 'Kompanzasyon',
    tanim:
        'Kondansatörlerin farklı gruplar halinde otomatik devreye alınmasıdır.',
    aciklama:
        'Örneğin 10 + 10 + 20 + 20 kvar gibi kademelerle yük değişimine cevap verilebilir. Küçük kademeler daha hassas kontrol sağlarken kademe sayısı ve pano yapısı da buna göre büyür.',
    dikkat:
        'Kademe yapısı yalnızca toplam kvar değerine göre değil, yükün değişim hızına ve minimum/maksimum çalışma seviyelerine göre düşünülmelidir.',
  ),

  _TeknikBilgi(
    baslik: 'Reaktif Kontrol Rölesi',
    konu: 'Kompanzasyon',
    tanim: 'Kompanzasyon kademelerini otomatik kontrol eden cihazdır.',
    aciklama:
        'Röle, ölçüm sisteminden aldığı akım ve gerilim bilgilerini kullanarak sistemin güç faktörü veya reaktif davranışını değerlendirir ve uygun kondansatör kademelerini devreye alıp çıkarır.',
    dikkat:
        'CT yönü, oranı, faz bağlantısı ve röle ayarları yanlışsa kompanzasyon sistemi ters yönde veya hatalı çalışabilir.',
  ),

  _TeknikBilgi(
    baslik: 'CT Bağlantısının Kompanzasyondaki Önemi',
    konu: 'Kompanzasyon',
    tanim:
        'Akım trafosundan alınan ölçümün kompanzasyon kontrolüne etkisini açıklar.',
    aciklama:
        'Kompanzasyon rölesi tesisin akım davranışını CT üzerinden algılar. CT yanlış faza bağlanırsa, yönü ters olursa veya oran yanlış girilirse röle gerçek reaktif davranışı doğru değerlendiremeyebilir.',
    dikkat:
        'Kompanzasyon devreye alma sırasında CT oranı, yönü, faz ilişkisi ve ölçüm ekranları mutlaka kontrol edilmelidir.',
  ),

  _TeknikBilgi(
    baslik: 'Aşırı Kompanzasyon',
    konu: 'Kompanzasyon',
    tanim: 'Sisteme ihtiyacından fazla kapasitif reaktif güç verilmesidir.',
    aciklama:
        'Endüktif yük azaldığında aynı kondansatör kademeleri devrede kalırsa sistem kapasitif karaktere kayabilir. Bu durum uygun olmayan reaktif çalışma ve ilgili ölçüm/faturalama koşullarında istenmeyen sonuçlar doğurabilir.',
    dikkat:
        'Kompanzasyon hedefi “en yüksek kvar” değil, uygun ve kararlı güç faktörüdür.',
  ),

  _TeknikBilgi(
    baslik: 'Harmonikler ve Kompanzasyon',
    konu: 'Kompanzasyon',
    tanim:
        'Harmoniklerin kondansatörlü kompanzasyon sistemlerine etkisini açıklar.',
    aciklama:
        'Doğrultucu, sürücü, UPS, inverter ve benzeri doğrusal olmayan yükler harmonik akımlar oluşturabilir. Kondansatörler harmoniklerle etkileşime girerek rezonans riskini artırabilir. Bu nedenle harmonik seviyeleri ölçülerek uygun reaktörlü veya farklı kompanzasyon çözümleri değerlendirilmelidir.',
    dikkat:
        'Harmonikli tesislerde sadece kvar hesabına bakılarak kondansatör seçilmemelidir.',
  ),

  _TeknikBilgi(
    baslik: 'Kompanzasyon Panosunda Temel Elemanlar',
    konu: 'Kompanzasyon',
    tanim:
        'Tipik bir kompanzasyon sisteminde bulunan temel elemanları açıklar.',
    aciklama:
        'Kondansatörler, kontaktör veya uygun anahtarlama elemanları, reaktif kontrol rölesi, sigorta/koruma elemanları, gerektiğinde harmonik filtre reaktörleri, bara ve ölçüm sistemi birlikte değerlendirilir.',
    dikkat:
        'Elemanların anma değerleri birbirinden bağımsız değil, sistemin toplam tasarımı içinde belirlenmelidir.',
  ),

  // ==============================================================
  // KORUMA
  // ==============================================================

  _TeknikBilgi(
    baslik: 'Kısa Devre Koruması',
    konu: 'Koruma ve Anahtarlama',
    tanim:
        'Kısa devre akımlarının ekipmana zarar vermesini sınırlayan koruma düzenidir.',
    aciklama:
        'Koruma cihazının anma akımı, açma karakteristiği, kısa devre kesme kapasitesi ve tesisin beklenen kısa devre akımı birlikte değerlendirilir.',
    dikkat: 'Anma akımı ile kesme kapasitesi aynı parametre değildir.',
  ),

  _TeknikBilgi(
    baslik: 'Seçicilik',
    konu: 'Koruma ve Anahtarlama',
    tanim:
        'Arıza durumunda mümkün olduğunca arızaya en yakın koruma elemanının açmasını hedefleyen koordinasyondur.',
    aciklama:
        'Doğru seçicilik, gereksiz geniş enerji kesintilerini azaltır. Zaman-akım eğrileri ve üretici seçicilik tabloları kullanılabilir.',
    dikkat:
        'Sadece sigorta anma akımlarına bakılarak seçicilik garanti edilemez.',
  ),

  _TeknikBilgi(
    baslik: 'Kesici ve Sigorta Arasındaki Temel Fark',
    konu: 'Koruma ve Anahtarlama',
    tanim: 'İki farklı koruma/anahtarlama elemanının temel çalışma farkıdır.',
    aciklama:
        'Sigorta belirli aşırı akım şartlarında eriyerek devreyi açarken kesiciler mekanik olarak açma-kapama yapabilir ve farklı koruma fonksiyonları içerebilir.',
    dikkat: 'Kullanım amacına göre doğru cihaz teknolojisi seçilmelidir.',
  ),

  // ==============================================================
  // ÖLÇÜM VE FATURALAMA
  // ==============================================================

  _TeknikBilgi(
    baslik: 'Aktif Enerji Ölçümü',
    konu: 'Ölçüm ve Faturalama',
    tanim: 'Tüketilen aktif elektrik enerjisinin kWh cinsinden ölçülmesidir.',
    aciklama:
        'Sayaç aktif enerji tüketimini zaman boyunca biriktirir. Faturalandırma hesabında tarife yapısı ve ilgili diğer bedellerle birlikte değerlendirilir.',
    dikkat: 'Birim enerji bedeli ile toplam fatura tutarı aynı şey değildir.',
  ),

  _TeknikBilgi(
    baslik: 'Reaktif Enerji Ölçümü',
    konu: 'Ölçüm ve Faturalama',
    tanim: 'Reaktif enerji tüketiminin ölçülmesidir.',
    aciklama:
        'Sayaçlarda kvarh cinsinden ölçülebilir. İlgili tüketici grubunda ve yürürlükteki tarife koşullarında reaktif bedel/limit değerlendirmesine konu olabilir.',
    dikkat: 'Güncel limitler ve uygulama koşulları mevzuattan doğrulanmalıdır.',
  ),

  _TeknikBilgi(
    baslik: 'Talep Gücü ve Sözleşme Gücü',
    konu: 'Ölçüm ve Faturalama',
    tanim: 'İki farklı güç kavramının ayrımını açıklar.',
    aciklama:
        'Talep gücü tesisin yük davranışı veya hesaplanan ihtiyacıyla ilişkilidir. Sözleşme gücü ise bağlantı/tedarik sözleşmesindeki güç değeridir.',
    dikkat: 'Bu iki kavram aynı anlamda kullanılmamalıdır.',
  ),

  _TeknikBilgi(
    baslik: 'Faturadaki Enerji Bedeli ve Diğer Bedeller',
    konu: 'Ölçüm ve Faturalama',
    tanim:
        'Elektrik faturasında tüketim karşılığının toplam fatura tutarına dönüşüm mantığını açıklar.',
    aciklama:
        'Fatura yalnızca kWh × tek bir enerji fiyatından oluşmayabilir. Tarife yapısına göre enerji bedelinin yanında vergi, fon, dağıtım veya diğer düzenlenmiş bedeller bulunabilir. ESA fatura analizinde bu ayrımların mümkün olduğunca ayrı gösterilmesi hedeflenir.',
    dikkat:
        'Tarife ve mevzuat değişebildiği için kesin fatura hesabında güncel tarife verisi kullanılmalıdır.',
  ),

  // ==============================================================
  // TOPRAKLAMA
  // ==============================================================

  _TeknikBilgi(
    baslik: 'Topraklamanın Amacı',
    konu: 'Topraklama',
    tanim:
        'Arıza durumunda insan ve tesis güvenliğini artırmak için yapılan bağlantı sistemidir.',
    aciklama:
        'Topraklama, hata akımlarının uygun bir yoldan akmasına yardımcı olur ve koruma cihazlarının gerekli koşullarda çalışmasına katkı sağlar.',
    dikkat: 'Topraklama yalnızca tek bir direnç değerine indirgenmemelidir.',
  ),

  _TeknikBilgi(
    baslik: 'Eşpotansiyel Bağlama',
    konu: 'Topraklama',
    tanim:
        'İletken bölümler arasındaki tehlikeli potansiyel farklarını azaltmayı amaçlayan bağlantıdır.',
    aciklama:
        'Metal gövdeler, tesisatın uygun iletken bölümleri ve diğer ilgili metal kısımlar uygun bir eşpotansiyel sistem içerisinde birbirine bağlanabilir.',
    dikkat:
        'Bağlantı kesitleri ve uygulama şekli ilgili tesisat kurallarına göre belirlenmelidir.',
  ),

  _TeknikBilgi(
    baslik: 'PE ve Nötr Ayrımı',
    konu: 'Topraklama',
    tanim: 'Koruma iletkeni ile nötr iletkeninin görev farkını açıklar.',
    aciklama:
        'Nötr normal işletmede yük akımını taşırken PE temel olarak koruma amacı taşır. Sistem tipine göre PEN gibi birleşik iletken yapıları bulunabilir.',
    dikkat:
        'PE ve nötr bağlantıları tesisin sistem tipine göre doğru noktada ve doğru yöntemle yapılmalıdır.',
  ),
];

// ================================================================
// TEKNİK BİLGİLER ANA EKRANI
// ================================================================

class TeknikBilgilerEkrani extends StatefulWidget {
  const TeknikBilgilerEkrani({
    super.key,
  });

  @override
  State<TeknikBilgilerEkrani> createState() => _TeknikBilgilerEkraniState();
}

class _TeknikBilgilerEkraniState extends State<TeknikBilgilerEkrani> {
  final List<String> _konular = [
    'AG / OG Sistemleri',
    'Akım Trafoları',
    'Elektrik Temelleri',
    'GES / Solar',
    'Gerilim Trafoları',
    'Kablolar ve İletkenler',
    'Kompanzasyon',
    'Koruma ve Anahtarlama',
    'Ölçüm ve Faturalama',
    'Topraklama',
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Teknik Bilgiler',
      info: true,
      onInfo: () => bilgiPopup(
        context,
        'Teknik Bilgiler',
        'Elektrik Saha Asistanı içerisindeki elektriksel '
            'temelleri, ekipmanları, hesaplama mantıklarını '
            've saha uygulamalarını açıklayan çevrim dışı '
            'teknik bilgi kütüphanesidir. '
            'Yeni başlayan kullanıcı temel kavramlardan başlayabilir; '
            'deneyimli kullanıcılar ise seçim ve hesaplama mantığına '
            'geçebilir. Kesin teknik uygunluk güncel mevzuat, '
            'standart, şartname, üretici verisi ve proje koşulları '
            'ile doğrulanmalıdır.',
      ),
      body: ScrollBody(
        children: [
          _bilgiKarti(
            context,
            baslik: 'Teknik Terimler Sözlüğü',
            ikon: Icons.menu_book_outlined,
            aciklama: 'Elektriksel kısaltmalar, semboller, teknik terimler '
                've hızlı başvuru açıklamaları.',
            onTap: () {
              Navigator.of(context).push(
                materialRoute(
                  const TeknikTerimlerSozluguEkrani(),
                ),
              );
            },
          ),
          const SizedBox(height: 2),
          ..._konular.map(
            (konu) => _konuKarti(
              context,
              konu,
            ),
          ),
          const SizedBox(height: 4),
          AdviceCard(
            title: 'Teknik kullanım seviyesi',
            text: 'Bu kütüphane özellikle elektrik alanına yeni başlayan '
                'kullanıcının temel kavramları öğrenebilmesi ve saha '
                'deneyimi olan kullanıcının hesaplama/seçim mantığını '
                'daha iyi anlayabilmesi amacıyla hazırlanmıştır. '
                'Bilgi kartları nihai proje hesabının veya mevzuat '
                'uygunluk raporunun yerine geçmez.',
          ),
        ],
      ),
    );
  }

  Widget _bilgiKarti(
    BuildContext context, {
    required String baslik,
    required IconData ikon,
    required String aciklama,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: cCard(),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Row(
            children: [
              Icon(
                ikon,
                color: cIcon(),
                size: 25,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      baslik,
                      style: TextStyle(
                        color: cText(),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      aciklama,
                      style: TextStyle(
                        color: cText().withValues(
                          alpha: .72,
                        ),
                        fontSize: 11.5,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: cText().withValues(
                  alpha: .55,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _konuKarti(
    BuildContext context,
    String konu,
  ) {
    final adet = _teknikBilgiler.where((e) => e.konu == konu).length;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: cCard(),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.of(context).push(
            materialRoute(
              TeknikKonuEkrani(
                konu: konu,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 11,
          ),
          child: Row(
            children: [
              Icon(
                _konuIkonu(konu),
                color: cIcon(),
                size: 22,
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  konu,
                  style: TextStyle(
                    color: cText(),
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '$adet konu',
                style: TextStyle(
                  color: cText().withValues(
                    alpha: .58,
                  ),
                  fontSize: 10.5,
                ),
              ),
              const SizedBox(width: 5),
              Icon(
                Icons.chevron_right,
                color: cText().withValues(
                  alpha: .5,
                ),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _konuIkonu(String konu) {
    switch (konu) {
      case 'AG / OG Sistemleri':
        return Icons.account_tree_outlined;

      case 'Akım Trafoları':
        return Icons.swap_horiz_outlined;

      case 'Elektrik Temelleri':
        return Icons.electrical_services_outlined;

      case 'GES / Solar':
        return Icons.solar_power_outlined;

      case 'Gerilim Trafoları':
        return Icons.bolt_outlined;

      case 'Kablolar ve İletkenler':
        return Icons.cable_outlined;

      case 'Kompanzasyon':
        return Icons.battery_charging_full_outlined;

      case 'Koruma ve Anahtarlama':
        return Icons.security_outlined;

      case 'Ölçüm ve Faturalama':
        return Icons.receipt_long_outlined;

      case 'Topraklama':
        return Icons.foundation_outlined;

      default:
        return Icons.article_outlined;
    }
  }
}

// ================================================================
// TEKNİK KONU EKRANI
// ================================================================

class TeknikKonuEkrani extends StatelessWidget {
  final String konu;

  const TeknikKonuEkrani({
    super.key,
    required this.konu,
  });

  @override
  Widget build(BuildContext context) {
    final bilgiler = _teknikBilgiler.where((e) => e.konu == konu).toList();

    return AppScaffold(
      title: konu,
      info: true,
      onInfo: () => bilgiPopup(
        context,
        konu,
        'Bu bölüm $konu konusu ile ilgili '
        'temel ve orta seviye teknik bilgileri içerir. '
        'Kartları açarak tanım, teknik açıklama ve dikkat '
        'edilmesi gereken noktaları inceleyebilirsiniz.',
      ),
      body: ScrollBody(
        children: [
          ...bilgiler.map(
            (bilgi) => _TeknikBilgiAcilirKart(
              bilgi: bilgi,
            ),
          ),
          const SizedBox(height: 4),
          AdviceCard(
            title: 'Uygulama notu',
            text: 'Buradaki açıklamalar teknik kavramları ve '
                'hesaplama mantığını anlamaya yardımcı olmak '
                'amacıyla hazırlanmıştır. Nihai seçim ve uygunluk '
                'değerlendirmesinde güncel standart, mevzuat, '
                'şartname, üretici teknik verisi ve proje koşulları '
                'esas alınmalıdır.',
          ),
        ],
      ),
    );
  }
}

// ================================================================
// TEKNİK BİLGİ AÇILIR KART
// ================================================================

class _TeknikBilgiAcilirKart extends StatefulWidget {
  final _TeknikBilgi bilgi;

  const _TeknikBilgiAcilirKart({
    required this.bilgi,
  });

  @override
  State<_TeknikBilgiAcilirKart> createState() => _TeknikBilgiAcilirKartState();
}

class _TeknikBilgiAcilirKartState extends State<_TeknikBilgiAcilirKart> {
  bool acik = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cCard(),
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          setState(() {
            acik = !acik;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.bilgi.baslik,
                      style: TextStyle(
                        color: cText(),
                        fontWeight: FontWeight.bold,
                        fontSize: 13.5,
                      ),
                    ),
                  ),
                  Icon(
                    acik ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: cIcon(),
                  ),
                ],
              ),
              if (acik) ...[
                const SizedBox(height: 10),
                const Divider(
                  height: 1,
                ),
                const SizedBox(height: 10),
                _etiketliMetin(
                  'Tanım',
                  widget.bilgi.tanim,
                ),
                const SizedBox(height: 9),
                _etiketliMetin(
                  'Teknik açıklama',
                  widget.bilgi.aciklama,
                ),
                if (widget.bilgi.dikkat != null) ...[
                  const SizedBox(height: 9),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.orange.shade700,
                      ),
                    ),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Dikkat\n',
                            style: TextStyle(
                              color: Colors.orange.shade800,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: widget.bilgi.dikkat!,
                            style: TextStyle(
                              color: cText(),
                              fontSize: 11.5,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _etiketliMetin(
    String baslik,
    String metin,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          baslik,
          style: TextStyle(
            color: cIcon(),
            fontWeight: FontWeight.bold,
            fontSize: 11.5,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          metin,
          style: TextStyle(
            color: cText(),
            fontSize: 11.5,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

// ================================================================
// TEKNİK TERİMLER SÖZLÜĞÜ
// ================================================================

class TeknikTerimlerSozluguEkrani extends StatefulWidget {
  const TeknikTerimlerSozluguEkrani({
    super.key,
  });

  @override
  State<TeknikTerimlerSozluguEkrani> createState() =>
      _TeknikTerimlerSozluguEkraniState();
}

class _TeknikTerimlerSozluguEkraniState
    extends State<TeknikTerimlerSozluguEkrani> {
  final TextEditingController arama = TextEditingController();

  String siralama = 'A-Z';

  @override
  void dispose() {
    arama.dispose();
    super.dispose();
  }

  List<_TeknikTerim> get filtrelenmis {
    final q = arama.text.trim().toLowerCase();

    final liste = _teknikTerimler.where((terim) {
      if (q.isEmpty) {
        return true;
      }

      return terim.terim.toLowerCase().contains(q) ||
          terim.konu.toLowerCase().contains(q) ||
          terim.aciklama.toLowerCase().contains(q) ||
          (terim.ayrinti ?? '').toLowerCase().contains(q);
    }).toList();

    if (siralama == 'A-Z') {
      liste.sort(
        (a, b) => a.terim.toLowerCase().compareTo(
              b.terim.toLowerCase(),
            ),
      );
    } else {
      liste.sort(
        (a, b) {
          final konu = a.konu.compareTo(b.konu);

          if (konu != 0) {
            return konu;
          }

          return a.terim.toLowerCase().compareTo(
                b.terim.toLowerCase(),
              );
        },
      );
    }

    return liste;
  }

  @override
  Widget build(BuildContext context) {
    final liste = filtrelenmis;

    return AppScaffold(
      title: 'Teknik Terimler Sözlüğü',
      info: true,
      onInfo: () => bilgiPopup(
        context,
        'Teknik Terimler Sözlüğü',
        'Elektrik Saha Asistanı içerisinde kullanılan '
            'teknik terimlerin, sembollerin ve kısaltmaların '
            'hızlı başvuru açıklamalarını içerir. '
            'Arama alanı terim, konu ve açıklama içerisinde çalışır.',
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              14,
              14,
              14,
              6,
            ),
            child: TextField(
              controller: arama,
              onChanged: (_) => setState(() {}),
              style: TextStyle(
                color: cText(),
                fontSize: 13,
              ),
              decoration: customInputDec(
                'Terim veya açıklama ara...',
              ).copyWith(
                prefixIcon: Icon(
                  Icons.search,
                  color: cIcon(),
                ),
                suffixIcon: arama.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Temizle',
                        icon: Icon(
                          Icons.clear,
                          color: cText().withValues(
                            alpha: .65,
                          ),
                        ),
                        onPressed: () {
                          arama.clear();
                          setState(() {});
                        },
                      ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              14,
              2,
              14,
              6,
            ),
            child: Row(
              children: [
                Text(
                  'Sıralama',
                  style: TextStyle(
                    color: cText(),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: siralama,
                    isDense: true,
                    dropdownColor: cInputBg(),
                    style: TextStyle(
                      color: cText(),
                      fontSize: 12,
                    ),
                    decoration: customInputDec(
                      'Sıralama',
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'A-Z',
                        child: Text('A-Z'),
                      ),
                      DropdownMenuItem(
                        value: 'Konu Kapsamı',
                        child: Text('Konu Kapsamı'),
                      ),
                    ],
                    onChanged: (v) {
                      if (v == null) {
                        return;
                      }

                      setState(() {
                        siralama = v;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: liste.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Aradığınız terim bulunamadı.\n'
                        'Terimi farklı bir yazımla deneyin.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: cText().withValues(
                            alpha: .7,
                          ),
                          height: 1.4,
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      14,
                      4,
                      14,
                      14,
                    ),
                    itemCount: liste.length,
                    itemBuilder: (context, index) {
                      final terim = liste[index];

                      final bool yeniKonu = siralama == 'Konu Kapsamı' &&
                          (index == 0 || liste[index - 1].konu != terim.konu);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (yeniKonu)
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 9,
                                bottom: 6,
                              ),
                              child: Text(
                                terim.konu,
                                style: TextStyle(
                                  color: cIcon(),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          _TerimKarti(
                            terim: terim,
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// TERİM KARTI
// ================================================================

class _TerimKarti extends StatelessWidget {
  final _TeknikTerim terim;

  const _TerimKarti({
    required this.terim,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cCard(),
      margin: const EdgeInsets.only(bottom: 7),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          _terimPopup(
            context,
            terim,
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      terim.terim,
                      style: TextStyle(
                        color: cText(),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      terim.aciklama,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: cText().withValues(
                          alpha: .72,
                        ),
                        fontSize: 11,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      terim.konu,
                      style: TextStyle(
                        color: cIcon(),
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                color: cText().withValues(
                  alpha: .45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _terimPopup(
    BuildContext context,
    _TeknikTerim terim,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: cCard(),
          title: Text(
            terim.terim,
            style: TextStyle(
              color: cText(),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  terim.konu,
                  style: TextStyle(
                    color: cIcon(),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  terim.aciklama,
                  style: TextStyle(
                    color: cText(),
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
                if (terim.ayrinti != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    terim.ayrinti!,
                    style: TextStyle(
                      color: cText().withValues(
                        alpha: .78,
                      ),
                      fontSize: 11.5,
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(
                dialogContext,
              ).pop(),
              child: Text(
                'KAPAT',
                style: TextStyle(
                  color: cIcon(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
