import 'package:flutter/material.dart';

import '../../../theme.dart';

// ignore: must_be_immutable
class SurahCard extends StatelessWidget {
  String? nama;
  String? ayat;

  SurahCard({super.key, this.nama, this.ayat});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 131,
      width: double.infinity,
      margin: EdgeInsets.only(
        right: defaultMargin,
        left: defaultMargin,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            primaryColor,
            const Color.fromARGB(255, 12, 88, 88),
          ],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                left: defaultMargin,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/read.png',
                        width: 20,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Terakhir dibaca',
                        style: whiteTextStyle,
                      )
                    ],
                  ),
                  const Spacer(),
                  Text(
                    nama.toString(),
                    style: whiteTextStyle.copyWith(
                      fontWeight: bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    ayat.toString(),
                    style: whiteTextStyle.copyWith(
                      fontWeight: medium,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              right: 15,
            ),
            child: Opacity(
              opacity: 0.7,
              child: Image.asset(
                'assets/images/logo.png',
                height: 100,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
