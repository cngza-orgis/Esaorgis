part of 'main.dart';

class KompanzasyonAnaEkrani extends StatefulWidget { const KompanzasyonAnaEkrani({super.key}); @override State<KompanzasyonAnaEkrani> createState()=>_KompanzasyonAnaEkraniState(); }
class _KompanzasyonAnaEkraniState extends State<KompanzasyonAnaEkrani>{
  int sekme=0;
  @override Widget build(BuildContext context)=>AppScaffold(title:'Kompanzasyon Merkezi',info:true,onInfo:()=>bilgiPopup(context,'Kompanzasyon Merkezi','Fatura/reaktif analiz, mevcut sistem analizi ve yeni pano/kademe tasarımını tek merkezde toplar.'),body:Column(children:[
    Padding(padding:const EdgeInsets.fromLTRB(14,10,14,4),child:Row(children:[Expanded(child:_seg('Fatura / Ceza Kontrol',0)),const SizedBox(width:8),Expanded(child:_seg('Pano Tasarım / Kademe',1))])),
    Expanded(child:sekme==0?const _KompFaturaTab():const _KompPanoTab()),
  ]));
  Widget _seg(String text,int i)=>InkWell(borderRadius:BorderRadius.circular(8),onTap:()=>setState(()=>sekme=i),child:Container(padding:const EdgeInsets.symmetric(vertical:10),decoration:BoxDecoration(color:sekme==i?cIcon():cCard(),borderRadius:BorderRadius.circular(8),border:Border.all(color:cIcon().withValues(alpha: .35))),child:Text(text,textAlign:TextAlign.center,style:TextStyle(color:sekme==i?Colors.white:cText(),fontWeight:FontWeight.w800,fontSize:12))));
}

class KompPanoTasarimEkrani extends StatelessWidget { const KompPanoTasarimEkrani({super.key}); @override Widget build(BuildContext context)=>AppScaffold(title:'Kompanzasyon — Pano Tasarımı',info:true,onInfo:()=>bilgiPopup(context,'Pano Tasarımı','Yeni kompanzasyon panosunun gerekli kVAr gücü, kademe dizilimi ve ön tasarımını gösterir.'),body:const _KompPanoTab()); }

class _KompFaturaTab extends StatefulWidget {
  const _KompFaturaTab();
  @override
  State<_KompFaturaTab> createState() => _KompFaturaTabState();
}
class _KompFaturaTabState extends State<_KompFaturaTab> {
  final _sozlesmeGucu = TextEditingController();
  final _tIlk = TextEditingController(), _tSon = TextEditingController();
  final _t1Ilk = TextEditingController(), _t1Son = TextEditingController();
  final _t2Ilk = TextEditingController(), _t2Son = TextEditingController();
  final _t3Ilk = TextEditingController(), _t3Son = TextEditingController();
  final _riIlk = TextEditingController(), _riSon = TextEditingController();
  final _rcIlk = TextEditingController(), _rcSon = TextEditingController();
  String sonuc = '';
  String uyari = '';
  bool hesaplandi = false;

  @override
  void dispose() {
    _sozlesmeGucu.dispose();
    for (final c in [_tIlk,_tSon,_t1Ilk,_t1Son,_t2Ilk,_t2Son,_t3Ilk,_t3Son,_riIlk,_riSon,_rcIlk,_rcSon]) { c.dispose(); }
    super.dispose();
  }

  double _v(TextEditingController c) => double.tryParse(c.text.trim().replaceAll(',', '.')) ?? 0.0;
  bool _dolu(TextEditingController a, TextEditingController b) => a.text.trim().isNotEmpty && b.text.trim().isNotEmpty;
  double? _delta(TextEditingController a, TextEditingController b) => _dolu(a,b) ? max(0, _v(b)-_v(a)) : null;

