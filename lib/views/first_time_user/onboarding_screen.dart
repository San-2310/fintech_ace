import 'package:concentric_transition/page_view.dart';
import 'package:fintech_ace/views/first_time_user/welcome_screen.dart';
import 'package:flutter/material.dart';

import 'onboarding1.dart';
import 'onboarding2.dart';
import 'onboarding3.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var pages = [
      Onboarding1(),
      Onboarding2(),
      Onboarding3(),
    ];

    return Scaffold(
        body: ConcentricPageView(
            itemCount: 3,
            physics: BouncingScrollPhysics(),
            itemBuilder: (index) {
              return pages[index];
            },
            onFinish: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WelcomeScreen()),
              ); // Replace HomePage with your target page))
            },
            colors: [
          Color.fromRGBO(244, 224, 253, 1),
          Color.fromRGBO(227, 196, 242, 1),
          Color.fromRGBO(223, 185, 240, 1),
        ]));
  }
}
