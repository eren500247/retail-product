import 'package:flutter/material.dart';
import 'package:retail_go/models/product_model.dart';

class CartPage extends StatefulWidget {
  final List<Product> cart;

  CartPage({required this.cart});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void removeFromCart(Product product) {
    // print("this is product variant : ${product.variants.first}");
    // setState(() {
    //   widget.cart.remove(product);
    // });
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text("Removed from cart: ${product.name}")),
    // );
  }

  double calculateTotalPrice() {
    double total = 0.0;
    for (var product in widget.cart) {
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
      body: widget.cart.isEmpty
          ? Center(child: Text("Your cart is empty."))
          : ListView.builder(
              itemCount: widget.cart.length,
              itemBuilder: (context, index) {
                Product product = widget.cart[index];
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
                    subtitle: Text("No"),
                    // subtitle: Text(
                    //   product.firstVariant != null
                    //       ? "\$${product.firstVariant!.price.toStringAsFixed(2)}"
                    //       : "No Price Available",
                    // ),
                    trailing: IconButton(
                      icon: Icon(Icons.remove_circle_outline),
                      onPressed: () => removeFromCart(product),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Total: \$${calculateTotalPrice().toStringAsFixed(2)}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {
                // Proceed to checkout page (you can implement checkout logic here)
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
