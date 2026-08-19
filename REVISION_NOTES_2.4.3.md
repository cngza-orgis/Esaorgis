# ESA 2.4.3 — 20:00 sonrası revizyon paketi

## Uygulananlar
- Fatura Analizi yalnızca TL → kWh olacak şekilde sadeleştirildi.
- Fatura Analizi'ne tarife seçimi eklendi. Mesken referansı aktif; diğer tarifeler gerçek fatura ile kalibrasyon bekliyor.
- Fatura Analizi dönem/gün ve kWh → fatura mantığından arındırıldı.
- ALPEK gösterimi monofaze için 1xfaz+nötr, trifaze için 3xfaz+nötr biçimine çevrildi.
- ALPEK seçimi tasarım akımına göre korunarak kesit önerisi yapılacak şekilde bırakıldı.
- KCMIL için teknik açıklama eklendi.
- Ana menüde 8 araç grubu korunarak kartlar daha kompakt 3 sütunlu ızgaraya alındı.
- Ana menüye Teknik Bilgiler alanı ve çevrim dışı teknik kütüphane eklendi.
- Teknik kütüphaneye arama ve konu detay pencereleri eklendi.
- Akım trafosu / ölçü sistemleri için 1 A/5 A, çoklu sekonder, 5P/10P, 0,2S/0,5S, Ith/Idyn gibi başlıklar teknik kütüphaneye alındı.
- Ölçü Trafo Hesaplama girişleri AG=kW, OG=kVA olacak şekilde revize edildi.
- Güç faktörü ön kabulü ilgili araçlarda 0,80'e çekildi.
- Yer Altı Kablolar araç adı talep edilen biçime getirildi.
- Ortak Yardım/(i) kontrolü tek tıklanabilir alan olarak korunuyor; ayrıca çerçeveli ayrı buton kullanılmıyor.

## Not
Bu paket mevcut ZIP'in üzerine revizyon uygulanmış çalışma sürümüdür. Flutter/FlutLab ortamında son derleme ve cihaz testi ayrıca yapılmalıdır.
