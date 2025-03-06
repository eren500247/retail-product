class ProductResponse {
  final bool error;
  final bool success;
  final List<Product> data;

  ProductResponse({
    required this.error,
    required this.success,
    required this.data,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      error: json["error"] ?? true,
      success: json["success"] ?? false,
      data: (json["data"] as List?)?.map((p) => Product.fromJson(p)).toList() ??
          [],
    );
  }
}

class Product {
  final String productId;
  final String name;
  final String description;
  final String brand;
  final double discount;
  final String status;
  final double basePrice;
  final String? featuredImage;
  final List<Variant> variants;

  Product({
    required this.productId,
    required this.name,
    required this.description,
    required this.brand,
    required this.discount,
    required this.status,
    required this.basePrice,
    required this.featuredImage,
    required this.variants,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json["product_id"] ?? "",
      name: json["name"] ?? "Unknown Product",
      description: json["description"] ?? "No description available",
      brand: json["brand"] ?? "Unknown Brand",
      discount: double.tryParse(json["discount"].toString()) ?? 0.0,
      status: json["status"] ?? "unknown",
      basePrice: double.tryParse(json["base_price"].toString()) ?? 0.0,
      featuredImage: json["featured_image"] ?? "",
      variants: (json["variants"] as List?)
              ?.map((v) => Variant.fromJson(v))
              .toList() ??
          [],
    );
  }
}

class Variant {
  final int variantId;
  final String productId;
  final String sku;
  final double price;
  final int stock;
  final double discount;
  final String createdAt;
  final String updatedAt;
  final List<Attribute> attributes;
  final List<Media> media;

  Variant({
    required this.variantId,
    required this.productId,
    required this.sku,
    required this.price,
    required this.stock,
    required this.discount,
    required this.createdAt,
    required this.updatedAt,
    required this.attributes,
    required this.media,
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      variantId: json["variant_id"] ?? 0,
      productId: json["product_id"] ?? "",
      sku: json["sku"] ?? "Unknown SKU",
      price: double.tryParse(json["price"].toString()) ?? 0.0,
      stock: json["stock"] ?? 0,
      discount: double.tryParse(json["discount"].toString()) ?? 0.0,
      createdAt: json["created_at"] ?? "",
      updatedAt: json["updated_at"] ?? "",
      attributes: (json["attributes"] as List?)
              ?.map((a) => Attribute.fromJson(a))
              .toList() ??
          [],
      media: (json["media"] as List?)?.map((m) => Media.fromJson(m)).toList() ??
          [],
    );
  }
}

class Attribute {
  final String name;
  final String value;

  Attribute({required this.name, required this.value});

  factory Attribute.fromJson(Map<String, dynamic> json) {
    return Attribute(
      name: json["attribute_name"] ?? "",
      value: json["value"] ?? "",
    );
  }
}

class Media {
  final int mediaId;
  final String mediaUrl;
  final String mediaType;

  Media({
    required this.mediaId,
    required this.mediaUrl,
    required this.mediaType,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      mediaId: json["media_id"] ?? 0,
      mediaUrl: json["media_url"] ?? "",
      mediaType: json["media_type"] ?? "",
    );
  }
}
