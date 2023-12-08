import 'package:flutter/material.dart';

class StockScreen extends StatelessWidget {
  const StockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Screen'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Overview of Stock Screen'),
      ),
    );
  }
}
