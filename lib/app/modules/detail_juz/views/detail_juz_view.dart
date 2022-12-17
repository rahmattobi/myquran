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
                  // Container(
                  //   height: 120,
                  //   width: double.infinity,
                  //   padding: const EdgeInsets.symmetric(vertical: 10),
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(5),
                  //     gradient: LinearGradient(
                  //       begin: Alignment.topRight,
                  //       end: Alignment.bottomLeft,
                  //       colors: [
                  //         primaryColor,
                  //         const Color.fromARGB(255, 12, 88, 88),
                  //       ],
                  //     ),
                  //     color: primaryColor,
                  //   ),
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Text(
                  //         allSurahInJuz[controller.index]
                  //                 .name
                  //                 ?.translation!
                  //                 .id ??
                  //             '',
                  //         style: titleTextStyle.copyWith(
                  //           fontWeight: semiBold,
                  //           fontSize: 20,
                  //           color: whiteColor,
                  //         ),
                  //       ),
                  //       Divider(
                  //         color: subtitleColor.withOpacity(0.5),
                  //         thickness: 1.5,
                  //       ),
                  //       const SizedBox(
                  //         height: 5,
                  //       ),
                  //       Image.asset(
                  //         'assets/images/bismillah.png',
                  //       ),
                  //     ],
                  //   ),
                  // ),
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
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.play_arrow_outlined,
                                color: homeC.isDark.isTrue
                                    ? whiteColor
                                    : Colors.green,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.bookmark_border,
                                color: homeC.isDark.isTrue
                                    ? whiteColor
                                    : Colors.green,
                              ),
                            )
                          ],
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
