import 'package:ambulert/services/location.dart';
import 'package:ambulert/services/network.dart';
import 'package:ambulert/widgets/address.dart';
import 'package:ambulert/widgets/bottom_modal.dart';
import 'package:ambulert/widgets/bottom_modal_custom.dart';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../secrets.dart';

/// This class defines the HomeScreen which is the main screen
/// that shows user location, and functions.
class HomeScreen extends StatefulWidget {
  const HomeScreen({required this.location});
  final Location location;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String address1 = "";
  String address2 = "";

  @override
  void initState() {
    getCurrentAddress(widget.location.latitude, widget.location.longitude);
    super.initState();
  }

  void getCurrentAddress(double latitude, double longitude) async {
    String URL =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&location_type=ROOFTOP&result_type=street_address&key=$googleApiKey';
    NetworkHelper networkHelper = NetworkHelper(URL);
    var locationData = await networkHelper.getData();
    String address = "";
    if (locationData['results'].length == 0) {
      address = locationData['plus_code']['compound_code'];
      address = address.substring(address.indexOf(' '));
      address = address.replaceAll("  ", '');
      setState(() {
        address1 = address;
      });
    } else {
      address = locationData['results'][0]['formatted_address'];
      var address_format = address.split(',');
      setState(() {
        address1 = address_format[0];
        address2 = address_format[1].replaceAll(' ', '') +
            address_format[2].replaceAll("  ", "");
      });
    }
  }

  void updateAddress() async {
    Location location = Location();
    await location.getCurrentLocation();
    getCurrentAddress(location.latitude, location.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60.0),
              const Center(
                child: Icon(FontAwesomeIcons.ambulance, size: 100),
              ),
              const SizedBox(height: 40.0),
              TypewriterAnimatedTextKit(
                text: const ['Ambulert'],
                textAlign: TextAlign.center,
                textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 50.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    FontAwesomeIcons.locationArrow,
                    color: Colors.lightBlueAccent,
                  ),
                  Text(
                    ' Location',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.lightBlueAccent,
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 15.0),
              Address(address: address1),
              Address(address: address2),
              const SizedBox(height: 20.0),
              Center(
                child: ArgonButton(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  borderRadius: 5.0,
                  color: Colors.green,
                  child: const Text(
                    "Update Location",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                  loader: Container(
                    padding: const EdgeInsets.all(10),
                    child: const SpinKitRotatingCircle(
                      color: Colors.white,
                      // size: loaderWidth ,
                    ),
                  ),
                  onTap: (startLoading, stopLoading, btnState) {
                    if (btnState == ButtonState.Idle) {
                      startLoading();
                      // await whatever then set new location
                      updateAddress();
                      stopLoading();
                    }
                  },
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ArgonButton(
                    height: MediaQuery.of(context).size.height / 4,
                    width: MediaQuery.of(context).size.width * 0.47,
                    borderRadius: 5.0,
                    color: Colors.red,
                    child: Column(
                      children: const [
                        SizedBox(
                          height: 60,
                        ),
                        Icon(FontAwesomeIcons.locationArrow),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Send Alert to Current Location",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    loader: Container(
                      padding: const EdgeInsets.all(10),
                      child: const SpinKitRotatingCircle(
                        color: Colors.white,
                        // size: loaderWidth ,
                      ),
                    ),
                    onTap: (startLoading, stopLoading, btnState) {
                      if (btnState == ButtonState.Idle) {
                        startLoading();
                        // await whatever then set new location
                        alertCurrentLocationSheet(
                            context,
                            address1,
                            address2,
                            widget.location.latitude,
                            widget.location.longitude,
                            false);
                        stopLoading();
                      }
                    },
                  ),
                  ArgonButton(
                    height: MediaQuery.of(context).size.height / 4,
                    width: MediaQuery.of(context).size.width * 0.47,
                    borderRadius: 5.0,
                    color: Colors.red,
                    child: Column(
                      children: const [
                        SizedBox(
                          height: 60,
                        ),
                        Icon(FontAwesomeIcons.ambulance),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Send Alert to Custom Location",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    loader: Container(
                      padding: const EdgeInsets.all(10),
                      child: const SpinKitRotatingCircle(
                        color: Colors.white,
                        // size: loaderWidth ,
                      ),
                    ),
                    onTap: (startLoading, stopLoading, btnState) {
                      if (btnState == ButtonState.Idle) {
                        startLoading();
                        alertCurrentLocationSheet(
                            context,
                            address1,
                            address2,
                            widget.location.latitude,
                            widget.location.longitude,
                            true);
                        stopLoading();
                      }
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

alertCurrentLocationSheet(BuildContext context, String address1,
    String address2, double latitude, double longitude, bool custom) {
  if (custom) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return BottomModalCustom();
        });
  }
  return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return BottomModal(
          latitude: latitude,
          longitude: longitude,
          address1: address1,
          address2: address2,
        );
      });
}
