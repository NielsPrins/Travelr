import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travelr/components/add_country.dart';

class TravelrList extends StatefulWidget {
  @override
  _TravelrListState createState() => _TravelrListState();
}

class _TravelrListState extends State<TravelrList> {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            children: [
              Text(
                'These are all the countries you\'ve visited',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.lightBlueAccent,
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('/users/' + firebaseUser.uid + '/countries').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Text('Loading...');

                    if (snapshot.data.docs.length == 0)
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text('No countries yet'),
                      );

                    return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(5.0),
                                      child: Image.asset(
                                        'icons/flags/png/${snapshot.data.docs[index]['code']}.png',
                                        package: 'country_icons',
                                        height: 25,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Text('${snapshot.data.docs[index]['name']}')
                                  ],
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  iconSize: 20.0,
                                  color: Colors.red,
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('/users/' + firebaseUser.uid + '/countries')
                                        .doc(snapshot.data.docs[index].id)
                                        .delete();
                                  },
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
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
      ),
    );
  }
}
