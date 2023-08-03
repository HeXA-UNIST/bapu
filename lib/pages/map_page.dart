import 'dart:async';

import 'package:bapu/widgets/custom_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin {
  Completer<NaverMapController> _controller = Completer();
  bool _isMapReady = false;
  late TabController _tabController;

  void onMapCreated(NaverMapController controller) {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);
  }

  final double initialChildSize = 0.2;
  final double minChildSize = 0.2;
  final double maxChildSize = 0.7;
  final List<String> mapLoaction = ["유니스트", "구영리", "삼산", "울산대"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: mapLoaction.length,
      vsync: this,
      initialIndex: 0,
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _isMapReady = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          "주변 식당 목록",
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: CustomTabBar(
          mainColor: 0xFF00CD80,
          tabController: _tabController,
          menuList: mapLoaction,
        ),
      ),
      body: Stack(
        children: [
          _isMapReady
              ? CustomNaverMap(onMapCreated: onMapCreated)
              : buildMapLoad(),
          DraggableScrollableSheet(
            initialChildSize: initialChildSize,
            minChildSize: minChildSize,
            maxChildSize: maxChildSize,
            snap: true,
            snapAnimationDuration: const Duration(milliseconds: 50),
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  physics: const ClampingScrollPhysics(),
                  child: buildEmptySelectedScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildEmptySelectedScreen() {
    return const Expanded(
      child: Center(
        child: Column(
          children: [Text("식당을 선택하세요.")],
        ),
      ),
    );
  }

  Center buildMapLoad() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 30),
          Text("지도를 불러오고 있습니다."),
        ],
      ),
    );
  }
}

class CustomNaverMap extends StatelessWidget {
  const CustomNaverMap({super.key, required this.onMapCreated});
  final Function(NaverMapController) onMapCreated;

  @override
  Widget build(BuildContext context) {
    return NaverMap(
      activeLayers: const [
        MapLayer.LAYER_GROUP_BUILDING,
        MapLayer.LAYER_GROUP_TRAFFIC,
        MapLayer.LAYER_GROUP_BICYCLE,
        MapLayer.LAYER_GROUP_TRANSIT,
      ],
      mapType: MapType.Navi,
      initialCameraPosition: const CameraPosition(
        target: LatLng(35.5736458, 129.1877499),
        zoom: 14,
      ),
      onMapCreated: onMapCreated,
    );
  }
}
