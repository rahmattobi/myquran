import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:myquran/app/data/models/surah_m.dart';
import '../../../routes/app_pages.dart';
import '../../../../theme.dart';
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
                'My Qur\an',
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
      body: FutureBuilder<List<Surah>?>(
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
                  height: 50,
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
    );
  }
}