  void hesapla() {
    FocusManager.instance.primaryFocus?.unfocus();
    final guc = _v(_sozlesmeGucu);
    final uyarilar = <String>[];
    double? aktif;

    // Öncelik: T toplam. T boşsa T1/T2/T3'ten girilmiş olanların toplamı.
    final t = _delta(_tIlk, _tSon);
    if (t != null) {
      aktif = t;
      if (_dolu(_t1Ilk,_t1Son) || _dolu(_t2Ilk,_t2Son) || _dolu(_t3Ilk,_t3Son)) {
        uyarilar.add('T toplam endeksi kullanıldı; T1/T2/T3 endeksleri karşılaştırma amacıyla ayrıca girilmiş olabilir.');
      }
    } else {
      final vals = <double>[];
      final t1 = _delta(_t1Ilk,_t1Son); if (t1 != null) vals.add(t1);
      final t2 = _delta(_t2Ilk,_t2Son); if (t2 != null) vals.add(t2);
      final t3 = _delta(_t3Ilk,_t3Son); if (t3 != null) vals.add(t3);
      if (vals.isNotEmpty) aktif = vals.fold<double>(0.0, (a, b) => a + b);
    }

    // RI/RC birbirinden bağımsızdır; biri boşsa diğeri yine hesaplanır.
    final ri = _delta(_riIlk,_riSon) ?? 0.0;
    final rc = _delta(_rcIlk,_rcSon) ?? 0.0;
    if (_riIlk.text.isNotEmpty != _riSon.text.isNotEmpty) uyarilar.add('RI için ilk/son endeksten biri eksik; RI hesabı atlandı.');
    if (_rcIlk.text.isNotEmpty != _rcSon.text.isNotEmpty) uyarilar.add('RC için ilk/son endeksten biri eksik; RC hesabı atlandı.');
    if (aktif == null || aktif <= 0) {
      setState(() { hesaplandi=false; sonuc=''; uyari='T toplamı veya T1/T2/T3 sayaç endekslerinden en az bir tam ilk/son çifti girilmelidir.'; });
      return;
    }

    final indOran = ri / aktif * 100;
    final kapOran = rc / aktif * 100;
    final limitInd = guc > 0 && guc > 30 ? 20.0 : 33.0;
    final limitKap = guc > 0 && guc > 30 ? 15.0 : 20.0;
    final indBad = indOran > limitInd;
    final kapBad = kapOran > limitKap;
    final bad = indBad || kapBad;
    if (guc <= 0) uyarilar.add('Sözleşme gücü girilmediği için limit karşılaştırması ön değerlendirme olarak gösterildi.');

    setState(() {
      sonuc = 'Aktif tüketim: ${aktif!.toStringAsFixed(1)} kWh\nRI tüketimi: ${ri.toStringAsFixed(1)} kVArh (%${indOran.toStringAsFixed(2)})\nRC tüketimi: ${rc.toStringAsFixed(1)} kVArh (%${kapOran.toStringAsFixed(2)})\n\n${bad ? 'DURUM: UYGUN DEĞİL / KONTROL GEREKLİ' : 'DURUM: UYGUN / ÖN DEĞERLENDİRMEDE SINIR İÇİNDE'}';
      uyari = uyarilar.join('\n');
      hesaplandi = true;
    });
  }

  Widget _alan(String lbl, TextEditingController c) => Expanded(child: Field(controller:c,label:lbl));
  Widget _endeksSatiri(String a, TextEditingController ai, TextEditingController ason) => Padding(padding:const EdgeInsets.only(bottom:8),child:Row(children:[_alan('$a İlk Endeks',ai),const SizedBox(width:8),_alan('$a Son Endeks',ason)]));

