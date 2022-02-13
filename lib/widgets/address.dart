import 'package:flutter/material.dart';

/// This class defines a widget for displaying an Address
class Address extends StatelessWidget {
  const Address({Key? key, required this.address}) : super(key: key);
  final String address;

  @override
  Widget build(BuildContext context) {
    Widget widget = Text(
      address,
      textAlign: TextAlign.center,
      style: const TextStyle(
          color: Colors.blueAccent,
          fontSize: 35.0,
          fontWeight: FontWeight.bold),
    );
    if (address == '') {
      return Container();
    }
    return widget;
  }
}

class AddressModal extends StatelessWidget {
  const AddressModal({Key? key, required this.address}) : super(key: key);
  final String address;

  @override
  Widget build(BuildContext context) {
    Widget widget = Text(
      address,
      textAlign: TextAlign.center,
      style: const TextStyle(
          color: Colors.redAccent, fontSize: 28.0, fontWeight: FontWeight.bold),
    );
    if (address == '') {
      return Container();
    }
    return widget;
  }
}
