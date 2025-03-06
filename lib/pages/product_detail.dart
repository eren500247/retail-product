import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:retail_go/models/product_model.dart';
import 'package:retail_go/services/product_service.dart';
// import '../models/product_model.dart';
// import '../services/product_service.dart';

class ProductDetailPage extends StatefulWidget {
  final String productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late Future<Product> futureProduct;
  int selectedVariantIndex = 0;

  @override
  void initState() {
    super.initState();
    futureProduct = ProductService().fetchProductDetails(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product Details"), centerTitle: true),
      body: FutureBuilder<Product>(
        future: futureProduct,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("Product not found"));
          }

          Product product = snapshot.data!;
          Variant selectedVariant = product.variants[selectedVariantIndex];

          Map<String, Set<String>> groupedAttributes = {};
          for (var variant in product.variants) {
            for (var attribute in variant.attributes) {
              if (!groupedAttributes.containsKey(attribute.name)) {
                groupedAttributes[attribute.name] = <String>{};
              }
              groupedAttributes[attribute.name]!.add(attribute.value);
            }
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (selectedVariant.media.isNotEmpty)
                  CarouselSlider(
                    options: CarouselOptions(height: 200.0, autoPlay: true),
                    items: selectedVariant.media.map((media) {
                      return Image.network(media.mediaUrl, fit: BoxFit.cover);
                    }).toList(),
                  ),
                const SizedBox(height: 10),
                Text(product.name,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                Text("Brand: ${product.brand}",
                    style: const TextStyle(fontSize: 16)),
                Text("Status: ${product.status}",
                    style: const TextStyle(fontSize: 16)),
                Text("Price: \$${selectedVariant.price.toStringAsFixed(2)}",
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue)),
                const SizedBox(height: 10),
                Text(product.description,
                    style: const TextStyle(fontSize: 16, color: Colors.grey)),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 10,
                  children: List.generate(product.variants.length, (index) {
                    Variant variant = product.variants[index];
                    String? imageUrl = variant.media.isNotEmpty
                        ? variant.media.first.mediaUrl
                        : null;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedVariantIndex = index;
                        });
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: selectedVariantIndex == index
                                ? Colors.blue
                                : Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: imageUrl != null
                            ? Image.network(imageUrl, fit: BoxFit.cover)
                            : const Icon(Icons.image, color: Colors.grey),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 10),
                Text("Attributes:",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                ...selectedVariant.attributes.map((attribute) {
                  return Text("${attribute.name}: ${attribute.value}");
                }).toList(),
                // Text("Attributes:",
                //     style: const TextStyle(
                //         fontSize: 18, fontWeight: FontWeight.bold)),
                // for (var attributeName in groupedAttributes.keys)
                //   Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text(attributeName,
                //           style: const TextStyle(
                //               fontSize: 16, fontWeight: FontWeight.bold)),
                //       Wrap(
                //         children: groupedAttributes[attributeName]!
                //             .map((value) => Row(
                //                   mainAxisSize: MainAxisSize.min,
                //                   children: [
                //                     Checkbox(
                //                       value: false,
                //                       onChanged: (bool? newValue) {},
                //                     ),
                //                     Text(value.trim()),
                //                   ],
                //                 ))
                //             .toList(),
                //       ),
                //     ],
                //   ),
              ],
            ),
          );
        },
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import '../models/product_model.dart';
// import '../services/product_service.dart';

// class ProductDetailPage extends StatefulWidget {
//   final String productId;

//   const ProductDetailPage({super.key, required this.productId});

//   @override
//   _ProductDetailPageState createState() => _ProductDetailPageState();
// }

// class _ProductDetailPageState extends State<ProductDetailPage> {
//   late Future<Product> futureProduct;
//   int selectedVariantIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     futureProduct = ProductService().fetchProductDetails(widget.productId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Product Details"), centerTitle: true),
//       body: FutureBuilder<Product>(
//         future: futureProduct,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           } else if (!snapshot.hasData) {
//             return const Center(child: Text("Product not found"));
//           }

//           Product product = snapshot.data!;
//           Variant selectedVariant = product.variants[selectedVariantIndex];

//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 if (selectedVariant.media.isNotEmpty)
//                   CarouselSlider(
//                     options: CarouselOptions(height: 200.0, autoPlay: true),
//                     items: selectedVariant.media.map((media) {
//                       return Image.network(media.mediaUrl, fit: BoxFit.cover);
//                     }).toList(),
//                   ),
//                 const SizedBox(height: 10),
//                 Text(product.name,
//                     style: const TextStyle(
//                         fontSize: 24, fontWeight: FontWeight.bold)),
//                 Text("Brand: ${product.brand}",
//                     style: const TextStyle(fontSize: 16)),
//                 Text("Status: ${product.status}",
//                     style: const TextStyle(fontSize: 16)),
//                 Text("Price: \$${selectedVariant.price.toStringAsFixed(2)}",
//                     style: const TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.blue)),
//                 const SizedBox(height: 10),
//                 Text(product.description,
//                     style: const TextStyle(fontSize: 16, color: Colors.grey)),
//                 const SizedBox(height: 20),
//                 Wrap(
//                   spacing: 10,
//                   children: List.generate(product.variants.length, (index) {
//                     Variant variant = product.variants[index];
//                     String? imageUrl = variant.media.isNotEmpty
//                         ? variant.media.first.mediaUrl
//                         : null;

//                     return GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           selectedVariantIndex = index;
//                         });
//                       },
//                       child: Container(
//                         width: 50,
//                         height: 50,
//                         decoration: BoxDecoration(
//                           border: Border.all(
//                             color: selectedVariantIndex == index
//                                 ? Colors.blue
//                                 : Colors.grey,
//                           ),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: imageUrl != null
//                             ? Image.network(imageUrl, fit: BoxFit.cover)
//                             : const Icon(Icons.image, color: Colors.grey),
//                       ),
//                     );
//                   }),
//                 ),
//                 const SizedBox(height: 10),
//                 Text("Attributes:",
//                     style: const TextStyle(
//                         fontSize: 18, fontWeight: FontWeight.bold)),
//                 ...selectedVariant.attributes.map((attribute) {
//                   return Text("${attribute.name}: ${attribute.value}");
//                 }).toList(),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
