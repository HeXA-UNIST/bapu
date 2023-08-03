import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({
    super.key,
    required this.title,
    required this.content,
    required this.date,
  });

  final String title;
  final String content;
  final String date;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      title: Center(
        child: SvgPicture.asset('assets/images/green_letterless_logo.svg'),
      ),
      content: SizedBox(
        height: 400,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color.fromARGB(255, 121, 121, 121),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                content,
                style: const TextStyle(fontSize: 15),
              )
            ],
          ),
        ),
      ),
      actions: [
        SizedBox(
          width: 150,
          child: FilledButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: const Text(
              "닫기",
              style: TextStyle(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

void showNotification(
  BuildContext context,
  String title,
  String date,
  String content,
) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return NotificationPage(
          title: title,
          date: date,
          content: content,
        );
      });
}
