# E.S.A. 2.3.6 — QA5 Static Hotfix

- QA4 paketindeki Flutter web derleme riskleri yeniden tarandı.
- `Map<double,double>` sabit/yerel tabloları kaldırıldı; indeks tabanlı sabit listeler kullanıldı.
- `CardThemeData` kullanımı korundu.
- Uygulama sürümü ve görünen sürüm metni 2.3.6 olarak eşitlendi.
- Hat Analizi özel kablo tasarımı seçeneği korundu ve manuel yapı alanı eklendi.
- `2x(3x240+120)` ve `3x(1x240)` gibi paralel özel gösterimler için kesit/paralel ayrıştırma güçlendirildi.
- Monofaze 1x ve 2x kesit listeleri ile trifaze 4x ve 3x...+N listeleri korunarak tekrar kontrol edildi.
- Üst/alt sistem çubuğu renkleri kurumsal lacivertte tutuldu.
- Bu paket kaynak seviyesinde statik kontrol edilmiştir; çalışma ortamında Flutter SDK bulunmadığından gerçek FlutLab build testi yapılamamıştır.
