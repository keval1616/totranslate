import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:totranslate/lang.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width * 0.78,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            color: Get.isDarkMode
                ? Lang.themeColor.withOpacity(0.9)
                : Colors.white),
        child: const Center(
          child: Text('Provide me deisgn for this page'),
        ),
      ),
    );
  }
}
