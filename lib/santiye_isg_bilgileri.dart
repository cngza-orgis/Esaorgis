part of 'main.dart';

const List<EsaTeknikKonu> esaSantiyeIsgBilgileri = [
  EsaTeknikKonu(
    id: 'enerji-kesme', kategori: 'Şantiye & İSG', baslik: 'Enerji kesme',
    ozet: 'Çalışma öncesi enerjinin güvenli şekilde kesilmesi ve yeniden enerjilenmenin önlenmesidir.', nedir: 'Ayırma ve güvenli çalışma prosedürünün parçasıdır.', nasil: 'Kilitleme/etiketleme, gerilimsizlik doğrulaması ve gerekiyorsa topraklama uygulanır.',
    saha: 'Şantiyede yalnızca şalteri kapatmak yeterli kabul edilmemelidir.', dikkat: 'Yetki ve prosedür olmadan müdahale etmeyin.', ilgiliAraclar: 'Şantiye',
    kaynak: 'İlgili İSG mevzuatı; IEC 60364-4-41',
  ),
  EsaTeknikKonu(
    id: 'kkd', kategori: 'Şantiye & İSG', baslik: 'KKD',
    ozet: 'Kişisel koruyucu donanımdır.', nedir: 'Elektriksel risklere göre uygun koruyucu ekipmanı kapsar.', nasil: 'Gerilim, ark riski ve çalışma yöntemine göre seçilir.',
    saha: 'KKD mühendislik önlemlerinin yerine geçmez.', dikkat: 'Uygunluk sınıfı ve periyodik kontrol şartları doğrulanmalıdır.', ilgiliAraclar: 'Şantiye',
    kaynak: 'İlgili İSG mevzuatı; üretici KKD verileri',
  ),
  EsaTeknikKonu(
    id: 'gerilimsizlik', kategori: 'Şantiye & İSG', baslik: 'Gerilimsizlik kontrolü',
    ozet: 'Çalışma öncesi gerilim bulunmadığının uygun cihazla doğrulanmasıdır.', nedir: 'Güvenli ölçüm prosedürünün bir parçasıdır.', nasil: 'Uygun cihaz, ölçüm noktası ve test yöntemi belirlenir.',
    saha: 'Ölçüm cihazının uygunluğu ve sağlamlığı önemlidir.', dikkat: 'Tek bir kontrol adımına güvenmeyin.', ilgiliAraclar: 'Şantiye',
    kaynak: 'IEC 61010 ailesi; ilgili İSG prosedürleri',
  ),
];
