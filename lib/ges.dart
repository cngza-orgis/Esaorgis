part of 'main.dart';

class GesAnaEkrani extends StatefulWidget { const GesAnaEkrani({super.key}); @override State<GesAnaEkrani> createState()=>_GesAnaEkraniState(); }
class _GesAnaEkraniState extends State<GesAnaEkrani>{
  int sekme=0;
  @override Widget build(BuildContext context)=>AppScaffold(title:'GES / Solar Sistemler',info:true,onInfo:()=>bilgiPopup(context,'GES / Solar Sistemler','Otomatik tasarım ve manuel sistem analizini tek çalışma alanında sunar. Gerçek proje; panel/inverter üretici verileri, DC/AC koruma, kablo, gölgeleme, statik ve bağlantı koşulları ile doğrulanmalıdır.'),body:Column(children:[
    Padding(padding:const EdgeInsets.fromLTRB(14,10,14,4),child:Row(children:[Expanded(child:_seg('Otomatik Tasarım',0)),const SizedBox(width:8),Expanded(child:_seg('Manuel Analiz',1))])),
    Expanded(child:sekme==0?const _GesOtomatikTab():const _GesManuelTab()),
  ]));
  Widget _seg(String text,int i)=>InkWell(borderRadius:BorderRadius.circular(8),onTap:()=>setState(()=>sekme=i),child:Container(padding:const EdgeInsets.symmetric(vertical:10),decoration:BoxDecoration(color:sekme==i?cIcon():cCard(),borderRadius:BorderRadius.circular(8),border:Border.all(color:cIcon().withValues(alpha: .35))),child:Text(text,textAlign:TextAlign.center,style:TextStyle(color:sekme==i?Colors.white:cText(),fontWeight:FontWeight.w800,fontSize:12))));
}

class GesOtomatikEkrani extends StatelessWidget { const GesOtomatikEkrani({super.key}); @override Widget build(BuildContext context)=>AppScaffold(title:'GES — Otomatik Tasarım',info:true,onInfo:()=>bilgiPopup(context,'GES Otomatik Tasarım','Talep gücüne göre ön sistem tasarımı ve malzeme zinciri oluşturur.'),body:const _GesOtomatikTab()); }
class GesManuelEkrani extends StatelessWidget { const GesManuelEkrani({super.key}); @override Widget build(BuildContext context)=>AppScaffold(title:'GES — Manuel Sistem Analizi',info:true,onInfo:()=>bilgiPopup(context,'GES Manuel Analiz','Mevcut panel, akü ve inverter bilgilerini kontrol eder.'),body:const _GesManuelTab()); }

// ================= GES - OTOMATİK SEKME =================
class _GesOtomatikTab extends StatefulWidget {
  const _GesOtomatikTab();
  @override
  State<_GesOtomatikTab> createState() => _GesOtomatikTabState();
}

int standartInvertorBul(double kw) {
  // Güncel saha ürünlerinde 300 kW+ sınıf string inverterler de bulunuyor.
  // Örnek: Sungrow SG320/350HX serisi 320/350 kW sınıfındadır.
  const values = [5, 10, 15, 20, 25, 30, 40, 50, 60, 75, 100, 125, 150, 200, 250, 320, 350];
  final target = kw <= 0 ? 5.0 : kw;
  return values.firstWhere((v) => v >= target, orElse: () => values.last);
}

int inverterAdediVeGuc(double gerekliAcKw) {
  if (gerekliAcKw <= 0) return 1;
  return (gerekliAcKw / 350).ceil();
}

class _GesOtomatikTabState extends State<_GesOtomatikTab> {
  final _gucCtrl = TextEditingController();
  String sistemTipi = 'Şebeke Bağlantılı (On-Grid)';
  double panelW = 500;
  String bolge = 'Marmara';
  final _alanBoyCtrl = TextEditingController();
  final _alanEnCtrl = TextEditingController();
  double gunesSaat = 3.8;
  double? catiGuc; 
  
