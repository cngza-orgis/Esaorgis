part of 'main.dart';


// Teknik referans ve saha veri katmanı.
// Veriler referans/ön değerlendirme amacıyla kullanılır; nihai seçim güncel
// mevzuat, ilgili standart, TEDAŞ/dağıtım şirketi şartnamesi, üretici verisi
// ve onaylı proje ile doğrulanmalıdır.

class TrafoReferans {
  final int kva;
  final String agBara;
  final String agAnaKabloYerAlti;
  final String agAnaKabloHava;
  final String anaKorumaReferansi;
  final String termikAyarReferansi;
  final String sabitKondansatorKvar;
  const TrafoReferans({
    required this.kva,
    required this.agBara,
    required this.agAnaKabloYerAlti,
    required this.agAnaKabloHava,
    required this.anaKorumaReferansi,
    required this.termikAyarReferansi,
    required this.sabitKondansatorKvar,
  });
}

const List<TrafoReferans> trafoReferanslari = [
  TrafoReferans(kva: 50, agBara: '20x3 mm Cu', agAnaKabloYerAlti: '4x16 mm² NYY', agAnaKabloHava: '4x16 mm² NYY', anaKorumaReferansi: '3x100 A sınıfı', termikAyarReferansi: '80–100 A', sabitKondansatorKvar: '—'),
  TrafoReferans(kva: 100, agBara: '40x3 mm Cu', agAnaKabloYerAlti: '4x50 mm² NYY', agAnaKabloHava: '3x50+25 mm² NYY', anaKorumaReferansi: '3x150 A sınıfı', termikAyarReferansi: '120–150 A', sabitKondansatorKvar: '—'),
  TrafoReferans(kva: 160, agBara: '40x3 mm Cu', agAnaKabloYerAlti: '3x70+35 mm² NYY', agAnaKabloHava: '2(3x50/25) mm² NYY', anaKorumaReferansi: '3x250 A sınıfı', termikAyarReferansi: '200–250 A', sabitKondansatorKvar: '—'),
  TrafoReferans(kva: 200, agBara: '40x3 mm Cu', agAnaKabloYerAlti: '3x120+70 mm² NYY', agAnaKabloHava: '3x150+70 mm² NYY', anaKorumaReferansi: '3x300 A sınıfı', termikAyarReferansi: '260–300 A', sabitKondansatorKvar: '—'),
  TrafoReferans(kva: 250, agBara: '40x3 mm Cu', agAnaKabloYerAlti: '3x120+70 mm² NYY', agAnaKabloHava: '3(1x150)+1x70 mm²', anaKorumaReferansi: '3x400 A sınıfı', termikAyarReferansi: '320–400 A', sabitKondansatorKvar: '1,5 kVAr'),
  TrafoReferans(kva: 315, agBara: '40x5 mm Cu', agAnaKabloYerAlti: '3(1x150)+1x70 mm²', agAnaKabloHava: '3(1x185)+1x95 mm²', anaKorumaReferansi: '3x500 A sınıfı', termikAyarReferansi: '400–500 A', sabitKondansatorKvar: '2,5 kVAr'),
  TrafoReferans(kva: 400, agBara: '40x5 mm Cu', agAnaKabloYerAlti: '6(1x150)+240 mm²', agAnaKabloHava: '3(1x240)+1x120 mm²', anaKorumaReferansi: '3x600 A sınıfı', termikAyarReferansi: '480–600 A', sabitKondansatorKvar: '2,5 kVAr'),
  TrafoReferans(kva: 500, agBara: '50x10 mm Cu', agAnaKabloYerAlti: '2(3x120+70) mm²', agAnaKabloHava: '6(1x240)+(1x240) mm²', anaKorumaReferansi: '3x800 A sınıfı', termikAyarReferansi: '700–800 A', sabitKondansatorKvar: '5 kVAr'),
  TrafoReferans(kva: 630, agBara: '50x10 mm Cu', agAnaKabloYerAlti: '6(1x150)+2(1x150) mm²', agAnaKabloHava: '9(1x185)+3(1x95) mm²', anaKorumaReferansi: '3x1000 A sınıfı', termikAyarReferansi: '800–1000 A', sabitKondansatorKvar: '5 kVAr'),
  TrafoReferans(kva: 800, agBara: '60x10 mm Cu', agAnaKabloYerAlti: '9(1x150)+2(1x70) mm²', agAnaKabloHava: '9(1x240)+3(1x120) mm²', anaKorumaReferansi: '3x1200 A sınıfı', termikAyarReferansi: '1000–1200 A', sabitKondansatorKvar: '7,5 kVAr'),
  TrafoReferans(kva: 1000, agBara: '80x10 mm Cu', agAnaKabloYerAlti: '15(1x120)+5(1x70) mm²', agAnaKabloHava: '12(1x240)+2(1x240) mm²', anaKorumaReferansi: '3x1600 A sınıfı', termikAyarReferansi: '1400–1600 A', sabitKondansatorKvar: '10 kVAr'),
  TrafoReferans(kva: 1250, agBara: '100x10 mm Cu', agAnaKabloYerAlti: '18(1x120)+3(1x120) mm²', agAnaKabloHava: '15(1x240)+5(1x120) mm²', anaKorumaReferansi: '3x2000 A sınıfı', termikAyarReferansi: '1800–2150 A', sabitKondansatorKvar: '12,5 kVAr'),
  TrafoReferans(kva: 1600, agBara: '2(80x10) mm Cu', agAnaKabloYerAlti: '12(1x240)+2(1x240) mm²', agAnaKabloHava: '18(1x240)+3(1x240) mm²', anaKorumaReferansi: '3x2500 A sınıfı', termikAyarReferansi: '2300–2500 A', sabitKondansatorKvar: '15 kVAr'),
  TrafoReferans(kva: 2000, agBara: '2(100x10) mm Cu', agAnaKabloYerAlti: '15(1x240)+5(1x120) mm²', agAnaKabloHava: '24(1x240)+4(1x240) mm²', anaKorumaReferansi: '3x3000 A sınıfı', termikAyarReferansi: '2500–3000 A', sabitKondansatorKvar: '17,5 kVAr'),
  TrafoReferans(kva: 2500, agBara: '2(100x10) mm Cu', agAnaKabloYerAlti: '18(1x240)+3(1x240) mm²', agAnaKabloHava: '30(1x240)+5(1x240) mm²', anaKorumaReferansi: '3x4000 A sınıfı', termikAyarReferansi: '3000–4000 A', sabitKondansatorKvar: '20 kVAr'),
];

TrafoReferans? trafoBul(int kva) {
  for (final item in trafoReferanslari) {
    if (item.kva == kva) return item;
  }
  return null;
}
