import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smiletravle/utility/my_style.dart';
import 'package:smiletravle/widget/home_listview.dart';
import 'package:smiletravle/widget/information.dart';

class Travel extends StatefulWidget {
  @override
  _TravelState createState() => _TravelState();
}

class _TravelState extends State<Travel> {
  //Field
  String name = '', email = '', uid, url;
  Widget currentWidget = HomeListView();

  //Method
  @override
  void initState() {
    super.initState();
    findUID();
  }

  Future<void> findUID() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await firebaseAuth.currentUser();

    setState(() {
      uid = firebaseUser.uid;
      email = firebaseUser.email;
    });
    print('UID ===>>> $uid, E-Mail ===>>> $email');
    findName();
  }

  Future<void> findName() async {
    Firestore firestore = Firestore.instance;
    CollectionReference collectionReference = firestore.collection('Travel');
    await collectionReference.snapshots().listen((response) {
      List<DocumentSnapshot> doucmentSnapshots = response.documents;
      for (var snapshot in doucmentSnapshots) {
        // String name = snapshot.data['Name'];
        // print('Name ===>>> $name');
        //String myUID = snapshot.data['Uid'];
        if (snapshot.data['Uid'] == uid) {
          setState(() {
            name = snapshot.data['Name'];
            url = snapshot.data['Url'];
          });
        }
      }
    });
  }

  Widget showAvatar() {
    return Container(
      width: 80.0,
      height: 80.0,
      child: url == null
          ? Image.asset('images/avatar.png')
          : showAvatarFromFirebase(),
    );
  }

  Widget showAvatarFromFirebase() {
    return CircleAvatar(
      backgroundImage: NetworkImage(url),
    );
  }

  Widget headDrawer() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/wallpaper.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      //decoration: BoxDecoration(color: Colors.orange),
      currentAccountPicture: showAvatar(),
      accountName: Text(
        '$name',
        style: MyStyle().h1WhiteText,
      ),
      accountEmail: Text('$email', style: MyStyle().whiteText,),
    );
  }

  Widget showDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          headDrawer(),
          homeListMenu(),
          informationMenu(),
          signOutMenu(),
        ],
      ),
    );
  }

  Widget homeListMenu() {
    return ListTile(
      leading: Icon(Icons.filter_1),
      title: Text('Home ListView'),
      subtitle: Text('Description for Header'),
      onTap: () {
        setState(() {
          currentWidget = HomeListView();
        });
        Navigator.of(context).pop();
      },
    );
  }

  Widget informationMenu() {
    return ListTile(
      leading: Icon(Icons.filter_2),
      title: Text('Information'),
      subtitle: Text('Description for Header'),
      onTap: () {
        setState(() {
          currentWidget = Information();
        });
        Navigator.of(context).pop();
      },
    );
  }

  Widget signOutMenu() {
    Color color = Colors.red;

    return ListTile(
      leading: Icon(
        Icons.filter_3,
        color: color,
      ),
      title: Text(
        'Sing Out',
        style: TextStyle(color: color),
      ),
      subtitle: Text('Description for Header'),
      onTap: () {
        processSingOut();
      },
    );
  }

  Future<void> processSingOut() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.signOut().then((response) {
      exit(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyStyle().mainColor,
        title: Text('Travel'),
      ),
      drawer: showDrawer(),
      body: currentWidget,
    );
  }
}
