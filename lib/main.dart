import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Application",
      initialRoute: AppPages.splashScreen,
      getPages: AppPages.routes,
    ),
  );
}

// Testing API

// import 'dart:convert';

// import 'package:http/http.dart' as http;
// import 'package:myquran/app/data/models/ayat_m.dart';
// import 'package:myquran/app/data/models/detail_surah_m.dart';
// import 'package:myquran/app/data/models/juz_m.dart';
// import 'package:myquran/app/data/models/surah_m.dart';

// void main() async {
  // Uri url = Uri.parse('https://api.quran.gading.dev/surah');

  // var res = await http.get(url);

  // List data = (jsonDecode(res.body) as Map<String, dynamic>)["data"];

  // Surah surah = Surah.fromJson(data[1]);
  // // print(surah.number);

  // Uri urls = Uri.parse('https://api.quran.gading.dev/surah/${surah.number}');

  // var ress = await http.get(urls);

  // Map<String, dynamic> datas = (jsonDecode(ress.body) as Map<String, dynamic>)["data"];
  // DetailSurah detail = DetailSurah.fromJson(datas);

  // ayat
  // Uri urls = Uri.parse('https://api.quran.gading.dev/surah/114/1');

  // var ress = await http.get(urls);

  // Map<String, dynamic> datas =
  //     (jsonDecode(ress.body) as Map<String, dynamic>)["data"];

  // Ayat ayat = Ayat.fromJson(datas);
  // print(ayat.text!.transliteration!.en);

  // List<Juz> juz = [];
  // for (var id = 1; id <= 30; id++) {
  //   Uri url = Uri.parse('https://api.quran.gading.dev/juz/$id');

  //   var res = await http.get(url);

  //   Map<String, dynamic> data =
  //       (jsonDecode(res.body) as Map<String, dynamic>)["data"];

  //   Juz allJuz = Juz.fromJson(data);

  //   juz.add(allJuz);
  // }
  // return juz;
// }
