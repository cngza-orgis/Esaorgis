# ESA 1.0.2 — Modüler revizyon

Bu sürüm, önceki ESA 1.0.1/Dagitim_ENH paketinin üzerine hazırlanmıştır.

## Ana değişiklikler
- `lib/main.dart` tek dosya yaklaşımından çıkarıldı; Dart `part` mimarisiyle modüllere ayrıldı.
- Ana menü görsel dili korunarak `E.S.A.` üst başlık ibaresi kaldırıldı; yalnızca `Elektrik Saha Asistanı` gösterilir.
- Ana menüde kısmi satırlar genel olarak ortalanır; tek araç kalırsa tam ortaya, iki araç kalırsa iki araç birlikte ortaya hizalanır.
- `Dağıtım Şebekesi / ENH` korunmuştur: ilk seçim AG / OG / Müşterek; ikinci liste seçilen tipe göre filtrelenir.
- Ayrı `Trafo Bilgileri` aracı eklendi: 50–2500 kVA standart güç seçimi, AG anma akımı ve trafo → AG pano → ana bara saha zinciri.
- `Kompanzasyon Merkezi` üç araçlı yapıya getirildi: Fatura / Arıza Kontrol, Mevcut Sistem Analizi, Pano Tasarım / Kademe.
- Mevcut Sistem Analizi; sistem gücü, cosφ, kademe sayısı, kademe kVAr, şönt reaktör, CT ve sürücü/analizör bilgilerini kullanır.
- Fatura / Arıza ekranında uygunsuzluk halinde Mevcut Sistem Analizi'ne yönlendirme butonu bulunur.
- OG Trafo Standart Pano güç listesi 2500 kVA'ya kadar genişletildi.
- Web başlangıcında beyaz/lacivert yükleme ekranı, viewport ve ilk-frame temizliği eklendi.
- Web başlangıcında `SystemChrome` çağrısı yapılmaz; mobil sistem çubukları yalnızca mobil platformlarda uygulanır.
- Platform seviyesinde hatayı sessizce yutup siyah ekran oluşturabilecek `PlatformDispatcher.onError -> return true` yaklaşımı kaldırıldı.

## Teknik kaynak ilkesi
Uygulamadaki hesap/uygunluk kararları; yürürlükteki mevzuat, TEDAŞ teknik şartnameleri/tip projeleri, ilgili TS/EN/IEC standartları, dağıtım şirketi güncel uygulamaları ve üretici verileriyle doğrulanmalıdır. Başka uygulamalar/kataloglar yalnızca referanstır.
