import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:latlng/latlng.dart';

import 'package:provider/provider.dart';
import 'package:safeer/models/appColors.dart';
import 'package:safeer/models/mapVar.dart';
import 'package:safeer/models/rider.dart';
import 'package:safeer/models/user.dart';
import 'package:safeer/services/dataBase.dart';

class OrderPage extends StatefulWidget {
  final List<Rider> listOfAvailableRiders;
  OrderPage({super.key, required this.listOfAvailableRiders});

  @override
  _OrderPageState createState() => _OrderPageState();
}

enum PaymentMethod { Cash, Visa }

String extractTextAfterAt(String input) {
  // Find the index of the '@' character
  int atIndex = input.indexOf('@');

  // Check if '@' is present and not the last character
  if (atIndex != -1 && atIndex < input.length - 1) {
    // Extract and return the text after '@'
    return input.substring(atIndex + 1);
  } else {
    // Return an empty string if '@' is not found or there's nothing after '@'
    return '';
  }
}

List<String> extractCoordinates(String url) {
  var uri = Uri.parse(url);
  var atSplit = uri.path.split('@');
  if (atSplit.length > 1) {
    var commaSplit = atSplit[1].split(',');
    if (commaSplit.length > 1) {
      return [commaSplit[0], commaSplit[1]];
    }
  }
  return [];
}

class _OrderPageState extends State<OrderPage> {
  final _formKey = GlobalKey<FormState>();

  final _locationLinkController = TextEditingController();
  String _locationLink = '';

  String _clientName = '';
  String _address = '';
  String _phone = '';

  // String _paymentMethod = '';
  PaymentMethod? _paymentMethod;

  double _totalPrice = 0.0;
  String? riderId;
  String? dropDownValue = null;
  Rider? selectedRider;

  bool isGoodLink = false;

