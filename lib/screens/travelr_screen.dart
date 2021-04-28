import 'package:flutter/material.dart';
import 'package:travelr/screens/travelr_tabs/list.dart';
import 'package:travelr/screens/travelr_tabs/map.dart';
import 'package:travelr/screens/travelr_tabs/profile.dart';

class TravelrScreen extends StatefulWidget {
  @override
  _TravelrScreenState createState() => _TravelrScreenState();
}

class _TravelrScreenState extends State<TravelrScreen> {
  int _selectedTabIndex = 1;

  List<Widget> _widgets = <Widget>[
    TravelrMap(),
    TravelrList(),
    TravelrProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgets.elementAt(_selectedTabIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.public),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          )
        ],
        selectedItemColor: Colors.blue,
        currentIndex: _selectedTabIndex,
        onTap: (selectedTabIndex) => {
          setState(() {
            _selectedTabIndex = selectedTabIndex;
          })
        },
      ),
    );
  }
}
