# E.S.A. 1.0.1 — Revizyon Notları

## Kaynaklar
- FlutLab boş proje ZIP'i: orgis-esa
- Önceki kapsamlı ESA revizyon paketi: ESA_1.01_Test
- Kullanıcı tarafından sağlanan tasarım görseli
- Önceki proje notları / kronolojik revizyon kaydı

## Tasarım
- Telefon görünen adı: E.S.A.
- Kurumsal lacivert / beyaz / gri tema
- Ana menü: 3 sütun × 3 ana grup
- Alt Hakkında / Yasal Uyarı: ekranın tam genişliği
- Sonuç kartlarında daha kompakt tipografi
- Araçlarda bilgi ikonu + teknik not / uyarı yapısı

## Mimari / başlangıç
- Web'de SystemChrome çağrıları devre dışı; mobilde çalışıyor.
- ErrorWidget görünür hata ekranı korunuyor.
- Application ID: com.orgis.esa
- Flutter sürümü: 1.0.1+101

## Araç grupları
- Hat, Kablo ve Sigorta: hat analizi, gerilim düşümü, kablo kapasitesi, sigorta, aydınlatma
- Pano: AG pano, OG hücre/ölçü, OG trafo standart pano
- Kompanzasyon: fatura/arıza kontrol, pano tasarımı
- Motor: koruma/yol verme, trifaze→monofaze
- GES: otomatik, manuel, çatıdan tasarım
- Topraklama
- Şantiye: boru/tava, makara, AG açık iletken, OG kablo, ALPEK
- Faturalama: fatura tahminleme, fatura analizi
- Ölçü Trafo: AG/OG tek araç

## Teknik sınırlar
Bu sürümde yeni yardımcı araçların bir bölümü ön boyutlandırma / ön seçim seviyesindedir. Özellikle kablo taşıma kapasitesi, OG hücre, trafo AG panosu, açık iletken, ALPEK, GES üretimi ve makara hesabında üretici verileri, döşeme koşulları, kısa devre, mekanik koşullar, dağıtım şirketi şartları ve ilgili standartlar ile nihai doğrulama gerekir.


## 1.0.1+ Dağıtım Şebekesi / ENH
- Yeni ana menü grubu: **Dağıtım Şebekesi / ENH**.
- Tesis tipleri: Sadece OG, Sadece AG, OG–AG Müşterek, Aydınlatma Sistemi.
- Hat tipi: Havai / Yeraltı (aydınlatmada sistem tipleri).
- Direk / Box / Sistem tipi seçimine göre teknik özellik, fiziki özellik, kullanım alanı, teçhizat, mekanik/saha kontrolleri ve dikkat edilmesi gerekenler gösterilir.
- Teknik Uygunluk sonucu yalnızca **ön değerlendirme** olarak sunulur; tip proje, güncel teknik şartname, ilgili standart, dağıtım şirketi uygulaması ve onaylı proje yerine geçmez.
- Kaynak çerçevesi TEDAŞ proje onay/kabul dokümanları, TEDAŞ tip proje listeleri ve ilgili teknik şartnameler esas alınarak oluşturulmuştur.
