part of 'main.dart';

const List<EsaTeknikKonu> esaKompanzasyonBilgileri = [
  EsaTeknikKonu(
    id: 'p-q-s', kategori: 'Kompanzasyon', baslik: 'P, Q ve S',
    ozet: 'Aktif, reaktif ve görünür gücü ifade eder.', nedir: 'P işe dönüşen; Q reaktif; S toplam görünür güç büyüklüğüdür.', nasil: 'Güç üçgeni ve cosφ ilişkisi kullanılır.',
    saha: 'Kompanzasyon ihtiyacının temelidir.', dikkat: 'Şebeke ve yük özellikleri bilinmeden tek değer varsaymayın.', ilgiliAraclar: 'Kompanzasyon',
    kaynak: 'İlgili tesis ve dağıtım kuralları',
  ),
  EsaTeknikKonu(
    id: 'cosphi', kategori: 'Kompanzasyon', baslik: 'cosφ',
    ozet: 'Aktif gücün görünür güce oranıdır.', nedir: 'Yükün güç faktörünü ifade eder.', nasil: 'Motor ve trafo gibi indüktif yüklerde reaktif güçle birlikte değerlendirilir.',
    saha: 'Düşük cosφ daha yüksek akıma yol açabilir.', dikkat: 'cosφ harmonik seviyesini tek başına göstermez.', ilgiliAraclar: 'Kompanzasyon, Sigorta',
    kaynak: 'İlgili tesis ve dağıtım kuralları',
  ),
  EsaTeknikKonu(
    id: 'harmonik', kategori: 'Kompanzasyon', baslik: 'Harmonik',
    ozet: 'Temel frekansın katlarında oluşan gerilim/akım bileşenleridir.', nedir: 'Doğrusal olmayan yükler harmonik üretebilir.', nasil: 'Ölçüm ve spektrum analiziyle değerlendirilir.',
    saha: 'Kompanzasyon kondansatörlerinin seçimini etkileyebilir.', dikkat: 'Sadece cosφ ölçmek güç kalitesi analizi değildir.', ilgiliAraclar: 'Kompanzasyon',
    kaynak: 'IEC 61000 serisi',
  ),
];
