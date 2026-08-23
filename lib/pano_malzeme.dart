part of 'main.dart';

class OgGereksinimEkrani extends StatefulWidget { const OgGereksinimEkrani({super.key}); @override State<OgGereksinimEkrani> createState()=>_OgGereksinimEkraniState(); }
class _OgGereksinimEkraniState extends State<OgGereksinimEkrani>{
  final power=TextEditingController(text:'320');
  String olcu='AG', gerilimOg=esaOgVoltageOptions.first; bool sonucVar=false; String sonuc='';
  double pf = esaDefaultPowerFactor;
  @override void dispose(){power.dispose();super.dispose();}
  void hesapla(){
    final p=double.tryParse(power.text.replaceAll(',', '.'))??0;
    if(p<=0){setState(()=>sonucVar=false);return;}
    final kva=esaKvaFromKw(p,pf);
    final og=olcu=='OG';
    final ogAkimi=kva*1000/(sqrt(3)*double.parse(gerilimOg));
    final ct=og ? standartAkimTrafosuBul(ogAkimi) : '-';
    final hucre=og ? 'Giriş Hücresi + Ölçü Hücresi + gerekli çıkış/trafo koruma hücresi' : 'Ölçü hücresi eklenmez; AG ölçüm düzeni değerlendirilir.';
    setState(()=>sonuc='Talep gücü: ${p.toStringAsFixed(1)} kW\nYaklaşık görünür güç: ${kva.toStringAsFixed(1)} kVA (cosφ=${pf.toStringAsFixed(2)})\n\nÖlçüm tipi: ${og?'OG':'AG'}\nOG bağlantı değerlendirmesi: ${og?'GEREKİYOR':'Bu girişlere göre AG tarafı öncelikli'}\n\nHücre düzeni: $hucre\nOG gerilimi: ${gerilimOg} V\nOG tarafı hesaplanan akım: ${ogAkimi.toStringAsFixed(2)} A\nAkım trafosu ön referansı: $ct\nGerilim trafosu: ${og?'Ölçü/koruma fonksiyonuna göre uygun sınıf ve oran seçilmelidir.':'-'}\n\nKesin hücre fonksiyonları, kısa devre dayanımı, ölçü sınıfı ve dağıtım şirketi bağlantı görüşü onaylı projeye göre belirlenmelidir.');
    sonucVar=true;
  }
  @override Widget build(BuildContext context)=>AppScaffold(title:'OG Hücre / Ölçü Gereksinimi',info:true,onInfo:()=>bilgiPopup(context,'OG Hücre / Ölçü Gereksinimi','Ölçüm tipi ve talep gücünden hareketle OG ölçü hücresi ile giriş/çıkış/trafo koruma fonksiyonlarını ön değerlendirme olarak gösterir. Kesin bağlantı şekli dağıtım şirketinin bağlantı görüşü ve onaylı projeye göre belirlenir.'),body:ScrollBody(children:[
    SectionCard(title:'Tesis Bilgileri',children:[
      Field(controller:power,label:'Talep gücü (kW)'),
      Drop(label:'Ölçüm Tipi (Faturaya Esas)',value:olcu,items:const ['AG','OG'],onChanged:(v)=>setState((){olcu=v!;sonucVar=false;})),
      Drop(label:'OG Gerilimi',value:gerilimOg,items:esaOgVoltageOptions,onChanged:(v)=>setState((){gerilimOg=v!;sonucVar=false;})),
      Drop(label:'Güç Faktörü (cosφ)',value:pf.toStringAsFixed(2),items:const ['0.80','0.85','0.90','0.95','0.98','1.00'],onChanged:(v)=>setState((){pf=double.tryParse(v??'')??esaDefaultPowerFactor;sonucVar=false;})),
      calcButton('GEREKSİNİMLERİ DEĞERLENDİR',hesapla),
    ]),
    if(sonucVar) ...[...resultSectionCardsFromText(sonuc, fallbackTitle:'Teknik sonuç', fallbackNote:'Sonuç ön değerlendirmedir; seçilen ekipman ve bağlantı koşulları proje/şartname/üretici verileriyle kesinleştirilmelidir.', icons: const [Icons.electrical_services_outlined, Icons.verified_outlined])],
    const AdviceCard(title:'Kesinlik uyarısı',text:'Güç tek başına hücre sayısını, CT/VT oranını veya koruma fonksiyonlarını kesinleştirmez. Bağlantı görüşü, kısa devre seviyesi, tesis topolojisi, ölçü sınıfı ve güncel dağıtım şirketi şartları ayrıca kontrol edilmelidir.',error:true),
  ]));
}

