import 'package:flutter/material.dart';
import 'package:smart_home/view/home/select_device/select_device.dart';
import 'package:smart_home/view/home/bottom_navbar/bottom_bar_item.dart';
import 'package:smart_home/view/home/home_page/home_page.dart';
import 'package:smart_home/view/home/settings/settings.dart';
import 'package:smart_home/widgets/widgets.dart';
// import 'package:double_back_to_close/double_back_to_close.dart';

// class MainScreen extends StatelessWidget {
//   const MainScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(

//       home: DoubleBack(child: HomeBottomBar()),
//       //DoubleBack(child: MyBottomNavigationBar()),
//     );
//   }
// }

class HomeBottomBar extends StatefulWidget {
  const HomeBottomBar({Key? key}) : super(key: key);
  @override
  _HomeBottomBarState createState() => _HomeBottomBarState();
}

class _HomeBottomBarState extends State<HomeBottomBar> {
  final List<Widget> pages = [const HomePage(), const Settings()];
  int index = 0;
  void onChangedTab(int index) {
    setState(() {
      this.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFecf5fb),
      extendBody: true,
      body: pages[index],
      bottomNavigationBar: TabBarMaterialWidget(
        backgroundColor: kBackgroundColor,
        selectedColor: fontColor,
        color: Colors.grey,
        index: index,
        onChangedTab: onChangedTab,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SelectDevice())),
        child: const Icon(
          Icons.add,
          color: fontColor,
        ),
        tooltip: "Add Switches",
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
