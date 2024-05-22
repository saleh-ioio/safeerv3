import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:safeer/models/appColors.dart';
import 'package:safeer/models/order.dart';
import 'package:safeer/models/orderStages.dart';
import 'package:safeer/models/rider.dart';
import 'package:safeer/models/user.dart';
import 'package:safeer/screens/Home/admin/orderFormpage.dart';
import 'package:safeer/services/dataBase.dart';

class EditOrderPage extends StatefulWidget {
  final String adminUid;
  final String orderId;
  const EditOrderPage(
      {super.key, required this.adminUid, required this.orderId});

  @override
  State<EditOrderPage> createState() => _EditOrderPageState();
}

class _EditOrderPageState extends State<EditOrderPage> {
//variables for input fields
  String clientName = "" ;
  String clientPhone = "";
  String clientAddress = "";
  double orderPrice = 0.0;
  OrderStatus orderStatus = OrderStatus.StillInChina;
  ClientOrder? order;
  OrderStatus selectedStatus = OrderStatus.StillInChina;
  List<Rider>? riders ;  

  String? dropDownValue = null;

  Rider? selectedRider;

  bool firstTime = true;

  final _locationLinkController = TextEditingController();
  bool isGoodLink = false;

  Widget buildTextField(String label, String initialValue,
      Function(String) onChanged, String? Function(String?) validator) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        initialValue: initialValue,
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

    

    
    final uid = widget.adminUid;
    final orderId = widget.orderId;
final email = context.read<UserProvider>().email!;
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: const Text("Edit Order"),
      ),
      body: order == null
          ? FutureBuilder(
              future: DataBaseServiceWithNoUser()
                  .getOrder(adminId: uid, orderId: orderId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: LoadingAnimationWidget.fourRotatingDots(
                        color: AppColors.darkergreen, size: 30),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error}"),
                  );
                }

                order = snapshot.data!;
