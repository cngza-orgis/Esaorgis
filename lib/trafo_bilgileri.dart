part of 'main.dart';

const List<EsaTeknikKonu> esaTrafoBilgileri = [
  EsaTeknikKonu(
    id: 'trafo-gucu', kategori: 'Trafo', baslik: 'Trafo anma gücü',
    ozet: 'Transformatörün görünür güç kapasitesidir.', nedir: 'Genellikle kVA/MVA ile ifade edilir.', nasil: 'Yük profili, soğutma ve gelecekteki büyüme dikkate alınır.',
    saha: 'Trafo seçiminin temel parametrelerindendir.', dikkat: 'kVA doğrudan kW değildir; güç faktörü ayrıca değerlendirilir.', ilgiliAraclar: 'Trafo Araçları',
    kaynak: 'IEC 60076 serisi',
  ),
  EsaTeknikKonu(
    id: 'trafo-akim', kategori: 'Trafo', baslik: 'Trafo akımı',
    ozet: 'Trafo gücü ve geriliminden türetilen nominal akımdır.', nedir: 'AG ve OG taraflarında farklı nominal akımlar bulunur.', nasil: 'Görünür güç ve gerilim ilişkisi kullanılır.',
    saha: 'Kablo, bara ve kesici seçiminde kullanılır.', dikkat: 'Trafo oranı ve bağlantı grubu dikkate alınmalıdır.', ilgiliAraclar: 'Trafo, Pano',
    kaynak: 'IEC 60076 serisi',
  ),
  EsaTeknikKonu(
    id: 'kisa-devre-empedansi', kategori: 'Trafo', baslik: 'Kısa devre empedansı',
    ozet: 'Trafo kısa devre davranışını etkileyen parametredir.', nedir: 'Kısa devre akımı ve gerilim regülasyonu değerlendirmesine katkı verir.', nasil: 'Etiket değeri şebeke empedansıyla birlikte değerlendirilir.',
    saha: 'Kesici kesme kapasitesi açısından önemlidir.', dikkat: 'Yalnızca trafo kVA’sına bakarak kısa devre seviyesi belirlenmez.', ilgiliAraclar: 'Kısa Devre, Pano',
    kaynak: 'IEC 60076 serisi',
  ),
];
