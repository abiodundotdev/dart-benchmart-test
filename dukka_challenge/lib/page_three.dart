import 'package:flutter/material.dart';

class PageThree extends StatefulWidget {
  const PageThree({super.key});

  @override
  State<PageThree> createState() => _PageThreeState();
}

class _PageThreeState extends State<PageThree> {
  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: ScaffoldFlowDelegate(),
      children: const [],
    );
  }
}

class ScaffoldFlowDelegate extends FlowDelegate {
  @override
  void paintChildren(FlowPaintingContext context) {}

  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) {
    return true;
  }
}
