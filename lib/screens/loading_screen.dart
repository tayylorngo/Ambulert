import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ambulert/services/location.dart';

import 'home_screen.dart';

/// This class defines the LoadingScreen
/// which is the first screen that automatically jumps to the HomeScreen
class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    getLocationData();
    super.initState();
  }

  /// This method retrieves the current user's location data
  /// and passes it to the HomeScreen
  void getLocationData() async {
    Location location1 = Location();
    await location1.getCurrentLocation();
    Navigator.push(
      context,
      PageTransition(
          child: HomeScreen(
            location: location1,
          ),
          type: PageTransitionType.fade,
          alignment: Alignment.bottomCenter),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SpinKitCircle(
          color: Colors.white,
          size: 100.0,
        ),
      ),
    );
  }
}
