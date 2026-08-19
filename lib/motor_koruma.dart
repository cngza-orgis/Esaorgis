part of 'main.dart';

class MotorKorumaEkrani extends StatefulWidget { const MotorKorumaEkrani({super.key}); @override State<MotorKorumaEkrani> createState()=>_MotorKorumaEkraniState(); }
class _MotorKorumaEkraniState extends State<MotorKorumaEkrani>{
  final guc=TextEditingController(); String yol='Direkt Yol Verme (DOL)'; bool teorikDol=false; String kumanda='Kontaktör'; double akim=0; String termik='',koruma='',ana='',yildiz='-',ucgen='-',kablo='',uyari=''; bool hesap=false;
  @override void dispose(){guc.dispose();super.dispose();}
  void hesapla(){
    final p=double.tryParse(guc.text.replaceAll(',', '.'))??0;
    if(p<=0){setState(()=>hesap=false);return;}
    if(yol=='Direkt Yol Verme (DOL)' && p>5.5 && !teorikDol){setState((){hesap=false;uyari='5,5 kW üzeri direkt yol verme için teorik hesap onayı gerekir. Riskin farkındayım — teorik hesap istiyorum seçeneğini işaretleyin.';});return;}
    final i=p*1000/(sqrt(3)*400*.82*.85);
    final d=yol=='Direkt Yol Verme (DOL)';
    final yd=yol=='Yıldız-Üçgen Yol Verme';
    final u=yd?'${standartKontaktorBul(i*.33)} A':'-';
    final y=yd?'${standartKontaktorBul(i*.33)} A':'-';
    final c=d?'${standartKontaktorBul(i)} A':yd?'${standartKontaktorBul(i*.58)} A':'${standartKontaktorBul(i)} A';
    final f=standartTMSBul(i*(d?2.0:1.5));
    setState(() {
      akim=i;
      termik='${(i*.9).toStringAsFixed(1)}–${(i*1.1).toStringAsFixed(1)} A';
      koruma='$f A sınıfı ön seçim';
      ana=c; ucgen=u; yildiz=y;
      kablo=standartKabloBulNYY(i,true);
      uyari=d&&p>5.5
        ? 'Direkt yol verme yüksek güçlü motorlarda kalkış akımı ve gerilim düşümü açısından ayrıca kontrol edilmelidir. Soft starter veya uygun hız kontrolü değerlendirilebilir.'
        : yd&&p<4
          ? 'Yıldız-üçgen için motor etiketinin uygun bağlantı gerilimleri ve 6 uç erişimi doğrulanmalıdır.'
          : '';
      hesap=true;
    });
  }

