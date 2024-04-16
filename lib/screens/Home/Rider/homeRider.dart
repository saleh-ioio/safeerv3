import 'package:flutter/material.dart';

class HomeRiderPage extends StatefulWidget {
  const HomeRiderPage({super.key});

  @override
  State<HomeRiderPage> createState() => _HomeRiderPageState();
}

class _HomeRiderPageState extends State<HomeRiderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Home Rider")),
        body: Column(
          children: [
            Center(
              child: TextButton(
                onPressed: () {},
                child: Text("home driver"),
              ),
            ),
          ],
        ));
  }
}
