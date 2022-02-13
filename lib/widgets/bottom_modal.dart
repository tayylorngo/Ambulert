import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

import '../secrets.dart';
import 'address.dart';

/// This modal is for sending an alert to
/// one's current location
class BottomModal extends StatefulWidget {
  const BottomModal(
      {Key? key,
      required this.latitude,
      required this.longitude,
      required this.address1,
      required this.address2})
      : super(key: key);
  final double latitude;
  final double longitude;
  final String address1;
  final String address2;

  @override
  _BottomModalState createState() => _BottomModalState();
}

class _BottomModalState extends State<BottomModal> {
  final miles = ['0.5 miles', '1 mile', '2.5 miles', '3 miles', '5 miles'];
  String? currentRadius = '0.5 miles';
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String latitudeS = widget.latitude.toStringAsFixed(2);
    String longitudeS = widget.longitude.toStringAsFixed(2);
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Container(
          height: MediaQuery.of(context).size.height * 0.45,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 150.0),
                child: Divider(
                  thickness: 4.0,
                  color: Colors.white,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  'Approximate Location',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              AddressModal(address: widget.address1),
              AddressModal(address: widget.address2),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Latitude: $latitudeS',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Longitude: $longitudeS',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Text(
                      'Alert Radius: ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  DropdownButton(
                    value: currentRadius,
                    onChanged: (value) {
                      setState(() {
                        currentRadius = value as String?;
                      });
                    },
                    items: miles.map(buildMenuItem).toList(),
                  )
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 15.0, left: 8.0, right: 8.0),
                child: TextField(
                  controller: controller,
                  minLines: 2,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    hintText: "Alert Message",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ArgonButton(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  borderRadius: 5.0,
                  color: Colors.red,
                  child: const Text(
                    "Send Alert",
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
                    var radius = currentRadius?.split(' ');
                    double miles = double.parse(radius![0]);
                    sendAlert(controller.text.toString(), miles);
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/// DropdownMenuItem definition
DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
      value: item,
      child: Text(
        item,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
    );

/// This method sends an alert via text using Twilio API
void sendAlert(String message, double distance) {
  TwilioFlutter twilioFlutter = TwilioFlutter(
      accountSid: accountSid, authToken: authToken, twilioNumber: twilioNumber);
  twilioFlutter.sendSMS(toNumber: phoneNumber, messageBody: message);
}
