import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:smiletravle/utility/my_style.dart';
import 'package:smiletravle/utility/normal_dialog.dart';
import 'package:smiletravle/widget/register.dart';
import 'package:smiletravle/widget/travel.dart';

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  // Field
  String user = '', pass = '';

  // Method

  @override
  void initState() {
    super.initState();
    checkStatus();
  }


  Future<void> checkStatus() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await firebaseAuth.currentUser();
    if (firebaseUser != null) {
      routeToTravel();
    }
  }

  Widget singInButton() {
    return RaisedButton(
      color: MyStyle().textColor,
      child: Text(
        'Sing In',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        checkAuthen();
      },
    );
  }

  Future<void> checkAuthen() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth
        .signInWithEmailAndPassword(
      email: user,
      password: pass,
    )
        .then((response) {
      routeToTravel();
    }).catchError((response) {
      String title = response.code;
      String message = response.message;
      nomalDialog(context, title, message);
    });
  }

  void routeToTravel() {
    MaterialPageRoute materialPageRoute =
        MaterialPageRoute(builder: (BuildContext buildContext) => Travel());
    Navigator.of(context)
        .pushAndRemoveUntil(materialPageRoute, (Route<dynamic> route) => false);
  }

  Widget singUpButton() {
    return OutlineButton(
      // color: MyStyle().textColor,
      child: Text(
        'Sing Up',
        style: TextStyle(
          color: MyStyle().textColor,
        ),
      ),
      onPressed: () {
        print('You Click Sing Up');

        MaterialPageRoute materialPageRoute =
            MaterialPageRoute(builder: (BuildContext buildContext) {
          return Register();
        });
        Navigator.of(context).push(materialPageRoute);
      },
    );
  }

  Widget showButton() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        singInButton(),
        SizedBox(
          width: 10.0,
        ),
        singUpButton(),
      ],
    );
  }

  Widget userForm() {
    return Container(
      width: 250.0,
      child: TextField(
        onChanged: (String string) {
          user = string.trim();
        },
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
              color: MyStyle().textColor,
            )),
            prefixIcon: Icon(
              Icons.mail_outline,
              color: MyStyle().textColor,
            ),
            hintText: 'E-Mail : ',
            hintStyle: TextStyle(
              color: MyStyle().textColor,
            )),
      ),
    );
  }

  Widget passForm() {
    return Container(
      width: 250.0,
      child: TextField(
        onChanged: (String string) {
          pass = string.trim();
        },
        obscureText: true,
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
              color: MyStyle().textColor,
            )),
            prefixIcon: Icon(
              Icons.lock_outline,
              color: MyStyle().textColor,
            ),
            hintText: 'Password : ',
            hintStyle: TextStyle(
              color: MyStyle().textColor,
            )),
      ),
    );
  }

  Widget showLogo() {
    return Container(
      width: 120.0,
      child: Image.asset('images/authlogo.png'),
    );
  }

  Widget showAppName() {
    return Text(
      'Smile Travel ไทย',
      style: MyStyle().h1Text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            radius: 1.2,
            colors: <Color>[
              Colors.white,
              MyStyle().mainColor,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              showLogo(),
              showAppName(),
              userForm(),
              passForm(),
              SizedBox(
                height: 10.0,
              ),
              showButton(),
            ],
          ),
        ),
      ),
    );
  }
}