  double kuruluGuc = 0, alan = 0;
  int panelAdet = 0, invertor = 0, invertorAdedi = 1;
  double inverterToplamAc = 0, tahminiYillikUretim = 0;
  String depolama = "", dcKablo = "", acKablo = "";
  String panelBaglanti = "", akuBaglanti = "";
  bool hesaplandi = false;

  @override
  void dispose() {
    _gucCtrl.dispose();
    _alanBoyCtrl.dispose();
    _alanEnCtrl.dispose();
    super.dispose();
  }

  void hesapla() {
    FocusManager.instance.primaryFocus?.unfocus();
    double p = double.tryParse(_gucCtrl.text.replaceAll(',', '.')) ?? 0;
    if (p <= 0 || panelW <= 0) { setState(() => hesaplandi = false); return; }
    
    double kG = p * 1.2; 
    int pAdet = ((kG * 1000) / panelW).ceil();
    final hedefAc = p * 1.0;
    // Tek cihazı gereksiz büyütmemek için önce paralel grup adedi,
    // ardından her grubun standart inverter sınıfı belirlenir.
    final invCount = inverterAdediVeGuc(hedefAc);
    final grupAcKw = hedefAc / invCount;
    final inv = standartInvertorBul(grupAcKw);
    final invTotal = invCount * inv.toDouble();
    
    double vmp = 40.0;
    double imp = panelW / vmp;
    
    String pBaglanti = "";
    if (sistemTipi == 'Şebeke Bağlantılı (On-Grid)') {
      int seriAdet = min(pAdet, 14); 
      int paralelAdet = (pAdet / seriAdet).ceil();
      pBaglanti = "$seriAdet Seri x $paralelAdet Paralel Grup\n(~${(seriAdet * vmp).toInt()}V DC / ~${(paralelAdet * imp).toInt()}A)";
    } else {
      int seriAdet = 3; 
      int paralelAdet = (pAdet / seriAdet).ceil();
      pBaglanti = "$seriAdet Seri x $paralelAdet Paralel Grup\n(~${(seriAdet * vmp).toInt()}V DC / ~${(paralelAdet * imp).toInt()}A)";
    }

    String depo = "-";
    String aBaglanti = "-";
    
    if (sistemTipi == 'Şebeke Bağlantılı (On-Grid)') {
      depo = t("- (Şebekeye Satış / Mahsuplaşma)", "- (Grid Tied / Net Metering)");
    } else if (sistemTipi == 'Şebekesiz Doğrudan Kullanım (Aküsüz)') {
      depo = t("- (Sadece Gündüz Doğrudan Kullanım)", "- (Daytime Direct Use Only)");
    } else if (sistemTipi == 'Şebekesiz + Akülü (Off-Grid)') {
      double depokWh = p * 4; 
      depo = "${depokWh.toStringAsFixed(1)} kWh ${t('Kapasite İhtiyacı', 'Required Capacity')}";
      
      int akuAdet = (depokWh / 2.4).ceil();
      while (akuAdet % 4 != 0) { akuAdet++; } 
      int paralelKol = akuAdet ~/ 4;
      aBaglanti = "$akuAdet Adet (12V 200Ah)\n4 Seri x $paralelKol Paralel -> 48V Sistem";
    }
    
    final boy = double.tryParse(_alanBoyCtrl.text.replaceAll(',', '.')) ?? 0;
    final en = double.tryParse(_alanEnCtrl.text.replaceAll(',', '.')) ?? 0;
    final catiAlan = boy > 0 && en > 0 ? boy * en : 0;
    final catiUygunPanel = catiAlan > 0 ? (catiAlan / (2.5 * 1.15)).floor() : 0;
    final catiGucHesabi = catiUygunPanel > 0 ? catiUygunPanel * panelW / 1000 : 0;
    final yillikUretim = (pAdet * panelW / 1000) * gunesSaat * 365 * 0.80;
    setState(() {
      catiGuc = catiGucHesabi > 0 ? catiGucHesabi.toDouble() : null;
      kuruluGuc = (pAdet * panelW) / 1000;
      panelAdet = pAdet;
      invertor = inv;
      invertorAdedi = invCount;
      inverterToplamAc = invTotal;
      tahminiYillikUretim = yillikUretim;
      depolama = depo;
      alan = pAdet * 2.5 * 1.15; 
      dcKablo = (p <= 10) ? "4 mm² Solar Kablo" : "6 mm² Solar Kablo";
      acKablo = standartKabloBulNYY(inv * 1.5, true); 
      panelBaglanti = pBaglanti;
      akuBaglanti = aBaglanti;
      hesaplandi = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: cInputBg(), borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            twoCol(
              Field(controller: _gucCtrl, label: t('Talep Gücü (kW)', 'Demand Power (kW)')),
              Drop(label: t('Sistem Tipi', 'System Type'), value: sistemTipi, items: const ['Şebeke Bağlantılı (On-Grid)', 'Şebekesiz + Akülü (Off-Grid)', 'Şebekesiz Doğrudan Kullanım (Aküsüz)'], onChanged: (v) => setState(() { sistemTipi = v ?? sistemTipi; hesaplandi = false; })),
            ),
            const SizedBox(height: 20),
            twoCol(
              Drop(label: 'Türkiye Coğrafi Bölgesi', value: bolge, items: const ['Marmara','Ege','Akdeniz','İç Anadolu','Karadeniz','Doğu Anadolu','Güneydoğu Anadolu'], onChanged: (v) => setState(() { bolge = v!; gunesSaat = {'Marmara':3.8,'Ege':4.5,'Akdeniz':5.0,'İç Anadolu':4.2,'Karadeniz':3.2,'Doğu Anadolu':4.0,'Güneydoğu Anadolu':5.5}[bolge] ?? 3.8; hesaplandi = false; })),
              Drop(label: 'Günlük Güneşlenme', value: gunesSaat.toString(), items: const ['3.0','3.2','3.5','3.8','4.0','4.2','4.5','5.0','5.5','6.0'], onChanged: (v) => setState(() { gunesSaat = double.tryParse(v!) ?? 3.8; hesaplandi = false; })),
            ),
            twoCol(Field(controller: _alanBoyCtrl, label: 'Çatı Boyu (m)'), Field(controller: _alanEnCtrl, label: 'Çatı Eni (m)')),
            const SizedBox(height: 4),
            Text('${t('Kullanılacak Panel Gücü', 'Panel Rating (Wp)')}: ${panelW.toInt()} Wp', style: TextStyle(fontWeight: FontWeight.bold, color: cText())),
            Slider(value: panelW, min: 0, max: 1000, divisions: 100, activeColor: cIcon(), onChanged: (v) => setState(() { panelW = v; hesaplandi = false; })),
            const SizedBox(height: 15),
            ElevatedButton(onPressed: hesapla, child: Text(t('SİSTEM OLUŞTUR', 'GENERATE SYSTEM'))),
            const SizedBox(height: 20),
            if (hesaplandi)
              Column(
                children: [
                  uiResultCard(t('İnvertör Kurgusu', 'Inverter Configuration'), '$invertorAdedi × $invertor kW = ${inverterToplamAc.toStringAsFixed(0)} kW AC', 'Paralel inverter grubu / blok tasarım'),
                  uiResultCard(t('Panel Gücü ve Sayısı', 'Panel Pwr. & Count'), kuruluGuc.toStringAsFixed(2), 'kWp DC (${panelAdet.toString()} Adet)'),
                  uiResultCard('Tahmini Yıllık Üretim', fmt2(tahminiYillikUretim), 'kWh/yıl • seçilen güneşlenme değeri ve %80 performans oranı ile ön tahmin'),
                  uiResultCard(t('Panel Teknik Bilgisi', 'Panel Technical Data'), '${panelW.toInt()} Wp • yaklaşık 40 Vmp • ${fmt2(panelW/40)} A', ''),
                  AdviceCard(title:'İnvertör seçimi notu', text:'Tek invertör için sabit 200 kW sınırı kullanılmaz. Güncel ürünlerde 320/350 kW sınıfı string inverterler bulunur; daha yüksek santral güçlerinde paralel inverterler, blok tasarımı ve OG/MV istasyonu birlikte değerlendirilir. Kesin adet; DC/AC oranı, MPPT gerilim/akım sınırları, şebeke bağlantı koşulları ve üretici tasarım yazılımı ile doğrulanmalıdır.'),
                  uiResultCard(t('Panel Bağlantı Şekli', 'Panel Array Connection'), panelBaglanti, ''),
                  if (sistemTipi == 'Şebekesiz + Akülü (Off-Grid)') uiResultCard(t('Gerekli Depolama (Battery/Akü)', 'Required Battery Storage'), depolama, ''),
                  if (sistemTipi == 'Şebekesiz + Akülü (Off-Grid)') uiResultCard(t('Akü Bankası Kurgusu', 'Battery Bank Connection'), akuBaglanti, ''),
                  if (sistemTipi != 'Şebekesiz + Akülü (Off-Grid)') uiResultCard(t('Gerekli Depolama Durumu', 'Required Battery Storage'), depolama, ''),
                  uiResultCard(t('Gerekli Çatı / Saha Alanı', 'Est. Roof/Field Area'), alan.toStringAsFixed(1), 'm² (yürüyüş yolu payı %15)'),
                  if (catiGuc != null) uiResultCard('Girilen Çatı Alanıyla Tahmini Güç', fmt2(catiGuc!), 'kWp DC'),
                  uiResultCard(t('DC Solar Kablo Kesiti', 'DC Solar Cable Section'), dcKablo, ''),
                  uiResultCard(t('AC Çıkış Kablosu (Ana Pano)', 'AC Output Cable'), acKablo, ''),
                ],
              )
          ],
        ),
      ),
    );
  }
}

