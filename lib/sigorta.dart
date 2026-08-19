part of 'main.dart';

class SigortaSecimiEkrani extends StatefulWidget { const SigortaSecimiEkrani({super.key}); @override State<SigortaSecimiEkrani> createState()=>_SigortaSecimiEkraniState(); }
class _SigortaSecimiEkraniState extends State<SigortaSecimiEkrani>{
  final guc=TextEditingController(); String sistem='Trifaze'; double akim=0; int sigorta=0; bool hesaplandi=false;
  @override void dispose(){guc.dispose();super.dispose();}
  void hesapla(){
    final p=double.tryParse(guc.text.replaceAll(',','.'))??0;
    if(p<=0){setState(()=>hesaplandi=false);return;}
    final i=sistem=='Trifaze'?(p*1000)/(sqrt(3)*380):(p*1000)/220;
    const std=[2,4,6,10,16,20,25,32,40,50,63,80,100,125,160,200,250,315,400,500,630,800,1000,1250,1600,2000,2500,3200,4000];
    final f=std.firstWhere((x)=>x>=i,orElse:()=>4000);
    setState(() {akim=i;sigorta=f;hesaplandi=true;});
  }
  @override Widget build(BuildContext context)=>AppScaffold(title:'Sigorta Seçimi',info:true,onInfo:()=>bilgiPopup(context,'Sigorta Seçimi','Teorik yük akımından standart koruma değerine ön seçim yapar. Kısa devre, açma eğrisi, selektivite ve kablo taşıma kapasitesi ayrıca doğrulanmalıdır.'),body:ScrollBody(children:[
    SectionCard(title:'Giriş',children:[twoCol(Field(controller:guc,label:'Güç (kW)'),Drop(label:'Sistem',value:sistem,items:const ['Trifaze','Monofaze'],onChanged:(v)=>setState(() {sistem=v!;hesaplandi=false;}))),calcButton('HESAPLA',hesapla)]),
    if(hesaplandi)...[
      if(sistem=='Trifaze') const ResultCard(title:'Referans güç faktörü',value:'cosφ = 0,90',subtitle:'Ön hesap referansı; gerçek tesis cosφ değeri ölçüm/proje verisiyle doğrulanmalıdır.'),
      ResultCard(title:'Hesaplanan akım',value:'${akim.toStringAsFixed(2)} A'),
      ResultCard(title:'Önerilen sigorta / TMŞ',value:'$sigorta A',good:true),
    ],
    const AdviceCard(title:'Teknik not',text:'Sigorta veya TMŞ seçimi yalnızca akıma göre kesinleştirilmez. Kablo akım taşıma kapasitesi, kısa devre seviyesi, açma karakteristiği, selektivite ve kullanım kategorisi birlikte kontrol edilmelidir.'),
  ]));
}

// ================= EKLENEN SAHA ARAÇLARI =================
