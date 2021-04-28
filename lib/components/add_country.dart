import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travelr/data/countries.dart';

class AddCountry extends StatefulWidget {
  @override
  _AddCountryState createState() => _AddCountryState();
}

class _AddCountryState extends State<AddCountry> {
  String _search = '';
  bool _removedAlreadyVisited = false;
  List<Country> selectableCountries = List.of(countries);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    if (!_removedAlreadyVisited) {
      FirebaseFirestore.instance.collection('/users/' + firebaseUser.uid + '/countries').get().then(
        (QuerySnapshot snapshot) {
          snapshot.docs.forEach((alreadyVisitedCountry) {
            var alreadyVisitedCountriesToRemove = [];
            selectableCountries.forEach((selectableCountry) {
              if (selectableCountry.name == alreadyVisitedCountry['name']) {
                alreadyVisitedCountriesToRemove.add(selectableCountry);
              }
            });
            selectableCountries.removeWhere((e) => alreadyVisitedCountriesToRemove.contains(e));
          });
          setState(() {
            _removedAlreadyVisited = true;
          });
        },
      );
    }

    var countriesToRemove = [];
    selectableCountries.forEach((selectableCounty) {
      if (_search.isNotEmpty) {
        if (!selectableCounty.name.toLowerCase().contains(_search)) {
          countriesToRemove.add(selectableCounty);
        }
      }
    });

    List<Country> selectableCountriesAfterSearch = List.of(selectableCountries);
    selectableCountriesAfterSearch.removeWhere((e) => countriesToRemove.contains(e));

    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Text(
                'Choose a country',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                  color: Colors.lightBlueAccent,
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _search = value.toLowerCase();
                        });
                      },
                      decoration: InputDecoration(
                          labelText: "Search",
                          hintText: "Search",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: selectableCountriesAfterSearch.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text('${selectableCountriesAfterSearch[index].name}'),
                          onTap: () {
                            FirebaseFirestore.instance.collection('/users/' + firebaseUser.uid + '/countries').doc().set({
                              'name': selectableCountriesAfterSearch[index].name,
                              'code': selectableCountriesAfterSearch[index].code,
                              'continent': selectableCountriesAfterSearch[index].continent
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
