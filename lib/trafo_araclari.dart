part of 'main.dart';

class AkuOmurEkrani extends StatefulWidget {
  const AkuOmurEkrani({super.key});
  @override
  State<AkuOmurEkrani> createState() => _AkuOmurEkraniState();
}

class _AkuOmurEkraniState extends State<AkuOmurEkrani> {
  final cycles = TextEditingController(text: '2000');
  final dod = TextEditingController(text: '80');
  double? years;

  @override
  void dispose() {
    cycles.dispose();
    dod.dispose();
    super.dispose();
  }

  void hesapla() {
    final c = double.tryParse(cycles.text.replaceAll(',', '.')) ?? 0;
    final d = double.tryParse(dod.text.replaceAll(',', '.')) ?? 0;
    if (c <= 0 || d <= 0 || d > 100) {
      setState(() => years = null);
      return;
    }
    final equivalentCyclesPerYear = 365 * d / 100;
    setState(() => years = c / equivalentCyclesPerYear);
  }

  @override
  Widget build(BuildContext context) => AppScaffold(
    title: t('Akü Ömür Hesabı', 'Battery Life'),
    body: ScrollBody(children: [
      SectionCard(title: t('Girdiler', 'Inputs'), children: [
        Field(controller: cycles, label: t('Nominal Çevrim Sayısı', 'Nominal Cycle Count')),
        Field(controller: dod, label: t('Ortalama DoD (%)', 'Average DoD (%)')),
        calcButton(t('HESAPLA', 'CALCULATE'), hesapla),
      ]),
      if (years != null)
        uiResultCard(t('Tahmini Ömür', 'Estimated Life'), years!.toStringAsFixed(1), 'yıl'),
      AdviceCard(
        title: t('Teknik Not', 'Technical Note'),
        text: t(
          'Bu sonuç ön tahmindir. Üretici çevrim eğrisi, sıcaklık, şarj/deşarj akımı ve gerçek kullanım profili ayrıca değerlendirilmelidir.',
          'This is a preliminary estimate. Manufacturer cycle curves, temperature, charge/discharge current and actual duty profile must also be evaluated.',
        ),
      ),
    ]),
  );
}

class PanelAmortismanEkrani extends StatefulWidget {
  const PanelAmortismanEkrani({super.key});
  @override
  State<PanelAmortismanEkrani> createState() => _PanelAmortismanEkraniState();
}

class _PanelAmortismanEkraniState extends State<PanelAmortismanEkrani> {
  final cost = TextEditingController();
  final monthly = TextEditingController();
  double? years;

  @override
  void dispose() {
    cost.dispose();
    monthly.dispose();
    super.dispose();
  }

  void hesapla() {
    final c = double.tryParse(cost.text.replaceAll(',', '.')) ?? 0;
    final m = double.tryParse(monthly.text.replaceAll(',', '.')) ?? 0;
    setState(() => years = c > 0 && m > 0 ? c / (m * 12) : null);
  }

  @override
  Widget build(BuildContext context) => AppScaffold(
    title: t('Panel Ömür / Amortisman', 'Panel Life / Payback'),
    body: ScrollBody(children: [
      SectionCard(title: t('Girdiler', 'Inputs'), children: [
        Field(controller: cost, label: t('Yatırım Tutarı (TL)', 'Investment Cost (TRY)')),
        Field(controller: monthly, label: t('Aylık Tasarruf (TL)', 'Monthly Saving (TRY)')),
        calcButton(t('HESAPLA', 'CALCULATE'), hesapla),
      ]),
      if (years != null)
        uiResultCard(t('Basit Amortisman', 'Simple Payback'), years!.toStringAsFixed(1), 'yıl'),
      AdviceCard(
        title: t('Teknik Not', 'Technical Note'),
        text: t(
          'Basit geri dönüş hesabıdır; panel degradasyonu, bakım, finansman, enerji fiyat değişimi ve teşvikler dahil değildir.',
          'Simple payback only; degradation, maintenance, financing, energy-price changes and incentives are not included.',
        ),
      ),
    ]),
  );
}

