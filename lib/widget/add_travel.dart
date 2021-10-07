import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:smiletravle/utility/my_style.dart';
import 'package:smiletravle/utility/normal_dialog.dart';

class AddTravel extends StatefulWidget {
  @override
  _AddTravelState createState() => _AddTravelState();
}

class _AddTravelState extends State<AddTravel> {
  // Field
  double lat, lng;
  LatLng latLng;
  File file;
  String name, detail, uid = '', url;

  // Method
  @override
  void initState() {
    super.initState();
    findLocation();
  }

  Future<void> findUID() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await firebaseAuth.currentUser();

    setState(() {
      uid = firebaseUser.uid;
    });
    print('UID ===>>> $uid');
  }

  Future<void> findLocation() async {
    LocationData locationData = await findLocationData();
    setState(() {
      lat = locationData.latitude;
      lng = locationData.longitude;
    });

    // Duration duration = Duration(seconds: 5);
    // await Timer(duration, () {
    //   setState(() {
    //     lat = 13.668428;
    //     lng = 100.6314179;
    //   });
    // });
    findUID();
  }

  Future<LocationData> findLocationData() async {
    var location = Location();
    try {
      return await location.getLocation();
    } catch (e) {
      return null;
    }
  }

  Widget nameForm() {
    return Container(
      height: 50.0,
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: TextField(
        onChanged: (String string) {
          name = string.trim();
        },
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Name Travel',
          hintStyle: TextStyle(color: Colors.white),
          prefixIcon: Icon(
            Icons.photo_album,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget detailForm() {
    return Container(
      //height: 50.0,
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: TextField(
        onChanged: (String string) {
          detail = string.trim();
        },
        maxLines: 4,
        keyboardType: TextInputType.multiline,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Detial Travel',
          hintStyle: TextStyle(color: Colors.white),
          prefixIcon: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(
                Icons.details,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget cameraButton() {
    return IconButton(
      icon: Icon(
        Icons.add_a_photo,
        size: 40.0,
      ),
      onPressed: () {
        cameraOrGaller(ImageSource.camera);
      },
    );
  }

  Future<void> cameraOrGaller(ImageSource imageSource) async {
    try {
      var object = await ImagePicker.pickImage(
        source: imageSource,
        maxWidth: 800.0,
        maxHeight: 800.0,
      );
      setState(() {
        file = object;
      });
    } catch (e) {}
  }

  Widget galleryButton() {
    return IconButton(
      icon: Icon(
        Icons.add_photo_alternate,
        size: 40.0,
      ),
      onPressed: () {
        cameraOrGaller(ImageSource.gallery);
      },
    );
  }

  Widget showButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        cameraButton(),
        galleryButton(),
      ],
    );
  }

  Widget showPic() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.3,
      child:
          file == null ? Image.asset('images/picture.png') : Image.file(file),
    );
  }

  Widget showContent() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.3,
      child: lat == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : showMap(),
    );
  }

  Set<Marker> myMarker() {
    return <Marker>[
      Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(13),
        infoWindow: InfoWindow(
          title: 'Your Location',
          snippet: 'Lat = $lat, Lng = $lng',
        ),
        position: latLng,
        markerId: MarkerId('My Location'),
      ),
    ].toSet();
  }

  Widget showMap() {
    if (lat != null) {
      latLng = LatLng(lat, lng);
      CameraPosition cameraPosition = CameraPosition(
        target: latLng,
        zoom: 15.0,
      );
      return GoogleMap(
        markers: myMarker(),
        mapType: MapType.hybrid,
        initialCameraPosition: cameraPosition,
        onMapCreated: (GoogleMapController googleMapController) {},
      );
    }
  }

  Widget saveButton() {
    return RaisedButton(
      color: MyStyle().barColor,
      child: Text(
        'Save & Upload',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      onPressed: () {
        if (file == null) {
          nomalDialog(
              context, 'Choose Image', 'Please Click on Camera or Gallery');
        } else if (name == null ||
            name.isEmpty ||
            detail == null ||
            detail.isEmpty) {
          nomalDialog(context, 'Have space', 'Please fill every blank');
        } else {
          confirmDialog();
        }
      },
    );
  }

  Widget showName() {
    return Text('Name = $name');
  }

  Widget showDetial() {
    return Text('Detail = $detail');
  }

  Widget showImage() {
    return Container(
      height: 200.0,
      child: Image.file(file),
    );
  }

  Widget showLocation() {
    return Text(
      'Lat = $lat, Lng = $lng',
      style: TextStyle(fontSize: 12.0),
    );
  }

  Widget showConfirmContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        showName(),
        showDetial(),
        showImage(),
        showLocation(),
      ],
    );
  }

  Widget cancelButton() {
    return FlatButton(
      child: Text(
        'Cancel',
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget confirmButton() {
    return FlatButton(
      child: Text('Confirm'),
      onPressed: () {
        Navigator.of(context).pop();
        uploadPicture();
      },
    );
  }

  Future<void> uploadPicture() async {
    var now = new DateTime.now();
    print(now);
    String string = '$uid-|-$now';
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    StorageReference storageReference =
        firebaseStorage.ref().child('Travel/$string');
    StorageUploadTask storageUploadTask = storageReference.putFile(file);

    url = await (await storageUploadTask.onComplete).ref.getDownloadURL();
    print('URL ===>>> $url');

    insertValueToFirestore();
  }

  Future<void> insertValueToFirestore() async {
    Map<String, dynamic> map = Map();
    map['Uid'] = uid;
    map['Name'] = name;
    map['Detail'] = detail;
    map['Url'] = url;
    map['Lat'] = lat;
    map['Lng'] = lng;

    Firestore firebaseStorage = Firestore.instance;
    CollectionReference collectionReference =
        firebaseStorage.collection('Travel');
    await collectionReference.document().setData(map).then((respones) {
      Navigator.of(context).pop();
    });
  }

  Future<void> confirmDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext buildContext) {
        return AlertDialog(
          title: Text('Please confirm data'),
          content: showConfirmContent(),
          actions: <Widget>[
            cancelButton(),
            confirmButton(),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyStyle().barColor,
        title: Text('Add New Travel'),
      ),
      body: ListView(
        padding: EdgeInsets.all(10.0),
        children: <Widget>[
          showPic(),
          showButton(),
          SizedBox(height: 8),
          nameForm(),
          SizedBox(height: 8),
          detailForm(),
          SizedBox(height: 8),
          showContent(),
          SizedBox(height: 8),
          saveButton(),
        ],
      ),
    );
  }
}
