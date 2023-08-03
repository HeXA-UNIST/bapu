import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({
    super.key,
    required this.mainColor,
    required TabController tabController,
    required this.menuList,
  }) : _tabController = tabController;

  final int mainColor;
  final TabController _tabController;
  final List<String> menuList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          color: Color.fromRGBO(250, 250, 250, 1),
        ),
        height: 40,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 5.0,
          ),
          child: TabBar(
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Color(mainColor),
            ),
            labelColor: Colors.white,
            unselectedLabelColor: const Color.fromRGBO(147, 147, 147, 1),
            controller: _tabController,
            labelStyle:
                const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
            tabs: <Widget>[for (String menu in menuList) Text(menu)],
          ),
        ),
      ),
    );
  }
}
