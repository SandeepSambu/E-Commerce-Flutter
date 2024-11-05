import "dart:convert";

import "package:http/http.dart" as http;

Future<List<Products>> fetchProductsData() async {
  final response = await http.get(Uri.parse("https://dummyjson.com/products"));

  if(response.statusCode == 200) {
    final List<dynamic> productJson = jsonDecode(response.body)["products"];
    return productJson.map((json) => Products.fromJson(json)).toList();
  } else {
    throw Exception("Failed to load data");
  }
}

class Products {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double rating;
  final int stock;
  final List<Reviews> reviews;
  final List<String> images;

  Products({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.rating,
    required this.stock,
    required this.reviews,
    required this.images
  });

  @override
  String toString() {
    return 'Products(id: $id, title: $title, description: $description, category: $category, price: $price, stock: $stock rating: $rating, reviews: $reviews, images: $images)';
  }

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      id: json["id"] as int,
      title: json["title"] as String,
      description: json["description"] as String,
      category: json["category"] as String,
      price: (json["price"] as num).toDouble(),
      stock: json["stock"] as int,
      rating: (json["rating"] as num).toDouble(),
      reviews: (json["reviews"] as List).map((json) => Reviews.fromJson(json as Map<String, dynamic>)).toList(),
      images: List<String>.from(json["images"] as List)
    );
  }
}

class Reviews {
  final double rating;
  final String comment;
  final DateTime date;
  final String reviewerName;
  final String reviewerEmail;

  Reviews({
    required this.rating,
    required this.comment,
    required this.date,
    required this.reviewerName,
    required this.reviewerEmail
  });

  factory Reviews.fromJson(Map<String, dynamic> json) {
    return Reviews(
      rating: (json["rating"] as num).toDouble(),
      comment: json["comment"] as String,
      date: DateTime.parse(json["date"] as String),
      reviewerName: json["reviewerName"] as String,
      reviewerEmail: json["reviewerEmail"] as String
    );
  }
}