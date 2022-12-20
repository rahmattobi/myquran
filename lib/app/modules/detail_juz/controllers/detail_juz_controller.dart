import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:myquran/app/data/models/juz_m.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../theme.dart';
import '../../../data/models/db/bookmark.dart';
import '../../../data/models/surah_m.dart';
import '../../home/controllers/home_controller.dart';

class DetailJuzController extends GetxController {
  int index = 0;
  final player = AudioPlayer();
  Verses? lastVerse;
  DatabaseManager databaseManager = DatabaseManager.instance;
  final homeC = Get.find<HomeController>();


void addBookmark(
      bool lastRead, Surah surah, Verses ayat, int indexAyat) async {
    Database db = await databaseManager.db;

    bool testData = false;

    if (lastRead == true) {
      db.delete("bookmark", where: "last_read == 1");
    } else {
      List checkData = await db.query("bookmark",
          where:
              "surah = '${surah.name!.transliteration!.id!.replaceAll("'", "+")}' and ayat = ${ayat.number!.inSurah} and juz = ${ayat.meta!.juz} and index_ayat = $indexAyat and last_read = 0");
      if (checkData.isNotEmpty) {
        testData = true;
      }
    }

    if (testData == false) {
      await db.insert(
        "bookmark",
        {
          "surah": surah.name!.transliteration!.id!.replaceAll("'", "+"),
          "ayat": ayat.number!.inSurah,
          "juz": ayat.meta!.juz,
          "via": "Juz",
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
    // var data = await db.query("bookmark");
    // print(data);
  }

  void playAudio(Verses? ayat) async {
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

  void pauseAudio(Verses ayat) async {
    try {
      await player.pause();
      ayat.statusAudio = "pause";
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

  void resumeAudio(Verses ayat) async {
    try {
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
  }

  void stopAudio(Verses ayat) async {
    try {
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

  @override
  void onClose() {
    player.stop();
    super.onClose();
  }
}
