import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:safeer/models/appColors.dart';
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
 final   emailProv = context.read<UserProvider>().email!;
 final  uidProv = context.read<UserProvider>().uid!;
// Widget pendingInvetations(){

//     return StreamBuilder(stream: DataBaseService(email: emailProv,uid: uidProv   ).pendingInvetations, builder:(context, snapshot) {
//       if(snapshot.connectionState == ConnectionState.waiting){
//         return LoadingAnimationWidget.fallingDot(color: AppColors.darkergreen, size: 20);
//       }
      
//       if(snapshot.hasError){
//         return Text("error", style: TextStyle(color: AppColors.red),);
//       }
//       final pendingInvetations = snapshot.data  ;
//       print(pendingInvetations);
//       return Column(
//         children: [
//           Container(alignment: Alignment.centerLeft,
//             child: Text('Pending Invitations : ',textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold ,color:AppColors.darkergreen
//              ),),
//           ),
                
//         ],
//           );
//     }, );
//   }
    return 
       Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
         child: Column(
          children: <Widget>[
            Autocomplete<String>(
              onSelected: (option) {
                driverListToAdd.add(suggestedRider
                    .firstWhere((element) => element.containsKey(option)));
                suggestedRider.clear();
                setState(() {});
              },
              optionsBuilder: (TextEditingValue value) async {
                final result = await DataBaseService(
            uid: context.read<UserProvider>().uid!,
            email: context.read<UserProvider>().email!)
                    .searchDriverQuery(email: value.text);
            
                List<String> resultList = result.docs.map((doc) {
                  suggestedRider.add({doc['email'].toString(): doc.id.toString()});
                  return doc['email'].toString();
                }).toList();
            
                return resultList;
              },
              fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
                return TextFormField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  onFieldSubmitted: (String value) {
                    onFieldSubmitted();
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Search',
                  ),
                );
              },
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Text("Drivers for Invitation :", textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold ,color:AppColors.darkergreen ),)),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: driverListToAdd.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          title: Text("${index+1 }-  ${driverListToAdd[index].keys.first}"),
                          trailing: IconButton(
                            icon: Icon(Icons.delete , color: AppColors.red),
                            onPressed: () {
                              driverListToAdd.removeAt(index);
                              setState(() {});
                            },
                          ),
                        ),
                        Divider(color: AppColors.green,)
                      ],
                    );
                  }),
            ),
            TextButton(
              
              onPressed: driverListToAdd.isEmpty == true
                  ? null
                  : () {
                      driverListToAdd.forEach((element) {
                        DataBaseService(
                                uid: context.read<UserProvider>().uid!,
                                email: context.read<UserProvider>().email!)
                            .sendInvetation(
                                riderId: element.values.first,
                                riderEmail: element.keys.first);
                      });
         
                      driverListToAdd.clear();
                      setState(() {});
                    },
              child: Text("invite Drivers" , style: TextStyle(color: AppColors.lightyellow , fontSize: 15)),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                         AppColors.darkergreen),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Text("All riders In Fleet :", textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold ,color:AppColors.darkergreen ),)),
            StreamBuilder(stream: DataBaseService(email: context.read<UserProvider>().email!,uid: context.read<UserProvider>().uid! ).allRidersInFleet, builder: 
            (context, snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return LoadingAnimationWidget.fallingDot(color: AppColors.darkergreen, size: 20);
              }
              if(snapshot.hasError){
                return Text("error", style: TextStyle(color: AppColors.red),);
              }
              final ridersInFleet = snapshot.data  ;
              return ListView.builder( itemCount: ridersInFleet!.length, shrinkWrap: true,
               itemBuilder: (context, index){
                  return 
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    color: AppColors.offWhite,
                    child: ListTile(
                      title: Text(ridersInFleet[index].email.toString()),
                      trailing: Text(ridersInFleet[index].status, style: TextStyle(color: AppColors.red),),
                    ),
                  );
                  
               },);
            }
            ),
            // Container(
            //   margin: EdgeInsets.symmetric(vertical: 10),
            //   child: pendingInvetations())
          ],
               ),
       );

       

  }

  
}
