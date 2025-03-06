import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:retail_go/models/product_model.dart';
// import '../models/product_model.dart';

// class ProductService {
//   static const String baseUrl = "http://10.0.2.2:3000/api/products";

//   Future<List<Product>> fetchProducts() async {
//     final response = await http.get(Uri.parse(baseUrl));

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> jsonData = json.decode(response.body);
//       final ProductResponse productResponse =
//           ProductResponse.fromJson(jsonData);
//       return productResponse.data;
//     } else {
//       throw Exception("Failed to load products");
//     }
//   }

//   // Fetch products by category
//   Future<List<Product>> fetchProductsByCategory(String category) async {
//     final response = await http.get(Uri.parse('$baseUrl?category=$category'));

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> jsonResponse = json.decode(response.body);
//       List<dynamic> data = jsonResponse['data'];
//       return data.map((product) => Product.fromJson(product)).toList();
//     } else {
//       throw Exception("Failed to load filtered products");
//     }
//   }

//   // Fetch products with search query and category
//   Future<List<Product>> searchProducts(String searchQuery, String category) async {
//     final String url = '$baseUrl?search=$searchQuery' + (category.isNotEmpty ? '&category=$category' : '');

//     final response = await http.get(Uri.parse(url));

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> jsonResponse = json.decode(response.body);
//       List<dynamic> data = jsonResponse['data'];
//       return data.map((product) => Product.fromJson(product)).toList();
//     } else {
//       throw Exception("Failed to search products");
//     }
//   }
// }

class ProductService {
  static const String baseUrl = "http://10.0.2.2:3000/api/products";

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      print("API Response: ${response.body}"); // Debugging

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        // Ensure "data" is not null before parsing
        if (jsonData["data"] == null || jsonData["data"] is! List) {
          throw Exception("Invalid data format from API");
        }

        final ProductResponse productResponse =
            ProductResponse.fromJson(jsonData);
        return productResponse.data;
      } else {
        throw Exception("Failed to load products: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching products: $e");
      throw Exception("Error: $e");
    }
  }

  Future<List<Product>> fetchProductsByCategory(String category) async {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:3000/api/products?category=$category'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<dynamic> data = jsonResponse['data'];
      return data.map((product) => Product.fromJson(product)).toList();
    } else {
      throw Exception("Failed to load filtered products");
    }
  }

  Future<Product> fetchProductDetails(String productId) async {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:3000/api/products/$productId'));

    print("API Response ${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse["data"] != null) {
        return Product.fromJson(jsonResponse["data"]);
      } else {
        throw Exception("Invalid product data received");
      }
    } else {
      throw Exception("Failed to load product details");
    }
  }

  Future<List<Product>> searchProducts(
      String searchQuery, String category) async {
    final String url = '$baseUrl?search=$searchQuery' +
        (category.isNotEmpty ? '&category=$category' : '');

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<dynamic> data = jsonResponse['data'];
      return data.map((product) => Product.fromJson(product)).toList();
    } else {
      throw Exception("Failed to search products");
    }
  }
}
