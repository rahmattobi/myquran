import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:myquran/app/data/models/juz_m.dart' as detailjuz;
import 'package:myquran/theme.dart';

import '../controllers/detail_juz_controller.dart';

class DetailJuzView extends GetView<DetailJuzController> {
  DetailJuzView({Key? key}) : super(key: key);

  final detailjuz.Juz juzD = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Juz ${juzD.juz}',
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: whiteColor,
          foregroundColor: primaryColor,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/nomor.png'),
                        ),
                      ),
                      child: Center(child: Text('${index + 1}')),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        '${ayat.text!.arab}',
                        style: titleTextStyle.copyWith(
                          fontWeight: semiBold,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: defaultMargin + 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${ayat.text!.transliteration!.en}',
                      style: primaryTextStyle.copyWith(
                        fontWeight: medium,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    Text(
                      '${ayat.translation!.id}',
                      style: subtitleTextStyle.copyWith(
                        fontWeight: medium,
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