// ================= YENI MODUL ORTAK WIDGETLARI =================

class AnaPanoSecimiEkrani extends StatefulWidget {
  const AnaPanoSecimiEkrani({super.key});
  @override
  State<AnaPanoSecimiEkrani> createState() => _AnaPanoSecimiEkraniState();
}

class _AnaPanoSecimiEkraniState extends State<AnaPanoSecimiEkrani> {
  final _gucCtrl = TextEditingController();
  String gerilimTipi = 'Trifaze';
  String aboneGrubu = 'Diğer';
  bool teorikMonofaze = false;
  double pf = esaDefaultPowerFactor;
  
  double akim = 0;
  int cikisTms = 0;
  int girisTms = 0;
  String kabloKesiti = "-";
  String girisKakr = "-";
  String cikisKakr = "-";
  String akimTrafosu = "-";
  String baraTipi = "-";
  
  String hataMesaji = "";
  bool hesaplandi = false;

  @override
  void dispose() {
    _gucCtrl.dispose();
    super.dispose();
  }

  void hesapla() {
    FocusManager.instance.primaryFocus?.unfocus();
    double p = double.tryParse(_gucCtrl.text.replaceAll(',', '.')) ?? 0;
    
    if (p == 0) { setState(() { hesaplandi = false; }); return; }
    
    hataMesaji = (gerilimTipi == 'Monofaze' && p > 21)
        ? "Teknik uygunluk uyarısı: Monofaze tesisatta 20 kW üzeri talep gücü genel uygulama sınırları açısından uygun değildir. Aşağıdaki sonuç yalnızca teorik hesaplamadır ve sahada uygulanabilirlik anlamına gelmez."
        : "";
    
    if (gerilimTipi == 'Monofaze' && aboneGrubu == 'Mesken' && p > 21 && !teorikMonofaze) { setState(() { hesaplandi=false; hataMesaji='Mesken abonelerinde 21 kW üzeri monofaze seçim uygun değildir. Trifaze seçin veya teorik hesap onayını işaretleyin.'; }); return; }
    double i = (gerilimTipi == 'Trifaze') ? esaThreePhaseCurrentFromKw(p, esaAgThreePhaseVoltage, pf) : esaSinglePhaseCurrentFromKw(p, esaAgSinglePhaseVoltage, pf);
    final List<int> standartlar = esaStandardProtectionRatings;
    
    int outFuse = standartlar.firstWhere((val) => val >= i, orElse: () => 4000);
    if (outFuse < 16) outFuse = 16;
    
    int outIndex = standartlar.indexOf(outFuse);
    int inFuse = standartlar[outIndex < standartlar.length - 1 ? outIndex + 1 : outIndex];
    if (inFuse < 25) inFuse = 25;

    String k = standartKabloBulNYY(inFuse.toDouble(), gerilimTipi == 'Trifaze'); 
    String aT = p > 320 ? '${standartAkimTrafosuBul(min(i, 5000).toDouble())} — OG den ölçü / x/5 sayaç' : aboneGrubu == 'Mesken' ? (p <= 30 ? 'AG den ölçüm — direkt bağlı aktif sayaç' : '${standartAkimTrafosuBul(min(i, 5000).toDouble())} — AG den ölçüm / x/5 sayaç') : (p <= 9 ? 'AG den ölçüm — direkt bağlı aktif sayaç' : p <= 30 ? 'AG den ölçüm — kombi sayaç' : '${standartAkimTrafosuBul(min(i, 5000).toDouble())} — AG den ölçüm / x/5 sayaç');
    String b = inFuse > 1600 ? 'Kayar Bara' : standartBaraBul(inFuse.toDouble());
    
    String cKakr = standartKakrBul(outFuse, t("30mA (Hayat Koruma)", "30mA (Life Prot.)"));
    String gKakr = standartKakrBul(inFuse, t("300mA (Yangın Koruma)", "300mA (Fire Prot.)"));

    setState(() { 
      akim = i; cikisTms = outFuse; girisTms = inFuse; kabloKesiti = k; cikisKakr = cKakr; girisKakr = gKakr; akimTrafosu = aT; baraTipi = b; hesaplandi = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeLangWrapper(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text(t('AG Pano Malzeme Seçimi', 'LV Panel Materials'), style: const TextStyle(fontSize: 16)),
          actions: [IconButton(icon: const Icon(Icons.info_outline), onPressed: () => bilgiPopup(context, t('AG Pano Malzeme Seçimi', 'LV Panel Material Selection'), t('Talep gücü ve güç faktörüne göre mevzuat ve teknik şartnamelere (selektivite) uygun şekilde panoda olması gereken tüm temel ekipmanları hesaplar.', 'Calculates all basic equipment required in the panel in accordance with regulations and technical specifications.')))],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: cInputBg(), borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(child: TextField(controller: _gucCtrl, keyboardType: TextInputType.number, style: TextStyle(color: cText()), decoration: customInputDec(t('Talep Gücü (kW)', 'Demand Pwr. (kW)')))),
                    const SizedBox(width: 10),
                    Expanded(child: Drop(label: t('Gerilim', 'Voltage'), value: gerilimTipi, items: const ['Trifaze', 'Monofaze'], onChanged: (v) => setState(() { gerilimTipi = v!; hesaplandi = false; }))),
                  ],
                ),
                Drop(label: 'Abone Grubu', value: aboneGrubu, items: const ['Mesken','Diğer'], onChanged: (v) => setState(() { aboneGrubu=v!; hesaplandi=false; })),
                if (gerilimTipi == 'Monofaze' && aboneGrubu == 'Mesken') CheckboxListTile(contentPadding:EdgeInsets.zero,value:teorikMonofaze,onChanged:(v)=>setState(()=>teorikMonofaze=v??false),title:const Text('Riskin farkındayım — teorik hesap istiyorum',style:TextStyle(fontSize:12,fontWeight:FontWeight.w700)),subtitle:const Text('21 kW üzeri monofaze mesken hesabını yalnızca teorik olarak çalıştırır.',style:TextStyle(fontSize:10.5))),
                const SizedBox(height: 20),
                Text('${t('Güç Faktörü', 'Power Factor')} (cosφ): ${pf.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold, color: cText())),
                Slider(value: pf, min: 0.80, max: 1.0, activeColor: cIcon(), onChanged: (v) => setState(() { pf = v; hesaplandi = false; })),
                const SizedBox(height: 15),
                ElevatedButton(onPressed: hesapla, child: Text(t('HESAPLA', 'CALCULATE'))),
                const SizedBox(height: 20),
                
                if (hataMesaji.isNotEmpty)
                  Container(margin: const EdgeInsets.only(bottom: 20), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: cCard(), border: Border.all(color: Colors.red.shade700, width: 1.3), borderRadius: BorderRadius.circular(8)), child: Text(hataMesaji, style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.bold), textAlign: TextAlign.left)),

                if (hesaplandi)
                  Column(
                    children: [
                      uiResultCard(t('Çekilen Akım', 'Drawn Current'), akim.toStringAsFixed(2), 'A'),
                      uiResultCard(t('Giriş Sigorta / TMŞ (Selektif)', 'Input Fuse / MCCB (Selective)'), girisTms.toString(), 'A'),
                      uiResultCard(t('Çıkış Sigorta / TMŞ (Selektif)', 'Output Fuse / MCCB (Selective)'), cikisTms.toString(), 'A'),
                      uiResultCard(t('Ön Seçim Kablo Kesiti', 'Preselected Cable Section'), kabloKesiti, ''),
                      uiResultCard(t('Akım Trafosu', 'Current Transformer'), akimTrafosu, ''),
                      uiResultCard(t('Giriş Kaçak Akım Koruması (KAKR)', 'Input Leakage Current Prot.'), girisKakr, ''),
                      uiResultCard(t('Çıkış Kaçak Akım Koruması (KAKR)', 'Output Leakage Current Prot.'), cikisKakr, ''),
                      uiResultCard(t('Bara Seçimi (Cu)', 'Busbar Selection (Cu)'), baraTipi, ''),
                      if ((double.tryParse(_gucCtrl.text.replaceAll(',', '.')) ?? 0) > 320) AdviceCard(title: 'OG değerlendirmesi', text: 'Talep gücü yüksek seviyeye ulaştığında OG bağlantı, ölçü hücresi, akım/gerilim trafoları ve dağıtım şirketi bağlantı görüşü ayrıca değerlendirilmelidir.', error: true),
                      
                      const SizedBox(height: 15),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: cCardAlpha(), border: Border.all(color: cIcon().withValues(alpha: 0.5)), borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.info, color: cIcon(), size: 20),
                            const SizedBox(width: 8),
                            Expanded(child: Text(t('Not: Dağıtım/TEDAŞ şartnameleri gereği şebeke koruması için giriş sigortası çıkış sigortasından asgari bir üst standartta, min. giriş 25A ve min. çıkış 16A olacak şekilde selektif ayarlanmıştır. Kablo kesiti bakır için min. 6mm² alınmıştır.', 'Note: Per utility specifications, the input fuse is set at least one standard level above the output fuse for selectivity, with a min. input of 25A and min. output of 16A. Copper cable min. section is 6mm².'), style: TextStyle(fontSize: 12, color: cText(), height: 1.3))),
                          ],
                        ),
                      )
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ================= 3. KOMPANZASYON MERKEZİ =================

