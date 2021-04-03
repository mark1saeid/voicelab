import 'package:flutter/material.dart';

class LoadingCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black), strokeWidth: 2));
}
