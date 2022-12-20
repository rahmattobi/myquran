import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:myquran/app/data/models/db/bookmark.dart';
import 'package:myquran/app/modules/home/controllers/home_controller.dart';
import 'package:myquran/theme.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sqflite/sqflite.dart';

import '../../../data/models/detail_surah_m.dart';

class DetailSurahController extends GetxController {
  AutoScrollController scrollC = AutoScrollController();
  final player = AudioPlayer();
  Verse? lastVerse;
  final homeC = Get.find<HomeController>();
  DatabaseManager databaseManager = DatabaseManager.instance;

  void addBookmark(
      bool lastRead, DetailSurah surah, Verse ayat, int indexAyat) async {
    Database db = await databaseManager.db;

    bool testData = false;

    if (lastRead == true) {
      db.delete("bookmark", where: "last_read == 1");
    } else {
      List checkData = await db.query("bookmark",
          where:
              "surah = '${surah.name!.transliteration!.id!.replaceAll("'", "+")}' and number_surah = ${surah.number!} and ayat = ${ayat.number!.inSurah} and juz = ${ayat.meta!.juz} and index_ayat = $indexAyat and last_read = 0");
      if (checkData.isNotEmpty) {
        testData = true;
      }
    }

    if (testData == false) {
      await db.insert(
        "bookmark",
        {
          "surah": surah.name!.transliteration!.id!.replaceAll("'", "+"),
          "number_surah": surah.number!,
          "ayat": ayat.number!.inSurah,
          "juz": ayat.meta!.juz,
          "via": "surah",
          "index_ayat": indexAyat,
          "last_read": lastRead == true ? 1 : 0
        },
      );

      Get.back();
      homeC.update();
      Get.snackbar(
        "Berhasil",
        "Berhasil Menambahkan Bookmark / Last Read",
        colorText: whiteColor,
        backgroundColor: successColor,
      );
    } else {
      Get.back();
      Get.snackbar(
        "Ada Kesalahan",
        "Bookmark Sudah Tersedia",
        backgroundColor: dangerColor,
        colorText: whiteColor,
      );
    }
    var data = await db.query("bookmark");
    print(data);
  }

  Future<DetailSurah> getAyat(String id) async {
    Uri url = Uri.parse('https://api.quran.gading.dev/surah/$id');

    var res = await http.get(url);

    Map<String, dynamic> data =
        (jsonDecode(res.body) as Map<String, dynamic>)["data"];

    return DetailSurah.fromJson(data);
  }

  void playAudio(Verse? ayat) async {
    if (ayat!.audio!.primary!.isNotEmpty) {
      try {
        lastVerse ??= ayat;
        lastVerse!.statusAudio = "stop";
        lastVerse = ayat;
        lastVerse!.statusAudio = "stop";
        update();
        await player.stop();
        await player.setUrl(ayat.audio!.primary!);
        ayat.statusAudio = "playing";
        update();
        await player.play();
        ayat.statusAudio = "stop";
        update();
        await player.stop();
      } on PlayerException catch (e) {
        Get.defaultDialog(
          title: "Terjadi Kesalahan",
          middleText: "Error message: ${e.message}",
        );
      } on PlayerInterruptedException catch (e) {
        Get.defaultDialog(
          title: "Terjadi Kesalahan",
          middleText: "Connection aborted: ${e.message}",
        );
      } catch (e) {
        Get.defaultDialog(
          title: "Terjadi Kesalahan",
          middleText: 'An error occured: $e',
        );
      }
    } else {
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "Url Audio tidak valid",
      );
    }
  }

  void pauseAudio(Verse? ayat) async {
    try {
      await player.pause();
      ayat!.statusAudio = "pause";
      update();
    } on PlayerException catch (e) {
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "Error message: ${e.message}",
      );
    } on PlayerInterruptedException catch (e) {
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "Connection aborted: ${e.message}",
      );
    } catch (e) {
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: 'An error occured: $e',
      );
    }
  }

  void resumeAudio(Verse? ayat) async {
    try {
      ayat!.statusAudio = "playing";
      update();
      await player.play();
      ayat.statusAudio = "stop";
      update();
      await player.stop();
    } on PlayerException catch (e) {
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "Error message: ${e.message}",
      );
    } on PlayerInterruptedException catch (e) {
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "Connection aborted: ${e.message}",
      );
    } catch (e) {
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: 'An error occured: $e',
      );
    }
  }

  void stopAudio(Verse? ayat) async {
    try {
      ayat!.statusAudio = "stop";
      update();
      await player.stop();
    } on PlayerException catch (e) {
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "Error message: ${e.message}",
      );
    } on PlayerInterruptedException catch (e) {
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "Connection aborted: ${e.message}",
      );
    } catch (e) {
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: 'An error occured: $e',
      );
    }
  }

  @override
  void onClose() {
    player.stop();
    super.onClose();
  }
}