// ================= GES - MANUEL SEKME =================
class _GesManuelTab extends StatefulWidget {
  const _GesManuelTab();
  @override
  State<_GesManuelTab> createState() => _GesManuelTabState();
}

class _GesManuelTabState extends State<_GesManuelTab> {
  final _panelGucuCtrl = TextEditingController();
  final _panelAdetCtrl = TextEditingController();
  final _akuAhCtrl = TextEditingController();
  final _akuAdetCtrl = TextEditingController();
  final _invGucuCtrl = TextEditingController();

  String akuTipi = 'Jel';
  String invTipi = 'Off-Grid';

  String uretimBilgisi = "";
  String hataVeTavsiyeler = "";
  bool hesaplandi = false;

  @override
  void dispose() {
    _panelGucuCtrl.dispose();
    _panelAdetCtrl.dispose();
    _akuAhCtrl.dispose();
    _akuAdetCtrl.dispose();
    _invGucuCtrl.dispose();
    super.dispose();
  }

  void analizEt() {
    FocusManager.instance.primaryFocus?.unfocus();
    double pGuc = double.tryParse(_panelGucuCtrl.text.replaceAll(',', '.')) ?? 0;
    int pAdet = int.tryParse(_panelAdetCtrl.text) ?? 0;
    double aAh = double.tryParse(_akuAhCtrl.text.replaceAll(',', '.')) ?? 0;
    int aAdet = int.tryParse(_akuAdetCtrl.text) ?? 0;
    double iGuc = double.tryParse(_invGucuCtrl.text.replaceAll(',', '.')) ?? 0;

    if (pGuc == 0 || pAdet == 0 || iGuc == 0) {
      setState(() => hesaplandi = false);
      return;
    }

    double toplamPanelkW = (pGuc * pAdet) / 1000;
    double gunlukUretimkWh = toplamPanelkW * 4.5; // Ortalama 4.5 saat efektif güneşlenme
    double toplamAkukWh = (12 * aAh * aAdet) / 1000; // Aküler 12V blok varsayımı

    List<String> tavsiyeler = [];

    // İnvertör & Akü Mantık Kontrolü
    if (invTipi == 'On-Grid' && aAdet > 0) {
      tavsiyeler.add(t("On-Grid (Şebeke Bağlantılı) sistemlerde genellikle akü kullanılmaz. Akü kullanacaksanız invertör tipini 'Hibrit' olarak değiştirmeniz tavsiye edilir.", "Batteries aren't typically used in On-Grid systems. Choose 'Hybrid' if batteries are needed."));
    }

    // Kapasite Kontrolleri
    if (toplamPanelkW > iGuc * 1.3) {
      tavsiyeler.add(t("Panel gücünüz (${toplamPanelkW.toStringAsFixed(1)} kW), invertör kapasitenizin ($iGuc kW) çok üzerinde. Güvenli çalışma için invertör gücünü en az ${toplamPanelkW.toStringAsFixed(1)} kW seviyesine çıkarmanız tavsiye edilir.", "Panel power exceeds inverter capacity significantly. Upgrade the inverter."));
    } else if (iGuc > toplamPanelkW * 2) {
      tavsiyeler.add(t("İnvertör gücünüz ($iGuc kW), mevcut panel gücüne göre gereğinden fazla büyük. Bu durum düşük verimle çalışmaya sebep olabilir.", "Inverter capacity is oversized for the panels, which may reduce efficiency."));
    }

    // Depolama Kontrolleri
    if (invTipi != 'On-Grid') {
      if (aAdet == 0) {
         tavsiyeler.add(t("Off-Grid / Hibrit sistemlerde enerji depolaması (akü) olmadan sistem güneşsiz anlarda çalışmaz. Şebeke desteği yoksa Akü eklemeniz tavsiye edilir.", "Off-Grid/Hybrid systems require batteries for operation without sun/grid."));
      } else {
         if (toplamAkukWh < gunlukUretimkWh * 0.3) {
            tavsiyeler.add(t("Akü kapasiteniz (${toplamAkukWh.toStringAsFixed(1)} kWh) üretilen enerjiyi depolamak için yetersiz kalabilir. Akü sayısını veya kapasitesini artırmanız tavsiye edilir.", "Battery capacity is insufficient for the generated energy. Consider expanding the battery bank."));
         }
         if (akuTipi == 'Jel') {
            tavsiyeler.add(t("Bilgi: Jel akülerin döngü ömrünü korumak için toplam kapasitesinin en fazla %50'sini (Half-Cycle) kullanmanız önerilir.", "Info: To preserve cycle life, use max 50% of Gel battery capacity."));
         }
      }
    }

    String hataMetni = tavsiyeler.isEmpty
        ? t("Sistem tasarımı teknik açıdan uyumlu ve dengeli görünüyor.", "System design looks technically compatible and balanced.")
        : tavsiyeler.map((e) => "• $e").join("\n\n");

    setState(() {
      uretimBilgisi = t(
        "Kurulu Panel Gücü: ${toplamPanelkW.toStringAsFixed(2)} kW\nTahmini Günlük Üretim: ${gunlukUretimkWh.toStringAsFixed(2)} kWh\nToplam Depolama (Akü): ${toplamAkukWh.toStringAsFixed(2)} kWh",
        "Total Panel Power: ${toplamPanelkW.toStringAsFixed(2)} kW\nEst. Daily Prod.: ${gunlukUretimkWh.toStringAsFixed(2)} kWh\nTotal Storage (Bat): ${toplamAkukWh.toStringAsFixed(2)} kWh"
      );
      hataVeTavsiyeler = hataMetni;
      hesaplandi = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: cInputBg(), borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: TextField(controller: _panelGucuCtrl, keyboardType: TextInputType.number, style: TextStyle(color: cText()), decoration: customInputDec(t('Panel Gücü (Wp)', 'Panel Power (Wp)')))),
                const SizedBox(width: 10),
                Expanded(child: TextField(controller: _panelAdetCtrl, keyboardType: TextInputType.number, style: TextStyle(color: cText()), decoration: customInputDec(t('Panel Adedi', 'Panel Count')))),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: TextField(controller: _invGucuCtrl, keyboardType: TextInputType.number, style: TextStyle(color: cText()), decoration: customInputDec(t('İnvertör Gücü (kW)', 'Inv. Power (kW)')))),
                const SizedBox(width: 10),
                Expanded(
                  child: Drop(label: t('İnvertör Tipi', 'Inv. Type'), value: invTipi, items: const ['Off-Grid', 'On-Grid', 'Hibrit'], onChanged: (v) => setState(() { invTipi = v!; hesaplandi = false; }))
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: TextField(controller: _akuAhCtrl, keyboardType: TextInputType.number, style: TextStyle(color: cText()), decoration: customInputDec(t('1 Akü Akımı (Ah)', '1 Bat. Current (Ah)')))),
                const SizedBox(width: 10),
                Expanded(child: TextField(controller: _akuAdetCtrl, keyboardType: TextInputType.number, style: TextStyle(color: cText()), decoration: customInputDec(t('Akü Adedi', 'Battery Count')))),
              ],
            ),
            const SizedBox(height: 12),
            Drop(label: t('Akü Tipi (Teknoloji)', 'Battery Tech'), value: akuTipi, items: const ['Jel', 'Lityum'], onChanged: (v) => setState(() { akuTipi = v!; hesaplandi = false; })),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: analizEt, child: Text(t('SİSTEMİ ANALİZ ET', 'ANALYZE SYSTEM'))),
            const SizedBox(height: 20),
            
            if (hesaplandi)
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(color: cCardAlpha(), borderRadius: BorderRadius.circular(8), border: Border.all(color: cIcon().withValues(alpha: 0.5))),
                    child: Column(
                      children: [
                        Text(t('Sistem Performansı', 'System Performance'), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: cIcon())),
                        const SizedBox(height: 8),
                        Text(uretimBilgisi, style: TextStyle(fontSize: 14, color: cText(), height: 1.5), textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                  ResultCard(title:'Değerlendirme', value:hataVeTavsiyeler, subtitle:hataVeTavsiyeler.contains('•') ? 'Teknik kontrol / revizyon gerekli' : 'Ön değerlendirmede belirgin uyumsuzluk görülmedi', good:!hataVeTavsiyeler.contains('•'), error:hataVeTavsiyeler.contains('•'))
                ],
              )
          ],
        ),
      ),
    );
  }
}

