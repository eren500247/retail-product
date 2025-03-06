import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retail_go/cart_model.dart';
import 'package:retail_go/pages/home_page.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => CartModel(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ),
  ));
}