  @override
  Widget build(BuildContext context) => ScrollBody(children:[
    SectionCard(title:'Sayaç Endeksleri — İlk / Son',children:[
      Field(controller:_sozlesmeGucu,label:'Sözleşme Gücü (kW) — isteğe bağlı'),
      AdviceCard(title:'Limit ön notu',text:'9–30 kW sözleşme gücünde endüktif %33 / kapasitif %20; 30 kW üzeri sözleşme gücünde endüktif %20 / kapasitif %15 sınırları ön değerlendirmede esas alınır. Kesin uygulama güncel mevzuat ve tarife ile doğrulanmalıdır.'),
      const SizedBox(height:4),
      _endeksSatiri('T Toplam',_tIlk,_tSon),
      _endeksSatiri('T1',_t1Ilk,_t1Son),
      _endeksSatiri('T2',_t2Ilk,_t2Son),
      _endeksSatiri('T3',_t3Ilk,_t3Son),
      const Divider(),
      _endeksSatiri('RI İndüktif',_riIlk,_riSon),
      _endeksSatiri('RC Kapasitif',_rcIlk,_rcSon),
      Text('T toplam girilirse T1/T2/T3 zorunlu değildir. T toplam boşsa girilmiş olan T1, T2 ve/veya T3 çiftleri toplanır. RI ve RC de birbirinden bağımsız hesaplanır.',style:TextStyle(color:cText(),fontSize:11,height:1.35)),
      const SizedBox(height:10),
      calcButton('FATURA / KOMPANZASYONU ANALİZ ET',hesapla),
    ]),
    if(uyari.isNotEmpty) AdviceCard(title:'Veri notu',text:uyari),
    if(hesaplandi)...[
      ResultCard(title:'Analiz Sonucu',value:sonuc,subtitle:'Endeks hesabı ön değerlendirmedir; güncel tarife, abone grubu ve dağıtım şirketi limitleri ayrıca doğrulanmalıdır.',good:sonuc.contains('UYGUN /'),error:sonuc.contains('UYGUN DEĞİL')),
      AdviceCard(title:'Düzeltme / Onarım Önerisi',text:sonuc.contains('UYGUN DEĞİL')?'Kompanzasyon rölesi ölçümü, CT oranı/yönü, kademe kontaktörleri, kondansatörlerin kapasitesi, şönt reaktörler ve harmonik seviyesi sahada kontrol edilmelidir. Gerekirse Mevcut Sistem Analizi ile pano tersine mühendisliği yapılmalıdır.':'Kademe devreye girme/çıkma kayıtları, CT bağlantısı ve reaktif sayaç endeksleri periyodik olarak kontrol edilmelidir.'),
      if(sonuc.contains('UYGUN DEĞİL')) OutlinedButton.icon(icon:const Icon(Icons.query_stats_rounded),label:const Text('MEVCUT SİSTEM ANALİZİNE GİT'),onPressed:()=>Navigator.push(context,materialRoute(const KompMevcutSistemAnaliziEkrani()))),
    ],
    AdviceCard(title:'Teknik dayanak notu',text:'Bu araç fatura/sayaç endekslerinden reaktif oranların ön değerlendirmesini yapar. Kesin ceza veya kabul kararı; güncel mevzuat, tarife, sözleşme, sayaç yapısı ve dağıtım şirketi uygulamasına göre verilmelidir.'),
  ]);
}

class _KompPanoTab extends StatefulWidget {
  const _KompPanoTab();
  @override
  State<_KompPanoTab> createState() => _KompPanoTabState();
}
class _KompPanoTabState extends State<_KompPanoTab> {
  final sistemGucu=TextEditingController();
  final ctOran=TextEditingController();
  String kademe='6', analizor='Var', harmonik='Bilinmiyor', reaktor='Yok';
  double pfMevcut=0.80,pfHedef=0.98, gerilim=400;
  List<_KompTasarimKademe> kademeler=List.generate(6,(_)=>_KompTasarimKademe());
  bool hesaplandi=false;
  String sonuc='', detay='';
  double gerekli=0, toplam=0;

