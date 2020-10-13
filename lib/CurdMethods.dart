// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class CrudMethods {
//   final databaseReference = Firestore.instance;
//
//   bool isLogin() {
//     print("Checking the Login-----------");
//
//     if (FirebaseAuth.instance.currentUser != null) {
//       return true;
//     } else {
//       return false;
//     }
//   }
//
//   Future<void> addData(Map MapData, String token) async {
//     print("adding the data--------------");
//     if (isLogin()) {
//       // Firestore.instance.collection("users").add(MapData).catchError((e) {
//       //   // print(e);
//       //   print("Error in app data method"+e);
//       // });
//       await databaseReference
//           .collection("users")
//           .add(MapData)
//           .catchError((e) {
//         print("There is an error add data class --------------" + e);
//       });
//     } else {
//       print("Please Login");
//     }
//     print("Add data is going to finish");
//   }
// }
