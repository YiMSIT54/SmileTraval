import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smiletravle/utility/my_style.dart';

class Travel extends StatefulWidget {
  @override
  _TravelState createState() => _TravelState();
}

class _TravelState extends State<Travel> {
  //Field
  String name = '', email = '', uid, pic = 'images/avatar.png';

  //Method
  @override
  void initState() {
    super.initState();
    findUID();
  }

  Future<void> findUID() async{
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await firebaseAuth.currentUser();
    uid = firebaseUser.uid;
    email = firebaseUser.email;
    print('UID ===>>> $uid, E-Mail ===>>> $email');
    findName();
  }

  Future<void> findName() async{
    Firestore firestore = Firestore.instance;
    CollectionReference collectionReference = firestore.collection('Travel');
    await collectionReference.snapshots().listen((response) {
      List<DocumentSnapshot> doucmentSnapshots = response.documents;
      for (var snapshot in doucmentSnapshots) {
        // String name = snapshot.data['Name'];
        // print('Name ===>>> $name');
        //String myUID = snapshot.data['Uid'];
        if (snapshot.data['Uid'] == uid) {
          name = snapshot.data['Name'];
          pic = snapshot.data['Pic'];
        }
      }
    });

  }

  Widget showAvatar() {
    return Container(
      width: 80.0,
      height: 80.0,
      child: Image.asset('$pic'),
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
      accountEmail: Text('$email'),
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
    );
  }

  Widget informationMenu() {
    return ListTile(
      leading: Icon(Icons.filter_2),
      title: Text('Information'),
      subtitle: Text('Description for Header'),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyStyle().mainColor,
        title: Text('Travel'),
      ),
      drawer: showDrawer(),
    );
  }
}
