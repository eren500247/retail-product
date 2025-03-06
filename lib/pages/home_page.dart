import 'package:flutter/material.dart';
import 'package:retail_go/models/category_model.dart';
import 'package:retail_go/models/product_model.dart';
import 'package:retail_go/services/category_services.dart';
import 'package:retail_go/services/product_service.dart';
import 'package:retail_go/widgets/product_card.dart';
// import '../models/product_model.dart';
// import '../models/category_model.dart';
// import '../services/product_service.dart';
// import '../services/category_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Category>> futureCategories;
  late Future<List<Product>> futureProducts;

  String selectedCategory = "All"; // Track selected category
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    futureCategories = CategoryService().fetchCategories();
    futureProducts = ProductService().fetchProducts(); // Default: fetch all
  }

  void filterProducts(String category) {
    setState(() {
      selectedCategory = category;
      if (category == "All") {
        futureProducts = ProductService().fetchProducts();
      } else {
        futureProducts = ProductService().fetchProductsByCategory(category);
      }
    });
  }

  void searchProducts(String query) {
    if (query == searchQuery) return; // Prevent unnecessary updates
    debugPrint("Searching for: $query in category: $selectedCategory");
    setState(() {
      searchQuery = query;

      if (query.isEmpty) {
        // If no search query, filter only by selected category
        futureProducts = selectedCategory == "All"
            ? ProductService().fetchProducts()
            : ProductService().fetchProductsByCategory(selectedCategory);
      } else {
        // If searching, filter by query and category
        futureProducts =
            ProductService().searchProducts(query, selectedCategory);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Products"),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: ProductSearchDelegate(searchProducts),
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Categories",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          FutureBuilder<List<Category>>(
            future: futureCategories,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No categories available"));
              }

              List<Category> categories = snapshot.data!;
              return Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length + 1, // Add "All" category
                  itemBuilder: (context, index) {
                    String categoryName =
                        index == 0 ? "All" : categories[index - 1].name;
                    bool isSelected = selectedCategory == categoryName;

                    return GestureDetector(
                      onTap: () => filterProducts(categoryName),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Center(
                          child: Text(
                            categoryName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Browse Products",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Product>>(
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
                return GridView.builder(
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProductSearchDelegate extends SearchDelegate {
  final Function(String) onSearchQueryChanged;

  ProductSearchDelegate(this.onSearchQueryChanged);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          onSearchQueryChanged(
              query); // Clear the search and fetch all products
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Ensure setState() is not called during build
    Future.microtask(() => onSearchQueryChanged(query));
    return Container(); // Placeholder, as results will be displayed dynamically
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(); // Placeholder for search suggestions if needed
  }
}
