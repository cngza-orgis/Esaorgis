part of 'main.dart';

class EsaTeknikKonu {
  final String id, kategori, baslik, ozet, nedir, nasil, saha, dikkat, ilgiliAraclar, kaynak;
  const EsaTeknikKonu({
    required this.id, required this.kategori, required this.baslik, required this.ozet,
    required this.nedir, required this.nasil, required this.saha, required this.dikkat,
    required this.ilgiliAraclar, required this.kaynak,
  });
  String get aranabilirMetin =>
      '$kategori $baslik $ozet $nedir $nasil $saha $dikkat $ilgiliAraclar $kaynak'.toLowerCase();
}

class EsaTeknikSozlukMaddesi {
  final String terim, acilim, tanim, saha, ilgili;
  const EsaTeknikSozlukMaddesi({
    required this.terim, required this.acilim, required this.tanim,
    required this.saha, required this.ilgili,
  });
  String get aranabilirMetin =>
      '$terim $acilim $tanim $saha $ilgili'.toLowerCase();
}
