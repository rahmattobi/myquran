import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:myquran/app/data/models/juz_m.dart' as detailjuz;
import 'package:myquran/app/data/models/surah_m.dart';
import 'package:myquran/theme.dart';

import '../../home/controllers/home_controller.dart';
import '../../widget/surah_tile.dart';
import '../controllers/detail_juz_controller.dart';

// ignore: must_be_immutable
class DetailJuzView extends GetView<DetailJuzController> {
  DetailJuzView({Key? key}) : super(key: key);

  var homeC = Get.find<HomeController>();
  final List<Surah> allSurahInJuz = Get.arguments["surah"];
  final detailjuz.Juz juzD = Get.arguments["juz"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Juz ${juzD.juz}',
            style: titleTextStyle.copyWith(
              fontSize: 18,
              fontWeight: bold,
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: ListView.builder(
          padding: EdgeInsets.only(
            left: defaultMargin,
            right: defaultMargin,
            bottom: defaultMargin,
          ),
          itemCount: juzD.verses?.length ?? 0,
          itemBuilder: (context, index) {
            if (juzD.verses == null || juzD.verses!.isEmpty) {
              return const Center(
                child: Text('Data Kosong !!'),
              );
            }

            detailjuz.Verses ayat = juzD.verses![index];

            //menset index dari surah di dalam juz
            if (index != 0) {
              if (ayat.number!.inSurah == 1) {
                controller.index++;
              }
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (ayat.number!.inSurah == 1)
                  InkWell(
                    onTap: () => Get.defaultDialog(
                      title:
                          "Tafsir ${allSurahInJuz[controller.index].name?.transliteration!.id ?? ''}",
                      titleStyle: titleTextStyle.copyWith(
                        fontSize: 20,
                        fontWeight: bold,
                      ),
                      content: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8.0,
                              right: 8.0,
                              bottom: 8.0,
                            ),
                            child: Text(
                              '${allSurahInJuz[controller.index].tafsir!.id}',
                              style: subtitleTextStyle.copyWith(
                                fontWeight: medium,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ],
                      ),
                    ),
                    child: SurahTile(
                      nama: allSurahInJuz[controller.index]
                          .name!
                          .transliteration!
                          .id,
                      arti:
                          allSurahInJuz[controller.index].name!.translation!.id,
                      ayat: allSurahInJuz[controller.index]
                          .numberOfVerses
                          .toString(),
                      type: allSurahInJuz[controller.index].revelation!.id,
                    ),
                  ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: homeC.isDark.isTrue
                        ? primaryColor.withOpacity(0.2)
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(
                      5,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: index + 1 > 99 ? 28 : 25,
                          backgroundImage: AssetImage(
                            homeC.isDark.isTrue
                                ? 'assets/images/nomor2.png'
                                : 'assets/images/nomor3.png',
                          ),
                          backgroundColor: Colors.transparent,
                          child: Text(
                            '${ayat.number!.inSurah}',
                            style: titleTextStyle.copyWith(
                              fontWeight: bold,
                              fontSize: 12,
                              color: homeC.isDark.isTrue
                                  ? whiteColor
                                  : subtitleColor,
                            ),
                          ),
                        ),
                        GetBuilder<DetailJuzController>(
                          init: DetailJuzController(),
                          initState: (_) {},
                          builder: (c) {
                            return Row(
                              children: [
                                (ayat.statusAudio == "stop")
                                    ? IconButton(
                                        onPressed: () {
                                          c.playAudio(ayat);
                                        },
                                        icon: Icon(
                                          Icons.play_arrow_outlined,
                                          color: homeC.isDark.isTrue
                                              ? whiteColor
                                              : Colors.green,
                                        ),
                                      )
                                    : Row(
                                        children: [
                                          (ayat.statusAudio == "playing")
                                              ? IconButton(
                                                  onPressed: () {
                                                    c.pauseAudio(ayat);
                                                  },
                                                  icon: Icon(
                                                    Icons.pause,
                                                    color: homeC.isDark.isTrue
                                                        ? whiteColor
                                                        : Colors.green,
                                                  ),
                                                )
                                              : IconButton(
                                                  onPressed: () {
                                                    c.resumeAudio(ayat);
                                                  },
                                                  icon: Icon(
                                                    Icons.play_arrow_outlined,
                                                    color: homeC.isDark.isTrue
                                                        ? whiteColor
                                                        : Colors.green,
                                                  ),
                                                ),
                                          IconButton(
                                            onPressed: () {
                                              c.stopAudio(ayat);
                                            },
                                            icon: Icon(
                                              Icons.stop,
                                              color: homeC.isDark.isTrue
                                                  ? whiteColor
                                                  : Colors.green,
                                            ),
                                          ),
                                        ],
                                      ),
                                IconButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(25.0),
                                        ),
                                      ),
                                      builder: (context) => Container(
                                        height: 200,
                                        margin: EdgeInsets.only(
                                          top: defaultMargin,
                                          left: defaultMargin,
                                          right: defaultMargin,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: Container(
                                                width: 30,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    width: 2,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Center(
                                              child: Text(
                                                'Qs. ${allSurahInJuz[controller.index].name!.transliteration!.id} : Ayat ${ayat.number!.inSurah}',
                                                style:
                                                    primaryTextStyle.copyWith(
                                                  fontSize: 16,
                                                  color: homeC.isDark.isTrue
                                                      ? whiteColor
                                                      : titleColor,
                                                  fontWeight: semiBold,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const Divider(
                                              color: Colors.grey,
                                              height: 2,
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                controller.addBookmark(
                                                  false,
                                                  allSurahInJuz[
                                                      controller.index],
                                                  ayat,
                                                  index,
                                                );
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.add_box_outlined,
                                                    color: subtitleColor,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    'Tambah ke Bookmark',
                                                    style: subtitleTextStyle
                                                        .copyWith(
                                                      fontWeight: semiBold,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                c.addBookmark(
                                                  true,
                                                  allSurahInJuz[
                                                      controller.index],
                                                  ayat,
                                                  index,
                                                );
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .format_line_spacing_outlined,
                                                    color: subtitleColor,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    'Tandai Terakhir Baca',
                                                    style: subtitleTextStyle
                                                        .copyWith(
                                                      fontWeight: semiBold,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.bookmark_border,
                                    color: homeC.isDark.isTrue
                                        ? whiteColor
                                        : Colors.green,
                                  ),
                                )
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  '${ayat.text!.arab}',
                  style: titleTextStyle.copyWith(
                    fontWeight: bold,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.end,
                ),
                SizedBox(
                  width: defaultMargin + 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${ayat.text!.transliteration!.en}',
                      style: primaryTextStyle.copyWith(
                        fontWeight: medium,
                        fontSize: 16,
                        color: primaryColor,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      '${ayat.translation!.id}',
                      style: subtitleTextStyle.copyWith(
                        fontWeight: medium,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            );
          },
        ));
  }
}
