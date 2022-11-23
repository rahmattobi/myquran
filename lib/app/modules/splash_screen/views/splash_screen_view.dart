import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../theme.dart';
import '../../../routes/app_pages.dart';
import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  const SplashScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: defaultMargin,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Qur\'anku',
                style: primaryTextStyle.copyWith(
                  fontSize: 24,
                  fontWeight: bold,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                'Learn Quran and \n Recite once everyday',
                style: subtitleTextStyle.copyWith(
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 40,
              ),
              Lottie.asset('assets/lottie/splash_screen.json'),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 50,
                margin: const EdgeInsets.only(
                  left: 50,
                  right: 50,
                ),
                decoration: BoxDecoration(
                  color: Colors.lightGreen,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      Get.offAllNamed(Routes.home);
                    },
                    child: Text(
                      'Get Started',
                      style: whiteTextStyle.copyWith(
                        fontSize: 18,
                        fontWeight: semiBold,
                      ),
                    ),
                  ),
                ),
              ),

              // Container(
              //   width: 315,
              //   height: 315,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(100),
              //   ),
              //   child: Stack(
              //     children: [
              //       Container(
              //         height: 295,
              //         decoration: BoxDecoration(
              //           color: primaryColor,
              //           borderRadius: BorderRadius.circular(70),
              //         ),
              //         child: Center(
              //           child: Image.asset(
              //             'assets/logo.png',
              //             width: 180,
              //           ),
              //         ),
              //       ),
              //       Positioned(
              //         bottom: 0,
              //         left: 0,
              //         right: 0,
              //         child: GestureDetector(
              //           onTap: () {
              //             Navigator.pushNamed(context, '/home');
              //           },
              //           child: Container(
              //             height: 50,
              //             margin: const EdgeInsets.only(
              //               left: 50,
              //               right: 50,
              //             ),
              //             decoration: BoxDecoration(
              //               color: Colors.lightGreen,
              //               borderRadius: BorderRadius.circular(50),
              //             ),
              //             child: Center(
              //               child: Text(
              //                 'Get Started',
              //                 style: whiteTextStyle.copyWith(
              //                   fontSize: 18,
              //                   fontWeight: semiBold,
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
              //       )
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
