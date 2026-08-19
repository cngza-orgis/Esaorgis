part of 'main.dart';

class JeneratorSecimiEkrani extends StatefulWidget {
  const JeneratorSecimiEkrani({super.key});
  @override
  State<JeneratorSecimiEkrani> createState() => _JeneratorSecimiEkraniState();
}

class _JeneratorSecimiEkraniState extends State<JeneratorSecimiEkrani> {
  final _gucCtrl = TextEditingController();
  final _esCtrl = TextEditingController();
  double pf = 0.80, hIhtiyac = 0;
  int oJenerator = 0;
  String form = "";
  bool hesaplandi = false;
  final List<int> genList = [15, 22, 33, 50, 75, 100, 150, 200, 250, 330, 400, 500, 630];

  @override
  void dispose() {
    _gucCtrl.dispose();
    _esCtrl.dispose();
    super.dispose();
  }

  void hesapla() {
    FocusManager.instance.primaryFocus?.unfocus();
    double p = double.tryParse(_gucCtrl.text.replaceAll(',', '.')) ?? 0;
    double es = double.tryParse(_esCtrl.text.replaceAll(',', '.')) ?? 0;
    if (p == 0 || es == 0) { setState(() => hesaplandi = false); return; }
    
    double pEs = p * es;
    double s = pEs / pf;
    int gen = genList.firstWhere((g) => g >= s, orElse: () => 630);
    setState(() { hIhtiyac = s; oJenerator = gen; form = "$p kW × $es = ${pEs.toStringAsFixed(1)} kW\n${pEs.toStringAsFixed(1)} / $pf = ${s.toStringAsFixed(1)} kVA"; hesaplandi = true; });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeLangWrapper(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text(t('Jeneratör Seçimi', 'Generator Selection'), style: const TextStyle(fontSize: 16)),
          actions: [IconButton(icon: const Icon(Icons.info_outline), onPressed: () => bilgiPopup(context, t('Jeneratör Seçimi', 'Generator Selection'), t('Tesisin kurulu gücü ve eş zamanlılık faktörü kullanılarak ihtiyaç duyulan görünür gücü (kVA) hesaplar ve en uygun jeneratörü seçer.', 'Calculates the required apparent power (kVA) using installed capacity and diversity factor, and selects the most suitable generator.')))],
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
                    Expanded(child: TextField(controller: _gucCtrl, keyboardType: TextInputType.number, style: TextStyle(color: cText()), decoration: customInputDec(t('Kurulu Güç (kW)', 'Installed Power')))),
                    const SizedBox(width: 10),
                    Expanded(child: TextField(controller: _esCtrl, keyboardType: TextInputType.number, style: TextStyle(color: cText()), decoration: customInputDec(t('Eş Zamanlılık', 'Diversity Factor')))),
                  ],
                ),
                const SizedBox(height: 20),
                Text('${t('Güç Faktörü', 'Power Factor')} (cosφ): ${pf.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold, color: cText())),
                Slider(value: pf, min: 0.6, max: 1.0, activeColor: cIcon(), onChanged: (v) => setState(() { pf = v; hesaplandi = false; })),
                const SizedBox(height: 15),
                ElevatedButton(onPressed: hesapla, child: Text(t('HESAPLA', 'CALCULATE'))),
                const SizedBox(height: 15),
                if (hesaplandi)
                  Column(
                    children: [
                      uiResultCard(t('İhtiyaç Duyulan Güç', 'Required Power'), hIhtiyac.toStringAsFixed(1), 'kVA'),
                      uiResultCard(t('Önerilen Jeneratör', 'Recommended Gen.'), oJenerator.toString(), 'kVA'),
                      const SizedBox(height: 10),
                      if (form.isNotEmpty) Text(form, style: TextStyle(fontSize: 12, color: cText()), textAlign: TextAlign.center)
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

// ================= 9. SİGORTA SEÇİMİ =================
