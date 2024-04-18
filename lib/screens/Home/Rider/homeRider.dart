import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safeer/models/invetation.dart';
import 'package:safeer/models/user.dart';
import 'package:safeer/services/auth.dart';
import 'package:safeer/services/dataBase.dart';

class HomeRiderPage extends StatefulWidget {
  const HomeRiderPage({super.key});

  @override
  State<HomeRiderPage> createState() => _HomeRiderPageState();
}

class _HomeRiderPageState extends State<HomeRiderPage> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>();
    return Scaffold(
        appBar: AppBar(
          title: Text("Home Rider"),
          actions: [
            TextButton(
                onPressed: () async {
                  final result = await _auth.signOut();

                  if (result == null) {
                    context
                        .read<UserProvider>()
                        .updateUid(result, UserTyp.owner);
                    print("signed out");
                  } else {
                    print(result.toString());
                  }
                },
                child: Text("sign out"))
          ],
        ),
        body: Column(
          children: [
            Center(
              child: TextButton(
                onPressed: () {},
                child: Text("home driver"),
              ),
            ),
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
                        return ListTile(
                            title: Text(invetations[index].owenerEmail ?? ''),
                            subtitle: Text(invetations[index].Status),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      final invite = invetations[index];
                                      DataBaseService(
                                              uid: user.uid!,
                                              email: user.email!)
                                          .updateInvetationStatus(
                                              ownerId: invite.onwerId,
                                              refrenceInOwner:
                                                  invite.refrerenceInOwner,
                                              refrenceInrider:
                                                  invite.refrenceInRider,
                                              status: StatusEnum.accepted);
                                      print("accept");
                                    },
                                    child: Text("Accept")),
                                TextButton(
                                    onPressed: () {
                                      final invite = invetations[index];
                                      DataBaseService(
                                              uid: user.uid!,
                                              email: user.email!)
                                          .updateInvetationStatus(
                                              ownerId: invite.onwerId,
                                              refrenceInOwner:
                                                  invite.refrerenceInOwner,
                                              refrenceInrider:
                                                  invite.refrenceInRider,
                                              status: StatusEnum.rejected);
                                      print("reject");
                                    },
                                    child: Text("Reject"))
                              ],
                            ));
                      },
                    );
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            )
          ],
        ));
  }
}
