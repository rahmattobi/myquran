import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:myquran/app/data/models/detail_surah_m.dart' as detail;
import 'package:myquran/app/modules/home/controllers/home_controller.dart';
import 'package:myquran/app/modules/widget/surah_tile.dart';
import 'package:myquran/theme.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../controllers/detail_surah_controller.dart';

// ignore: must_be_immutable
class DetailSurahView extends GetView<DetailSurahController> {
  DetailSurahView({super.key});
  Map<String, dynamic>? bookmark;
  var homeC = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'SURAH ${Get.arguments['name'].toString().toUpperCase()}',
            style: titleTextStyle.copyWith(
              fontSize: 18,
              fontWeight: bold,
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: FutureBuilder<detail.DetailSurah>(
          future: controller.getAyat(Get.arguments['number'].toString()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData) {
              return const Center(
                child: Text('Tidak Mempunyai data'),
              );
            }
            if (Get.arguments['bookmark'] != null) {
              bookmark = Get.arguments['bookmark'];
              controller.scrollC.scrollToIndex(
                bookmark!['index_ayat'] + 2,
                preferPosition: AutoScrollPosition.begin,
              );
            }

            detail.DetailSurah data = snapshot.data!;
            List<Widget> allAyat =
                List.generate(snapshot.data?.verses?.length ?? 0, (index) {
              detail.Verse? ayat = snapshot.data?.verses?[index];
              return AutoScrollTag(
                key: ValueKey(index + 2),
                index: index + 2,
                controller: controller.scrollC,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: defaultMargin - 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
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
                                radius: index + 1 > 99 ? 28 : 23,
                                backgroundImage: AssetImage(
                                  homeC.isDark.isTrue
                                      ? 'assets/images/nomor2.png'
                                      : 'assets/images/nomor3.png',
                                ),
                                backgroundColor: Colors.transparent,
                                child: Text(
                                  '${index + 1}',
                                  style: titleTextStyle.copyWith(
                                    fontWeight: bold,
                                    fontSize: 12,
                                    color: homeC.isDark.isTrue
                                        ? whiteColor
                                        : subtitleColor,
                                  ),
                                ),
                              ),
                              GetBuilder<DetailSurahController>(
                                init: DetailSurahController(),
                                initState: (_) {},
                                builder: (c) {
                                  return Row(
                                    children: [
                                      (ayat!.statusAudio == "stop")
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
                                                          color: homeC
                                                                  .isDark.isTrue
                                                              ? whiteColor
                                                              : Colors.green,
                                                        ),
                                                      )
                                                    : IconButton(
                                                        onPressed: () {
                                                          c.resumeAudio(ayat);
                                                        },
                                                        icon: Icon(
                                                          Icons
                                                              .play_arrow_outlined,
                                                          color: homeC
                                                                  .isDark.isTrue
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
                                              borderRadius:
                                                  BorderRadius.vertical(
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
                                                            BorderRadius
                                                                .circular(50),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Center(
                                                    child: Text(
                                                      'Qs. ${data.name!.transliteration!.id} : Ayat ${ayat.number!.inSurah}',
                                                      style: primaryTextStyle
                                                          .copyWith(
                                                        fontSize: 16,
                                                        color:
                                                            homeC.isDark.isTrue
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
                                                      c.addBookmark(
                                                        false,
                                                        snapshot.data!,
                                                        ayat,
                                                        index,
                                                      );
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .add_box_outlined,
                                                          color: subtitleColor,
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          'Tambah ke Bookmark',
                                                          style:
                                                              subtitleTextStyle
                                                                  .copyWith(
                                                            fontWeight:
                                                                semiBold,
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
                                                        snapshot.data!,
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
                                                          style:
                                                              subtitleTextStyle
                                                                  .copyWith(
                                                            fontWeight:
                                                                semiBold,
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
                        '${ayat!.text!.arab}',
                        style: titleTextStyle.copyWith(
                          fontSize: 18,
                          fontWeight: bold,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        '${ayat.text!.transliteration!.en}',
                        style: primaryTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: regular,
                          color: primaryColor,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        '${ayat.translation!.id}',
                        style: subtitleTextStyle.copyWith(
                          fontSize: 15,
                          fontWeight: regular,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(
                        height: defaultMargin,
                      ),
                    ],
                  ),
                ),
              );
            });
            return ListView(
              controller: controller.scrollC,
              children: [
                AutoScrollTag(
                  key: const ValueKey(0),
                  index: 0,
                  controller: controller.scrollC,
                  child: Container(
                    margin: EdgeInsets.only(
                      right: defaultMargin - 5,
                      left: defaultMargin - 5,
                      top: 10,
                    ),
                    child: InkWell(
                      onTap: () => Get.defaultDialog(
                        title: "Tafsir ${data.name!.transliteration!.id}",
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
                                '${data.tafsir!.id}',
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
                        nama: data.name!.transliteration!.id,
                        arti: data.name!.translation!.id,
                        ayat: data.numberOfVerses.toString(),
                        type: data.revelation!.id,
                      ),
                    ),
                  ),
                ),
                AutoScrollTag(
                  key: const ValueKey(1),
                  index: 1,
                  controller: controller.scrollC,
                  child: const SizedBox(
                    height: 32,
                  ),
                ),
                ...allAyat
              ],
            );
          },
        ));
  }
}
