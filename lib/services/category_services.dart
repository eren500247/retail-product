import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:retail_go/models/category_model.dart';
// import '../models/category_model.dart';

class CategoryService {
  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/api/categories'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<dynamic> data = jsonResponse['data'];
      return data.map((category) => Category.fromJson(category)).toList();
    } else {
      throw Exception("Failed to load categories");
    }
  }
}
