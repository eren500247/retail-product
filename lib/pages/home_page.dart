import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retail_go/cart_model.dart';
import 'package:retail_go/models/category_model.dart';
import 'package:retail_go/models/product_model.dart';
import 'package:retail_go/pages/cart_page.dart';
import 'package:retail_go/services/category_services.dart';
import 'package:retail_go/services/product_service.dart';
import 'package:retail_go/widgets/product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Category>> futureCategories;
  late Future<List<Product>> futureProducts;

  final TextEditingController searchController = TextEditingController();
  String selectedCategory = "All";
  String searchQuery = "";
  List<Product> cart = [];

  @override
  void initState() {
    super.initState();
    futureCategories = CategoryService().fetchCategories();
    fetchProducts();
  }

  void addToCart(Product product) {
    setState(() {
      cart.add(product);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Added to cart: ${product.name}")),
    );
  }
  void fetchProducts() {
    setState(() {
      futureProducts = ProductService().fetchProducts(
        category: selectedCategory == "All" ? null : selectedCategory,
        searchQuery: searchQuery.isEmpty ? null : searchQuery,
      );
    });
  }

  void onSearch(String query) {
    setState(() {
      searchQuery = query;
    });
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Products"),
        centerTitle: true,
        actions: [
          // Display cart icon with the number of items in the cart
          Consumer<CartModel>(
            builder: (context, cartModel, child) {
              return IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  // Navigate to the CartPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartPage(),
                    ),
                  );
                },
              );
            },
          ),
        ],
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.shopping_cart),
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => CartPage(cart: cart),
        //         ),
        //       );
        //       // Navigate to cart screen (to be implemented)
        //     },
        //   ),
        // ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search Products...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => onSearch(searchController.text),
                ),
              ),
              onSubmitted: onSearch,
            ),
          ),
          FutureBuilder<List<Product>>(
            future: futureProducts,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No products available"));
              }

              List<Product> products = snapshot.data!;
              return Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return ProductCart(products[index]);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
