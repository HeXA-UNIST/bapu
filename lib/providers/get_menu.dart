import 'dart:convert';

import 'package:http/http.dart' as http;

final Map dayTypeMap = {
  "MON": 0,
  "TUE": 1,
  "WED": 2,
  "THU": 3,
  "FRI": 4,
  "SAT": 5,
  "SUN": 6
};

final Map mealTypeMap = {
  "BREAKFAST": 0,
  "LUNCH": 1,
  "DINNER": 2,
};

class MenuInfo {
  final List<dynamic> menus;
  final int calorie;
  final String restaurantType;

  MenuInfo({
    required this.menus,
    required this.calorie,
    required this.restaurantType,
  });

  factory MenuInfo.fromJson(Map<String, dynamic> json) {
    return MenuInfo(
      menus: json['menus'],
      calorie: json['calorie'],
      restaurantType: json['restaurantType'],
    );
  }
}

Future<List<List<List<MenuInfo>>>> fetchMenuInfo() async {
  final response =
      await http.get(Uri.parse('https://meal.hexa.pro/mainpage/data'));

  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
    var list = jsonResponse;

    List<List<List<MenuInfo>>> res =
        List.generate(7, (_) => List.generate(3, (_) => <MenuInfo>[]));

    for (var item in list) {
      int dayType = dayTypeMap[item['dayType']];
      int mealType = mealTypeMap[item['mealType']];

      res[dayType][mealType].add(MenuInfo.fromJson(item));
    }

    return res;
  } else {
    throw Exception('Failed to load MenuInfo');
  }
}
