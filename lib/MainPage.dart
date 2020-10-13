import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_user/CurdMethods.dart';
import 'package:login_user/GitHubUsersModel.dart';
import 'package:login_user/main.dart';
import 'package:login_user/storeclass.dart';
import 'package:permission_handler/permission_handler.dart';

class MainPage extends StatefulWidget {
  final User user;

  const MainPage({Key key, this.user}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  final databaseReference = Firestore.instance;

  // final DocumentReference documentReference =
  //     Firestore.instance.collection("users").doc("dummy");
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StoreClass obj = new StoreClass();
  String token;

  List<GitHubUsersModel> list;
  String _imageurl;
  var title = TextEditingController();
  var description = TextEditingController();
  var _imagepath;
  PickedFile _pickedFile;
  var isImageLoaded = false;

  // CrudMethods crudobj = new CrudMethods();
  String downloadURL;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            Text(widget.user.displayName),
            Text(widget.user.emailVerified.toString()),
            Text(widget.user.phoneNumber.toString()),
            Container(
              child: _imagepath != null
                  ? Image.file(_imagepath)
                  : Icon(
                      Icons.image,
                      size: 50,
                    ),
              height: 150,
            ),
            Container(
              child: TextField(
                controller: title,
                maxLines: 2,
                minLines: 1,
                decoration: InputDecoration(
                  hintText: "Title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.amber,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
                keyboardType: TextInputType.multiline,
              ),
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            ),
            Container(
              child: TextField(
                maxLines: 10,
                minLines: 5,
                decoration: InputDecoration(
                  hintText: "Please tell us about yourself",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.amber,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
                keyboardType: TextInputType.multiline,
                controller: description,
              ),
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            ),
            
            Container(
              child: RaisedButton(
                onPressed: () async {
                  // _uploadImage();
                  getToken().then((value) {
                    token = value.toString();
                    print(value.toString());
                  });
if (_pickedFile != null) {
         final _storage= FirebaseStorage.instance;
        //Main part of uploading file to the cloud storage
        var data = await _storage
            .ref()
            .child(
            'foldername/${DateTime
                .now()
                .second}-${DateTime
                .now()
                .microsecond}')
            .putFile(_imagepath)
            .onComplete;
        downloadURL = await data.ref.getDownloadURL();
      
        setState(() {
          _imageurl = downloadURL;
        });
      } else {}
                  _add(title.text, description.text, _imageurl);
                },
                child: Text("Upload data"),
              ),
            ),
            Container(
              child: RaisedButton(
                onPressed: () {
                  _uploadImage();
                },
                child: _imagepath == null
                    ? Text("Upload Image")
                    : Text("Change Image"),
              ),
            ),
            Container(
              child: RaisedButton(
                onPressed: () {
                  _signOut().whenComplete(() {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => MyHomePage(),
                      ),
                    );
                  });
                },
                child: Text("Log Out"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> getToken() async {
    String token = await _auth.currentUser.getIdToken();
    return token;
  }

  Future _uploadImage() async {
   
    await Permission.photos.request(); //  show pop up for the permission
    var permission = await Permission.photos.status;
    final _picker = ImagePicker();

    if (permission.isGranted) {
      _pickedFile = await _picker.getImage(source: ImageSource.gallery);
      setState(() {
        _imagepath = File(_pickedFile.path);
      });
      // if (_pickedFile != null) {
      //    final _storage= FirebaseStorage.instance;
      //   //Main part of uploading file to the cloud storage
      //   var data = await _storage
      //       .ref()
      //       .child(
      //       'foldername/${DateTime
      //           .now()
      //           .second}-${DateTime
      //           .now()
      //           .microsecond}')
      //       .putFile(_imagepath)
      //       .onComplete;
      //   downloadURL = await data.ref.getDownloadURL();
      
      //   setState(() {
      //     _imageurl = downloadURL;
      //   });
      // } else {}
    } else {
      print("Please Grant permission and try again");
    }
  }

  Future _signOut() async {
    await _auth.signOut();
  }

  // void createRecord() async {
  //   try {
  //     await databaseReference.collection("books").add({
  //       'title': title.toString(),
  //       'desc': description.toString(),
  //       'img_url': downloadURL
  //     }).whenComplete(
  //         () => print('Created user in database with Google Provider'));
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  void _add(String title, String desc, String image_url) {
    Map<String, String> data = <String, String>{
      "title": title,
      "desc": desc,
      "img_url": image_url
    };
    print(widget.user.uid);
    Firestore.instance
        .collection("users")
        .doc(widget.user.uid)
        .setData(data)
        .whenComplete(() {
      print("Document added");
    }).catchError((e) {
      print(e + "--------------------");
    });
  }

  Future<bool> LoadImage() async {
    final _storage = FirebaseStorage.instance; //Take storage instance

    if (_pickedFile != null) {
      var data = await _storage
          .ref()
          .child(
              'foldername/${DateTime.now().second}-${DateTime.now().microsecond}')
          .putFile(_imagepath)
          .onComplete;
      isImageLoaded = true;
      downloadURL = await data.ref.getDownloadURL();

      setState(() {
        _imageurl = downloadURL;
      });
    } else {}
  }

  void _fetch() {}
}
