import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smiletravle/utility/my_style.dart';

class AddTravel extends StatefulWidget {
  @override
  _AddTravelState createState() => _AddTravelState();
}

class _AddTravelState extends State<AddTravel> {
  // Field
  double lat, lng;
  LatLng latLng;

  // Method
  @override
  void initState() {
    super.initState();
    findLocation();
  }

  Future<void> findLocation() async{
    Duration duration = Duration(seconds: 10);
    await Timer(duration, () {
      setState(() {
        lat = 13.668428;
        lng = 100.6314179;
      });
    });
  }

  Widget nameForm() {
    return Container(
      height: 50.0,
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: TextField(
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
      icon: Icon(Icons.add_a_photo),
      onPressed: () {},
    );
  }

  Widget galleryButton() {
    return IconButton(
      icon: Icon(Icons.add_photo_alternate),
      onPressed: () {},
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
      child: Image.asset('images/picture.png'),
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

  Widget showMap() {
    if (lat != null) {
      latLng = LatLng(lat, lng);
      CameraPosition cameraPosition = CameraPosition(
        target: latLng,
        zoom: 15.0,
      );
      return GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: cameraPosition,
        onMapCreated: (GoogleMapController googleMapController) {},
      );
    }
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
          nameForm(),
          SizedBox(
            height: 8,
          ),
          detailForm(),
          SizedBox(
            height: 8,
          ),
          showContent(),
        ],
      ),
    );
  }
}