  @override void dispose(){sistemGucu.dispose();ctOran.dispose();for(final k in kademeler)k.dispose();super.dispose();}
  void _kademe(String v){
    for(final k in kademeler)k.dispose();
    setState(() {
      kademe=v;
      kademeler=List.generate(int.parse(v),(_)=>_KompTasarimKademe());
      hesaplandi=false;
    });
  }
  double _v(TextEditingController c)=>double.tryParse(c.text.replaceAll(',','.'))??0;
  void tasarla(){
    FocusManager.instance.primaryFocus?.unfocus();
    final p=_v(sistemGucu);
    if(p<=0){setState(()=>hesaplandi=false);return;}
    gerekli=max(0,p*(tan(acos(pfMevcut))-tan(acos(pfHedef))));
    final girilen=kademeler.map((x)=>_v(x.kvar)).toList();
    toplam=girilen.fold(0.0,(a,b)=>a+b);
    final hasManual=toplam>0;
    final hedefToplam=hasManual?toplam:gerekli;
    final fazA=p*1000/(sqrt(3)*gerilim*pfHedef);
    final anaKoruma=standartTMSBul(fazA);
    final bara=standartBaraBul(fazA);
    final kablo=standartKabloBulNYY(fazA,true);
    final ct=_v(ctOran)>0?ctOran.text:'Yaklaşık ${standartAkimTrafosuBul(fazA)}';
    final kademeList=hasManual?girilen:[for(int i=0;i<int.parse(kademe);i++) _otomatikKademe(i,int.parse(kademe),hedefToplam)];
    final hedefKontrol=hasManual ? (gerekli > 0 ? toplam/gerekli : 1.0) : 1.0;
    final risk=hedefKontrol>1.20?'Aşırı kompanzasyon riski':hedefKontrol<0.80?'Kompanzasyon kapasitesi yetersiz':'Kademe toplamı hesaplanan ihtiyaca yakın';
    setState((){
      sonuc='Önerilen toplam: ${hedefToplam.toStringAsFixed(1)} kVAr\nGerekli teorik güç: ${gerekli.toStringAsFixed(1)} kVAr\nAna akım: ${fazA.toStringAsFixed(1)} A\nAna koruma ön seçimi: $anaKoruma A\nAG ana bara ön seçimi: $bara\nAG besleme kablosu ön seçimi: $kablo';
      final kademeDetay = kademeList.asMap().entries.map((e){
        final kv=e.value;
        final stageA=kv*1000/(sqrt(3)*gerilim);
        final kontaktor=standartKontaktorBul(stageA);
        final kademeKoruma=standartTMSBul(stageA*1.5);
        final reaktorBilgi=kademeler[e.key].reaktor?'Reaktör: VAR':'Reaktör: YOK';
        return 'K${e.key+1}: ${kv.toStringAsFixed(1)} kVAr | yaklaşık ${stageA.toStringAsFixed(1)} A | kontaktör ön seçimi ${kontaktor} A | kademe koruması ön seçimi ${kademeKoruma} A | $reaktorBilgi';
      }).join('\n');
      detay='CT: $ct\nAnalizör / röle: $analizor\nHarmonik durumu: $harmonik\nReaktör yaklaşımı: $reaktor\nDurum: $risk\n\nKademe yapısı:\n$kademeDetay\n\nTasarım sırası: Ana giriş → koruma → ölçü/CT → kompanzasyon rölesi/analizör → kademe korumaları → kapasitif yüke uygun kontaktörler → kondansatörler → şönt reaktör (gerekiyorsa) → bara/kablo → pano havalandırma ve yardımcı devreler.';
      hesaplandi=true;
    });
  }
  double _otomatikKademe(int i,int n,double total){
    final oran=n==6?[0.05,0.10,0.10,0.15,0.25,0.35]:List<double>.filled(n,1/n);
    return total*oran[i];
  }
  Widget _kademeSatiri(int i){final k=kademeler[i];return Row(children:[SizedBox(width:34,child:Text('K${i+1}',style:TextStyle(fontWeight:FontWeight.bold,color:cText()))),Expanded(child:Field(controller:k.kvar,label:'Kondansatör kVAr')),const SizedBox(width:6),SizedBox(width:118,child:CheckboxListTile(contentPadding:EdgeInsets.zero,dense:true,title:const Text('Reaktör',style:TextStyle(fontSize:10)),value:k.reaktor,onChanged:(v)=>setState(()=>k.reaktor=v??false))) ]);}
  @override Widget build(BuildContext context)=>ScrollBody(children:[
    SectionCard(title:'1. Sistem ve Hedef Bilgileri',children:[
      twoCol(Field(controller:sistemGucu,label:'Sistem Gücü (kW)'),Field(controller:ctOran,label:'CT Oranı / Primer (A) — isteğe bağlı')),
      twoCol(Drop(label:'Gerilim (V)',value:gerilim.toStringAsFixed(0),items:const ['400','415'],onChanged:(v)=>setState(()=>gerilim=double.parse(v!))),Drop(label:'Kademe Sayısı',value:kademe,items:const ['5','6','7','8','9','10','11','12'],onChanged:(v)=>_kademe(v!))),
      Text('Mevcut cosφ: ${pfMevcut.toStringAsFixed(2)}',style:TextStyle(fontWeight:FontWeight.bold,color:cText())),Slider(value:pfMevcut,min:.50,max:.99,onChanged:(v)=>setState(()=>pfMevcut=v)),
      Text('Hedef cosφ: ${pfHedef.toStringAsFixed(2)}',style:TextStyle(fontWeight:FontWeight.bold,color:cText())),Slider(value:pfHedef,min:.90,max:1,onChanged:(v)=>setState(()=>pfHedef=v)),
      twoCol(Drop(label:'Analizör / Röle',value:analizor,items:const ['Yok','Var'],onChanged:(v)=>setState(()=>analizor=v!)),Drop(label:'Harmonik Durumu',value:harmonik,items:const ['Bilinmiyor','Yok','Var'],onChanged:(v)=>setState(()=>harmonik=v!))),
      Drop(label:'Şönt Reaktör Yaklaşımı',value:reaktor,items:const ['Yok','Değerlendirilecek','Var'],onChanged:(v)=>setState(()=>reaktor=v!)),
    ]),
    SectionCard(title:'2. Kademe Tasarımı / Tersine Mühendislik',children:[
      Text('Kondansatör kVAr değerlerini girersen mevcut pano tasarımı üzerinden revizyon yapılır. Boş bırakırsan sistem gücü ve hedef cosφ üzerinden otomatik ön kademe dizilimi oluşturulur.',style:TextStyle(color:cText(),fontSize:11,height:1.35)),
      const SizedBox(height:8),
      for(int i=0;i<kademeler.length;i++)_kademeSatiri(i),
      calcButton('PANOYU TASARLA / ANALİZ ET',tasarla),
    ]),
    if(hesaplandi)...[
      ResultCard(title:'Tasarım Sonucu',value:'${gerekli.toStringAsFixed(1)} kVAr gerekli',subtitle:'Ön tasarım; nihai seçim saha ölçüleri, harmonik ölçümü, kısa devre seviyesi, CT bilgisi ve ilgili şartnamelerle doğrulanmalıdır.',good:true),
      SectionCard(title:'3. Ana Ekipman ve Bağlantı Zinciri',children:[Text(sonuc,style:TextStyle(color:cText(),height:1.5))]),
      SectionCard(title:'4. Kademe / Komponent Özeti',children:[Text(detay,style:TextStyle(color:cText(),height:1.5))]),
      AdviceCard(title:'Teknik uygunluk ve saha kontrolü',text:'${teknikKaynakNotu}\n\nTeknik referans tablolarında 400 V sabit/otomatik kompanzasyon malzeme seçim cetveli ve kVAr kademelerine ilişkin tablolar bulunur; özel kompanzasyon kontaktörleri vurgulanır. Kondansatörlerin gerçek kVAr değerleri, kontaktörlerin kapasitif yüke uygunluğu, kademe sigortaları, CT oranı/yönü, röle ayarları, şönt reaktörler, harmonikler, pano ısıl koşulları, kablo/bara akım taşıma ve kısa devre dayanımı sahada doğrulanmalıdır.'),
    ],
  ]);
}