class OgTrafoStandartPanoEkrani extends StatefulWidget {
  const OgTrafoStandartPanoEkrani({super.key});
  @override State<OgTrafoStandartPanoEkrani> createState()=>_OgTrafoStandartPanoEkraniState();
}

class _OgTrafoStandartPanoEkraniState extends State<OgTrafoStandartPanoEkrani>{
  String kva='100', gerilim=esaAgThreePhaseVoltage.toStringAsFixed(0), trafoTipi='Hermetik', sogutma='ONAN', sargi='Bakır', grup='Dyn11';
  bool al=false; String? sonuc;
  final std=const ['50','100','160','200','250','315','400','500','630','800','1000','1250','1600','2000','2500'];
  TrafoReferans? get ref => trafoBul(int.parse(kva));
  void hesapla(){
    final s=double.tryParse(kva)??0, voltage=double.tryParse(gerilim)??400; if(s<=0||voltage<=0)return;
    final i=s*1000/(sqrt(3)*voltage), r=ref;
    final cable=al?'Alüminyum AG kablo sistemi — proje ve döşeme şartına göre ayrıca boyutlandırılmalı':(r?.agAnaKabloYerAlti??standartKabloBulNYY(i,true));
    final bara=al?'Alüminyum bara — sürekli akım/kısa devre hesabı ile seçilmeli':(r?.agBara??standartBaraBul(i));
    final koruma=r?.anaKorumaReferansi ?? (standartTMSBul(i)==null ? 'Hesaplanan akımı karşılayan standart koruma bulunamadı' : '${standartTMSBul(i)} A sınıfı ön referans');
    final ct=i>800?standartAkimTrafosuBul(i):'Ölçü şekline göre CT değerlendirmesi';
    setState(()=>sonuc='Trafo gücü: ${fmt2(s)} kVA\nAG tarafı anma akımı: ${fmt2(i)} A @ ${fmt2(voltage)} V\nTrafo tipi: $trafoTipi\nSoğutma: $sogutma\nSargı: $sargi\nBağlantı grubu: $grup\nAG ana kablo referansı — yeraltı: $cable\nAG ana kablo referansı — hava: ${r?.agAnaKabloHava??'Tablo verisi yok'}\nAG ana bara referansı: $bara\nAna koruma referansı: $koruma\nTermik ayar referansı: ${r?.termikAyarReferansi??'Proje ile belirlenmeli'}\nAkım trafosu: $ct');
  }
  void teknikBilgiyiGoster(){
    final r=ref;
    final yagi=trafoTipi=='Kuru Tip'?'Yağ yok':'Üretici teknik föyünden alınmalıdır.';
    bilgiPopup(context,'Trafo Teknik Bilgileri','Seçilen trafo: ${kva} kVA\n\nTip: $trafoTipi\nSoğutma: $sogutma\nSargı malzemesi: $sargi\nBağlantı grubu: $grup\nAG gerilimi: ${gerilim} V\n\nYağ miktarı: $yagi\nTrafo ağırlığı: Üretici teknik föyünden alınmalıdır.\n\nAG bara referansı: ${r?.agBara??'Tablo verisi yok'}\nAG ana kablo yeraltı referansı: ${r?.agAnaKabloYerAlti??'Tablo verisi yok'}\nAG ana kablo hava referansı: ${r?.agAnaKabloHava??'Tablo verisi yok'}\nAna koruma referansı: ${r?.anaKorumaReferansi??'Proje ile belirlenmeli'}\n\nNot: Yağ miktarı, ağırlık, kayıplar, empedans, boyutlar ve diğer üreticiye bağlı teknik değerler marka/model bazında değişir; kesin değer için üretici teknik föyü esas alınmalıdır.');
  }
  @override Widget build(BuildContext context)=>AppScaffold(title:'OG Trafo Standart Pano',info:true,onInfo:()=>bilgiPopup(context,'OG Trafo Standart Pano','Trafo gücünden AG pano ön malzeme listesini ve seçilen trafonun temel teknik özelliklerini tek araçta gösterir. Trafo tipi, sargı, soğutma ve bağlantı grubu kullanıcı tarafından seçilir. Yağ miktarı, ağırlık ve üreticiye bağlı değerler kesin olarak üretici teknik föyünden doğrulanmalıdır.'),body:ScrollBody(children:[
    SectionCard(title:'Trafo / AG Çıkış',children:[
      Drop(label:'Trafo Gücü (kVA)',value:kva,items:std,onChanged:(v)=>setState(()=>kva=v!)),
      twoCol(Drop(label:'AG Gerilimi (V)',value:gerilim,items:esaAcVoltageOptions,onChanged:(v)=>setState(()=>gerilim=v!)),Drop(label:'Trafo Tipi',value:trafoTipi,items:const ['Hermetik','Kuru Tip','Yağlı Tip'],onChanged:(v)=>setState(()=>trafoTipi=v!))),
      twoCol(Drop(label:'Soğutma',value:sogutma,items:const ['ONAN','ONAF','AN'],onChanged:(v)=>setState(()=>sogutma=v!)),Drop(label:'Sargı Malzemesi',value:sargi,items:const ['Bakır','Alüminyum'],onChanged:(v)=>setState(()=>sargi=v!))),
      Drop(label:'Bağlantı Grubu',value:grup,items:const ['Dyn11','Dyn5','Yyn0','Diğer / Üreticiye göre'],onChanged:(v)=>setState(()=>grup=v!)),
      Drop(label:'AG İletken',value:al?'Alüminyum':'Bakır',items:const ['Bakır','Alüminyum'],onChanged:(v)=>setState(()=>al=v=='Alüminyum')),
      Row(children:[Expanded(child:calcButton('PANOYU HESAPLA',hesapla)),const SizedBox(width:10),Expanded(child:OutlinedButton(onPressed:teknikBilgiyiGoster,child:const Text('TEKNİK BİLGİLERİ GÖSTER')))]),
    ]),
    if(sonuc!=null) ...[...resultSectionCardsFromText(sonuc!, fallbackTitle:'Sıralı Ön Malzeme / Teknik Sonuç', fallbackNote:'Trafo ve pano malzemeleri ön seçimdir; üretici teknik föyü, kısa devre dayanımı, bağlantı görüşü ve onaylı proje ile doğrulanmalıdır.', icons: const [Icons.inventory_2_outlined, Icons.electrical_services_outlined, Icons.verified_outlined])],
    AdviceCard(title:'Bilgi / Yardım',text:'Trafo gücü seçildiğinde AG anma akımı, pano ana kablo/bara ve koruma ön referansları hesaplanır. Teknik bilgiler bölümünde trafo tipi, soğutma, sargı ve bağlantı grubu gösterilir. Yağ miktarı ve ağırlık gibi üreticiye özgü değerler kesin olarak marka/model teknik föyünden alınmalıdır. Kısa devre empedansı, kayıplar, sıcaklık artışı, izolasyon seviyesi, koruma koordinasyonu ve saha koşulları ayrıca doğrulanmalıdır.'),
  ]));
}
