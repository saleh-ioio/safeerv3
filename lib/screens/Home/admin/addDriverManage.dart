import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:safeer/models/user.dart';
import 'package:safeer/services/dataBase.dart';

class AddDriverPage extends StatefulWidget {
  const AddDriverPage({super.key});

  @override
  State<AddDriverPage> createState() => _AddDriverPageState();
}

class _AddDriverPageState extends State<AddDriverPage> {
  List<Map<String, String>> driverListToAdd = [];
  List<Map<String, String>> suggestedRider =
      List<Map<String, String>>.empty(growable: true);
  String email = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Driver"),
      ),
      body: Column(
        children: <Widget>[
          Autocomplete<String>(onSelected: (option) {
            driverListToAdd.add(suggestedRider
                .firstWhere((element) => element.containsKey(option)));
            suggestedRider.clear();
            setState(() {});
          }, optionsBuilder: (TextEditingValue value) async {
            final result =
                await DataBaseService(uid: context.read<UserProvider>().uid!)
                    .searchDriverQuery(email: value.text);

            List<String> resultList = result.docs.map((doc) {
              suggestedRider.add({doc['email'].toString(): doc.id.toString()});
              return doc['email'].toString();
            }).toList();

            print(resultList);

            return resultList;
          }),
          ListView.builder(
              shrinkWrap: true,
              itemCount: driverListToAdd.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(driverListToAdd[index].keys.first),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      driverListToAdd.removeAt(index);
                      setState(() {});
                    },
                  ),
                );
              }),
          TextButton(
            onPressed: driverListToAdd.isEmpty == true
                ? null
                : () {
                    driverListToAdd.forEach((element) {
                      DataBaseService(uid: context.read<UserProvider>().uid!)
                          .sendInvetation(element.values.first);
                    });

                    driverListToAdd.clear();
                    setState(() {});
                  },
            child: Text("invite Drivers"),
          ),
        ],
      ),
    );
  }
}
