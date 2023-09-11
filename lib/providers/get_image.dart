import 'package:http/http.dart' as http;
import 'dart:convert';

class MealImage {
  final String dormitoryUrl;
  final String studentUrl;
  final String professorUrl;

  const MealImage({
    required this.dormitoryUrl,
    required this.professorUrl,
    required this.studentUrl,
  });

  factory MealImage.fromJson(Map<String, dynamic> json) {
    return MealImage(
      dormitoryUrl: json['dormitoryUrl'],
      professorUrl: json['professorUrl'],
      studentUrl: json['studentUrl'],
    );
  }
}

Future<MealImage> fetchImage() async {
  final response = await http.get(Uri.parse('https://meal.hexa.pro/image'));

  if (response.statusCode == 200) {
    return MealImage.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load Image');
  }
}
