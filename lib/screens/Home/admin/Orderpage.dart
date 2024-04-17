import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:safeer/models/user.dart';
import 'package:safeer/services/dataBase.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

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

  @override
  Widget build(BuildContext context) {
    final userId = context.watch<UserProvider>().uid;
    final email = context.watch<UserProvider>().email;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Page'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Client Name'),
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
              TextFormField(
                decoration: const InputDecoration(labelText: 'Address'),
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
              TextFormField(
                decoration: const InputDecoration(labelText: 'Phone'),
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
              TextFormField(
                decoration: const InputDecoration(labelText: 'Location Link'),
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
              TextFormField(
                decoration: const InputDecoration(labelText: 'Payment Method'),
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
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Total Price'),
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
              ElevatedButton(
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
                            _locationLink, _paymentMethod, _totalPrice);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save Order'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
