# E.S.A. 2.4.2 — Analiz Sonrası Revizyon

Bu paket, önceki analiz raporundaki yüksek öncelikli eksiklerin bir bölümünü doğrudan kaynak kodda düzeltmek için hazırlanmıştır.

## Uygulanan düzeltmeler
- Uygulama sürümü 2.4.2 olarak güncellendi.
- Ortak araç üst çubuğunda info ikonunun soluna **Yardım** etiketi eklendi.
- `ResultCard` ve `uiResultCard` sonuçlarında **Özet / Detay** aç-kapa yapısı eklendi.
- AG pano malzeme seçiminde **Mesken / Diğer** abone grubu eklendi.
- Mesken + monofaze için 21 kW üzeri kullanımda teorik hesap onayı eklendi.
- AG pano sayaç/ölçüm metni 9 / 30 / 320 kW eşiklerine göre yeniden kurgulandı.
- Kompanzasyon fatura ekranında sözleşme gücü **kW** yapıldı ve 30 kW eşiğine göre %33/%20 ve %20/%15 ön limitleri uygulandı.
- Motor DOL için 5,5 kW üzeri teorik hesap onayı eklendi.
- Yer Altı Kablolar ekranına Bakır/Alüminyum ve AG için Monofaze/Trifaze seçimi eklendi; isim güncellendi.
- Alpek listesi 150/185/240 mm² seviyelerine genişletildi ve yaklaşık AWG karşılığı gösterildi.

## Bilinçli olarak kesinleştirilmemiş alanlar
- TEDAŞ/dağıtım şirketi ve üretici kataloglarına bağlı gerçek saha ampere tabloları, tek bir katsayıyla üretilmemiştir.
- Fatura analizi hâlâ tam mevzuat-temelli tersine mühendislik motoru değildir.
- OG hücre dizilimi ve kesici/ayırıcı seçimi hâlâ bağlantı görüşü/kısa devre/ölçü fonksiyonlarıyla birlikte yeniden tasarlanmalıdır.
- GES DC/AC koruma seçimi henüz tam koruma koordinasyonu motoruna dönüştürülmemiştir.

## Test notu
Bu çalışma ortamında Flutter SDK bulunmadığından `flutter analyze` ve gerçek Android build çalıştırılamamıştır. Bu nedenle paket **kaynak kod revizyonu + statik tutarlılık** seviyesinde teslim edilmektedir; FlutLab/yerel Flutter ortamında build alınması gerekir.
