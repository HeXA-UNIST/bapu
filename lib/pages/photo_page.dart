import 'dart:async';

import 'package:bapu/providers/get_image.dart';
import 'package:bapu/widgets/custom_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:photo_view/photo_view.dart';

class PhotoPage extends StatefulWidget {
  const PhotoPage({Key? key}) : super(key: key);

  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> with TickerProviderStateMixin {
  Completer<NaverMapController> _controller = Completer();
  late TabController _tabController;

  void onMapCreated(NaverMapController controller) {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);
  }

  final double initialChildSize = 0.2;
  final double minChildSize = 0.2;
  final double maxChildSize = 0.7;
  final List<String> restaurantLoaction = ["기숙사 식당", "학생 식당", "교직원 식당"];
  MealImage photoUrls =
      const MealImage(dormitoryUrl: "", professorUrl: "", studentUrl: "");
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: restaurantLoaction.length,
      vsync: this,
      initialIndex: 0,
    );
    Future.delayed(Duration.zero, () async {
      photoUrls = await fetchImage();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          "식단표 사진",
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: SizedBox(
          height: 50,
          child: CustomTabBar(
            mainColor: 0xFF00CD80,
            tabController: _tabController,
            menuList: restaurantLoaction,
          ),
        ),
      ),
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: [
              photoUrls.dormitoryUrl != ""
                  ? PhotoView(
                      imageProvider: NetworkImage(photoUrls.dormitoryUrl))
                  : const SizedBox.shrink(),
              photoUrls.studentUrl != ""
                  ? PhotoView(imageProvider: NetworkImage(photoUrls.studentUrl))
                  : const SizedBox.shrink(),
              photoUrls.professorUrl != ""
                  ? PhotoView(
                      imageProvider: NetworkImage(photoUrls.professorUrl))
                  : const SizedBox.shrink(),
            ],
          )
        ],
      ),
    );
  }

  Center buildLoad() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 30),
          Text("이미지를 불러오고 있습니다."),
        ],
      ),
    );
  }
}
