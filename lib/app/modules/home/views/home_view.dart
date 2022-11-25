import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:myquran/app/data/models/juz_m.dart' as juz;
import 'package:myquran/app/data/models/surah_m.dart';
import '../../../routes/app_pages.dart';
import '../../../../theme.dart';
import '../../widget/surah_card.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: whiteColor,
        title: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                'My Qur\'an',
                style: primaryTextStyle.copyWith(
                  fontSize: 20,
                  fontWeight: bold,
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search),
              color: Colors.grey,
            ),
          ],
        ),
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Get.toNamed(Routes.lastRead);
              },
              child: SurahCard(
                nama: "Surah Alfatihah",
                ayat: "Ayat no. 1",
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: defaultMargin,
              ),
              child: TabBar(
                labelColor: primaryColor,
                indicatorColor: primaryColor,
                unselectedLabelColor: subtitleColor,
                labelStyle: primaryTextStyle.copyWith(
                  fontWeight: semiBold,
                  fontSize: 16,
                ),
                tabs: const [
                  Tab(
                    text: 'Surah',
                  ),
                  Tab(
                    text: 'Juz',
                  ),
                  Tab(
                    text: 'Bookmark',
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  FutureBuilder<List<Surah>?>(
                    future: controller.getAllSurah(),
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
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          Surah surah = snapshot.data![index];

                          return ListTile(
                            onTap: () {
                              Get.toNamed(
                                Routes.detailSurah,
                                arguments: surah,
                              );
                            },
                            leading: Container(
                              width: 50,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/images/nomor.png'),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '${surah.number!}',
                                  style: subtitleTextStyle.copyWith(
                                    fontWeight: bold,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              "Surah ${surah.name?.transliteration!.id}",
                              style: titleTextStyle.copyWith(
                                fontWeight: medium,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              "${surah.numberOfVerses} ayat | ${surah.revelation!.id}",
                              style: subtitleTextStyle.copyWith(
                                fontWeight: medium,
                                fontSize: 12,
                              ),
                            ),
                            trailing: Text(
                              '${surah.name!.short}',
                              style: primaryTextStyle.copyWith(
                                fontWeight: bold,
                                fontSize: 20,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  FutureBuilder<List<juz.Juz>?>(
                      future: controller.getAllJuz(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                          itemCount: 30,
                          itemBuilder: (context, index) {
                            juz.Juz detailJuz = snapshot.data![index];
                            return ListTile(
                              onTap: () {
                                Get.toNamed(
                                  Routes.detailJuz,
                                  arguments: detailJuz,
                                );
                              },
                              leading: Container(
                                width: 50,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/nomor.png'),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: subtitleTextStyle.copyWith(
                                      fontWeight: bold,
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                "Juz ${index + 1}",
                                style: titleTextStyle.copyWith(
                                  fontWeight: medium,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Mulai dari ${detailJuz.juzStartInfo} ',
                                    style: subtitleTextStyle.copyWith(
                                      fontWeight: medium,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    'Sampai ${detailJuz.juzEndInfo}',
                                    style: subtitleTextStyle.copyWith(
                                      fontWeight: medium,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }),
                  Center(
                    child: Text('data3'),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
