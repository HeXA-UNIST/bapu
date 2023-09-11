import 'package:bapu/pages/main_page.dart';
import 'package:bapu/providers/get_properties.dart';

import 'package:flutter/material.dart';

class AllergyPage extends StatefulWidget {
  const AllergyPage({super.key});

  @override
  State<AllergyPage> createState() => _AllergyPageState();
}

class _AllergyPageState extends State<AllergyPage> {
  late List allergyList = [];
  int added = 0;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    Future<void>.delayed(Duration.zero, () async {
      await LocalStorageService.init();
      allergyList =
          LocalStorageService.getValue("allergyList", defaultValue: []);
      if (allergyList.isEmpty) {
        allergyList = [
          {"name": "난류", "enable": false},
          {"name": "우유", "enable": false},
          {"name": "메밀", "enable": false},
          {"name": "땅콩", "enable": false},
          {"name": "대두", "enable": false},
          {"name": "밀", "enable": false},
          {"name": "고등어", "enable": false},
          {"name": "게", "enable": false},
          {"name": "새우", "enable": false},
          {"name": "돼지고기", "enable": false},
          {"name": "복숭아", "enable": false},
          {"name": "토마토", "enable": false},
          {"name": "아황산염", "enable": false},
          {"name": "호두", "enable": false},
          {"name": "닭고기", "enable": false},
          {"name": "쇠고기", "enable": false},
          {"name": "오징어", "enable": false},
          {"name": "오징어", "enable": false},
          {"name": "잣", "enable": false},
        ];
      }
      LocalStorageService.setValue("allergyList", allergyList);
      setState(() {});
    });
  }

  void updateToggleState(int index, bool isToggled) {
    setState(() {
      allergyList[index]["enable"] = isToggled;
    });
  }

  // 저장 버튼 눌렀을 때 알레르기 목록 저장
  void saveAllergyList() {
    LocalStorageService.setValue("allergyList", allergyList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: SvgPicture.asset('assets/images/green_letterless_logo.svg'),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            const Text(
              "알레르기를 선택해주세요",
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
            const SizedBox(height: 50),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: allergyList.asMap().entries.map((entry) {
                int index = entry.key;
                Map item = entry.value;
                return CustomToggleButton(
                  buttonText: item["name"],
                  toggleEnable: item['enable'],
                  onToggle: (isToggled) {
                    updateToggleState(index, isToggled);
                    if (isToggled) {
                      added = added + 1;
                    } else {
                      added = added - 1;
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 30)
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 90,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: ElevatedButton(
            style: const ButtonStyle(
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)))),
              elevation: MaterialStatePropertyAll(0),
            ),
            onPressed: () {
              saveAllergyList();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const MainPage(),
                ),
              );
            },
            child: Center(
              child: Text(
                added == 0 ? "변경사항 없음" : '${added.abs()}개 변경사항 저장하기',
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomToggleButton extends StatefulWidget {
  const CustomToggleButton({
    super.key,
    required this.buttonText,
    required this.toggleEnable,
    required this.onToggle,
  });

  final String buttonText;
  final bool toggleEnable;
  final Function onToggle;

  @override
  State<CustomToggleButton> createState() => _CustomToggleButtonState();
}

class _CustomToggleButtonState extends State<CustomToggleButton> {
  bool isToggled = false;

  @override
  void initState() {
    super.initState();
    isToggled = widget.toggleEnable;
  }

  void toggleButton() {
    setState(() {
      isToggled = !isToggled;
      widget.onToggle(isToggled);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleButton,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200), // 애니메이션 지속 시간
        curve: Curves.easeInOut, // 애니메이션 이징 함수

        decoration: BoxDecoration(
          color: isToggled ? const Color(0xFF00CD80) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(13.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 26),
          child: Text(
            widget.buttonText,
            style: TextStyle(
              color: isToggled ? Colors.white : const Color(0xFF717171),
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
