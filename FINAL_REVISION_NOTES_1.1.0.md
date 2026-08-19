# E.S.A. — Final Revizyon Paketi

Uygulama adı: **Elektrik Saha Asistanı**
Telefon/Android görünen adı: **E.S.A.**
Application ID: `com.orgis.esa`

## Sonlandırılan mimari
- Ana menü 3 sütunlu yapıdadır; eksik satır/tek kart durumunda ortalama korunur.
- **Hat ve Şebeke Araçları** altında Hat/Kablo/Sigorta + Dağıtım Şebekesi/ENH araçları birleştirilmiştir.
- **Ölçü Trafo Hesaplama** Pano Malzeme Seçimi grubundadır.
- **Trafo Bilgileri** ayrı teknik bilgi aracı olarak korunmuştur.
- Kompanzasyonda Fatura/Ceza Kontrol + Mevcut Sistem Analizi + Pano Tasarım/Kademe korunmuştur.

## Stabilite / UI
- Açılışta yapay loading kapısı kaldırılmıştır.
- Ortak AppScaffold, ortak sonuç kartı ve ortak seçim alanı kullanılmıştır.
- Dropdown seçimlerinde `value`/`items` uyuşmazlığından doğan Flutter web assertion riski güvenli seçim katmanında ele alınmıştır.
- Hareketli TabBar/üst şerit kullanılmamaktadır.
- Dar ekranlarda iki kolon otomatik tek kolona iner.
- Uzun seçim metinleri taşma yerine ellipsis ile gösterilir.
- Ana ekran başlığında E.S.A. yerine **Elektrik Saha Asistanı** gösterilir; Android launcher adı E.S.A. olarak korunur.
- Kullanıcının verdiği ESA logosu Android/Web/mağaza ikonlarında eşitlenmiştir.

## Teknik kapsam
- teknik referans tabloları referans katmanı korunmuştur.
- Trafo teknik bilgi/AG çıkış zinciri 50–2500 kVA referanslarıyla korunmuştur.
- ENH/şebeke rehberinde AG, OG ve Müşterek ayrımı; seçime göre filtrelenmiş direk/box/bina/sistem listeleri ve tip kodu bilgileri korunmuştur.
- Motor yol verme yöntemleri uzun adlarıyla korunmuştur.
- Kompanzasyon endeksleri T/T1/T2/T3/RI/RC bağımsız ve eksik girişlere toleranslıdır.
- GES inverter kurgusu tek cihazı gereksiz büyütmeyecek şekilde paralel grup yaklaşımıyla düzenlenmiştir; 320/350 kW sınıfı referanslar korunmuştur.
- Çatı GES yaklaşık yatırım maliyeti USD/kWp ve kullanıcı bütçesi karşılaştırması içerir.
- Kablo/sigorta sonucunda trifaze için cosφ referansı gösterilir.
- Fatura tahminleme cihaz kütüphanesinde doğalgaz kombisinin elektrik tüketimi bulunur.

## Teknik sorumluluk
Uygulamadaki sonuçlar ön hesap/ön seçim ve teknik referans amacı taşır. Nihai saha uygulaması; yürürlükteki mevzuat, TEDAŞ/dağıtım şirketi teknik şartnameleri ve tip projeleri, ilgili TS/EN/IEC standartları, üretici teknik verileri, kısa devre/koruma koordinasyonu, saha ölçümleri ve onaylı proje ile doğrulanmalıdır.