class OlcuTrafoEkrani extends StatefulWidget { const OlcuTrafoEkrani({super.key}); @override State<OlcuTrafoEkrani> createState()=>_OlcuTrafoEkraniState(); }
class _OlcuTrafoEkraniState extends State<OlcuTrafoEkrani>{
  final power=TextEditingController(); String seviye='AG'; String gerilim='31500'; String? ct; String? vt; double? akim; double? va;
  final ctVals=const [20,30,40,50,75,100,150,200,250,300,400,500,600,800,1000,1250,1600,2000,2500,3000,4000,5000];
  @override void dispose(){power.dispose();super.dispose();}
  void hesapla(){final p=double.tryParse(power.text.replaceAll(',','.'))??0; if(p<=0){setState(() { ct=null; vt=null; akim=null; va=null; });return;} final v=seviye=='AG'?400:double.tryParse(gerilim)??31500; final i=seviye=='AG' ? p*1000/(sqrt(3)*v*.95) : p*1000/(sqrt(3)*v*.95); final prim=ctVals.firstWhere((x)=>x>=i,orElse:()=>5000); setState(() { akim=i; ct='$prim/5 A'; vt=seviye=='OG'?'${gerilim} / 100 V':'AG gerilim trafosu gerekmez'; va=max(5.0,i*1.5); });}
  @override Widget build(BuildContext context)=>AppScaffold(title:'Ölçü Trafo Hesaplama',info:true,onInfo:()=>bilgiPopup(context,'Ölçü Trafo Hesaplama','AG seviyesinde güç girişi kW, OG seviyesinde kVA olarak alınır. Akım trafosu seçiminde hesaplanan akıma eşit veya onu karşılayan en yakın üst standart primer değer ön seçim olarak kullanılır. Sekonder tarafı projeye göre 1 A veya 5 A olabilir. Kesin seçim; ölçü/koruma amacı, burden, doğruluk sınıfı, kısa devre dayanımı ve ilgili şartnameyle doğrulanmalıdır.'),body:ScrollBody(children:[
    SectionCard(title:'Girişler',children:[twoCol(Drop(label:'Gerilim seviyesi',value:seviye,items:const ['AG','OG'],onChanged:(v)=>setState(()=>seviye=v!)),Field(controller:power,label:seviye=='AG'?'Güç (kW)':'Güç (kVA)')),if(seviye=='OG')Drop(label:'OG gerilim seviyesi (V)',value:gerilim,items:const ['31500','33000','34500','36000'],onChanged:(v)=>setState(()=>gerilim=v!)),calcButton('HESAPLA',hesapla)]),
    if(akim!=null) ...[uiResultCard('Hesaplanan akım',fmt2(akim!),'A'),uiResultCard('Akım trafosu',ct??'-','A'),uiResultCard('Akım trafosu ikincil yükü (VA)',fmt2(va??0),'VA'),uiResultCard('Gerilim trafosu',vt??'-','')],
    AdviceCard(title:'Bilgi',text:'AG güç girişi kW, OG güç girişi kVA olarak değerlendirilir. Sekonder akımı projeye göre 5 A yerine 1 A seçilebilir (örn. 30/1 A). Kesin CT/VT seçimi proje, ölçü sistemi, koruma sistemi ve üretici verileriyle doğrulanmalıdır.'),
  ]));
}

class AkimTrafoEkrani extends StatefulWidget {
  const AkimTrafoEkrani({super.key});
  @override
  State<AkimTrafoEkrani> createState() => _AkimTrafoEkraniState();
}

class _AkimTrafoEkraniState extends State<AkimTrafoEkrani> {
  final current = TextEditingController();
  final burden = TextEditingController(text: '5');
  String? ratio;

  @override
  void dispose() {
    current.dispose();
    burden.dispose();
    super.dispose();
  }

  void hesapla() {
    final i = double.tryParse(current.text.replaceAll(',', '.')) ?? 0;
    final b = double.tryParse(burden.text.replaceAll(',', '.')) ?? 0;
    setState(() => ratio = i > 0 && b > 0 ? standartAkimTrafosuBul(i) : null);
  }

