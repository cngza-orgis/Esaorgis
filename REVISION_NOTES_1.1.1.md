ESA 1.1.1 – Düzeltme ve Teknik Revizyon

- Kullanıcı arayüzü ve bilgi notlarından belirli kaynak dosya adı/uzantısı ifadeleri kaldırıldı. Bilgi notları genel olarak mevzuat, standart, TEDAŞ/dağıtım şirketi şartnamesi, üretici verisi ve onaylı proje esasına göre düzenlendi.
- Hat Analizi artık otomatik kesit seçmez. Kullanıcının mevcut kablo/kesit seçimi analiz edilir; mevcut gerilim düşümü ve referans akım taşıma kapasitesi gösterilir, ardından olması gereken standart kablo/grup ayrıca önerilir.
- Manuel kablo listesi 1x0,75 mm²'den başlayarak tekli, paralel ve 3x...+PE yapıları ile 3x240+120 mm²'ye kadar genişletildi.
- Kablo Akım Taşıma Kapasitesi aracı aynı standart seçim listesini kullanacak şekilde güncellendi.
- AG Pano yüksek güçlerde artık 'Özel Kablo/Bara' sonucuna düşmez; standart paralel 3x240+120 mm² Cu kablo grupları ve standart bara grupları üzerinden ön seçim yapar.
- 1000 kW sınıfında çoklu paralel kablo grubu hesabı devreye alınmıştır.
- OG Hücre / Ölçü Gereksinimi aracı pasif seçim mantığından çıkarıldı; ölçüm tipi, OG gerilimi, giriş/ölçü/çıkış/trafo koruma fonksiyonları ve CT/VT ön değerlendirmesi sonuçta gösterilir.
- Flutter CardTheme uyumluluğu CardThemeData ile korunmuştur.

Not: Bu sürümde gerçek FlutLab/Flutter derlemesi bu çalışma ortamında Flutter SDK bulunmadığı için çalıştırılamamıştır. Kod ve paket bütünlüğü statik olarak kontrol edilmiştir.
