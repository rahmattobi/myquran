import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:myquran/app/data/models/detail_surah_m.dart' as detail;
import 'package:myquran/app/modules/widget/surah_card.dart';
import 'package:myquran/theme.dart';

import '../../../data/models/surah_m.dart';
import '../controllers/detail_surah_controller.dart';

class DetailSurahView extends GetView<DetailSurahController> {
  DetailSurahView({super.key});

  final Surah data = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Surah ${data.name!.transliteration!.id}'),
        centerTitle: false,
        elevation: 0,
        backgroundColor: whiteColor,
        foregroundColor: primaryColor,
      ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(
              right: defaultMargin - 5,
              left: defaultMargin - 5,
              top: 10,
            ),
            child: SurahCard(
              nama: data.name!.transliteration!.id,
              arti: data.name!.translation!.id,
              ayat: data.numberOfVerses.toString(),
              type: data.revelation!.id,
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
                  left: defaultMargin - 10,
                  right: defaultMargin - 10,
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
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 5,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    const AssetImage('assets/images/nomor.png'),
                                backgroundColor: Colors.transparent,
                                maxRadius: 16,
                                child: Text(
                                  '${index + 1}',
                                  style: titleTextStyle.copyWith(
                                    fontWeight: medium,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.play_arrow_outlined,
                                      color: Colors.green,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.bookmark_border,
                                      color: Colors.green,
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
                        style: titleTextStyle.copyWith(
                          fontSize: 17,
                          fontWeight: regular,
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
                          fontSize: 16,
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
