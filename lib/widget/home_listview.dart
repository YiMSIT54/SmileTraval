import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smiletravle/models/travel_model.dart';
import 'package:smiletravle/utility/my_style.dart';
import 'package:smiletravle/widget/add_travel.dart';

class HomeListView extends StatefulWidget {
  @override
  _HomeListViewState createState() => _HomeListViewState();
}

class _HomeListViewState extends State<HomeListView> {
// Field
  List<TravelModel> travelModels = List();

// Method

  @override
  void initState() {
    super.initState();
    readAllDate();
  }

  Future<void> readAllDate() async {
    Firestore firestore = Firestore.instance;
    CollectionReference collectionReference = firestore.collection('Travel');
    await collectionReference.snapshots().listen((response) {
      List<DocumentSnapshot> snapshots = response.documents;
      for (var snapshot in snapshots) {
        //print('Snapshot ===>>> ${snapshot.data}');
        TravelModel travelModel = TravelModel.fromJsonMap(snapshot.data);
        setState(() {
          travelModels.add(travelModel);
        });
      }
    });
  }

  Widget showName(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          travelModels[index].name,
          style: index % 2 == 0 ? MyStyle().h1Text : MyStyle().h1Text,
        ),
      ],
    );
  }

  Widget showDetial(int index) {
    String string = travelModels[index].detail;
    if (string == null) {
      string = ' - ';
    } else if (string.length > 350) {
      string = string.substring(0, 350);
      string = '          $string ...';
    }
    return Text(string,
        style:
            //TextStyle(color: index % 2 == 0 ? Colors.white : Colors.white),
            TextStyle(color: Colors.white));
  }

  Widget showText(int index) {
    return Container(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 5.0),
      width: MediaQuery.of(context).size.width * 0.75,
      height: MediaQuery.of(context).size.width * 0.40,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[showName(index), showDetial(index)],
      ),
    );
  }

  Widget showImage(int index) {
    return Container(
      padding: EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width * 0.25,
      height: MediaQuery.of(context).size.width * 0.40,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          image: DecorationImage(
            image: NetworkImage(travelModels[index].url),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget showListView() {
    return ListView.builder(
      itemCount: travelModels.length,
      itemBuilder: (BuildContext buildContext, int index) {
        //return Text(travelModels[index].name);
        return Container(
          decoration: BoxDecoration(
              color: index % 2 == 0 ? MyStyle().barColor : MyStyle().mainColor),
          child: Row(
            children: <Widget>[
              showImage(index),
              showText(index),
            ],
          ),
        );
      },
    );
  }

  Widget addButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.0),
              child: FloatingActionButton(
                backgroundColor: MyStyle().textColor,
                child: Icon(Icons.add),
                onPressed: () {
                  MaterialPageRoute materialPageRoute =
                      MaterialPageRoute(builder: (BuildContext buildContext) {
                    return AddTravel();
                  });
                  Navigator.of(context).push(materialPageRoute);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        showListView(),
        addButton(),
      ],
    );
  }
}
