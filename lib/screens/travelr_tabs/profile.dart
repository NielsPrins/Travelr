import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travelr/components/rounded_button.dart';

import '../../authentication_service.dart';

class TravelrProfile extends StatefulWidget {
  @override
  _TravelrProfileState createState() => _TravelrProfileState();
}

class Continent {
  String name;
  int timesVisited = 0;

  addVisited() {
    this.timesVisited += 1;
  }

  Continent(this.name);
}

class _TravelrProfileState extends State<TravelrProfile> {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [
            Text(
              firebaseUser.email,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.lightBlueAccent,
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            RoundedButton(
              title: 'Log out',
              colour: Colors.blueAccent,
              onPressed: () {
                context.read<AuthenticationService>().signOut();
              },
            ),
            Divider(
              height: 20,
              thickness: 3,
            ),
            Expanded(
              child: Center(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('/users/' + firebaseUser.uid + '/countries').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Text('Loading...');

                    List<Continent> continents = [
                      Continent('North America'),
                      Continent('South America'),
                      Continent('Europe'),
                      Continent('Africa'),
                      Continent('Asia'),
                      Continent('Oceania')
                    ];

                    for (int i = 0; i < snapshot.data.docs.length; i++) {
                      var alreadyVisitedCountry = snapshot.data.docs[i];

                      for (var i = 0; i < continents.length; i++) {
                        if (continents[i].name == alreadyVisitedCountry['continent']) {
                          continents[i].addVisited();
                        }
                      }
                    }

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Total countries visited: ${snapshot.data.docs.length}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 26,
                                color: Colors.lightBlueAccent,
                              ),
                            ),
                            ListView(
                              shrinkWrap: true,
                              children: [
                                for (var i = 0; i < continents.length; i++)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${continents[i].name}: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 26,
                                        ),
                                      ),
                                      Text(
                                        '${continents[i].timesVisited}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.lightBlueAccent,
                                          fontSize: 26,
                                        ),
                                      )
                                    ],
                                  ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
