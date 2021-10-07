import 'dart:io';
//import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smiletravle/utility/my_style.dart';
import 'package:smiletravle/utility/normal_dialog.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Field
  File file;
  String dname, email, pass, uid, url;

  // Method

  Widget nameForm() {
    Color color = Colors.purple;
    return Container(
      margin: EdgeInsets.only(
        left: 50.0,
        right: 50.0,
      ),
      child: TextField(
        onChanged: (String string) {
          dname = string.trim();
        },
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
          helperText: 'Type your Firstname Lastname in blank',
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
        onChanged: (String string) {
          email = string.trim();
        },
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
        onChanged: (String string) {
          pass = string.trim();
        },
        style: TextStyle(color: MyStyle().textColor),
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
      onPressed: () {
        cameraOrGallery(ImageSource.camera);
      },
    );
  }

  Future<void> cameraOrGallery(ImageSource imageSource) async {
    try {
      var object = await ImagePicker.pickImage(
        source: imageSource,
        maxWidth: 800.0,
        maxHeight: 800.0,
      );

      setState(() {
        file = object;
      });
    } catch (e) {
      print('e ===>>> ${e.toString()}');
    }
  }

  Widget galleryButton() {
    return OutlineButton.icon(
      icon: Icon(Icons.add_photo_alternate),
      label: Text('Gallery'),
      onPressed: () {
        cameraOrGallery(ImageSource.gallery);
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

  Widget showAvatar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.5,
      child: file == null ? Image.asset('images/avatar.png') : Image.file(file),
    );
  }

  Widget registerButton() {
    return IconButton(
      icon: Icon(Icons.cloud_upload),
      onPressed: () {
        if (file == null) {
          nomalDialog(context, 'No image',
              'Please click Camera or Gallery for choose Image.');
        } else if (dname == null ||
            dname.isEmpty ||
            email == null ||
            email.isEmpty ||
            pass == null ||
            pass.isEmpty) {
          nomalDialog(context, 'Have space', 'Please fill every blank');
        } else {
          registerFirebase();
        }
      },
    );
  }

  Future<void> registerFirebase() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: pass)
        .then((response) {
      print('Register Success');
      findUID();
    }).catchError((response) {
      print('Register Unsuccess');
      String title = response.code;
      String message = response.message;
      nomalDialog(context, title, message);
    });
  }

  Future<void> findUID() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await firebaseAuth.currentUser();
    uid = firebaseUser.uid;
    print('uid ===>>> $uid');
    uploadPicture();
  }

  Future<void> uploadPicture() async {
    //Random random = Random();
    //int i = random.nextInt(9999999);
    String namePic = '$uid.jpg';
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    StorageReference storageReference =
        firebaseStorage.ref().child('Avatar/$namePic');
    StorageUploadTask storageUploadTask = storageReference.putFile(file);
    url = await (await storageUploadTask.onComplete).ref.getDownloadURL();
    print('url ===>>> $url');
    insertValueToFireStore();
  }

  Future<void> insertValueToFireStore() async {
    Map<String, dynamic> map = Map();
    map['Name'] = dname;
    map['Uid'] = uid;
    map['Url'] = url;
    map['Pass'] = pass;

    Firestore firestore = Firestore.instance;
    CollectionReference collectionReference = firestore.collection('Travel');
    await collectionReference.document().setData(map).then((response) {
      Navigator.of(context).pop();
    });
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
