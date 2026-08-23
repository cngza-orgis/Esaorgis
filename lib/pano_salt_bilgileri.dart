part of 'main.dart';

const List<EsaTeknikKonu> esaPanoSaltBilgileri = [
  EsaTeknikKonu(
    id: 'bara', kategori: 'Pano & Şalt', baslik: 'Bara',
    ozet: 'Pano içinde enerjiyi dağıtan iletken sistemidir.', nedir: 'Yüksek akımları taşımak için boyutlandırılır.', nasil: 'Akım, sıcaklık, izolasyon ve kısa devre dayanımı birlikte değerlendirilir.',
    saha: 'Bağlantı torku ve mekanik destek önemlidir.', dikkat: 'Nominal akım kısa devre dayanımını tek başına göstermez.', ilgiliAraclar: 'Pano',
    kaynak: 'IEC 61439 serisi',
  ),
  EsaTeknikKonu(
    id: 'og-hucre', kategori: 'Pano & Şalt', baslik: 'OG hücre',
    ozet: 'OG şalt ve dağıtım fonksiyonlarını bir araya getiren hücresel yapıdır.', nedir: 'Kesici, ayırıcı, ölçü ve koruma elemanları içerebilir.', nasil: 'Tek hat, kısa devre ve işletme senaryosu birlikte değerlendirilir.',
    saha: 'Kilitleme ve topraklama düzeni kritiktir.', dikkat: 'Nominal gerilim tek seçim kriteri değildir.', ilgiliAraclar: 'OG Hücre',
    kaynak: 'IEC 62271 serisi; TEDAŞ/dağıtım şartnameleri',
  ),
  EsaTeknikKonu(
    id: 'kesici', kategori: 'Pano & Şalt', baslik: 'Kesici',
    ozet: 'Normal işletmede açıp kapatan ve arıza akımını kesebilen cihazdır.', nedir: 'Anma gerilimi, akımı ve kesme kapasitesi temel parametrelerdir.', nasil: 'Koruma ve açma düzeniyle koordineli çalışır.',
    saha: 'Bakım ve güvenli işletme için kilitlemeler önemlidir.', dikkat: 'Kesme kapasitesi kısa devre seviyesinin altında seçilmemelidir.', ilgiliAraclar: 'Pano, OG Hücre',
    kaynak: 'IEC 60947-2; IEC 62271',
  ),
];
