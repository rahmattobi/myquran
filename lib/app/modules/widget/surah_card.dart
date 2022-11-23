import 'package:flutter/material.dart';
import 'package:myquran/theme.dart';

// ignore: must_be_immutable
class SurahCard extends StatelessWidget {
  String? nama;
  String? arti;
  String? type;
  String? ayat;

  SurahCard({
    super.key,
    this.nama,
    this.arti,
    this.type,
    this.ayat,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            primaryColor,
            const Color.fromARGB(255, 12, 88, 88),
          ],
        ),
        color: primaryColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: defaultMargin,
          horizontal: defaultMargin,
        ),
        child: Column(
          children: [
            Text(
              nama.toString(),
              style: whiteTextStyle.copyWith(
                fontSize: 24,
                fontWeight: bold,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              arti.toString(),
              style: whiteTextStyle.copyWith(
                fontSize: 16,
                fontWeight: medium,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Divider(
              height: 1,
              color: Colors.white,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  type.toString(),
                  style: whiteTextStyle.copyWith(
                    fontWeight: medium,
                  ),
                ),
                Text(
                  '${ayat.toString()} ayat',
                  style: whiteTextStyle.copyWith(
                    fontWeight: medium,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Image.asset(
              'assets/images/bismillah.png',
            ),
          ],
        ),
      ),
    );
  }
}
