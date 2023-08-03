import 'package:bapu/widgets/custom_ripple_effect.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
    required this.drawerMenuLists,
    required this.closeFn,
  });

  final List<Map> drawerMenuLists;
  final Function closeFn;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      backgroundColor: const Color(0xFF00CD80),
      child: ListView(
        children: [
          SizedBox(
            height: 170,
            child: Container(
              margin: const EdgeInsets.only(top: 40, left: 25),
              padding: const EdgeInsets.only(left: 20),
              alignment: Alignment.centerLeft,
              child: SvgPicture.asset(
                'assets/images/small_logo.svg',
              ),
            ),
          ),
          for (Map drawerMenu in drawerMenuLists)
            CustomListTile(
              icon: drawerMenu['icon'],
              label: drawerMenu['label'],
              onClick: drawerMenu['onClick'],
              closeFn: closeFn,
            ),
        ],
      ),
    );
  }
}

class CustomListTile extends StatefulWidget {
  final Icon icon;
  final String label;
  final Function onClick;
  final Function closeFn;

  const CustomListTile({
    Key? key,
    required this.icon,
    required this.label,
    required this.onClick,
    required this.closeFn,
  }) : super(key: key);

  @override
  State<CustomListTile> createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return CustomRippleEffect(
      onClick: () {
        Future.delayed(const Duration(milliseconds: 150), () {
          widget.onClick(context);
          widget.closeFn();
        });
      },
      child: ListTile(
        leading: widget.icon,
        splashColor: Colors.transparent,
        title: Text(widget.label),
      ),
    );
  }
}
