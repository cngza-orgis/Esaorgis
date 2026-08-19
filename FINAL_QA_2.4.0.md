# Elektrik Saha Asistanı 2.4.0 — Final Revizyon QA

- Şantiye Araçları: yalnızca Boru / Tava Doluluk ve Makarada Kalan Kablo.
- Açık İletken, Yeraltı Kablo ve Alpek İletken: Hat ve Şebeke Araçları altında.
- Ana menüde ayrı Trafo Bilgileri aracı kaldırıldı; OG Trafo Standart Pano içine trafo teknik bilgi seçimi/gösterimi entegre edildi.
- Kablo kesitleri merkezi `technical_data.dart` listesinden referanslanıyor; 1x, 2x, 4x, 3x+N ve paralel gruplar mevcut.
- Hat Analizi mevcut seçilen kabloyu analiz eder; akım, kapasite, gerilim düşümü V/% ve gerekçe gösterir; öneri ayrı kriterlerle belirlenir.
- Fatura Analizi toplam tutardan tahmini tüketim ve ana kalem ayrıştırması yapabilir; kWh verilirse doğrudan kontrol de yapılır.
- Tüm AppScaffold ekranlarında Bilgi/Yardım erişimi varsayılan olarak açıktır.
- Uygulama içi ad: Elektrik Saha Asistanı. Telefon uygulama adı: E.S.A.
- EMO 2025 PDF adı uygulama kaynaklarında kullanılmıyor.