class _KompTasarimKademe {
  final TextEditingController kvar=TextEditingController();
  bool reaktor=false;
  void dispose()=>kvar.dispose();
}

// ================= 4. MOTOR KORUMA VE YOL VERME =================

// ================= GELİŞMİŞ KOMPANZASYON ANALİZİ =================
class KompFaturaAnalizEkrani extends StatefulWidget {
  const KompFaturaAnalizEkrani({super.key});
  @override
  State<KompFaturaAnalizEkrani> createState() => _KompFaturaAnalizEkraniState();
}

class _KompFaturaAnalizEkraniState extends State<KompFaturaAnalizEkrani> {
  final guc = TextEditingController();
  final aktif = TextEditingController();
  final induktif = TextEditingController();
  final kapasitif = TextEditingController();
  final fatura = TextEditingController();
  bool analiz = false;
  double indOran = 0, kapOran = 0;
  String durum = '';
  String neden = '';
  String oneri = '';

  @override
  void dispose() {
    guc.dispose(); aktif.dispose(); induktif.dispose(); kapasitif.dispose(); fatura.dispose();
    super.dispose();
  }

  double _v(TextEditingController c) => double.tryParse(c.text.replaceAll(',', '.')) ?? 0;

  void hesapla() {
    final g = _v(guc);
    final a = _v(aktif);
    final i = _v(induktif);
    final k = _v(kapasitif);
    if (g <= 0 || a <= 0) {
      setState(() { analiz = false; });
      return;
    }
    final ind = max(0, i) / a * 100;
    final kap = max(0, k) / a * 100;
    final indLimit = g > 50 ? 20.0 : 33.0;
    final kapLimit = g > 50 ? 15.0 : 20.0;
    final indBad = ind > indLimit;
    final kapBad = kap > kapLimit;
    final bad = indBad || kapBad;
    final reasons = <String>[];
    if (indBad) reasons.add('İndüktif tüketim oranı sınırın üzerinde.');
    if (kapBad) reasons.add('Kapasitif tüketim oranı sınırın üzerinde.');
    if (i == 0 && k == 0) reasons.add('Reaktif endeks/tüketim verisi girilmemiş veya sıfır görünüyor; gerçek sayaç endeksleri doğrulanmalı.');
    setState(() {
      indOran = ind; kapOran = kap;
      durum = bad ? 'UYGUN DEĞİL / KONTROL GEREKLİ' : 'UYGUN / SINIRLAR İÇİNDE';
      neden = reasons.isEmpty ? 'Girilen aktif ve reaktif tüketim değerleri belirtilen oran sınırları içinde.' : reasons.join('\n');
      oneri = bad
          ? 'Kompanzasyon panosunda kademe çalışma sırası, kondansatörlerin fiziksel durumu, kontaktörler, röle ayarları, CT oranı/konumu ve varsa şönt reaktör-harmonik durumu kontrol edilmelidir. Gerekirse mevcut sistem analizi aracında pano tersine mühendisliği yapılmalıdır.'
          : 'Kademe devreye girme/çıkma kayıtları ve CT ölçüm yönü periyodik olarak kontrol edilmelidir. Sürücü/harmonik yükler varsa harmonik ölçümü ayrıca değerlendirilmelidir.';
      analiz = true;
    });
  }

