import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:myquran/app/data/models/juz_m.dart';

import '../../../data/models/surah_m.dart';

class HomeController extends GetxController {

  RxBool isDark = false.obs; // our observable

  // swap true/false & save it to observable
  void toggle() => isDark.value = isDark.value ? false : true;


  Future<List<Surah>?> getAllSurah() async {
    Uri url = Uri.parse('https://api.quran.gading.dev/surah');

    var res = await http.get(url);

    List data = (jsonDecode(res.body) as Map<String, dynamic>)["data"];

    if (data.isEmpty) {
      return [];
    } else {
      return data.map((e) => Surah.fromJson(e)).toList();
    }
  }

  Future<List<Juz>?> getAllJuz() async {
    List<Juz> juz = [];
    for (var id = 1; id <= 30; id++) {
      Uri url = Uri.parse('https://api.quran.gading.dev/juz/$id');

      var res = await http.get(url);

      Map<String, dynamic> data =
          (jsonDecode(res.body) as Map<String, dynamic>)["data"];

      Juz allJuz = Juz.fromJson(data);

      juz.add(allJuz);  
    }
    return juz;
  }
}