// ================= 6. TOPRAKLAMA SINIR DEĞERİ =================

class GesCatiTasarimEkrani extends StatefulWidget { const GesCatiTasarimEkrani({super.key}); @override State<GesCatiTasarimEkrani> createState()=>_GesCatiTasarimEkraniState(); }
class _GesCatiTasarimEkraniState extends State<GesCatiTasarimEkrani>{
  final en=TextEditingController(text:'20'), boy=TextEditingController(text:'30'), panel=TextEditingController(text:'550'), yatirim=TextEditingController(), maliyetKwp=TextEditingController(text:'650');
  String bolge='İç Anadolu'; String sonuc='';
  final factors=const {'Marmara':3.7,'Ege':4.2,'Akdeniz':4.5,'İç Anadolu':4.3,'Karadeniz':3.2,'Doğu Anadolu':4.0,'Güneydoğu Anadolu':4.6};
  @override void dispose(){en.dispose();boy.dispose();panel.dispose();yatirim.dispose();maliyetKwp.dispose();super.dispose();}
  void hesapla(){
    final w=double.tryParse(en.text.replaceAll(',','.'))??0;
    final h=double.tryParse(boy.text.replaceAll(',','.'))??0;
    final pw=double.tryParse(panel.text.replaceAll(',','.'))??0;
    final usdKwp=double.tryParse(maliyetKwp.text.replaceAll(',','.'))??0;
    if(w<=0||h<=0||pw<=0||usdKwp<=0){setState(()=>sonuc='Giriş değerlerini kontrol edin.');return;}
    final area=w*h;
    final usable=area*0.875;
    final pArea=2.2;
    final n=(usable/pArea).floor();
    final dc=n*pw/1000;
    final invCount=inverterAdediVeGuc(dc*0.9);
    final invUnit=standartInvertorBul(min(dc*0.9,350));
    final invTotal=invCount*invUnit;
    final daily=dc*(factors[bolge]??4.0)*0.8;
    final annual=daily*365;
    final tahminiMaliyet=dc*usdKwp;
    final userBudget=double.tryParse(yatirim.text.replaceAll(',','.'))??0;
    final fark=userBudget>0?tahminiMaliyet-userBudget:0;
    final oran=userBudget>0?(tahminiMaliyet/userBudget*100):0;
    setState(()=>sonuc='Çatı alanı: ${fmt2(area)} m²\nYürüyüş/servis payı sonrası kullanılabilir alan: ${fmt2(usable)} m²\nPanel adedi: $n\nKurulu DC güç: ${fmt2(dc)} kWp\nİnvertör kurgusu: $invCount × $invUnit kW = ${fmt2(invTotal)} kW AC\nTahmini yıllık üretim: ${fmt2(annual)} kWh/yıl\n\nYaklaşık yatırım maliyeti: ${fmt2(tahminiMaliyet)} USD (${fmt2(usdKwp)} USD/kWp varsayımı)\n${userBudget>0?'Kullanıcı yatırım bütçesi: ${fmt2(userBudget)} USD\nBütçe farkı: ${fmt2(fark)} USD\nTahmini maliyet / bütçe: %${fmt2(oran)}':'Kullanıcı yatırım bütçesi girilmedi.'}\n\nDC koruma: string sigortası + DC ayırıcı + SPD değerlendirmesi\nAC koruma: AC şalter/sigorta + ayırıcı + SPD değerlendirmesi');
  }
  @override Widget build(BuildContext context)=>AppScaffold(title:'Çatı Alanından Tasarım',info:true,onInfo:()=>bilgiPopup(context,'Çatı Alanından Tasarım','Çatı eni ve boyundan kurulabilecek yaklaşık panel gücünü çıkarır. Servis/yürüyüş alanı için %12,5 varsayımı kullanılır. Maliyet USD/kWp varsayımıdır ve kullanıcı tarafından güncellenebilir; çevrimdışı uygulamada canlı piyasa fiyatı iddia edilmez.'),body:ScrollBody(children:[
    SectionCard(title:'Çatı Bilgileri',children:[twoCol(Field(controller:en,label:'Çatı Eni (m)'),Field(controller:boy,label:'Çatı Boyu (m)')),twoCol(Field(controller:panel,label:'Panel Gücü (Wp)'),Drop(label:'Türkiye Bölgesi',value:bolge,items:factors.keys.toList(),onChanged:(v)=>setState(()=>bolge=v!))),twoCol(Field(controller:maliyetKwp,label:'Maliyet varsayımı (USD/kWp)'),Field(controller:yatirim,label:'Kullanıcı yatırım bütçesi (USD) — isteğe bağlı')), calcButton('OTOMATİK TASARLA',hesapla)]),
    if(sonuc.isNotEmpty)SectionCard(title:'Otomatik Tasarım Sonucu',children:[Text(sonuc,style:TextStyle(color:cText(),fontSize:13,height:1.5))]),
    AdviceCard(title:'Teknik not',text:'Üretim değeri bölgesel bir ön tahmindir; gerçek sonuç panel yönü/eğimi, gölgelenme, sıcaklık, inverter verimi ve saha koşullarına göre değişir.'),
  ]));
}

