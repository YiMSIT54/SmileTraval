import 'package:flutter/material.dart';
import 'package:smiletravle/utility/my_style.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Field

  // Method

  Widget nameForm() {
    Color color = Colors.purple;
    return Container(
      margin: EdgeInsets.only(
        left: 50.0,
        right: 50.0,
      ),
      child: TextField(
        style: TextStyle(color: MyStyle().textColor),
        decoration: InputDecoration(
          icon: Icon(
            Icons.account_circle,
            color: MyStyle().textColor,
            size: 36.0,
          ),
          labelText: 'Display Name',
          labelStyle: TextStyle(
            fontFamily: 'Sarabun',
            color: Colors.blue.shade900,
          ),
          helperText: 'Type your Name in blank',
          helperStyle: TextStyle(color: color),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: MyStyle().textColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget emailForm() {
    Color color = Colors.purple;
    return Container(
      margin: EdgeInsets.only(
        left: 50.0,
        right: 50.0,
      ),
      child: TextField(
        style: TextStyle(color: MyStyle().textColor),
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          icon: Icon(
            Icons.mail_outline,
            color: MyStyle().textColor,
            size: 36.0,
          ),
          labelText: 'E-Mail',
          labelStyle: TextStyle(
            fontFamily: 'Sarabun',
            color: Colors.blue.shade900,
          ),
          helperText: 'Type your E-Mail in blank',
          helperStyle: TextStyle(color: color),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: MyStyle().textColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget passForm() {
    Color color = Colors.purple;
    return Container(
      margin: EdgeInsets.only(
        left: 50.0,
        right: 50.0,
      ),
      child: TextField(
        style: TextStyle(color: MyStyle().textColor),
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          icon: Icon(
            Icons.lock_outline,
            color: MyStyle().textColor,
            size: 36.0,
          ),
          labelText: 'Password',
          labelStyle: TextStyle(
            fontFamily: 'Sarabun',
            color: Colors.blue.shade900,
          ),
          helperText: 'Type your Password in blank',
          helperStyle: TextStyle(color: color),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: MyStyle().textColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget cameraButton() {
    return OutlineButton.icon(
      icon: Icon(Icons.add_a_photo),
      label: Text('Camera'),
      onPressed: () {},
    );
  }

  Widget galleryButton() {
    return OutlineButton.icon(
      icon: Icon(Icons.add_photo_alternate),
      label: Text('Gallery'),
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

  Widget showAvatar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.5,
      child: Image.asset('images/avatar.png'),
    );
  }

  Widget registerButton() {
    return IconButton(
      icon: Icon(Icons.cloud_upload),
      onPressed: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          registerButton(),
        ],
        backgroundColor: MyStyle().barColor,
        title: Text('Register'),
      ),
      body: ListView(
        children: <Widget>[
          showAvatar(),
          showButton(),
          SizedBox(
            height: 10.0,
          ),
          nameForm(),
          emailForm(),
          passForm(),
        ],
      ),
    );
  }
}
