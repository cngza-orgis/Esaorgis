part of 'main.dart';

const List<EsaTeknikKonu> esaOgBilgileri = [
  EsaTeknikKonu(
    id: 'og-hucre', kategori: 'OG Sistemleri', baslik: 'OG hücre',
    ozet: 'OG dağıtımda kesme, ayırma, ölçme ve koruma işlevlerini barındırır.', nedir: 'Hücre konfigürasyonuna göre kesici, ayırıcı, topraklama ve ölçü elemanları içerir.', nasil: 'Gerilim, kısa devre ve işletme şeması birlikte değerlendirilir.',
    saha: 'Kilitleme ve topraklama işletme güvenliğinin parçasıdır.', dikkat: 'Sadece nominal gerilime göre seçim yapılmaz.', ilgiliAraclar: 'OG Hücre, Pano',
    kaynak: 'IEC 62271 serisi; TEDAŞ/dağıtım şartnameleri',
  ),
  EsaTeknikKonu(
    id: 'ct', kategori: 'OG Sistemleri', baslik: 'Akım trafosu',
    ozet: 'Yüksek akımı ölçü ve koruma seviyesine dönüştürür.', nedir: 'Primer akımla orantılı sekonder akım üretir.', nasil: 'Oran, sınıf, burden ve doyma davranışı seçilir.',
    saha: 'Sekonder bağlantılar güvenli yapılmalıdır.', dikkat: 'CT sekonderinin açık bırakılması tehlikelidir.', ilgiliAraclar: 'Ölçü Trafo',
    kaynak: 'IEC 61869 serisi',
  ),
  EsaTeknikKonu(
    id: 'vt', kategori: 'OG Sistemleri', baslik: 'Gerilim trafosu',
    ozet: 'Yüksek gerilimi ölçü ve koruma seviyesine dönüştürür.', nedir: 'Primer gerilimle orantılı sekonder gerilim sağlar.', nasil: 'Oran, sınıf, burden ve bağlantı grubu seçilir.',
    saha: 'Faz bağlantıları doğru olmalıdır.', dikkat: 'Sigorta ve koruma düzeni üretici/proje şemasına göre doğrulanmalıdır.', ilgiliAraclar: 'OG Hücre',
    kaynak: 'IEC 61869 serisi',
  ),
];
