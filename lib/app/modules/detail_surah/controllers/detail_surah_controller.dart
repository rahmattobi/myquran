import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/detail_surah_m.dart';

class DetailSurahController extends GetxController {
  Future<DetailSurah> getAyat(String id) async {
    Uri url = Uri.parse('https://api.quran.gading.dev/surah/$id');

    var res = await http.get(url);

    Map<String, dynamic> data =
        (jsonDecode(res.body) as Map<String, dynamic>)["data"];

    print(data);

    return DetailSurah.fromJson(data);
  }
}