  @override
  Widget build(BuildContext context) => AppScaffold(
    title: 'Kompanzasyon — Fatura / Arıza Kontrol',
    info: true,
    onInfo: () => bilgiPopup(context, 'Fatura / Arıza Kontrol', 'Aktif, indüktif ve kapasitif tüketim oranlarını analiz eder; sınır aşımı görüldüğünde olası nedenleri ve saha kontrol/onarım önerilerini gösterir. Fatura dönemi ve abone grubuna göre güncel tarife/limitler ayrıca doğrulanmalıdır.'),
    body: ScrollBody(children: [
      SectionCard(title: 'Fatura / Sayaç Verileri', children: [
        twoCol(Field(controller: guc, label: 'Sözleşme Gücü (kW)'), Field(controller: aktif, label: 'Aktif Tüketim (kWh)')),
        twoCol(Field(controller: induktif, label: 'İndüktif Tüketim (kVArh)'), Field(controller: kapasitif, label: 'Kapasitif Tüketim (kVArh)')),
        Field(controller: fatura, label: 'Fatura Tutarı (TL) — isteğe bağlı'),
        calcButton('KOMPANZASYONU ANALİZ ET', hesapla),
      ]),
      if (analiz) ...[
        ResultCard(title: 'Teknik Uygunluk', value: durum, subtitle: 'İndüktif: %${indOran.toStringAsFixed(2)} • Kapasitif: %${kapOran.toStringAsFixed(2)}', good: durum.startsWith('UYGUN /'), error: durum.startsWith('UYGUN DEĞİL')),
        AdviceCard(title: 'Tespit', text: neden, error: durum.startsWith('UYGUN DEĞİL')),
        AdviceCard(title: 'Düzeltme / Onarım Önerisi', text: oneri, error: false),
        if (durum.startsWith('UYGUN DEĞİL'))
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: OutlinedButton.icon(
              icon: const Icon(Icons.query_stats_rounded),
              label: const Text('MEVCUT SİSTEM ANALİZİNE GİT'),
              onPressed: () => Navigator.push(context, materialRoute(const KompMevcutSistemAnaliziEkrani())),
            ),
          ),
        SectionCard(title: 'Saha Kontrol Sırası', children: [
          Text('1. Sayaç endekslerini ve dönemsel veriyi doğrula.\n2. Kompanzasyon rölesinin ölçümünü ve CT yön/oranını kontrol et.\n3. Kademe kontaktörlerini ve kondansatörleri tek tek kontrol et.\n4. Şönt reaktör/harmonik filtre varsa devreye girme düzenini kontrol et.\n5. Sürücü/UPS/redresör gibi doğrultucu yükler varsa harmonik ölçümü yap.\n6. Sonuçlara göre kademe ve pano tasarımını yeniden değerlendir.', style: TextStyle(color: cText(), height: 1.45)),
        ]),
      ],
      AdviceCard(title: 'Teknik dayanak notu', text: 'Oran limitleri tesisin güncel mevzuat, dağıtım şirketi uygulaması, sözleşme yapısı ve ilgili tarife dönemi ile doğrulanmalıdır. Bu ekran teşhis ve ön değerlendirme içindir; tek başına kabul/ceza kararı üretmez.'),
    ]),
  );
}