  @override
  Widget build(BuildContext context) => AppScaffold(
    title: t('Akım Trafosu VA', 'Current Transformer VA'),
    body: ScrollBody(children: [
      SectionCard(title: t('Sekonder Burden', 'Secondary Burden'), children: [
        Field(controller: current, label: t('Primer Akım (A)', 'Primary Current (A)')),
        Field(controller: burden, label: t('Toplam Burden (VA)', 'Total Burden (VA)')),
        calcButton(t('HESAPLA', 'CALCULATE'), hesapla),
      ]),
      if (ratio != null) uiResultCard(t('Önerilen CT', 'Recommended CT'), ratio!, ''),
      if (ratio != null)
        uiResultCard(
          t('Sekonder Burden', 'Secondary Burden'),
          (double.tryParse(burden.text.replaceAll(',', '.')) ?? 0).toStringAsFixed(1),
          'VA',
        ),
      AdviceCard(
        title: t('Teknik Not', 'Technical Note'),
        text: t(
          'Kesin CT oranı, sınıfı, VA değeri ve kısa devre dayanımı koruma/ölçü devresine göre doğrulanmalıdır.',
          'Final CT ratio, class, VA rating and short-circuit withstand must be verified for the protection/metering circuit.',
        ),
      ),
    ]),
  );
}

class GerilimTrafoEkrani extends StatelessWidget {
  const GerilimTrafoEkrani({super.key});
  @override
  Widget build(BuildContext context) => AppScaffold(
    title: t('Gerilim Trafosu', 'Voltage Transformer'),
    body: ScrollBody(children: [
      uiResultCard(t('Örnek OG Oranı', 'Example MV Ratio'), '31.5 / 0.1', 'kV / kV'),
      AdviceCard(
        title: t('Teknik Not', 'Technical Note'),
        text: t(
          'Gerilim trafosu oranı, sınıfı, gücü ve bağlantı şekli ilgili OG hücre şartnamesine göre kesinleştirilmelidir.',
          'VT ratio, class, burden and connection must be finalized according to the MV switchgear specification.',
        ),
      ),
    ]),
  );
}

class IzolasyonTrafoEkrani extends StatefulWidget {
  const IzolasyonTrafoEkrani({super.key});
  @override
  State<IzolasyonTrafoEkrani> createState() => _IzolasyonTrafoEkraniState();
}

class _IzolasyonTrafoEkraniState extends State<IzolasyonTrafoEkrani> {
  final power = TextEditingController();
  double? selectedKva;

  @override
  void dispose() {
    power.dispose();
    super.dispose();
  }

  void hesapla() {
    final p = double.tryParse(power.text.replaceAll(',', '.')) ?? 0;
    const std = [1, 2, 3, 5, 7.5, 10, 15, 20, 25, 30, 40, 50, 63, 80, 100, 125, 160, 200, 250, 315, 400, 500];
    final target = p * 1.25;
    final v = target > 0 ? std.firstWhere((x) => x >= target, orElse: () => std.last).toDouble() : null;
    setState(() => selectedKva = v);
  }

  @override
  Widget build(BuildContext context) => AppScaffold(
    title: t('İzolasyon Trafosu', 'Isolation Transformer'),
    body: ScrollBody(children: [
      Field(controller: power, label: t('Yük Gücü (kW)', 'Load Power (kW)')),
      calcButton(t('HESAPLA', 'CALCULATE'), hesapla),
      if (selectedKva != null)
        uiResultCard(t('Önerilen Trafo', 'Recommended Transformer'), selectedKva!.toStringAsFixed(1), 'kVA'),
      AdviceCard(
        title: t('Teknik Not', 'Technical Note'),
        text: t(
          'Ön seçimde %25 kapasite payı kullanılmıştır. Primer/sekonder gerilim, izolasyon seviyesi, kısa devre empedansı ve yük tipi ayrıca doğrulanmalıdır.',
          'A 25% capacity margin is used for preselection. Primary/secondary voltage, insulation level, impedance and load type must be verified separately.',
        ),
      ),
    ]),
  );
}

