# E.S.A. — Elektrik Saha Asistanı

FlutLab / Flutter için hazırlanmış revizyon paketi.

- Telefon uygulama adı: **E.S.A.**
- Application ID: `com.orgis.esa`
- Görünen sürüm: **Esa Sürüm 1.0.1**
- Flutter sürümü: `1.0.1+101`
- Türkçe arayüz
- Çevrimdışı çalışma hedefi
- Kurumsal lacivert / beyaz / gri tasarım
- 3 sütunlu ana menü ve tam genişlik Hakkında / Yasal Uyarı kuşağı

## Tasarım ve teknik revizyonlar

Bu paket, verilen FlutLab boş proje ile birlikte sağlanan önceki revizyon paketi ve proje notları referans alınarak hazırlanmıştır. Çalışan hesap mantıklarının korunması, yeni özelliklerin tek merkezden eklenmesi ve web başlangıcının sadeleştirilmesi hedeflenmiştir.

Web emülatörü için `SystemChrome` çağrıları `kIsWeb` kontrolü altında yalnızca mobil platformlarda çalıştırılır. Böylece ilk Flutter frame'inin platform kanalı çağrıları nedeniyle etkilenme riski azaltılmıştır.

### Ana menü
1. Hat, Kablo ve Sigorta
2. Pano Malzeme Seçimi
3. Kompanzasyon Merkezi
4. Motor Hesapları
5. GES / Solar Sistemler
6. Topraklama
7. Şantiye Araçları
8. Faturalama
9. Ölçü Trafo Hesaplama

### Kaldırılan ayrı araçlar
- Jeneratör / Trafo ana menü grubu
- Ayrı Gerilim Trafosu aracı
- Ayrı Akü Ömür Hesabı
- Ayrı Panel Amortisman aracı
- İngilizce arayüz

### Yeni / genişletilmiş araçlar
- Fatura Analizi
- OG Trafo Standart Pano
- GES Çatı Alanından Tasarım
- AG Açık İletken
- OG Yeraltı Kablo
- ALPEK
- Geliştirilmiş Boru / Tava Doluluk
- Geliştirilmiş Makarada Kalan Kablo
- Aydınlatma hesabı Hat/Kablo/Sigorta grubuna taşındı

## Teknik sorumluluk notu

Uygulamadaki bağlantı, kablo, koruma, pano, OG hücre, GES ve benzeri sonuçlar ön hesap / ön seçim amacıyla sunulur. Kullanıcı tarafından sağlanan uygulama ve bağlantılar referans niteliğindedir; kesin teknik seçimler ilgili yönetmelik, şartname, usul/esas, mevzuat, standart, üretici verisi, dağıtım şirketi şartları ve proje koşulları ile doğrulanmalıdır. Teknik olarak uygun olmayan bir değer girildiğinde teorik sonuç gösterilebilir ancak bu, saha uygulamasının uygun olduğu anlamına gelmez.

## Test sırası
1. FlutLab'a ZIP'i içe aktar.
2. Pub Get.
3. Önce Web emülatöründe açılış ekranını test et.
4. Sonra kritik araçları tek tek test et.
5. APK hakkını ancak Web + temel Android testleri geçtikten sonra kullan.


## 1.0.1+ Dağıtım Şebekesi / ENH
- Yeni ana menü grubu: **Dağıtım Şebekesi / ENH**.
- Tesis tipleri: Sadece OG, Sadece AG, OG–AG Müşterek, Aydınlatma Sistemi.
- Hat tipi: Havai / Yeraltı (aydınlatmada sistem tipleri).
- Direk / Box / Sistem tipi seçimine göre teknik özellik, fiziki özellik, kullanım alanı, teçhizat, mekanik/saha kontrolleri ve dikkat edilmesi gerekenler gösterilir.
- Teknik Uygunluk sonucu yalnızca **ön değerlendirme** olarak sunulur; tip proje, güncel teknik şartname, ilgili standart, dağıtım şirketi uygulaması ve onaylı proje yerine geçmez.
- Kaynak çerçevesi TEDAŞ proje onay/kabul dokümanları, TEDAŞ tip proje listeleri ve ilgili teknik şartnameler esas alınarak oluşturulmuştur.

## 1.1.0 — Profesyonel revizyon
- 1.0.9 sağlıklı baseline korunarak hazırlanmıştır.
- Ortak responsive two-column düzeni ve sonuç kartı teması standardize edilmiştir.
- Ana ekran başlığı E.S.A. olarak güncellenmiştir; resmî uygulama adı Elektrik Saha Asistanı olarak korunur.
- teknik referans tabloları referans katmanı eklenmiştir.
- Trafo 50–2500 kVA referansları ve AG çıkış zinciri güçlendirilmiştir.
- Gerilim düşümü için Cu NYY R/X tabanlı empedans tabanlı ön hesap eklenmiştir.
- GES 200 kW inverter sınırından çıkarılmış, 320/350 kW sınıfı ve paralel inverter kurgusu eklenmiştir.
- Çatı GES'te USD/kWp varsayımı ve kullanıcı bütçesi karşılaştırması eklenmiştir.
- Motor yol verme ve kompanzasyon teknik referans notları genişletilmiştir.
