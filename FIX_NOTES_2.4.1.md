# E.S.A. 2.4.1 — Static Repair Package

Bu paket, 17.08/18.08.2026 tarihli 2.4.0 kaynak ZIP'i üzerinde yapılan kaynak seviyesinde düzeltmeleri içerir.

## Düzeltilen kritik derleme sorunları
- `main.dart` içine mevcut fakat `part` olarak bağlanmamış üç araç eklendi:
  - `yeralti_kablo.dart`
  - `alpek_iletken.dart`
  - `acik_iletken.dart`
- Ana menüde mevcut sınıf adlarıyla uyuşmayan araç çağrıları düzeltildi:
  - `AlpekEkrani` → `AlpekIletkenEkrani`
  - `BoruTavaGelistirilmisEkrani` → `BoruTavaEkrani`
  - `MakaraGelistirilmisEkrani` → `MakaraEkrani`
- Projedeki Dart dosyalarında parantez/köşeli parantez/süslü parantez dengesi statik olarak kontrol edildi.
- Proje içi `const/new` sınıf çağrıları statik olarak tarandı; aktif kodda eksik proje sınıfı bırakılmadı.

## Teknik güvenlik düzeltmesi
- Hat Analizi'nde `Tavada` ve `Boruda` seçenekleri bulunmasına rağmen kapasite motorunun Havada/Toprakta tablolarını bu iki döşemeye de uygulaması engellendi.
- Bu iki döşeme için doğrulanmış kapasite modeli olmadığı durumda artık sahte bir kapasite değeri üretilmiyor; sonuç açıkça modelin bulunmadığını belirtiyor.
- `Hesaplanan Akım / Taşıma Kapasitesi` başlığı korunmuştur.

## Test sınırı
Bu çalışma ortamında Flutter/Dart SDK bulunmadığından gerçek `flutter analyze`, `flutter test` ve APK/Web build çalıştırılamadı. Bu nedenle paket, kaynak/statik analiz ile doğrulanmıştır. FlutLab'a aktarıldığında ilk adım olarak `flutter analyze` ve ardından web/Android build çalıştırılması önerilir.
