import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
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
  String email = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Driver"),
      ),
      body: Column(
        children: [
          Autocomplete<String>(optionsBuilder: (TextEditingValue value) async {
            final result =
                await DataBaseService(uid: context.read<UserProvider>().uid!)
                    .searchDriverQuery(email: value.text);

            List<String> resultList =
                result.docs.map((e) => e['email'].toString()).toList();

            print(resultList);

            return resultList;
            // return ListView.builder(
            //     itemCount: data.size,
            //     itemBuilder: (context, index) {
            //       final doc = data.docs[index];
            //       return ListTile(
            //         title: Text(doc['name']),
            //         subtitle: Text(doc['email']),
            //         trailing: IconButton(
            //             onPressed: () async {
            //               await DataBaseService(uid: context.read<UserProvider>().uid!).addDriverToOwner(
            //                   driverUid: doc.id, driverEmail: doc['email']);
            //             },
            //             icon: const Icon(Icons.add)),
            //       );
            //     });
          }),
        ],
      ),
    );
  }
}
