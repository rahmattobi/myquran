import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:myquran/app/data/models/juz_m.dart' as detailjuz;
import 'package:myquran/theme.dart';

import '../../home/controllers/home_controller.dart';
import '../controllers/detail_juz_controller.dart';

class DetailJuzView extends GetView<DetailJuzController> {
  DetailJuzView({Key? key}) : super(key: key);

  final detailjuz.Juz juzD = Get.arguments;
  var homeC = Get.find<HomeController>();

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
                          radius: index + 1 > 99 ? 28 : 25,
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
