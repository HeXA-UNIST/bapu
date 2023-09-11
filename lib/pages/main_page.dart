import 'package:bapu/pages/notification_page.dart';
import 'package:bapu/pages/photo_page.dart';
import 'package:bapu/providers/get_announce.dart';
import 'package:bapu/providers/get_menu.dart';
import 'package:bapu/providers/get_properties.dart';
import 'package:bapu/widgets/custom_drawer.dart';
import 'package:bapu/widgets/custom_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late List<List<List<MenuInfo>>> menuInfoList = [];
  static List<String> menuList = ["월", "화", "수", "목", "금", "토", "일"];
  static int mainColor = 0xFF00CD80;
  static List<Map> drawerMenus = [
    {
      "label": "공지사항",
      "icon": const Icon(Icons.notification_add),
      "onClick": (BuildContext context) {
        Future<void>.delayed(Duration.zero, () async {
          Announce newAnnounce = await fetchAnnounce();
          showNotification(
            context,
            newAnnounce.title,
            newAnnounce.time,
            newAnnounce.content,
          );
        });
      }
    },
    {
      "label": "식단표 사진",
      "icon": const Icon(Icons.photo),
      "onClick": (BuildContext context) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const PhotoPage(),
          ),
        );
      },
    },
    // {
    //   "label": "알레르기 정보 수정",
    //   "icon": const Icon(Icons.info),
    //   "onClick": (BuildContext context) {
    //     Navigator.of(context).push(
    //       MaterialPageRoute(
    //         builder: (context) => const AllergyPage(),
    //       ),
    //     );
    //   },
    // },
    {
      "label": "개발자에게 문의하기",
      "icon": const Icon(Icons.developer_mode),
      "onClick": (BuildContext context) async {
        final Uri uri = Uri.parse("https://pf.kakao.com/_xcaYlxj");
        if (!await launchUrl(uri)) {
          throw Exception('Could not launch');
        }
      },
    },
    // {
    //   "label": "HeXA 앱 목록",
    //   "icon": const Icon(Icons.credit_card),
    //   "onClick": (BuildContext context) {},
    // },
    // {
    //   "label": "주변 식당 목록",
    //   "icon": const Icon(Icons.map),
    //   "onClick": (BuildContext context) {
    //     Navigator.of(context).push(
    //       MaterialPageRoute(
    //         builder: (context) => const MapPage(),
    //       ),
    //     );
    //   },
    // },
    {
      "label": "도움말",
      "icon": const Icon(Icons.help),
      "onClick": (BuildContext context) {
        showNotification(
          context,
          "도움말",
          "V1",
          "기본적으로 앱을 시작하면, 요일(월, 화, 수, 목, 금, 토, 일)과 식사시간(아침, 점심, 저녁)이 자동으로 설정됩니다.\n\n화면을 좌우로 스크롤 하면 요일이 변경되고, 화면을 한번 클릭하면 식사시간이 변경됩니다.\n\n건의사항이 있을시 카카오톡 채널을 통해 문의해주세요.\n\n\n개발참여자 : 박예찬, 수정, 전민국, 예헌수, 홍준화",
        );
      },
    },
  ];

  DateTime now = DateTime.now();
  String formattedDate = '';
  String mealTime = '';
  late Announce newAnnouncementMap;
  final Map<String, String> nextMealTime = {
    '아침': '점심',
    '점심': '저녁',
    '저녁': '아침',
  };
  final Map<String, String> mealTimeDurationDormitory = {
    "아침": "8:00 - 9:00",
    "점심": "11:30 - 13:30",
    "저녁": "17:30 - 19:00"
  };

  final Map<String, String> mealTimeDurationStudent = {
    "아침": "미운영",
    "점심": "11:00 - 13:30",
    "저녁": "17:00 - 19:00"
  };

  final Map<String, String> mealTimeDurationProfessor = {
    "아침": "미운영",
    "점심": "11:30 - 13:30",
    "저녁": "17:30 - 19:30"
  };

  final Map<String, int> convertMealTime = {
    "아침": 0,
    "점심": 1,
    "저녁": 2,
  };

  void _initMenuInfoList() async {
    menuInfoList = await fetchMenuInfo();
    setState(() {});
  }

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
    Future<void>.delayed(Duration.zero, _initMenuInfoList);

    Future<void>.delayed(
      Duration.zero,
      () async {
        await LocalStorageService.init();
        newAnnouncementMap = await fetchAnnounce();
        String lastAnnounceContent;
        lastAnnounceContent = await LocalStorageService.getValue(
          "announceTime",
          defaultValue: "None",
        );
        if (lastAnnounceContent == "None" ||
            newAnnouncementMap.content != lastAnnounceContent) {
          await LocalStorageService.setValue(
              "announceTime", newAnnouncementMap.content);
          showNotification(
            context,
            newAnnouncementMap.title,
            newAnnouncementMap.time,
            newAnnouncementMap.content,
          );
        }
      },
    );
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
      } else if (currentHour < 15) {
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
    return WillPopScope(
      onWillPop: () async {
        return Future(() => false);
      },
      child: Scaffold(
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
      ),
    );
  }

  Widget buildMapLoad() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 30),
          Text("메뉴를 불러오고 있습니다."),
        ],
      ),
    );
  }

  Widget buildTabBarView() {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(
            () {
              mealTime = nextMealTime[mealTime] as String;
            },
          );
        },
        child: TabBarView(
          controller: _tabController,
          children: [
            for (int weekIndex in [1, 2, 3, 4, 5, 6, 7])
              SingleChildScrollView(
                child: Column(
                  children: [
                    // weekIndex % 3 == 0
                    //     ? const WarningMessage()
                    //     : const SizedBox.shrink(),
                    menuInfoList.isNotEmpty
                        ? GridView.count(
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            crossAxisCount: 2,
                            childAspectRatio: 1 / 1.3,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              ...menuInfoList[weekIndex - 1]
                                      [convertMealTime[mealTime]?.toInt() ?? 0]
                                  .map<Widget>(
                                (info) {
                                  return SingleMenu(
                                    restaurantName: info.restaurantType,
                                    menuLists: info.menus,
                                    calorie: info.calorie,
                                  );
                                },
                              ).toList()
                            ],
                          )
                        : SizedBox(
                            height: 200,
                            child: buildMapLoad(),
                          ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                        bottom: 60.0,
                      ),
                      child: SingleMenu(
                        restaurantName: "식당 운영시간 및 가격",
                        menuLists: [
                          "기숙사식당     ${mealTimeDurationDormitory[mealTime]} (4000원)",
                          "학생식당         ${mealTimeDurationStudent[mealTime]} (4000원)",
                          "교직원식당     ${mealTimeDurationProfessor[mealTime]} (5500원)"
                        ],
                        height: 130,
                        disableDisplayKcal: true,
                        calorie: 0,
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
  final List<dynamic> menuLists;
  final double height;
  final bool disableDisplayKcal;
  final String restaurantName;
  final int calorie;

  const SingleMenu({
    Key? key,
    required this.menuLists,
    required this.restaurantName,
    required this.calorie,
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
            child: Text(restaurantName,
                style: const TextStyle(
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
              ? SizedBox(
                  height: 30,
                  child: Text(
                    "$calorie Kcal",
                    style: const TextStyle(
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
