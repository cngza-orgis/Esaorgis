# ESA 1.0.9 – Final kontrol/revizyon notları

## Kompanzasyon – Fatura / Arıza Kontrol
- Menü artık doğrudan ilk/son endeks girişlerini içeren güncel Fatura / Ceza Kontrol ekranına açılır.
- T Toplam İlk/Son, T1 İlk/Son, T2 İlk/Son, T3 İlk/Son, RI İlk/Son ve RC İlk/Son alanları kullanılmaktadır.
- T toplam yoksa mevcut T1/T2/T3 çiftleri toplanabilir; eksik çiftler hata üretmeden atlanır.
- RI ve RC birbirinden bağımsız değerlendirilir.

## Kompanzasyon – Pano Tasarım / Kademe
- Kapsamlı ön tasarım yapısı korunmuştur.
- Sistem gücü, CT, gerilim, kademe sayısı, mevcut/hedef cosφ, analizör/röle, harmonik ve şönt reaktör bilgileri alınır.
- Manuel kademe değerleri girildiğinde mevcut pano tasarımına benzer tersine mühendislik yaklaşımı; boş bırakıldığında otomatik ön kademe dizilimi uygulanır.
- Ana koruma, bara, kablo, CT, kademe koruması ve kontaktör ön seçimleri sonuç ekranında gösterilir.

## Motor Koruma & Yol Verme
- Yol verme yöntemleri uzun ve net adlarıyla genişletildi:
  - Direkt Yol Verme (DOL)
  - Yıldız-Üçgen Yol Verme
  - Oto Transformatörlü Yol Verme
  - Yumuşak Yol Verici (Soft Starter)
  - Frekans Konvertörlü Yol Verme (VFD)
  - Bilezikli Rotorlu Motorlarda Rotor Dirençli Yol Verme
- Yıldız-üçgen için kontaktör sonuçları korunmuştur.
- Diğer yöntemlerde yöntemin çalışma prensibi ve saha kontrol notları gösterilir; kesin cihaz seçimi üretici/koordinasyon verilerine bırakılır.

## Dağıtım Şebekesi / ENH
- Ana menüde bağımsız ana araç olarak korunmuştur.
- İlk seçim yalnızca AG / OG / Müşterek'tir.
- İkinci seçim yalnızca seçilen şebeke tipine uygun elemanları gösterir.
- OG tarafında T/D/N/Z direk aileleri ve T-10…T-20, D-10…D-20, N-10…N-20, Z-10…Z-20 tipleri korunmuştur.
- AG/Müşterek tarafında A tipi I/U, 8I/10I/12I, 8U/10U/12U; kafes K1–K5; betonarme; taşıyıcı/durdurucu/nihayet/branşman; trafo direği; box/pano; aydınlatma direği ve yeraltı dağıtım seçenekleri genişletilmiştir.
- Ecomühendis elektrik direkleri sayfasındaki saha terminolojisi referans olarak kullanılmıştır; bu bilgiler nihai teknik otorite olarak kabul edilmez.
- TEDAŞ'ın direk malzeme poz kırılımı ve ilgili tip proje/şartname çerçevesi nihai teknik doğrulama için esas alınmalıdır.

## Sürüm
- Uygulama sürümü: 1.0.9+109
