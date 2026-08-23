part of 'main.dart';

const List<EsaTeknikKonu> esaKabloHatBilgileri = [
  EsaTeknikKonu(
    id: 'kha', kategori: 'Kablo & Hatlar', baslik: 'Akım taşıma kapasitesi',
    ozet: 'Kablonun belirli koşullarda taşıyabileceği sürekli akımın değerlendirmesidir.', nedir: 'Kesit, malzeme, yalıtım, ortam, döşeme ve gruplanma ile ilişkilidir.', nasil: 'İlgili tablo ve düzeltme katsayıları kullanılır.',
    saha: 'Aynı kesit farklı döşemede farklı kapasiteye sahip olabilir.', dikkat: 'Tek bir amper değerini bütün koşullara uygulamayın.', ilgiliAraclar: 'Kablo Kapasitesi, Hat Analizi',
    kaynak: 'IEC 60364-5-52; üretici verileri',
  ),
  EsaTeknikKonu(
    id: 'nyy', kategori: 'Kablo & Hatlar', baslik: 'NYY',
    ozet: 'Bakır iletkenli PVC yalıtımlı güç kablosu ailesidir.', nedir: 'Sabit tesislerde kullanılan yaygın güç kablolarındandır.', nasil: 'Kesit; kapasite, düşüm, kısa devre ve döşeme koşullarıyla seçilir.',
    saha: 'Toprak ve hava koşulları ayrı değerlendirilir.', dikkat: 'Kablo tipi tek başına kapasiteyi belirlemez.', ilgiliAraclar: 'Hat Analizi',
    kaynak: 'İlgili TS/EN kablo standardı; üretici verileri',
  ),
  EsaTeknikKonu(
    id: 'nayy', kategori: 'Kablo & Hatlar', baslik: 'NAYY',
    ozet: 'Alüminyum iletkenli PVC yalıtımlı güç kablosu ailesidir.', nedir: 'Alüminyum iletken nedeniyle elektriksel ve mekanik özellikleri farklıdır.', nasil: 'Kesit ve bağlantı ekipmanı birlikte seçilir.',
    saha: 'Pabuç ve klemens uygunluğu önemlidir.', dikkat: 'Bakır-alüminyum bağlantısını rastgele yapmayın.', ilgiliAraclar: 'Hat Analizi',
    kaynak: 'İlgili TS/EN kablo standardı; üretici verileri',
  ),
  EsaTeknikKonu(
    id: 'paralel', kategori: 'Kablo & Hatlar', baslik: 'Paralel kablo',
    ozet: 'Aynı devrenin akımını paylaşan birden fazla kablodur.', nedir: 'Eşdeğer empedansla akım paylaşımı amaçlanır.', nasil: 'Aynı tip, kesit, uzunluk ve döşeme koşulları tercih edilir.',
    saha: 'Büyük güç dağıtımında uygulanabilir.', dikkat: 'Farklı kesit ve çok farklı uzunlukları rastgele paralelleştirmeyin.', ilgiliAraclar: 'Pano, Hat Analizi',
    kaynak: 'IEC 60364-5-52',
  ),
];
