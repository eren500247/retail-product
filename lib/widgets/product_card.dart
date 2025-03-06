import 'package:flutter/material.dart';
// import 'package:meal_app/models/product_model.dart';
import 'package:retail_go/models/product_model.dart';
// import 'package:meal_app/pages/product_detail.dart';
import 'package:retail_go/pages/product_detail.dart';

class ProductCart extends StatelessWidget {
  const ProductCart(this.product, {super.key, required this.addToCart,required this.cart});
  final Product product;
  final Function(Product) addToCart;
  final List<Product> cart;

  @override
  Widget build(BuildContext context) {
    double productPrice = product.variants.isNotEmpty
        ? product.variants.first.price
        : product.basePrice;
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailPage(
                      productId: product.productId,
                      cart: [],
                    )));
        // Handle product tap (e.g., navigate to detail page)
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: product.featuredImage != null
                  ? Image.network(
                      product.featuredImage!,
                      width: double.infinity,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: double.infinity,
                      height: 50,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported,
                          size: 50, color: Colors.grey),
                    ),
            ),

            // Product Info
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "\$${productPrice.toStringAsFixed(2)}",
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.discount, size: 16, color: Colors.red),
                      const SizedBox(width: 4),
                      Text(
                        "${product.discount.toStringAsFixed(0)}% Off",
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () => addToCart(product),
                    child: Text("Add to Cart"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
