E.S.A. Elektrik Saha Asistanı - Test Paketi
Sürüm: E.S.A. 2.4.0
Application ID: com.orgis.esa

Bu paket 13.08.2026 tarihinde oluşturulan son revizyon paketinin test kopyasıdır; boş FlutLab projesi hedef yapısı olarak korunmuştur.
DESIGN_REFERENCE.png, üzerinde birlikte karar verdiğimiz görsel mimarinin referans görselidir.

Önemli teknik kural:
- Verilen uygulama/link/veriler yalnızca referans niteliğindedir.
- Kesin hesap ve seçimler ilgili yönetmelik, şartname, usul/esas, mevzuat ve teknik literatüre göre doğrulanmalıdır.
- Teknik olarak uygun olmayan seçimlerde teorik hesap sonucu ayrıca belirtilmelidir.

Test sırası:
1. FlutLab'a ZIP'i içe aktar.
2. Analyzer/Build temiz olduğunu kontrol et.
3. Web emülatöründe başlangıç ekranını test et.
4. Android emülatöründe araçları tek tek test et.
5. APK alma hakkını ancak temel ekranlar ve kritik araçlar çalışıyorsa kullan.


Revizyon 14.08.2026:
- Web başlangıcında SystemChrome yalnızca mobil platformlarda çağrılıyor.
- Ana menü 9 ana gruba indirildi ve 3 sütun düzeni korunuyor.
- Alt Hakkında / Yasal Uyarı kuşağı tam genişliğe alındı.
- Faturalama altında Fatura Tahminleme + Fatura Analizi toplandı.
- Aydınlatma Hat/Kablo/Sigorta grubuna taşındı.
- OG Trafo Standart Pano ve GES Çatı Alanından Tasarım eklendi.
- Şantiye araçları AG/OG, açık iletken, OG kablo ve ALPEK başlıklarıyla genişletildi.
- Ayrı Akü Ömür / Panel Amortisman / Jeneratör menüleri kaldırıldı; GES içinde geri dönüş hesabı tutuldu.
- Gerilim düşümü kullanıcı arayüzünde %5 üst sınır olarak standardize edildi.
- Sonuç kartı tipografisi küçültüldü.


## 1.0.1+ Dağıtım Şebekesi / ENH
- Yeni ana menü grubu: **Dağıtım Şebekesi / ENH**.
- Tesis tipleri: Sadece OG, Sadece AG, OG–AG Müşterek, Aydınlatma Sistemi.
- Hat tipi: Havai / Yeraltı (aydınlatmada sistem tipleri).
- Direk / Box / Sistem tipi seçimine göre teknik özellik, fiziki özellik, kullanım alanı, teçhizat, mekanik/saha kontrolleri ve dikkat edilmesi gerekenler gösterilir.
- Teknik Uygunluk sonucu yalnızca **ön değerlendirme** olarak sunulur; tip proje, güncel teknik şartname, ilgili standart, dağıtım şirketi uygulaması ve onaylı proje yerine geçmez.
- Kaynak çerçevesi TEDAŞ proje onay/kabul dokümanları, TEDAŞ tip proje listeleri ve ilgili teknik şartnameler esas alınarak oluşturulmuştur.


Revizyon 1.1.0 (15.08.2026):
- Sağlıklı 1.0.9 baseline korunarak profesyonel revizyon uygulanmıştır.
- Web/mobile başlangıç yükleme kapısı kaldırılmış, doğrudan AnaMenu ile açılış sağlanmıştır.
- Responsive twoCol ve ortak sonuç kartı teması standardize edilmiştir.
- Ana ekran başlığı E.S.A.; resmî uygulama adı Elektrik Saha Asistanı olarak korunmuştur.
- teknik referans tabloları referans katmanı eklenmiştir.
- Trafo 50–2500 kVA teknik referansları ve AG çıkış zinciri genişletilmiştir.
- Cu NYY gerilim düşümünde Cu NYY R/X tabanlı ön hesap eklenmiştir.
- GES'te 320/350 kW inverter sınıfı ve paralel inverter kurgusu eklenmiştir.
- Çatı GES'te USD/kWp maliyet varsayımı ve kullanıcı bütçesi karşılaştırması eklenmiştir.
- Motor ve kompanzasyon ekranlarına teknik referans notları eklenmiştir.

FlutLab son kontrolü: Bu çalışma ortamında Flutter SDK bulunmadığından burada gerçek `flutter analyze`/APK build çalıştırılamamıştır. ZIP bütünlüğü, proje dosya bütünlüğü ve kaynak referansları statik olarak kontrol edilmelidir.
