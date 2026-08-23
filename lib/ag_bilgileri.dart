part of 'main.dart';

const List<EsaTeknikKonu> esaAgBilgileri = [
  EsaTeknikKonu(
    id: 'ag', kategori: 'AG Sistemleri', baslik: 'Alçak gerilim',
    ozet: 'Alçak gerilim tesislerinin genel sınıfıdır.', nedir: 'Besleme, dağıtım ve son devrelerin gerilim seviyesini tanımlar.', nasil: 'Tesis gerilimi, faz sayısı, yük ve koruma düzeni birlikte değerlendirilir.',
    saha: 'Pano, kablo ve yüklerin aynı sistemle uyumu kontrol edilir.', dikkat: 'Gerilim seviyesini yalnızca cihaz etiketinden varsaymayın.', ilgiliAraclar: 'Hat Analizi, Pano',
    kaynak: 'IEC 60364 serisi',
  ),
  EsaTeknikKonu(
    id: 'mono-tri', kategori: 'AG Sistemleri', baslik: 'Monofaze / trifaze',
    ozet: 'Faz sayısı akım hesabını ve kablo düzenini etkiler.', nedir: 'Monofaze tek fazlı; trifaze üç fazlı sistemdir.', nasil: 'Güç bağıntısı sistem tipine göre seçilir.',
    saha: 'Motor ve büyük yüklerde trifaze; uygun küçük yüklerde monofaze kullanılabilir.', dikkat: 'Kablo damar yapısı ve hesap formülü sistem tipine göre değişir.', ilgiliAraclar: 'Hat Analizi, Sigorta',
    kaynak: 'IEC 60364 serisi',
  ),
  EsaTeknikKonu(
    id: 'gerilim-dusumu', kategori: 'AG Sistemleri', baslik: 'Gerilim düşümü',
    ozet: 'Hat empedansı nedeniyle yük ucundaki gerilim azalmasıdır.', nedir: 'Direnç ve reaktans kaynaklı gerilim kaybıdır.', nasil: 'Kesit, uzunluk, akım, cosφ, malzeme ve döşeme koşulları değerlendirilir.',
    saha: 'Uzun motor ve pompa hatlarında önemlidir.', dikkat: 'Sadece kesiti büyütmek yerine gerçek hat koşullarını hesaplayın.', ilgiliAraclar: 'Hat Analizi, Gerilim Düşümü',
    kaynak: 'IEC 60364-5-52',
  ),
  EsaTeknikKonu(
    id: 'koruma-koordinasyonu', kategori: 'AG Sistemleri', baslik: 'Koruma koordinasyonu',
    ozet: 'Kablo, yük ve koruma cihazının birlikte değerlendirilmesidir.', nedir: 'Aşırı yük ve kısa devre koşullarında güvenli çalışmayı amaçlar.', nasil: 'Yük akımı, kablo kapasitesi, koruma eğrisi ve kısa devre seviyesi incelenir.',
    saha: 'Sahada yalnızca amper değerine bakılarak cihaz seçilmemelidir.', dikkat: 'Selektivite ve kesme kapasitesi ayrıca kontrol edilmelidir.', ilgiliAraclar: 'Sigorta, Pano',
    kaynak: 'IEC 60364; IEC 60947-2',
  ),
];
