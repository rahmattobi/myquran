import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:myquran/app/data/models/detail_surah_m.dart' as detail;
import 'package:myquran/app/modules/home/controllers/home_controller.dart';
import 'package:myquran/app/modules/widget/surah_tile.dart';
import 'package:myquran/theme.dart';

import '../../../data/models/surah_m.dart';
import '../controllers/detail_surah_controller.dart';

// ignore: must_be_immutable
class DetailSurahView extends GetView<DetailSurahController> {
  DetailSurahView({super.key});

  final Surah data = Get.arguments;
  var homeC = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Surah ${data.name!.transliteration!.id}',
          style: titleTextStyle.copyWith(
            fontSize: 18,
            fontWeight: bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        children: [
          Container(
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
          const SizedBox(
            height: 32,
          ),
          FutureBuilder<detail.DetailSurah>(
            future: controller.getAyat(
              data.number.toString(),
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              // untuk mengcheck apakah ada data
              if (!snapshot.hasData) {
                return const Center(
                  child: Text('Tidak Mempunyai data'),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.only(
                  left: defaultMargin,
                  right: defaultMargin,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data?.verses?.length ?? 0,
                itemBuilder: (context, index) {
                  if (snapshot.data!.verses!.isEmpty) {
                    return const SizedBox();
                  }
                  detail.Verse? ayat = snapshot.data?.verses?[index];
                  return Column(
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
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }
}
