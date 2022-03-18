import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_db/helpers/debug_mode.dart';
import 'package:movie_db/screens/home/home_screen.dart';
import 'package:uni_links/uni_links.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  void initState() {
    super.initState();
    //
  }

  void handleUnitLinks() async {
    try {
      // final initialLink = await getInitialLink(); TODO
    } on Exception catch (err) {
      printLog(
          level: LogLevel.error,
          error: err,
          message: 'Bottom navbar handleUnitLink: ');
    }
  }

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    Widget buildCurrentPage(int index) {
      switch (index) {
        case 0:
          return const HomeSreen();
        case 1:
          return const Scaffold(
            body: Center(
              child: Text('Search Page'),
            ),
          );
        case 2:
          return const Scaffold(
            body: Center(
              child: Text('Favorite Screen'),
            ),
          );
        default:
          return const SizedBox();
      }
    }

    return Scaffold(
      body: buildCurrentPage(currentIndex),
      bottomNavigationBar: CupertinoTabBar(
        border: Border(
          top: BorderSide(color: Colors.grey.shade800, width: 0.4),
        ),
        backgroundColor: Colors.transparent,
        inactiveColor: Colors.grey,
        activeColor: Theme.of(context).primaryColor,
        currentIndex: currentIndex,
        iconSize: 25.0,
        onTap: (index) {
          currentIndex = index;
          setState(() {});
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            activeIcon: Icon(
              CupertinoIcons.house_fill,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search),
            activeIcon: Icon(
              CupertinoIcons.search,
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.heart),
            label: 'Favorites',
            activeIcon: Icon(
              CupertinoIcons.heart_solid,
            ),
          ),
        ],
      ),
    );
  }
}
