import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:login_user/MainPage.dart';
import 'package:login_user/SignUpScreen.dart';
import 'package:login_user/storeclass.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Login Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final email_data = TextEditingController();
  final password_data = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  StoreClass obj = new StoreClass();

  // bool isloading = false;

  @override
  Widget build(BuildContext context) {
    print("Hello");
    return Scaffold(
        key: _scaffoldkey,
        // appBar: AppBar(
        //   title: Text(widget.title),
        // ),
        body: Stack(
          children: [
            Image.network(
              "https://images.pexels.com/photos/931018/pexels-photo-931018.jpeg",
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.53,
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(50),
                          bottomLeft: Radius.circular(50))),
                  // color: Colors.grey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        child: Form(
                          key: _formkey,
                          child: Column(
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                    hintText: "Email", icon: Icon(Icons.email)),
                                controller: email_data,
                                validator: (val) {
                                  if (val.isEmpty) {
                                    return "Please put your email";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                validator: (val) {
                                  if (val.isEmpty) {
                                    return "Please fill your password";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    hintText: "Password",
                                    icon: Icon(Icons.lock)),
                                obscureText: true,
                                controller: password_data,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Observer(builder: (context) {
                        return obj.isLoading
                            ? Center(
                          child: SpinKitFoldingCube(color: Colors.blue, size: 30,),
                        )
                            : MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(15),
                                        bottomLeft: Radius.circular(15))),
                                onPressed: () async {
                                  if (_formkey.currentState.validate()) {
                                    _signInWithEmailPassword();
                                  }
                                },
                                child: Text("Login"),
                                color: Colors.blueAccent,
                                textColor: Colors.white,
                              );
                      }),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        child: RichText(
                          text: TextSpan(
                            text: "Does not have an account. ",
                            style: TextStyle(color: Colors.grey),
                            children: [
                              TextSpan(
                                  text: "Register",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black87))
                            ],
                          ),
                        ),
                        onTap: () {
                          _push(context, Register());
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  void _signInWithEmailPassword() async {
    try {
      obj.changeLoading();
      final User user = (await _auth.signInWithEmailAndPassword(
              email: email_data.text, password: password_data.text))
          .user;
      obj.changeLoading();
      if (!user.emailVerified) {
        await user.sendEmailVerification();
      }
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MainPage(
            user: user,
          ),
        ),
      );
    } catch (e) {
      _scaffoldkey.currentState.showSnackBar(
        SnackBar(
          content: Text("Failed to sign in with email and password"),
        ),
      );
      obj.changeLoading();
      print(e);
    }
  }

  void _push(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return page;
    }));
  }
}
