import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:travelr/components/add_country.dart';

class TravelrMap extends StatefulWidget {
  @override
  _TravelrMapState createState() => _TravelrMapState();
}

class _TravelrMapState extends State<TravelrMap> {
  MapShapeSource _mapSource;
  MapZoomPanBehavior _zoomPanBehavior;

  @override
  void initState() {
    _zoomPanBehavior = MapZoomPanBehavior()
      ..zoomLevel = 10
      ..minZoomLevel = 5
      ..focalLatLng = MapLatLng(48.858372564054754, 2.2944801943526834)
      ..toolbarSettings = MapToolbarSettings();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final firebaseUser = context.watch<User>();
    return Scaffold(
      body: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('/users/' + firebaseUser.uid + '/countries').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Text('Loading');

            _mapSource = MapShapeSource.asset(
              'assets/countries.json',
              shapeDataField: 'admin',
              dataCount: snapshot.data.docs.length,
              primaryValueMapper: snapshot.data.docs.length == 0 ? null : (int index) => snapshot.data.docs[index]['name'],
              shapeColorValueMapper: (int index) => Colors.blue,
            );

            return Center(
              child: SfMaps(
                layers: <MapShapeLayer>[
                  MapShapeLayer(
                    source: _mapSource,
                    strokeColor: Colors.white,
                    strokeWidth: 1,
                    shapeTooltipBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(7),
                        child: Text(snapshot.data.docs[index]['name'],
                            style: themeData.textTheme.caption.copyWith(color: themeData.colorScheme.surface)),
                      );
                    },
                    tooltipSettings: MapTooltipSettings(color: Colors.grey[700], strokeColor: Colors.white, strokeWidth: 2),
                    zoomPanBehavior: _zoomPanBehavior,
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.85 - MediaQuery.of(context).viewInsets.bottom,
                child: AddCountry(),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
