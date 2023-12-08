import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Screen'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Overview of Product Screen'),
      ),
    );
  }
}
