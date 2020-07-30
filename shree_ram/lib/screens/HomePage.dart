import 'package:flutter/material.dart';
import 'package:shree_ram/screens/Overview.dart';
import 'package:shree_ram/screens/ProductAdd.dart';
import 'package:shree_ram/screens/Setting.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _buttomNavColor = Colors.blue;
  int _currentIndex = 0;
  List<Widget> list = List();

  @override
  void initState() {
    list..add(Overview())..add(ProductAdd())..add(Setting());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: list[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          fixedColor: Color(0XFFe4f0e0),
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: _buttomNavColor,
                ),
                title: Text(
                  "Overview",
                  style: TextStyle(color: _buttomNavColor),
                )),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.category,
                  color: _buttomNavColor,
                ),
                title: Text(
                  "Category",
                  style: TextStyle(color: _buttomNavColor),
                )),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings,
                  color: _buttomNavColor,
                ),
                title: Text(
                  "Setting",
                  style: TextStyle(color: _buttomNavColor),
                ))
          ],
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.shifting,
        ));
  }
}
