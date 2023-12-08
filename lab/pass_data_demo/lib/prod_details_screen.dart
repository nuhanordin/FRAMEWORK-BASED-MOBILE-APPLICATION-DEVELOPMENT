/*
Author: Nuha Nordin
Date: 8/12/23
Purpose: user defined widget to display the product details
*/

import 'package:flutter/material.dart';
import 'product.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product products;
  const ProductDetailsScreen({Key? key, required this.products})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(products.code),
      ),
      body: Center(
        child: Text(products.description),
      ),
    );
  }
}
