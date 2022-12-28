import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
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
          'Qur\'anku',
          style: primaryTextStyle.copyWith(
            fontSize: 20,
            fontWeight: bold,
          ),
        ),
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: defaultMargin,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Assalamu'alaikum",
                    style: titleTextStyle.copyWith(
                      fontWeight: bold,
                      fontSize: 18,
                      color: successColor,
                    ),
                  ),
                  Text(
                    DateFormat.yMMMMEEEEd().format(DateTime.now()),
                    style: subtitleTextStyle.copyWith(
                      fontWeight: semiBold,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            GetBuilder<HomeController>(
              builder: (c) {
                return FutureBuilder<Map<String, dynamic>?>(
                  future: c.getLastRead(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SurahCard(
                        nama: "Loading....",
                        ayat: 'Loading....',
                      );
                    }

                    Map<String, dynamic>? dataLastRead = snapshot.data;

                    if (dataLastRead == null) {
                      return SurahCard(
                        nama: "",
                        ayat: 'Data Terakhir dibaca Kosong...',
                      );
                    }
                    if (c.dataJuzBookmark = false) {
                      return SurahCard(
                        nama: "",
                        ayat: 'Data Juz Masih Loading...',
                      );
                    } else {
                      return InkWell(
                        onTap: () {
                          switch (dataLastRead["via"]) {
                            case "Juz":
                              juz.Juz dataJuz =
                                  controller.juz[dataLastRead["juz"] - 1];

                              String surahStart =
                                  dataJuz.juzStartInfo?.split(" - ").first ??
                                      "";
                              String surahEnd =
                                  dataJuz.juzEndInfo?.split(" - ").first ?? "";

                              List<Surah> rawSurahinJuz = [];
                              List<Surah> allSurahinJuz = [];

                              for (Surah item in controller.allSurah) {
                                rawSurahinJuz.add(item);
                                if (item.name!.transliteration!.id ==
                                    surahEnd) {
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
                              Get.toNamed(
                                Routes.detailJuz,
                                arguments: {
                                  "juz": dataJuz,
                                  "surah": allSurahinJuz.reversed.toList(),
                                  "bookmark": dataLastRead,
                                },
                              );
                              break;
                            default:
                              Get.toNamed(
                                Routes.detailSurah,
                                arguments: {
                                  "name": dataLastRead["surah"],
                                  "number": dataLastRead["number_surah"],
                                  "bookmark": dataLastRead,
                                },
                              );
                          }
                        },
                        child: SurahCard(
                          nama: dataLastRead['surah']
                              .toString()
                              .replaceAll("+", "'"),
                          ayat:
                              "Ayat ${dataLastRead['ayat']} | juz ${dataLastRead['juz']} - via ${dataLastRead['via']}",
                        ),
                        onLongPress: () {
                          Get.defaultDialog(
                              title: "Hapus Terakhir Baca",
                              middleText:
                                  "Apakah Kamu yakin menghapus terakhir dibaca ?",
                              middleTextStyle: subtitleTextStyle,
                              actions: [
                                OutlinedButton(
                                  onPressed: () => Get.back(),
                                  child: Text(
                                    'Batal',
                                    style: primaryTextStyle,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () =>
                                      c.deleteLastRead(dataLastRead['id']),
                                  child: Text(
                                    'Hapus',
                                    style: primaryTextStyle,
                                  ),
                                )
                              ]);
                        },
                      );
                    }
                  },
                );
              },
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
                                arguments: {
                                  "name": surah.name!.transliteration!.id,
                                  "number": surah.number,
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
                          controller.dataJuzBookmark = false;
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

                        controller.dataJuzBookmark = true;
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

                            List<Surah> rawSurahinJuz = [];
                            List<Surah> allSurahinJuz = [];

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
                      if (c.dataJuzBookmark = false) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const CircularProgressIndicator(),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Data Juz masih Loading...',
                                style: primaryTextStyle.copyWith(
                                  fontWeight: medium,
                                  fontSize: 16,
                                ),
                              )
                            ],
                          ),
                        );
                      } else {
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
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Center(
                                  child: Lottie.asset(
                                    'assets/lottie/dataerror.json',
                                  ),
                                ),
                              );
                            }
                            return ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> data =
                                    snapshot.data![index];
                                return ListTile(
                                  leading: Obx(
                                    () => Icon(
                                      Icons.menu_book_rounded,
                                      size: 40,
                                      color: c.isDark.isTrue
                                          ? whiteColor
                                          : const Color.fromARGB(
                                              255, 0, 110, 55),
                                    ),
                                  ),
                                  onTap: () {
                                    switch (data["via"]) {
                                      case "Juz":
                                        juz.Juz dataJuz =
                                            controller.juz[data["juz"] - 1];

                                        String surahStart = dataJuz.juzStartInfo
                                                ?.split(" - ")
                                                .first ??
                                            "";
                                        String surahEnd = dataJuz.juzEndInfo
                                                ?.split(" - ")
                                                .first ??
                                            "";

                                        List<Surah> rawSurahinJuz = [];
                                        List<Surah> allSurahinJuz = [];

                                        for (Surah item
                                            in controller.allSurah) {
                                          rawSurahinJuz.add(item);
                                          if (item.name!.transliteration!.id ==
                                              surahEnd) {
                                            break;
                                          }
                                        }

                                        for (Surah item in rawSurahinJuz
                                            .reversed
                                            .toList()) {
                                          allSurahinJuz.add(item);
                                          if (item.name!.transliteration!.id ==
                                              surahStart) {
                                            break;
                                          }
                                        }
                                        Get.toNamed(
                                          Routes.detailJuz,
                                          arguments: {
                                            "juz": dataJuz,
                                            "surah":
                                                allSurahinJuz.reversed.toList(),
                                            "bookmark": data,
                                          },
                                        );
                                        break;
                                      default:
                                        Get.toNamed(
                                          Routes.detailSurah,
                                          arguments: {
                                            "name": data["surah"],
                                            "number": data["number_surah"],
                                            "bookmark": data,
                                          },
                                        );
                                    }
                                  },
                                  title: Text(
                                    data['surah']
                                        .toString()
                                        .replaceAll("+", "'"),
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
                                  trailing: Obx(() => InkWell(
                                        onTap: () {
                                          c.deleteBookmark(data['id']);
                                        },
                                        child: Icon(
                                          Icons.delete,
                                          color: c.isDark.isTrue
                                              ? whiteColor
                                              : const Color.fromARGB(
                                                  255, 0, 110, 55),
                                        ),
                                      )),
                                );
                              },
                            );
                          },
                        );
                      }
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
