import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:getcart/pages/adminPanel.dart';
import 'package:getcart/pages/checkout/addCreditCard.dart';
import 'package:getcart/pages/checkout/paymentMethod.dart';
import 'package:getcart/pages/checkout/placeOrder.dart';
import 'package:getcart/pages/checkout/shippingAddress.dart';
import 'package:getcart/pages/checkout/shippingMethod.dart';
import 'package:getcart/pages/home.dart';
import 'package:getcart/pages/login.dart';
import 'package:getcart/pages/onBoardingScreen/onboardingScreen.dart';
import 'package:getcart/pages/products/items.dart';
import 'package:getcart/pages/products/particularItem.dart';
import 'package:getcart/pages/products/subCategory.dart';
import 'package:getcart/pages/products/wishlist.dart';
import 'package:getcart/pages/profile/contactUs.dart';
import 'package:getcart/pages/profile/editProfile.dart';
import 'package:getcart/pages/profile/setting.dart';
import 'package:getcart/pages/profile/userProfile.dart';
import 'package:getcart/pages/shoppingBag.dart';
import 'package:getcart/pages/signup.dart';
import 'package:getcart/pages/start.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/orders/orderHistory.dart';
import 'components/shop.dart';


bool firstTime;

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  firstTime = (prefs.getBool('initScreen') ?? false);
  if(!firstTime){
    prefs.setBool('initScreen', true);
  }
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    Main()
  );
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: firstTime ? '/': '/onBoarding',
      routes: {
        '/': (context) => Start(),
        '/login': (context) => Login(),
        '/signup': (context) => SignUp(),
        '/home': (context) => Home(),
        '/shop': (context) => Shop(),
        '/subCategory': (context) => SubCategory(),
        '/items': (context) => Items(),
        '/particularItem': (context) => ParticularItem(),
        '/bag': (context) => ShoppingBag(),
        '/wishlist': (context) => WishList(),
        '/checkout/addCreditCard': (context) => AddCreditCard(),
        '/checkout/address': (context) => ShippingAddress(),
        '/checkout/shippingMethod': (context) => ShippingMethod(),
        '/checkout/paymentMethod': (context) => PaymentMethod(),
        '/checkout/placeOrder': (context) => PlaceOrder(),
        '/profile': (context) => UserProfile(),
        '/profile/settings': (context) => ProfileSetting(),
        '/profile/edit': (context) => EditProfile(),
        '/profile/contactUs': (context) => ContactUs(),
        '/placedOrder': (context) => OrderHistory(),
        "/onBoarding": (context) => OnBoardingScreen(),
        "/admin": (context) => AdminPanel()
      },
      theme: ThemeData(
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.white
        )
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isAuth = false;
  void checkBiometric() async {
    final LocalAuthentication auth = LocalAuthentication();
    bool canCheckBiometrics = false;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } catch (e) {
      print("error biome trics $e");
    }
    print("biometric is available: $canCheckBiometrics");
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } catch (e) {
      print("error enumerate biometrics $e");
    }
    print("following biometrics are available");
    if (availableBiometrics.isNotEmpty) {
      availableBiometrics.forEach((ab) {
        print("\ttech: $ab");
      });
    } else {
      print("no biometrics are available");
    }

    bool authenticated = false;

    try {
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Touch your finger on the sensor to login',
          useErrorDialogs: true,
          stickyAuth: false
          // androidAuthStrings:AndroidAuthMessages(signInTitle: "Login to HomePage")
      );
    } catch (e) {
      print("error using biometric auth: $e");
    }

    setState(() {
      isAuth = authenticated ? true : false;
    });

    if(authenticated){
      Navigator.pop(context);
    }

    print("authenticated: $authenticated");
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        home: new Scaffold(
          appBar: new AppBar(
            title: new Text('BioAuthentication'),
          ),
          body: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(),
              ),
              new RaisedButton(
                splashColor: Colors.pinkAccent,
                color: Colors.black,
                child: new Text(
                  "Authentiate",
                  style: new TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                onPressed: checkBiometric,
              ),
              new Expanded(
                child: Container(),
              ),
              isAuth == true
                  ? Text(
                      "Authenticated",
                      softWrap: true,
                      style: new TextStyle(fontSize: 30.0, color: Colors.black),
                    )
                  : Text(
                      "Not Authenticated",
                      softWrap: true,
                      style: new TextStyle(fontSize: 30.0, color: Colors.black),
                    ),
              new Expanded(
                child: Container(),
              ),
            ],
          ),
        ));
  }
}