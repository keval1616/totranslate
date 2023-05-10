import 'package:flutter/material.dart';

class HeightSpacer extends StatelessWidget {
  final double height;
  const HeightSpacer({Key? key, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}
