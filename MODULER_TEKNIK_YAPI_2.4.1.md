# ESA 2.4.1 — Teknik Veri Katmanını Ayırma Altyapısı

Bu sürümde kullanıcı arayüzü, araçların hesaplama mantığı ve mevcut ekran davranışları değiştirilmemiştir.

## Yapılan tek mimari değişiklik
- `lib/core/cable_database.dart` oluşturuldu.
- Kabloya ait mevcut teknik veri ve fonksiyonlar `technical_data.dart` içinden bu dosyaya taşındı.
- `lib/main.dart` içine `import 'core/cable_database.dart';` eklendi.
- `lib/core/technical_data.dart` yalnızca mevcut trafo teknik referanslarını içerir.
- Mevcut `part` yapısı korunmuştur; bu nedenle mevcut araçların davranışını değiştirmeden kablo verileri uygulamaya aktarılır.

## Neden bu şekilde?
Dart'ta mevcut proje `part` tabanlı tek bir library olarak çalışıyor. Şimdilik sadece kablo veri katmanını bağımsız normal Dart library'sine çıkararak düşük riskli bir geçiş yaptık. `main.dart` kablo kütüphanesini import ettiği için mevcut part dosyaları kablo sembollerini kullanmaya devam eder.

## Sonraki aşama
Her teknik alan tamamlandıkça ayrı bir normal Dart library'sine dönüştürülebilir:
- `cable_database.dart`
- `open_conductor_database.dart`
- `transformer_database.dart`
- `panel_database.dart`
- vb.

Bu aşamada araç ekranlarının dosya yapısını topluca değiştirmedik.


## UI System Bar Standardizasyonu
- Durum çubuğu ve alt sistem navigasyon alanı uygulama genelinde kurumsal lacivert ile standartlaştırıldı.
- Tüm menü ve araç rotaları `MaterialApp.builder` üzerinden aynı `SystemUiOverlayStyle` ile sarıldı.
- Android açılış/başlangıç penceresi arka planı da aynı lacivert renge alındı.
- Teknik veritabanı ve araç hesaplama mantığına dokunulmadı.
