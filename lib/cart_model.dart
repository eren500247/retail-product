import 'package:flutter/material.dart';
import 'package:retail_go/models/product_model.dart';

class CartModel extends ChangeNotifier {
  // List to store products in the cart
  List<Product> _cart = [];

  List<Product> get cart => _cart;

  // Add a product to the cart
  void addToCart(Product product) {
    _cart.add(product);
    notifyListeners(); // Notify listeners that cart has been updated
  }

  // Remove a product from the cart
  void removeFromCart(Product product) {
    _cart.remove(product);
    notifyListeners(); // Notify listeners that cart has been updated
  }

  // Get the total price of all items in the cart
  double get totalPrice {
    double total = 0.0;
    for (var product in _cart) {
      if (product.variants.isNotEmpty) {
        total += product.variants.first.price;
      } else {
        total += product.basePrice;
      }
    }
    return total;
  }
}
