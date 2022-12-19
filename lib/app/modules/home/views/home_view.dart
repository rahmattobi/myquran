import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:myquran/app/data/models/juz_m.dart' as juz;
import 'package:myquran/app/data/models/surah_m.dart';
import 'package:shimmer/shimmer.dart';
import '../../../routes/app_pages.dart';
import '../../../../theme.dart';
import '../../widget/surah_card.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (Get.isDarkMode) {
      controller.isDark.value = true;
    }
    return Scaffold(
      appBar: AppBar(
        actions: [
          Obx(
            () => Switch(
              onChanged: (val) => controller.toggle(),
              activeColor: darkColor,
              activeTrackColor: primaryColor,
              activeThumbImage: const AssetImage('assets/images/dark.png'),
              inactiveThumbImage: const AssetImage('assets/images/light.png'),
              value: controller.isDark.value,
            ),
          )
        ],
        centerTitle: true,
        elevation: 0,
        title: Text(
          'My Qur\'an',
          style: primaryTextStyle.copyWith(
            fontSize: 20,
            fontWeight: bold,
          ),
        ),
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Obx(
              () => Container(
                height: 60,
                margin: EdgeInsets.only(
                  top: 10,
                  left: defaultMargin - 10,
                  right: defaultMargin - 10,
                ),
                decoration: BoxDecoration(
                  color: controller.isDark.isTrue ? darkColor : whiteColor,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                      color: controller.isDark.isTrue
                          ? primaryColor.withOpacity(0.3)
                          : subtitleColor.withOpacity(0.3),
                    ),
                  ],
                ),
                child: Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: controller.isDark.isTrue
                            ? whiteColor
                            : subtitleColor,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration.collapsed(
                            hintText: 'Cari Doa',
                            hintStyle: subtitleTextStyle.copyWith(
                              fontSize: 15,
                              color: controller.isDark.isTrue
                                  ? whiteColor
                                  : subtitleColor,
                            ),
                          ),
                          onChanged: ((value) {
                            // searchDoa(value);
                          }),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
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
              child: Obx(
                () => TabBar(
                  labelColor:
                      controller.isDark.isTrue ? whiteColor : primaryColor,
                  indicatorColor:
                      controller.isDark.isTrue ? whiteColor : primaryColor,
                  unselectedLabelColor:
                      controller.isDark.isTrue ? primaryColor : subtitleColor,
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
            ),
            Expanded(
              child: TabBarView(
                children: [
                  FutureBuilder<List<Surah>?>(
                    future: controller.getAllSurah(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return ListView.builder(
                          itemBuilder: (context, index) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey,
                              highlightColor: subtitleColor,
                              child: ListTile(
                                leading: const CircleAvatar(),
                                title: Container(
                                  height: 20,
                                  color: whiteColor,
                                ),
                                subtitle: Container(
                                  height: 10,
                                  color: whiteColor,
                                ),
                                trailing: Container(
                                  height: 20,
                                  color: whiteColor,
                                  width: 50,
                                ),
                              ),
                            );
                          },
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
                            leading: Obx(
                              () => CircleAvatar(
                                radius: index + 1 > 99 ? 28 : 23,
                                backgroundImage: AssetImage(
                                  controller.isDark.isTrue
                                      ? 'assets/images/nomor2.png'
                                      : 'assets/images/nomor3.png',
                                ),
                                backgroundColor: Colors.transparent,
                                child: Text(
                                  '${index + 1}',
                                  style: titleTextStyle.copyWith(
                                    fontWeight: bold,
                                    fontSize: 12,
                                    color: controller.isDark.isTrue
                                        ? whiteColor
                                        : subtitleColor,
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
                          return ListView.builder(
                            itemBuilder: (context, index) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey,
                                highlightColor: subtitleColor,
                                child: ListTile(
                                  leading: const CircleAvatar(),
                                  title: Container(
                                    height: 20,
                                    color: whiteColor,
                                  ),
                                  subtitle: Container(
                                    height: 10,
                                    color: whiteColor,
                                  ),
                                ),
                              );
                            },
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

                            //Get surah in juz
                            String surahStart =
                                detailJuz.juzStartInfo?.split(" - ").first ??
                                    "";
                            String surahEnd =
                                detailJuz.juzEndInfo?.split(" - ").first ?? "";

                            List<Surah> allSurahinJuz = [];
                            List<Surah> rawSurahinJuz = [];

                            for (Surah item in controller.allSurah) {
                              rawSurahinJuz.add(item);
                              if (item.name!.transliteration!.id == surahEnd) {
                                break;
                              }
                            }

                            for (Surah item
                                in rawSurahinJuz.reversed.toList()) {
                              allSurahinJuz.add(item);
                              if (item.name!.transliteration!.id ==
                                  surahStart) {
                                break;
                              }
                            }
                            return ListTile(
                              onTap: () {
                                Get.toNamed(
                                  Routes.detailJuz,
                                  arguments: {
                                    "juz": detailJuz,
                                    "surah": allSurahinJuz.reversed.toList(),
                                  },
                                );
                              },
                              leading: Obx(
                                () => CircleAvatar(
                                  radius: index + 1 > 99 ? 28 : 23,
                                  backgroundImage: AssetImage(
                                    controller.isDark.isTrue
                                        ? 'assets/images/nomor2.png'
                                        : 'assets/images/nomor3.png',
                                  ),
                                  backgroundColor: Colors.transparent,
                                  child: Text(
                                    '${index + 1}',
                                    style: titleTextStyle.copyWith(
                                      fontWeight: bold,
                                      fontSize: 12,
                                      color: controller.isDark.isTrue
                                          ? whiteColor
                                          : subtitleColor,
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
                  GetBuilder<HomeController>(
                    builder: (c) {
                      return FutureBuilder<List<Map<String, dynamic>>?>(
                        future: c.getAllBookmark(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.data!.isEmpty) {
                            return const Center(
                              child: Text('Bookmark belum tersedia'),
                            );
                          }
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> data = snapshot.data![index];
                              return ListTile(
                                leading: Obx(
                                  () => Icon(
                                    Icons.menu_book_rounded,
                                    size: 40,
                                    color: c.isDark.isTrue
                                        ? whiteColor
                                        : const Color.fromARGB(255, 0, 110, 55),
                                  ),
                                ),
                                onTap: () {},
                                title: Text(
                                  data['surah'].toString().replaceAll("+", "'"),
                                  style: titleTextStyle.copyWith(
                                    fontWeight: medium,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(
                                  "Ayat ${data['ayat']} - via ${data['via']}",
                                  style: subtitleTextStyle.copyWith(
                                    fontWeight: medium,
                                    fontSize: 12,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
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
