import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safeer/models/appColors.dart';
import 'package:safeer/models/invetation.dart';
import 'package:safeer/models/user.dart';
import 'package:safeer/services/dataBase.dart';

class MenageOwner extends StatefulWidget {
  const MenageOwner({super.key});

  @override
  State<MenageOwner> createState() => _MenageOwnerState();
}

class _MenageOwnerState extends State<MenageOwner> {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>();
    return Column(children: [
      StreamBuilder<List<Invitationclient>>(
        stream: DataBaseService(
                uid: context.watch<UserProvider>().uid!,
                email: context.watch<UserProvider>().email!)
            .invetations,
        builder: (context, snapshot) {
          print(snapshot.hasData);
          if (snapshot.hasError) print(snapshot.error);
          if (snapshot.hasData) {
            List<Invitationclient> invetations =
                snapshot.data as List<Invitationclient>;
            if (invetations.length == 0) {
              return const Center(child: Text("No invetations"));
            } else {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: invetations.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                    color: invetations[index].Status == 'pending'
                        ? AppColors.offWhite
                        : invetations[index].Status == 'accepted'
                            ? AppColors.lightGreen
                            : AppColors.lightred,
                    child: ListTile(
                        title: Text(invetations[index].owenerEmail ?? ''),
                        subtitle: Text(invetations[index].Status),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                                onPressed: () {
                                  final invite = invetations[index];
                                  DataBaseService(
                                          uid: user.uid!, email: user.email!)
                                      .updateInvetationStatus(
                                          ownerId: invite.onwerId,
                                          refrenceInOwner:
                                              invite.refrerenceInOwner,
                                          refrenceInrider: invite.refrenceInRider,
                                          status: StatusEnum.accepted);
                                },
                                child: Icon(Icons.check)),
                            TextButton(
                                onPressed: () {
                                  final invite = invetations[index];
                                  DataBaseService(
                                          uid: user.uid!, email: user.email!)
                                      .updateInvetationStatus(
                                          ownerId: invite.onwerId,
                                          refrenceInOwner:
                                              invite.refrerenceInOwner,
                                          refrenceInrider: invite.refrenceInRider,
                                          status: StatusEnum.rejected);
                                },
                                child: Icon(Icons.close))
                          ],
                        )),
                  );
                },
              );
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      )
    ]);
  }
}
