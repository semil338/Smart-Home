import 'package:flutter/material.dart';
import 'package:smart_home/view/home/bottom_navbar/home_bottom_bar.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:smart_home/view/home/drawer/menu_drawer.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({Key? key}) : super(key: key);

  final controller = ZoomDrawerController();
  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      borderRadius: 24,
      openCurve: Curves.fastOutSlowIn,
      closeCurve: Curves.easeInOut,
      angle: 0,
      mainScreenTapClose: true,
      controller: controller,
      slideWidth: MediaQuery.of(context).size.width * 0.65,
      boxShadow: const [BoxShadow(color: Colors.white)],
      backgroundColor: Colors.white24,
      style: DrawerStyle.Style1,
      showShadow: true,
      mainScreen: const HomeBottomBar(),
      menuScreen: const MenuDrawer(),
    );
  }
}
