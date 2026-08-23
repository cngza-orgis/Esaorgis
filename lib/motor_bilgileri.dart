part of 'main.dart';

const List<EsaTeknikKonu> esaMotorBilgileri = [
  EsaTeknikKonu(
    id: 'motor-akim', kategori: 'Motorlar', baslik: 'Motor nominal akımı',
    ozet: 'Motorun anma koşullarındaki akımıdır.', nedir: 'Gerilim, güç, verim ve güç faktörüne bağlıdır.', nasil: 'Öncelikle motor etiketindeki nominal akım kullanılır.',
    saha: 'Koruma ayarlarının temel girdilerindendir.', dikkat: 'Yalnızca kW değerinden kesin akım varsaymayın.', ilgiliAraclar: 'Motor Koruma',
    kaynak: 'IEC 60034 serisi; üretici etiketi',
  ),
  EsaTeknikKonu(
    id: 'yildiz-ucgen', kategori: 'Motorlar', baslik: 'Yıldız-üçgen yol verme',
    ozet: 'Uygun motorlarda kalkış akımını azaltan yöntemdir.', nedir: 'Kalkışta yıldız, çalışma sırasında üçgen bağlantı kullanılır.', nasil: 'Motor etiketi ve şebeke gerilimi uygun olmalıdır.',
    saha: 'Pompa ve uygun motor uygulamalarında kullanılabilir.', dikkat: 'Her motor yıldız-üçgen çalıştırılamaz.', ilgiliAraclar: 'Motor Koruma',
    kaynak: 'IEC 60034; üretici bağlantı şeması',
  ),
  EsaTeknikKonu(
    id: 'soft-starter', kategori: 'Motorlar', baslik: 'Soft starter',
    ozet: 'Motor kalkışını kontrollü gerilimle yumuşatan cihazdır.', nedir: 'Kalkış akımını ve mekanik darbeyi azaltabilir.', nasil: 'Motor akımı, yük momenti ve rampalar seçilir.',
    saha: 'Pompa ve fanlarda faydalı olabilir.', dikkat: 'Frekans kontrolü yapmaz; hız kontrolü için farklı sürücü gerekir.', ilgiliAraclar: 'Motor Koruma',
    kaynak: 'IEC 60947-4-2',
  ),
  EsaTeknikKonu(
    id: 'vfd', kategori: 'Motorlar', baslik: 'VFD',
    ozet: 'Değişken frekanslı motor sürücüsüdür.', nedir: 'Motor hızını frekans ve gerilim kontrolüyle yönetir.', nasil: 'Motor etiketi, nominal akım ve yük tipi ile parametrelenir.',
    saha: 'Pompa/fanlarda proses ve enerji kontrolü sağlar.', dikkat: 'Yanlış parametreleme motoru ısıtabilir.', ilgiliAraclar: 'Motor, GES Tarımsal',
    kaynak: 'IEC 61800 serisi',
  ),
];
