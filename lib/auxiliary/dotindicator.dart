import 'package:flutter/material.dart';

class DotIndicator extends StatefulWidget {
  const DotIndicator({Key? key, required this.isActive}) : super(key: key);

  final bool isActive;

  @override
  State<DotIndicator> createState() => _DotIndicatorState();
}

class _DotIndicatorState extends State<DotIndicator> {
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        height: 8.0,
        width: 8.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: Colors.grey,
        ),
      ),
    );
  }
}
