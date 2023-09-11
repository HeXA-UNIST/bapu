import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class Announce {
  final String title;
  final String content;
  final bool isNull;
  final String time;

  const Announce({
    required this.title,
    required this.content,
    required this.time,
    required this.isNull,
  });

  factory Announce.fromJson(Map<String, dynamic> json) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    return Announce(
      // title: json['title'],
      title: "공지사항",
      content: json['content'],
      // time: json['time'],
      time: formattedDate,
      isNull: false,
    );
  }
}

Future<Announce> fetchAnnounce() async {
  final response = await http.get(Uri.parse('https://meal.hexa.pro/notice'));

  if (response.statusCode == 200) {
    return Announce.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load Announce');
  }

  // return Future.delayed(const Duration(seconds: 2)).then((value) {
  //   return const Announce(
  //     title: "공지사항",
  //     content: "content",
  //     time: "2023.06.35",
  //     isNull: false,
  //   );
  // });
}
