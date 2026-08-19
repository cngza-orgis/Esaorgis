part of 'main.dart';

class TopraklamaEkrani extends StatefulWidget {
  const TopraklamaEkrani({super.key});
  @override
  State<TopraklamaEkrani> createState() => _TopraklamaEkraniState();
}

class _TopraklamaEkraniState extends State<TopraklamaEkrani> {
  final _akimCtrl = TextEditingController();
  String sistemTipi = 'TT Sistem';
  String korumaElemani = 'TMŞ';
  String kar = 'Var';
  String? karEsik = '30 mA';
  String mahalTipi = 'Normal Mahal (50V)';
  
  double maxDirenc = 0;
  String form = "";
  bool hesaplandi = false;

  @override
  void dispose() {
    _akimCtrl.dispose();
    super.dispose();
  }

  void hesapla() {
    FocusManager.instance.primaryFocus?.unfocus();
    double iIn = double.tryParse(_akimCtrl.text.replaceAll(',', '.')) ?? 0;
    if (iIn == 0 && kar == 'Yok') { setState(() => hesaplandi = false); return; }
    
    double ul = mahalTipi == 'Normal Mahal (50V)' ? 50 : 25;
    setState(() {
      if (kar == 'Var') {
        double iDelta = karEsik == '30 mA' ? 0.03 : 0.3;
        double r = ul / iDelta;
        maxDirenc = r > 200 ? 200 : r;
        form = "Ra = ${ul.toInt()}V / ${karEsik?.replaceAll(' ', '') ?? ''} -> max ${maxDirenc.toInt()}Ω (Yönetmelik Ç. 12)";
      } else {
        double ia = korumaElemani == 'TMŞ' ? iIn * 1.2 : iIn * 5; 
        maxDirenc = ul / ia;
        form = "Ra = ${ul.toInt()}V / Ia\nIa = ${ia.toStringAsFixed(1)}A";
      }
      hesaplandi = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: t('Topraklama Sınır Değeri', 'Earthing Limit'),
      info: true,
      onInfo: () => bilgiPopup(context, t('Topraklama Sınır Değeri', 'Earthing Limit Value'), t('TT sistemlerinde koruma elemanının açma yapabilmesi için izin verilen en yüksek topraklama geçiş direncini (Ra) hesaplar.', 'Calculates the maximum allowed earthing resistance (Ra) for protection elements to trip in TT systems.')),
      body: ScrollBody(children: [
        SectionCard(title: t('Sistem ve Koruma Bilgileri', 'System and Protection'), children: [
          twoCol(
            Drop(label: t('Sistem Tipi', 'System'), value: sistemTipi, items: const ['TT Sistem'], onChanged: (v) {}),
            Drop(label: t('Koruma Elemanı', 'Protection'), value: korumaElemani, items: const ['TMŞ', 'Sigorta'], onChanged: (v) => setState(() { korumaElemani = v!; hesaplandi = false; })),
          ),
          twoCol(
            Field(controller: _akimCtrl, label: t('Anma Akımı (A)', 'Rated Current (A)')),
            Drop(label: t('KAKR', 'RCD'), value: kar, items: const ['Var', 'Yok'], onChanged: (v) => setState(() { kar = v!; karEsik = kar == 'Yok' ? null : '30 mA'; hesaplandi = false; })),
          ),
          if (kar == 'Var') Drop(label: t('KAKR Eşik', 'RCD Threshold'), value: karEsik ?? '30 mA', items: const ['30 mA', '300 mA'], onChanged: (v) => setState(() { karEsik = v; hesaplandi = false; })),
          Drop(label: t('Mahal', 'Area'), value: mahalTipi, items: const ['Normal Mahal (50V)', 'Nemli Mahal (25V)'], onChanged: (v) => setState(() { mahalTipi = v!; hesaplandi = false; })),
          calcButton(t('HESAPLA', 'CALCULATE'), hesapla),
        ]),
        if (hesaplandi) ...[
          ResultCard(title: t('Maksimum Topraklama Direnci', 'Maximum Earthing Resistance'), value: '${maxDirenc.toStringAsFixed(3)} Ω', good: true),
          AdviceCard(title: t('Uygulanan Formül', 'Applied Formula'), text: form),
        ],
        AdviceCard(title: t('Teknik Uygulama Notu', 'Technical Application Note'), text: 'Topraklama direnci tek başına yeterlilik kanıtı değildir. Dokunma gerilimi, koruma cihazının açma süresi, eşpotansiyel kuşaklama, PE/PEN düzeni, iletken kesitleri, elektrot yapısı ve ölçüm sonucu birlikte değerlendirilmelidir.'),
      ]),
    );
  }
}

// ================= 7. AYDINLATMA HESABI =================