  Widget TxtField(String label, Function(String) onChanged,
      String Function(String?) validator) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide(
              color: AppColors.darkergreen,
              width: 2.0,
            ),
          ),
          labelText: label,
        ),
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.watch<UserProvider>().uid;
    final email = context.watch<UserProvider>().email;
    return Scaffold(
      //change the color of the back button

      backgroundColor: AppColors.primary,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text('Order Form',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      color: AppColors.darkergreen,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: Container(
                        padding: EdgeInsets.only(left: 10.0),
                        child: const Text('Select Rider')),
                    value: dropDownValue,
                    items: widget.listOfAvailableRiders
                        .map<DropdownMenuItem<String>>((value) {
                      return DropdownMenuItem(
                          onTap: () {
                            selectedRider = value;
                          },
                          value: value.email,
                          child: Text(value.email));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedRider = widget.listOfAvailableRiders
                            .firstWhere((element) => element.email == value!);
                        dropDownValue = selectedRider?.email;
                      });
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(
                              color: AppColors.darkergreen,
                              width: 2.0), // Change this line
                        ),
                        labelText: 'Client Name'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter client name';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      if (value.isEmpty) {
                        return;
                      }
                      setState(() {
                        _clientName = value;
                      });
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(
                            color: AppColors.darkergreen,
                            width: 2.0), // Change this line
                      ),
                      labelText: 'Address',
                    ),
                    validator: (value) {
                      //checks if is null or empty
                      if (value!.isEmpty || value == null) {
                        return null;
                      }
                      return null;
                    },
                    onChanged: (value) {
                      if (value.isEmpty) {
                        return;
                      }
                      setState(() {
                        _address = value;
                      });
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(
                              color: AppColors.darkergreen,
                              width: 2.0), // Change this line
                        ),
                        labelText: 'Phone'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter phone number';
                      }
                      if (value.length != 10 ||
                          !value.startsWith('07') ||
                          !value.contains(RegExp(r'^[0-9]+$'))) {
                        return 'Please enter a valid Jordanian phone number';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      if (value.isEmpty) {
                        return;
                      }
                      setState(() {
                        _phone = value;
                      });
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _locationLinkController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                borderSide: BorderSide(
                                    color: AppColors.darkergreen,
                                    width: 2.0), // Change this line
                              ),
                              labelText: 'Google Maps share link'),
                          onChanged: (value) {
                            setState(() {
                              _locationLinkController.text = value;
                              isGoodLink = false;
                              if (value
                                  .startsWith('https://www.google.com/maps')) {
                                isGoodLink = true;
                              }
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return null; // valid if empty
                            } else if (!value
                                .startsWith('https://www.google.com/maps')) {
                              return 'Please enter a valid Google Maps link or leave it empty';
                            }
                            return null; // valid if it's a Google Maps link
                          },
                        ),
                      ),
                      Icon(
                        Icons.map_outlined,
                        color: isGoodLink ? Colors.green : Colors.red,
                      ),
                      // icon button to clear the textfield
                      IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _locationLinkController.clear();
                          setState(() {
                            isGoodLink = false;
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.paste),
                        onPressed: () async {
                          final clipboardData = await FlutterClipboard.paste();
                          _locationLinkController.text = clipboardData;

                          setState(() {
                            isGoodLink = false;
                            if (_locationLinkController.text
                                .startsWith('https://www.google.com/maps')) {
                              isGoodLink = true;
                            }
                          });
                        },
                      )
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10.0, right: 10),
                        child: DropdownButtonFormField<PaymentMethod?>(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(
                                color: AppColors.darkergreen,
                                width: 2.0,
                              ),
                            ),
                            labelText: 'Payment Method',
                          ),
                          items:
                              PaymentMethod.values.map((PaymentMethod method) {
                            return DropdownMenuItem<PaymentMethod?>(
                              value: method,
                              child: Text(method.toString().split('.').last),
                            );
                          }).toList(),
                          onChanged: (PaymentMethod? newValue) {
                            setState(() {
                              _paymentMethod = newValue;
                            });
                          },
                          validator: (PaymentMethod? value) {
                            if (value == null) {
                              return null;
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                          margin: EdgeInsets.only(bottom: 10.0),
                          child: TextFormField(
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  borderSide: BorderSide(
                                      color: AppColors.darkergreen,
                                      width: 2.0), // Change this line
                                ),
                                labelText: 'Total Price'),

                            // Other properties...
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return null;
                              }
                              if (!value
                                  .contains(RegExp(r'^[0-9]+(\.[0-9]+)?$'))) {
                                return 'Please enter a valid price';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                _totalPrice = double.tryParse(value) ?? 0.0;
                              });
                            },
                          )),
                    )
                  ],
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(AppColors.darkergreen),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Process data.
                      print('Client Name: $_clientName\n'
                          'Address: $_address\n'
                          'Phone: $_phone\n'
                          'Location Link: $_locationLink\n'
                          'location link: ${_locationLinkController.text}\n'
                          'Payment Method: $_paymentMethod\n'
                          'Total Price: $_totalPrice\n');

                      final originalUrl = _locationLinkController.text;

                      final extractedCoordinates =
                          extractCoordinates(originalUrl);

                      if (isGoodLink) {
                        Angle latAngle =
                            Angle.degree(double.parse(extractedCoordinates[0]));
                        Angle lonAngle =
                            Angle.degree(double.parse(extractedCoordinates[1]));

                        final MapPin mapPin = MapPin(
                          pin: LatLng(latAngle, lonAngle),
                        );

                        print(' latitude is ${mapPin.pin.latitude.degrees}');
                        print(' longitude is ${mapPin.pin.longitude.degrees}');

                        DataBaseService(uid: userId!, email: email!)
                            .updateOrderData(
                                _clientName,
                                _address,
                                _phone,
                                _locationLink,
                                _paymentMethod?.name,
                                _totalPrice,
                                rider: selectedRider,
                                pin: mapPin);

                        Navigator.pop(context);
                        return;
                      }
                      // print('Original URL: $originalUrl');
                      // print(" the text between @@" +
                      //     extractTextAfterAt(_locationLinkController.text));
                      // print("the text as a whole" + _locationLinkController.text);

                      //  final resulting = extractValues(_locationLinkController.text);

                      // final cat =  extractLatLng(_locationLinkController.text);
                      // print("the unshortened link" + cat);

                      DataBaseService(uid: userId!, email: email!)
                          .updateOrderData(
                        _clientName,
                        _address,
                        _phone,
                        _locationLink,
                        _paymentMethod?.name,
                        _totalPrice,
                        rider: selectedRider,
                      );

                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    'Save Order',
                    style: TextStyle(color: AppColors.lightyellow),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
