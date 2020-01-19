import 'package:flutter/material.dart';
import 'package:smiletravle/utility/my_style.dart';
import 'package:smiletravle/widget/register.dart';

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  // Field

  // Method
  Widget singInButton() {
    return RaisedButton(
      color: MyStyle().textColor,
      child: Text(
        'Sing In',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {},
    );
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
