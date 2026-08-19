part of 'main.dart';

class AydinlatmaHesabiEkrani extends StatefulWidget { const AydinlatmaHesabiEkrani({super.key}); @override State<AydinlatmaHesabiEkrani> createState()=>_AydinlatmaHesabiEkraniState(); }
class _AydinlatmaHesabiEkraniState extends State<AydinlatmaHesabiEkrani>{
  final en=TextEditingController(),boy=TextEditingController(),yukseklik=TextEditingController(text:'3'),lumen=TextEditingController(text:'4000'),watt=TextEditingController(text:'36');
  String mekan='Ofis'; double luks=500, tavan=.70, duvar=.50, zemin=.20, bakim=.80; bool hesaplandi=false; double alan=0,k=0,kf=0,af=0,lm=0; int adet=0; double toplamW=0;
  @override void dispose(){en.dispose();boy.dispose();yukseklik.dispose();lumen.dispose();watt.dispose();super.dispose();}
  void hesapla(){final a=double.tryParse(en.text.replaceAll(',','.'))??0,b=double.tryParse(boy.text.replaceAll(',','.'))??0,h=double.tryParse(yukseklik.text.replaceAll(',','.'))??0,pl=double.tryParse(lumen.text.replaceAll(',','.'))??0,pw=double.tryParse(watt.text.replaceAll(',','.'))??0;if(a<=0||b<=0||h<=0||pl<=0||pw<=0){setState(()=>hesaplandi=false);return;}final roomH=max(.5,h-0.8);final idx=(a*b)/(roomH*(a+b));final util=(.25+.55*min(1.0,idx/2.0))*(.65+.35*((tavan+duvar+zemin)/1.75));final req=(a*b*luks)/(max(.2,util)*bakim);final n=(req/pl).ceil();setState(() {alan=a*b;k=idx;kf=util;af=req;lm=pl;adet=n;toplamW=n*pw;hesaplandi=true;});}
  @override Widget build(BuildContext context)=>AppScaffold(title:'Aydınlatma Hesabı',info:true,onInfo:()=>bilgiPopup(context,'Aydınlatma Hesabı','Oda alanı, oda indeksi (k), yüzey yansıtma katsayıları, kullanım faktörü, bakım faktörü ve seçilen armatür lümeni üzerinden yaklaşık armatür adedini hesaplar. Gerçek projede armatür fotometrik dosyası, üretici verisi ve TS EN 12464-1 gibi ilgili standart/işyeri koşulları ayrıca değerlendirilmelidir.'),body:ScrollBody(children:[
    SectionCard(title:'1. Mekân Bilgileri',children:[
      twoCol(Field(controller:en,label:'Mekân eni (m)'),Field(controller:boy,label:'Mekân boyu (m)')),
      twoCol(Field(controller:yukseklik,label:'Tavan yüksekliği (m)'),Drop(label:'Mekân tipi',value:mekan,items:const ['Ofis','Atölye','Depo','Koridor','Sınıf','Mağaza','Genel alan'],onChanged:(v)=>setState(()=>mekan=v!))),
      Text('Hedef aydınlık düzeyi: ${luks.toInt()} lx',style:TextStyle(color:cText(),fontWeight:FontWeight.w700)),
      Slider(value:luks,min:100,max:1000,divisions:18,activeColor:cIcon(),onChanged:(v)=>setState(() {luks=v;hesaplandi=false;})),
    ]),
    SectionCard(title:'2. Yüzey Yansıtma / Bakım',children:[
      _slider('Tavan yansıtma',tavan,.3,.9,(v)=>setState(() {tavan=v;hesaplandi=false;})),
      _slider('Duvar yansıtma',duvar,.2,.8,(v)=>setState(() {duvar=v;hesaplandi=false;})),
      _slider('Zemin yansıtma',zemin,.1,.5,(v)=>setState(() {zemin=v;hesaplandi=false;})),
      _slider('Bakım faktörü',bakim,.5,.95,(v)=>setState(() {bakim=v;hesaplandi=false;})),
    ]),
    SectionCard(title:'3. Armatür Bilgileri',children:[twoCol(Field(controller:lumen,label:'Armatür ışık akısı (lm)'),Field(controller:watt,label:'Armatür gücü (W)')),calcButton('AYDINLATMAYI HESAPLA',hesapla)]),
    if(hesaplandi)...[
      ResultCard(title:'Mekân alanı',value:'${alan.toStringAsFixed(2)} m²'),
      ResultCard(title:'Oda indeksi (k)',value:k.toStringAsFixed(2)),
      ResultCard(title:'Yaklaşık kullanım faktörü',value:kf.toStringAsFixed(3)),
      ResultCard(title:'Gerekli toplam ışık akısı',value:'${af.toStringAsFixed(0)} lm'),
      ResultCard(title:'Önerilen armatür adedi',value:'$adet adet',good:true),
      ResultCard(title:'Kurulu aydınlatma gücü',value:'${toplamW.toStringAsFixed(0)} W'),
    ],
    const AdviceCard(title:'Teknik uyarı',text:'Bu sonuç bir ön tasarımdır. Armatür dağılımı, kamaşma, düzgünlük, bakım faktörü, çalışma düzlemi, acil aydınlatma, yangın/kaçış yolları ve üretici fotometrik verileri gerçek projede ayrıca kontrol edilmelidir.'),
  ]));
  Widget _slider(String label,double value,double minV,double maxV,ValueChanged<double> onChanged)=>Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[Text('$label: ${value.toStringAsFixed(2)}',style:TextStyle(color:cText(),fontWeight:FontWeight.w700)),Slider(value:value,min:minV,max:maxV,activeColor:cIcon(),onChanged:onChanged)]);
}

// ================= 8. JENERATÖR SEÇİMİ =================