class _KompKademe {
  final TextEditingController kvar = TextEditingController();
  bool reaktor = false;
  void dispose() => kvar.dispose();
}

class KompMevcutSistemAnaliziEkrani extends StatefulWidget {
  const KompMevcutSistemAnaliziEkrani({super.key});
  @override
  State<KompMevcutSistemAnaliziEkrani> createState() => _KompMevcutSistemAnaliziEkraniState();
}

class _KompMevcutSistemAnaliziEkraniState extends State<KompMevcutSistemAnaliziEkrani> {
  final sistemGucu = TextEditingController();
  final cosMevcut = TextEditingController(text: '0.80');
  final cosHedef = TextEditingController(text: '0.95');
  final ctOran = TextEditingController();
  String kademe = '6';
  String analizor = 'Yok';
  String sonuc = '';
  String detay = '';
  bool analizEdildi = false;
  List<_KompKademe> kademeler = List.generate(6, (_) => _KompKademe());

  @override
  void dispose() {
    sistemGucu.dispose(); cosMevcut.dispose(); cosHedef.dispose(); ctOran.dispose();
    for (final k in kademeler) k.dispose();
    super.dispose();
  }

  void _kademeDegistir(String v) {
    final n = int.parse(v);
    for (final k in kademeler) k.dispose();
    setState(() {
      kademe = v;
      kademeler = List.generate(n, (_) => _KompKademe());
      analizEdildi = false;
    });
  }

  double _v(TextEditingController c) => double.tryParse(c.text.replaceAll(',', '.')) ?? 0;

  void analizEt() {
    final p = _v(sistemGucu);
    final pf = _v(cosMevcut);
    final hedef = _v(cosHedef);
    final ct = _v(ctOran);
    final toplam = kademeler.fold<double>(0, (sum, k) => sum + _v(k.kvar));
    if (p <= 0 || pf <= 0 || pf > 1 || hedef <= 0 || hedef > 1) {
      setState(() { analizEdildi = false; });
      return;
    }
    final gerekli = p * (tan(acos(pf)) - tan(acos(hedef)));
    final fark = toplam - gerekli;
    final asiri = gerekli > 0 && toplam > gerekli * 1.20;
    final eksik = gerekli > 0 && toplam < gerekli * 0.80;
    final harmonikRiski = analizor == 'Var' && kademeler.every((x) => !x.reaktor);
    final ctEksik = ct <= 0;
    final durum = asiri || eksik || harmonikRiski || ctEksik ? 'UYGUN DEĞİL / AYRINTILI KONTROL GEREKLİ' : 'ÖN DEĞERLENDİRMEDE UYGUN';
    final nedenler = <String>[];
    if (asiri) nedenler.add('Toplam kurulu kVAr, hesaplanan ihtiyacın belirgin şekilde üzerinde; kapasitif çalışma riski araştırılmalı.');
    if (eksik) nedenler.add('Toplam kurulu kVAr, hesaplanan ihtiyacın belirgin şekilde altında; indüktif çalışma/kademe yetersizliği araştırılmalı.');
    if (harmonikRiski) nedenler.add('Sürücü/analizör doğrultucu yük bilgisi var ancak hiçbir kademede reaktör bilgisi girilmemiş; harmonik ölçümü ve reaktörlü çözüm değerlendirilmelidir.');
    if (ctEksik) nedenler.add('CT oranı girilmemiş; röle ölçümü ve bağlantı doğrulanmadan kesin teşhis yapılamaz.');
    if (nedenler.isEmpty) nedenler.add('Girilen kademe yapısı, CT bilgisi ve yük profili temelinde belirgin bir uygunsuzluk tespit edilmedi.');
    setState(() {
      sonuc = durum;
      detay = 'Gerekli kompanzasyon: ${gerekli.toStringAsFixed(1)} kVAr\nMevcut kademe toplamı: ${toplam.toStringAsFixed(1)} kVAr\nFark: ${fark.toStringAsFixed(1)} kVAr\n\n${nedenler.join('\n')}\n\nÖneri: Mevcut pano; röle ayarı, CT oranı/yeri, kontaktörler, kondansatörler, şönt reaktörler ve harmonik seviyeleri ile birlikte sahada kontrol edilmelidir.';
      analizEdildi = true;
    });
  }

