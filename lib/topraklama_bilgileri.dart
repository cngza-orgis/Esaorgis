part of 'main.dart';

const List<EsaTeknikKonu> esaTopraklamaBilgileri = [
  EsaTeknikKonu(
    id: 'pe', kategori: 'Topraklama', baslik: 'PE',
    ozet: 'Koruma iletkenidir.', nedir: 'Açıkta kalan iletken bölümlerin koruma düzenine bağlanmasını sağlar.', nasil: 'Sistem tipi ve ilgili kurallara göre boyutlandırılır.',
    saha: 'Arıza yolunun sürekliliği önemlidir.', dikkat: 'PE ile N gelişigüzel birleştirilmemelidir.', ilgiliAraclar: 'Topraklama, Pano',
    kaynak: 'IEC 60364 serisi',
  ),
  EsaTeknikKonu(
    id: 'pen', kategori: 'Topraklama', baslik: 'PEN',
    ozet: 'Koruma ve nötr işlevlerini birlikte taşıyan iletkendir.', nedir: 'Belirli TN düzenlerinde kullanılır.', nasil: 'Ayrılma noktası ve kesit ilgili kurallara göre belirlenir.',
    saha: 'Yanlış ayrım ciddi risk oluşturabilir.', dikkat: 'Tesis sistemi bilinmeden bağlantı önerisi verilmemelidir.', ilgiliAraclar: 'Topraklama',
    kaynak: 'IEC 60364 serisi',
  ),
  EsaTeknikKonu(
    id: 'tn-tt-it', kategori: 'Topraklama', baslik: 'TN / TT / IT',
    ozet: 'Topraklama sistemlerinin temel sınıflandırmasıdır.', nedir: 'Kaynak ve tesisin toprağa bağlantı biçimleriyle ayrılır.', nasil: 'Koruma düzeni sistem tipine göre belirlenir.',
    saha: 'RCD ve arıza akımı davranışı sistemden etkilenir.', dikkat: 'Sistem tipi bilinmeden koruma seçimi yapılmamalıdır.', ilgiliAraclar: 'Topraklama',
    kaynak: 'IEC 60364-4-41',
  ),
  EsaTeknikKonu(
    id: 'espotansiyel', kategori: 'Topraklama', baslik: 'Eşpotansiyel kuşaklama',
    ozet: 'İletken bölümler arasındaki tehlikeli potansiyel farkları azaltmaya yönelik bağlantıdır.', nedir: 'Metal kısımlar uygun koruma sistemine dahil edilir.', nasil: 'Tesisin yapısına göre ana ve tamamlayıcı kuşaklama uygulanabilir.',
    saha: 'Pano, metal yapı ve diğer iletken bölümler önemlidir.', dikkat: 'Rastgele metal bağlantısı yerine tasarlanmış sistem kullanılmalıdır.', ilgiliAraclar: 'Topraklama',
    kaynak: 'IEC 60364 serisi',
  ),
];
