import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.splashScreen,
      getPages: AppPages.routes,
    ),
  );
}


// Testing API

// import 'dart:convert';

// import 'package:http/http.dart' as http;
// import 'package:myquran/app/data/models/detail_surah_m.dart';
// import 'package:myquran/app/data/models/surah_m.dart';

// void main() async {
//   Uri url = Uri.parse('https://api.quran.gading.dev/surah');

//   var res = await http.get(url);

//   List data = (jsonDecode(res.body) as Map<String, dynamic>)["data"];

//   Surah surah = Surah.fromJson(data[1]);
//   // print(surah.number);

//   Uri urls = Uri.parse('https://api.quran.gading.dev/surah/${surah.number}');

//   var ress = await http.get(urls);

//   Map<String, dynamic> datas = (jsonDecode(ress.body) as Map<String, dynamic>)["data"];
//   DetailSurah detail = DetailSurah.fromJson(datas);

//   print(detail.verses![0].text!.arab);
// }
