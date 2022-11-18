import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/surah_m.dart';

class HomeController extends GetxController {
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
}