if(firstTime){
      clientName = order!.clientName;
      clientPhone = order!.phone;
      clientAddress = order!.address;
      orderStatus = order!.orderStatus!;
      orderPrice = order!.totalPrice;
      _locationLinkController.text = order!.locationLink;
      selectedStatus = order!.orderStatus!;
      firstTime = false;

      DataBaseService(email:email, uid: widget.adminUid ).getAvailableRiders().then((value) {
        setState(() {
          riders = value;
        });
      });
      
    }

                //the same as orderFormPage but with data already on input fields
                return SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    padding: EdgeInsets.symmetric(horizontal: 3, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.darkergreen),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Form(
                      child: Column(
                        children: [
riders != null ? Container(
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
                    items: riders!
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
                        selectedRider = riders!
                            .firstWhere((element) => element.email == value!);
                        dropDownValue = selectedRider?.email;
                      });
                    },
                  ),
                ): Container(),
                          Container(
                            margin: EdgeInsets.only(bottom: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              border: Border.all(
                                color: AppColors.darkergreen,
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: DropdownButton<OrderStatus>(
                              hint: const Text('Select Order Status'),
                              value: selectedStatus,
                              onChanged: (OrderStatus? newValue) {
                                setState(() {
                                  selectedStatus = newValue!;
                                });
                              },
                              items: OrderStatus.values
                                  .map<DropdownMenuItem<OrderStatus>>(
                                      (OrderStatus status) {
                                return DropdownMenuItem<OrderStatus>(
                                  value: status,
                                  child: Text(
                                    status
                                        .toString()
                                        .split('.')
                                        .last
                                        .replaceAllMapped(
                                            RegExp(r'([a-z])([A-Z])'),
                                            (Match m) => '${m[1]} ${m[2]}'),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),

                          buildTextField("Client Name", order!.clientName,
                              (value) {
                            clientName = value;
                          }, (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a name";
                            }
                            return null;
                          }),
                          buildTextField("Client Phone", order!.phone, (value) {
                            clientPhone = value;
                          }, (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a phone number";
                            }
                            return null;
                          }),
                          buildTextField("Client Address", order!.address,
                              (value) {
                            clientAddress = value;
                          }, (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter an address";
                            }
                            return null;
                          }),
                          Container(
                            margin: EdgeInsets.only(bottom: 10.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _locationLinkController,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          borderSide: BorderSide(
                                              color: AppColors.darkergreen,
                                              width: 2.0), // Change this line
                                        ),
                                        labelText: 'Google Maps share link'),
                                    onChanged: (value) {
                                      setState(() {
                                        _locationLinkController.text = value;
                                        isGoodLink = false;
                                        if (value.startsWith(
                                            'https://www.google.com/maps')) {
                                          isGoodLink = true;
                                        }
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return null; // valid if empty
                                      } else if (!value.startsWith(
                                          'https://www.google.com/maps')) {
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
                                    final clipboardData =
                                        await FlutterClipboard.paste();
                                    _locationLinkController.text =
                                        clipboardData;

                                    setState(() {
                                      isGoodLink = false;
                                      if (_locationLinkController.text
                                          .startsWith(
                                              'https://www.google.com/maps')) {
                                        isGoodLink = true;
                                      }
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                          // payment method

                          Row(
                            children: [
                              Expanded(
                                child: buildTextField(
                                    "Payment Method", order!.paymentMethod,
                                    (value) {
                                  clientAddress = value;
                                }, (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter a payment method";
                                  }
                                  return null;
                                }),
                              ),
                              Expanded(
                                child: buildTextField("Order total Price",
                                    order!.totalPrice.toString(), (value) {
                                  orderPrice = double.parse(value);
                                }, (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter a price";
                                  }
                                  return null;
                                }),
                              ),
                            ],
                          ),

                          ElevatedButton(
                            onPressed: () async {

                          final adminId = context.read<UserProvider>().uid;
                          DataBaseService(
                                  email: context.read<UserProvider>().email!,
                                  uid: adminId!)
                              .updateOrderData(
                                  orderId,
                                  clientName,
                                  clientAddress,
                                  clientPhone,
                                  orderStatus: selectedStatus,
                                  _locationLinkController.text,
                                  rider: selectedRider,
                                  PaymentMethod.Cash.name,
                                  orderPrice);

                          Navigator.pop(context);
 
                            },
                            child: const Text("Save"),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              })
          : SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                padding: EdgeInsets.symmetric(horizontal: 3, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.darkergreen),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Form(
                  child: Column(
                    children: [
riders != null ?  Container(
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
                    items: riders!
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
                        selectedRider = riders!
                            .firstWhere((element) => element.email == value!);
                        dropDownValue = selectedRider?.email;
                      });
                    },
                  ),
                ): Container(),
Container(
                            margin: EdgeInsets.only(bottom: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              border: Border.all(
                                color: AppColors.darkergreen,
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: DropdownButton<OrderStatus>(
                              hint: const Text('Select Order Status'),
                              value: selectedStatus,
                              onChanged: (OrderStatus? newValue) {
                                setState(() {
                                  selectedStatus = newValue!;
                                });
                              },
                              items: OrderStatus.values
                                  .map<DropdownMenuItem<OrderStatus>>(
                                      (OrderStatus status) {
                                return DropdownMenuItem<OrderStatus>(
                                  value: status,
                                  child: Text(
                                    status
                                        .toString()
                                        .split('.')
                                        .last
                                        .replaceAllMapped(
                                            RegExp(r'([a-z])([A-Z])'),
                                            (Match m) => '${m[1]} ${m[2]}'),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                      buildTextField("Client Name", order!.clientName, (value) {
                        clientName = value;
                      }, (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a name";
                        }
                        return null;
                      }),
                      buildTextField("Client Phone", order!.phone, (value) {
                        clientPhone = value;
                      }, (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a phone number";
                        }
                        return null;
                      }),
                      buildTextField("Client Address", order!.address, (value) {
                        clientAddress = value;
                      }, (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter an address";
                        }
                        return null;
                      }),
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
                                    if (value.startsWith(
                                        'https://www.google.com/maps')) {
                                      isGoodLink = true;
                                    }
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return null; // valid if empty
                                  } else if (!value.startsWith(
                                      'https://www.google.com/maps')) {
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
                                final clipboardData =
                                    await FlutterClipboard.paste();
                                _locationLinkController.text = clipboardData;

                                setState(() {
                                  isGoodLink = false;
                                  if (_locationLinkController.text.startsWith(
                                      'https://www.google.com/maps')) {
                                    isGoodLink = true;
                                  }
                                });
                              },
                            )
                          ],
                        ),
                      ),
                      // payment method

                      Row(
                        children: [
                          Expanded(
                            child: buildTextField(
                                "Payment Method", order!.paymentMethod,
                                (value) {
                              clientAddress = value;
                            }, (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter a payment method";
                              }
                              return null;
                            }),
                          ),
                          Expanded(
                            child: buildTextField("Order total Price",
                                order!.totalPrice.toString(), (value) {
                              orderPrice = double.parse(value);
                            }, (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter a price";
                              }
                              return null;
                            }),
                          ),
                        ],
                      ),

                      ElevatedButton(
                        onPressed: () async {

                          final adminId = context.read<UserProvider>().uid;
                          DataBaseService(
                                  email: context.read<UserProvider>().email!,
                                  uid: adminId!)
                              .updateOrderData(
                                  orderId,
                                  clientName,
                                  clientAddress,
                                  clientPhone,
                                  _locationLinkController.text,
                                  PaymentMethod.Cash.name,
                                  orderStatus: selectedStatus,
                                  rider: selectedRider,
                                  orderPrice);

                          Navigator.pop(context);
                        },
                        child: const Text("Save"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
