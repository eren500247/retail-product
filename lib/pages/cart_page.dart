import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retail_go/cart_model.dart';
import 'package:retail_go/models/product_model.dart'; 

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  void removeFromCart(Product product) {
    // Use Provider to remove the product from the cart
    context.read<CartModel>().removeFromCart(product);

    // Show a SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Removed from cart: ${product.name}")),
    );
  }

  double calculateTotalPrice() {
    double total = 0.0;
    // Use Provider to access the cart
    List<Product> cart = context.watch<CartModel>().cart;

    for (var product in cart) {
      if (product.variants.isNotEmpty) {
        total += product.variants.first.price; // Use variant price if available
      } else {
        total += product.basePrice; // Use base price if no variants exist
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: Consumer<CartModel>( // Use Consumer to listen to changes in the cart
        builder: (context, cartModel, child) {
          return cartModel.cart.isEmpty
              ? Center(child: Text("Your cart is empty."))
              : ListView.builder(
                  itemCount: cartModel.cart.length,
                  itemBuilder: (context, index) {
                    Product product = cartModel.cart[index];
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(8.0),
                        leading: product.featuredImage != null
                            ? Image.network(product.featuredImage!,
                                width: 50, fit: BoxFit.cover)
                            : Container(
                                color: Colors.grey[300],
                                width: 50,
                                child: Icon(Icons.image)),
                        title: Text(product.name),
                        subtitle: Text(
                          // Display price or a default message if price is unavailable
                          product.variants.isNotEmpty
                              ? "\$${product.variants.first.price.toStringAsFixed(2)}"
                              : "No Price Available",
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.remove_circle_outline),
                          onPressed: () => removeFromCart(product),
                        ),
                      ),
                    );
                  },
                );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Display the total price using the Provider
            Text(
              "Total: \$${calculateTotalPrice().toStringAsFixed(2)}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {
                // Implement your checkout logic here
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => CheckoutPage(cart: widget.cart)),
                // );
              },
              child: Text("Proceed to Checkout"),
            ),
          ],
        ),
      ),
    );
  }
}
