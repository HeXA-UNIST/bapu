import 'package:bapu/pages/allergy_page.dart';
import 'package:bapu/pages/main_page.dart';
import 'package:flutter/material.dart';

class AllergySelectPage extends StatefulWidget {
  const AllergySelectPage({super.key});

  @override
  State<AllergySelectPage> createState() => _AllergySelectPageState();
}

class _AllergySelectPageState extends State<AllergySelectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: SvgPicture.asset('assets/images/green_letterless_logo.svg'),
          ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            const Text(
              "알레르기가 있으신가요?",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 20),
            const Text(
              "식단에 알레르기 식품이 \n포함되어 있으면 알려드려요",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 155, 160, 170)),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildSelectButton("알레르기가 없어요", () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const MainPage(),
                      ),
                    );
                  }),
                  const SizedBox(height: 30),
                  buildSelectButton(
                    "알레르기가 있어요",
                    () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AllergyPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildSelectButton(String buttonText, VoidCallback onClick) {
    return SizedBox(
      height: 70,
      child: TextButton(
        onPressed: onClick,
        style: const ButtonStyle(
          backgroundColor:
              MaterialStatePropertyAll(Color.fromARGB(255, 250, 250, 250)),
          shape: MaterialStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)))),
          splashFactory: NoSplash.splashFactory,
          overlayColor: MaterialStatePropertyAll(Color(0xFF00CD80)),
        ),
        child: Text(
          buttonText,
          style: const TextStyle(
            color: Color.fromARGB(255, 118, 118, 118),
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
