part of 'main.dart';

const List<EsaTeknikKonu> esaKorumaBilgileri = [
  EsaTeknikKonu(
    id: 'mcb', kategori: 'Koruma & Sigorta', baslik: 'MCB',
    ozet: 'Minyatür devre kesicidir.', nedir: 'Aşırı yük ve kısa devre koruması sağlar.', nasil: 'Anma akımı, karakteristik ve kesme kapasitesi birlikte seçilir.',
    saha: 'Son devrelerde yaygındır.', dikkat: 'Kablo kapasitesi ve kısa devre seviyesi ayrıca kontrol edilmelidir.', ilgiliAraclar: 'Sigorta, Pano',
    kaynak: 'IEC 60898; IEC 60364',
  ),
  EsaTeknikKonu(
    id: 'mccb', kategori: 'Koruma & Sigorta', baslik: 'MCCB',
    ozet: 'Kompakt tip devre kesicidir.', nedir: 'Daha yüksek akımlarda ve ayarlanabilir korumada kullanılır.', nasil: 'Anma akımı, kesme kapasitesi ve açma ünitesi değerlendirilir.',
    saha: 'Ana dağıtım ve büyük çıkışlarda yaygındır.', dikkat: 'Kesme kapasitesi kısa devre seviyesinin altında olmamalıdır.', ilgiliAraclar: 'Pano, Sigorta',
    kaynak: 'IEC 60947-2',
  ),
  EsaTeknikKonu(
    id: 'rcd', kategori: 'Koruma & Sigorta', baslik: 'RCD',
    ozet: 'Artık/kaçak akımı algılayan koruma cihazı ailesidir.', nedir: 'Faz-nötr akım dengesizliğini algılayabilir.', nasil: 'Tip, hassasiyet, gecikme ve kutup sayısı seçilir.',
    saha: 'Kaçak akım korumasında kullanılır.', dikkat: 'Topraklama ve diğer koruma düzenleriyle birlikte değerlendirilmelidir.', ilgiliAraclar: 'Pano, Topraklama',
    kaynak: 'IEC 60364; IEC 61008/61009 ailesi',
  ),
  EsaTeknikKonu(
    id: 'selektivite', kategori: 'Koruma & Sigorta', baslik: 'Selektivite',
    ozet: 'Arızaya en yakın korumanın önce açmasını amaçlayan koordinasyondur.', nedir: 'Enerji sürekliliğini artırır.', nasil: 'Zaman-akım eğrileri ve üretici tabloları karşılaştırılır.',
    saha: 'Alt devre arızasında üst panonun gereksiz açmasını önlemeye yardımcı olur.', dikkat: 'Amper değerlerinin sıralı olması tek başına selektivite değildir.', ilgiliAraclar: 'Pano, Sigorta',
    kaynak: 'IEC 60947-2; üretici tabloları',
  ),
];