  @override Widget build(BuildContext context)=>AppScaffold(title:'Motor Koruma & Yol Verme',info:true,onInfo:()=>bilgiPopup(context,'Motor Koruma & Yol Verme','Motor nominal akımı, termik ayar aralığı, koruma sınıfı, kontaktörler, kablo ön seçimi ve yol verme yöntemine bağlı saha kontrol başlıklarını birlikte değerlendirir.'),body:ScrollBody(children:[
    SectionCard(title:'Motor / Yol Verme',children:[twoCol(Field(controller:guc,label:'Motor gücü (kW)'),Drop(label:'Yol verme yöntemi',value:yol,items:const ['Direkt Yol Verme (DOL)','Yıldız-Üçgen Yol Verme','Oto Transformatörlü Yol Verme','Yumuşak Yol Verici (Soft Starter)','Frekans Konvertörlü Yol Verme (VFD)','Bilezikli Rotorlu Motorlarda Rotor Dirençli Yol Verme'],onChanged:(v)=>setState(() {yol=v!;hesap=false;}))),Drop(label:'Kumanda/koruma',value:kumanda,items:const ['Kontaktör','Soft Starter','Hız Kontrol Cihazı'],onChanged:(v)=>setState(()=>kumanda=v!)),if(yol=='Direkt Yol Verme (DOL)') CheckboxListTile(contentPadding:EdgeInsets.zero,value:teorikDol,onChanged:(v)=>setState(()=>teorikDol=v??false),title:const Text('Riskin farkındayım — teorik hesap istiyorum',style:TextStyle(fontSize:12,fontWeight:FontWeight.w700)),subtitle:const Text('5,5 kW üzeri DOL hesabını yalnızca teorik ön hesap olarak çalıştırır.',style:TextStyle(fontSize:10.5))),calcButton('MOTORU ANALİZ ET',hesapla)]),
    if(hesap)...[
      ResultCard(title:'Nominal akım',value:'${akim.toStringAsFixed(2)} A'),
      ResultCard(title:'Termik röle ayar aralığı',value:termik),
      ResultCard(title:'Giriş koruma ön seçimi',value:koruma),
      ResultCard(title:'Ana kontaktör',value:ana),
      if(yol=='Yıldız-Üçgen Yol Verme') ResultCard(title:'Yıldız kontaktör',value:yildiz),
      if(yol=='Yıldız-Üçgen Yol Verme') ResultCard(title:'Üçgen kontaktör',value:ucgen),
      if(yol=='Direkt Yol Verme (DOL)' || yol=='Yıldız-Üçgen Yol Verme') AdviceCard(title:'Teknik referans',text:'Direkt yol vermede yol alma akımı yaklaşık 6 × In ve yıldız-üçgen yol vermede yaklaşık 2 × In referans alınır; süre ve gerçek kalkış karakteri motor/şebeke/proje koşullarıyla doğrulanmalıdır.'),
      ResultCard(title:'Motor besleme kablosu ön seçimi',value:kablo),
      if(uyari.isNotEmpty) AdviceCard(title:'Teknik uyarı',text:uyari,error:true),
      if(yol!='Direkt Yol Verme (DOL)' && yol!='Yıldız-Üçgen Yol Verme') AdviceCard(title:'Seçilen yol verme yöntemi',text:
        yol=='Oto Transformatörlü Yol Verme' ? 'Oto transformatörlü yol verme; kalkış akımını düşürmek ve uygun kalkış torkunu sağlamak için kullanılan kademeli bir yöntemdir. Oto transformatör oranları, motor gücü, kalkış yükü ve üretici verileriyle belirlenmelidir.' :
        yol=='Yumuşak Yol Verici (Soft Starter)' ? 'Yumuşak yol verici; motor gerilimini kontrollü artırarak kalkış akımını ve mekanik darbeyi azaltır. Bypass, termik model, kısa devre koruması, harmonikler ve motor üretici ayarları ayrıca kontrol edilmelidir.' :
        yol=='Frekans Konvertörlü Yol Verme (VFD)' ? 'Frekans konvertörlü yol verme; frekans ve gerilimi kontrollü değiştirerek kalkış ve hız kontrolü sağlar. EMC, harmonik, motor kablosu, bypass ve koruma koordinasyonu ayrıca değerlendirilmelidir.' :
        'Bilezikli rotorlu motorlarda rotor dirençli yol verme; rotor devresine kademeli direnç eklenerek yüksek kalkış torku ve kontrollü kalkış sağlanması esasına dayanır. Motorun rotor yapısı ve üretici şeması doğrulanmalıdır.'),
      SectionCard(title:'Saha kontrol listesi',children:[Text('• Motor etiketindeki In, cosφ, η ve bağlantı gerilimlerini doğrula.\n• Termik/elektronik aşırı yük ayarını motor etiket akımına göre yap.\n• Kısa devre koruması ile motor yol verme davranışını koordine et.\n• Yıldız-üçgende motorun 6 uçlu ve uygun gerilim etiketli olması gerekir.\n• Kontaktör kategori/servis sınıfı ve kullanım kategorisini üretici verisiyle doğrula.\n• Soft starter/hız kontrol cihazı varsa bypass, harmonik, EMC ve koruma düzenini ayrıca değerlendir.',style:TextStyle(color:cText(),height:1.45))]),
    ],
    AdviceCard(title:'Kesin saha uygulaması',text:'Koruma ve yol verme seçimi yalnızca kW değerinden kesinleştirilmez. Motor etiket verisi, kalkış yöntemi, kablo, kısa devre seviyesi, açma karakteristiği ve üretici koordinasyon tabloları birlikte kontrol edilmelidir.'),
  ]));
}

// ================= 5. GES / SOLAR HESAPLAYICI ANA EKRANI =================

class MotorMonofazeEkrani extends StatefulWidget {
  const MotorMonofazeEkrani({super.key});
  @override State<MotorMonofazeEkrani> createState() => _MotorMonofazeEkraniState();
}
class _MotorMonofazeEkraniState extends State<MotorMonofazeEkrani> {
  final power = TextEditingController();
  double? capRun, capStart;
  @override void dispose() { power.dispose(); super.dispose(); }
  void calc() {
    final p = double.tryParse(power.text.replaceAll(',', '.')) ?? 0;
    if (p <= 0) return;
    setState(() { capRun = p * 70; capStart = p * 120; });
  }
  @override Widget build(BuildContext context) => AppScaffold(title: t('Trifaze → Monofaze', 'Three-phase → Single-phase'), body: ScrollBody(children: [
    SectionCard(title: t('Motor Bilgileri', 'Motor Data'), children: [Field(controller: power, label: t('Motor Gücü (kW)', 'Motor Power (kW)'))]),
    calcButton(t('HESAPLA', 'CALCULATE'), calc),
    if (capRun != null) ...[uiResultCard(t('Daimi Kondansatör', 'Run Capacitor'), capRun!.toStringAsFixed(1), 'µF'), uiResultCard(t('İlk Hareket Kondansatörü', 'Start Capacitor'), capStart!.toStringAsFixed(1), 'µF')],
    AdviceCard(title: t('Teknik Not', 'Technical Note'), text: t('Bu değerler ön hesap niteliğindedir; motor etiket bilgileri, motorun üretici verileri ve gerçek çalışma koşullarıyla doğrulanmalıdır. Trifaze bir motorun monofaze çalıştırılabilirliği motorun tipine, gücüne ve üretici şartlarına göre ayrıca değerlendirilmelidir.', 'These are preliminary values; verify them against the motor nameplate, manufacturer data and actual operating conditions. The suitability of operating a three-phase motor on single-phase supply must be evaluated according to the motor type, power and manufacturer requirements.')),
  ]));
}
