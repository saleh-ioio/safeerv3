import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:safeer/models/appColors.dart';
import 'package:safeer/models/rider.dart';
import 'package:safeer/models/user.dart';
import 'package:safeer/services/dataBase.dart';

class OrderPage extends StatefulWidget {
  final List<Rider> listOfAvailableRiders;
  OrderPage({super.key, required this.listOfAvailableRiders});

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final _formKey = GlobalKey<FormState>();
  String _clientName = '';
  String _address = '';
  String _phone = '';
  String _locationLink = '';
  String _paymentMethod = '';
  double _totalPrice = 0.0;
  String? riderId;
  String? dropDownValue = null;
  Rider? selectedRider;

  @override
  Widget build(BuildContext context) {
    final userId = context.watch<UserProvider>().uid;
    final email = context.watch<UserProvider>().email;
    return Scaffold(
      //change the color of the back button
       
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text('Order Form', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                      if (value!.isEmpty) {
                        return 'Please enter address';
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
                      if (value!.isEmpty) {
                        return 'Please enter phone number';
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
                  child: TextFormField(
                    decoration: const InputDecoration(
                   border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(
                              color: AppColors.darkergreen,
                              width: 2.0), // Change this line
                        ),
                      labelText: 'Location Link'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter location link';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      if (value.isEmpty) {
                        return;
                      }
                      setState(() {
                        _locationLink = value;
                      });
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: TextFormField(
                    decoration:
                        const InputDecoration(
                   border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(
                              color: AppColors.darkergreen,
                              width: 2.0), // Change this line
                        ),
                          labelText: 'Payment Method'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter payment method';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      if (value.isEmpty) {
                        return;
                      }
                      setState(() {
                        _paymentMethod = value;
                      });
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                   border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(
                              color: AppColors.darkergreen,
                              width: 2.0), // Change this line
                        ),
                      labelText: 'Total Price'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter total price';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      if (value.isEmpty) {
                        return;
                      }
                      setState(() {
                        _totalPrice = double.parse(value);
                      });
                    },
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        AppColors.darkergreen),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Process data.
                      print('Client Name: $_clientName\n'
                          'Address: $_address\n'
                          'Phone: $_phone\n'
                          'Location Link: $_locationLink\n'
                          'Payment Method: $_paymentMethod\n'
                          'Total Price: $_totalPrice\n');

                      DataBaseService(uid: userId!, email: email!)
                          .updateOrderData(_clientName, _address, _phone,
                              _locationLink, _paymentMethod, _totalPrice,
                              rider: selectedRider);

                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save Order', style: TextStyle(color: AppColors.lightyellow),),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
