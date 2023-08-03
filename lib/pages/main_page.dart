import 'package:bapu/pages/map_page.dart';
import 'package:bapu/pages/notification_page.dart';
import 'package:bapu/widgets/custom_drawer.dart';
import 'package:bapu/widgets/custom_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static List<String> menuList = ["월", "화", "수", "목", "금", "토", "일"];
  static int mainColor = 0xFF00CD80;
  static List<Map> drawerMenus = [
    {
      "label": "공지사항",
      "icon": const Icon(Icons.notification_add),
      "onClick": (BuildContext context) {
        showNotification(
          context,
          "v1.0.1 업데이트 안내",
          "2023.06.30",
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce augue metus, tristique quis nisl eu, placerat iaculis diam. Sed ac mattis mauris. Nullam sollicitudin volutpat quam, vitae finibus nibh consequat sit amet. Integer tincidunt blandit est vitae vehicula. Quisque malesuada dolor non posuere condimentum. Sed sed dui vestibulum, pulvinar ante quis, porta libero. Proin sit amet arcu in erat luctus finibus in sit amet dui. Fusce consectetur lectus non mi sodales, eget cursus purus faucibus. Etiam at ex arcu. Aliquam at lacinia libero, vitae dapibus metus.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce augue metus, tristique quis nisl eu, placerat iaculis diam. Sed ac mattis mauris. Nullam sollicitudin volutpat quam, vitae finibus nibh consequat sit amet. Integer tincidunt blandit est vitae vehicula. Quisque malesuada dolor non posuere condimentum. Sed sed dui vestibulum, pulvinar ante quis, porta libero. Proin sit amet arcu in erat luctus finibus in sit amet dui. Fusce consectetur lectus non mi sodales, eget cursus purus faucibus. Etiam at ex arcu. Aliquam at lacinia libero, vitae dapibus metus.",
        );
      }
    },
    {
      "label": "식단표 사진",
      "icon": const Icon(Icons.photo),
      "onClick": (BuildContext context) {},
    },
    {
      "label": "알레르기 정보 수정",
      "icon": const Icon(Icons.info),
      "onClick": (BuildContext context) {},
    },
    {
      "label": "개발자에게 문의하기",
      "icon": const Icon(Icons.developer_mode),
      "onClick": (BuildContext context) {},
    },
    {
      "label": "HeXA 앱 목록",
      "icon": const Icon(Icons.credit_card),
      "onClick": (BuildContext context) {},
    },
    {
      "label": "주변 식당 목록",
      "icon": const Icon(Icons.map),
      "onClick": (BuildContext context) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const MapPage(),
          ),
        );
      },
    },
  ];

  static List<String> testLists = [
    "어니언하이라이스",
    "계란후라이1EA",
    "우동국",
    "매콤돈까스",
    "양배추콘샐러드",
    "배추김치",
  ];

  DateTime now = DateTime.now();
  String formattedDate = '';
  String mealTime = '';
  static Map<String, String> nextMealTime = {
    '아침': '점심',
    '점심': '저녁',
    '저녁': '아침',
  };

  @override
  void initState() {
    _tabController = TabController(
      length: menuList.length,
      vsync: this,
      initialIndex: now.weekday - 1,
    );
    _tabController.addListener(() {
      _updateDate(_tabController.index);
    });
    _updateDate(now.weekday - 1);
    _getMealTime();
    super.initState();
  }

  void _updateDate(int index) {
    DateTime newDate = now.add(Duration(days: index - now.weekday + 1));
    setState(() {
      formattedDate = DateFormat('MM월 dd일').format(newDate);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  void _closeDrawer() {
    _scaffoldKey.currentState!.closeDrawer();
  }

  void _getMealTime() {
    int currentHour = now.hour;

    setState(() {
      if (currentHour < 11) {
        mealTime = '아침';
      } else if (currentHour < 17) {
        mealTime = '점심';
      } else {
        mealTime = '저녁';
      }
    });
  }

  Widget buildMealTime() {
    return Builder(builder: (context) {
      late dynamic iconData;
      switch (mealTime) {
        case '아침':
          iconData = Icons.light_mode;
          break;
        case '점심':
          iconData = Icons.restaurant;
          break;
        case '저녁':
          iconData = Icons.nightlight;
          break;
      }
      return Icon(
        iconData,
        color: const Color.fromARGB(255, 146, 146, 146),
        size: 20,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Row(
              children: [
                buildMealTime(),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  mealTime,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 146, 146, 146),
                      fontSize: 15,
                      fontWeight: FontWeight.w700),
                )
              ],
            ),
          )
        ],
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            "$formattedDate 식단표",
          ),
        ),
        centerTitle: false,
      ),
      drawer: CustomDrawer(
        drawerMenuLists: drawerMenus,
        closeFn: _closeDrawer,
      ),
      body: Column(
        children: [
          CustomTabBar(
            mainColor: mainColor,
            tabController: _tabController,
            menuList: menuList,
          ),
          buildTabBarView(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openDrawer();
        },
        elevation: 0,
        child: const Icon(Icons.menu),
      ),
    );
  }

  Widget buildTabBarView() {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            mealTime = nextMealTime[mealTime] as String;
          });
        },
        child: TabBarView(
          controller: _tabController,
          children: [
            for (int _ in [1, 2, 3, 4, 5, 6, 7])
              SingleChildScrollView(
                child: Column(
                  children: [
                    const WarningMessage(),
                    GridView.count(
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      crossAxisCount: 2,
                      childAspectRatio: 1 / 1.3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        SingleMenu(menuLists: testLists),
                        SingleMenu(menuLists: testLists),
                        SingleMenu(menuLists: testLists),
                        SingleMenu(menuLists: testLists),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                        bottom: 60.0,
                      ),
                      child: SingleMenu(
                        menuLists: [
                          "학생식당         11:00 - 13:30 (4000원)",
                          "기숙사식당     11:30 - 13:30 (4000원)",
                          "교직원식당     11:30 - 13:30 (5000원)"
                        ],
                        height: 130,
                        disableDisplayKcal: true,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class SingleMenu extends StatelessWidget {
  final List<String> menuLists;
  final double height;
  final bool disableDisplayKcal;

  const SingleMenu({
    Key? key,
    required this.menuLists,
    this.height = 1000,
    this.disableDisplayKcal = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 250, 250, 250),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            height: 35,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 228, 244, 238),
            ),
            child: const Text("기숙사 식당",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Color.fromARGB(255, 0, 189, 117),
                )),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for (String menu in menuLists)
                  Text(
                    menu,
                    style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 66, 66, 66)),
                  )
              ],
            ),
          ),
          !disableDisplayKcal
              ? const SizedBox(
                  height: 30,
                  child: Text(
                    "1007 Kcal",
                    style: TextStyle(
                      color: Color.fromARGB(255, 124, 124, 124),
                      fontSize: 12,
                    ),
                  ),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}

class WarningMessage extends StatelessWidget {
  const WarningMessage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
      child: Container(
        height: 50,
        alignment: Alignment.centerLeft,
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 255, 240, 240),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: const Row(
          children: [
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.warning_rounded,
              color: Color.fromARGB(255, 255, 111, 111),
            ),
            SizedBox(
              width: 5,
            ),
            Text("식단에 알레르기 포함 메뉴를 확인하세요.",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Color.fromARGB(255, 255, 111, 111),
                )),
          ],
        ),
      ),
    );
  }
}
