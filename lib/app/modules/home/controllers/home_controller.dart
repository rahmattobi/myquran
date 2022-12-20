import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:myquran/app/data/models/db/bookmark.dart';
import 'package:myquran/app/data/models/juz_m.dart';
import 'package:myquran/theme.dart';
import 'package:sqflite/sqflite.dart';

import '../../../data/models/surah_m.dart';

class HomeController extends GetxController {
  RxBool isDark = false.obs; // our observable

  // swap true/false & save it to observable
  void toggle() async {
    Get.isDarkMode ? Get.changeTheme(lightTheme) : Get.changeTheme(darkTheme);
    isDark.toggle();
    final box = GetStorage();

    if (Get.isDarkMode) {
      box.remove("themeDark");
    } else {
      box.write("themeDark", true);
    }
  }

  // Get Bookmark from Sqflite
  DatabaseManager dbM = DatabaseManager.instance;

  Future<List<Map<String, dynamic>>?> getAllBookmark() async {
    Database db = await dbM.db;
    List<Map<String, dynamic>> allBookmark = await db.query(
      "bookmark",
      where: "last_read = 0",
    );
    return allBookmark;
  }

  Future<Map<String, dynamic>?> getLastRead() async {
    Database db = await dbM.db;
    List<Map<String, dynamic>> lastRead = await db.query(
      "bookmark",
      where: "last_read = 1",
    );

    if (lastRead.isEmpty) {
      return null;
    } else {
      return lastRead.first;
    }
  }

  void deleteBookmark(int id) async {
    Database db = await dbM.db;
    await db.delete("bookmark", where: "id= $id");
    update();
    Get.snackbar(
      "Berhasil",
      "Berhasil Menghapus Bookmark",
      backgroundColor: successColor,
      colorText: whiteColor,
    );
  }

  void deleteLastRead(int id) async {
    Database db = await dbM.db;
    await db.delete("bookmark", where: "id= $id");
    update();
    Get.back();

    Get.snackbar(
      "Berhasil",
      "Berhasil Menghapus Terakhir dibaca",
      backgroundColor: successColor,
      colorText: whiteColor,
    );
  }

  List<Surah> allSurah = [];
  Future<List<Surah>?> getAllSurah() async {
    Uri url = Uri.parse('https://api.quran.gading.dev/surah');

    var res = await http.get(url);

    List data = (jsonDecode(res.body) as Map<String, dynamic>)["data"];

    if (data.isEmpty) {
      return [];
    } else {
      allSurah = data.map((e) => Surah.fromJson(e)).toList();
      return allSurah;
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