  @override
  Widget build(BuildContext context) => AppScaffold(
    title: 'Mevcut Sistem Analizi',
    info: true,
    onInfo: () => bilgiPopup(context, 'Mevcut Sistem Analizi', 'Bu araç mevcut kompanzasyon panosunu tersine mühendislik yaklaşımıyla analiz eder. Sistem gücü, mevcut cosφ, hedef cosφ, kademe kVAr değerleri, şönt reaktör, CT ve sürücü/analizör bilgileri birlikte değerlendirilir.'),
    body: ScrollBody(children: [
      SectionCard(title: '1. Mevcut Sistem', children: [
        twoCol(Field(controller: sistemGucu, label: 'Sistem Gücü (kW)'), Field(controller: ctOran, label: 'CT Primer Akımı (A)')),
        twoCol(Field(controller: cosMevcut, label: 'Mevcut cosφ'), Field(controller: cosHedef, label: 'Hedef cosφ')),
        twoCol(Drop(label: 'Kademe Sayısı', value: kademe, items: const ['5','6','7','8','9','10','11','12'], onChanged: (v) => _kademeDegistir(v!)), Drop(label: 'Analizör / Sürücü', value: analizor, items: const ['Yok','Var'], onChanged: (v) => setState(() { analizor = v!; analizEdildi = false; }))),
      ]),
      SectionCard(title: '2. Mevcut Kademe İçeriği', children: [
        for (var i = 0; i < kademeler.length; i++)
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Expanded(child: Field(controller: kademeler[i].kvar, label: 'Kademe ${i + 1} — Kondansatör (kVAr)')),
            const SizedBox(width: 8),
            SizedBox(width: 112, child: CheckboxListTile(contentPadding: EdgeInsets.zero, dense: true, title: const Text('Reaktör', style: TextStyle(fontSize: 11)), value: kademeler[i].reaktor, onChanged: (v) => setState(() { kademeler[i].reaktor = v ?? false; analizEdildi = false; }))),
          ]),
        calcButton('MEVCUT SİSTEMİ ANALİZ ET', analizEt),
      ]),
      if (analizEdildi) ...[
        ResultCard(title: 'Analiz Sonucu', value: sonuc, subtitle: 'Sonuç kesin kabul/onay kararı değildir; saha ölçümü ve proje/şartname kontrolü gerekir.', good: sonuc.startsWith('ÖN'), error: sonuc.startsWith('UYGUN DEĞİL')),
        SectionCard(title: 'Hesap / Teşhis Özeti', children: [Text(detay, style: TextStyle(color: cText(), height: 1.45))]),
        if (sonuc.startsWith('UYGUN DEĞİL'))
          Padding(padding: const EdgeInsets.only(bottom: 12), child: OutlinedButton.icon(icon: const Icon(Icons.build_circle_outlined), label: const Text('PANO TASARIMINI AÇ'), onPressed: () => Navigator.push(context, materialRoute(const KompPanoTasarimEkrani())))),
      ],
      AdviceCard(title: 'Tersine mühendislik yaklaşımı', text: 'Mevcut Sistem Analizi, Pano Tasarım aracının ters yönde çalışan eşidir: mevcut kademeler ve saha verileri girilir, sistemin olası problemi ve revizyon ihtiyacı çıkarılır. Kesin karar için ölçüm kayıtları, röle ayarları, CT bağlantısı, kondansatör testleri ve harmonik ölçümü ayrıca doğrulanmalıdır.'),
    ]),
  );
}
