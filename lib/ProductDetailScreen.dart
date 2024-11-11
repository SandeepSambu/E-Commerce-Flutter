import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:recipeapp_flutter/Cart.dart';
import 'package:recipeapp_flutter/Footer.dart';
import 'package:recipeapp_flutter/ProductListScreen.dart';
import 'package:recipeapp_flutter/network.dart';

// represents a detailed view of a selected product, displaying information and reviews.
class ProductDetailScreen extends StatelessWidget {
  final User? user;
  final Products product;
  final Map<Products, int> cartItems;
  final Function menuPress;
  final Function removeFromCart;

  const ProductDetailScreen({
    required this.product,
    super.key,
    required this.user,
    required this.cartItems,
    required this.menuPress,
    required this.removeFromCart
  });

  bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          kIsWeb || isLandscape(context)
              ? Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 70),
                child: IconButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProductListScreen(user: user, cartItems: cartItems)));
                    },
                    icon: const Icon(Icons.home_filled)
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: Row(
                    children: [
                      Text("${cartItems.length}", style: const TextStyle(fontSize: 20),),
                      IconButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Cart(user: user, cartItems: cartItems, removeFromCart: removeFromCart)));
                          },
                          icon: const Icon(Icons.add_shopping_cart)
                      ),
                    ],
                  )
              )
            ],
          )
              : const SizedBox()
        ]
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: isLandscape(context) ? 200 : 350,
                  child: Image.network(
                    product.images.isNotEmpty ? product.images[0] : '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 100, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                product.title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              const SizedBox(height: 8),
              Text(
                "\$${product.price.toStringAsFixed(2)}",
                style: const TextStyle(color: Colors.green, fontSize: 20),
              ),
              const SizedBox(height: 8),
              Text(
                product.category,
                style: const TextStyle(color: Colors.grey, fontSize: 18),
              ),
              const SizedBox(height: 16),
              Text(
                product.description,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 24),
                  Text(
                    product.rating.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (product.reviews.isNotEmpty) ...[
                const Text(
                  "Reviews",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ...product.reviews.map((review) => _buildReviewTile(review)),
              ] else ...[
                const Text(
                  "No reviews available",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
              const SizedBox(height: 16),

              if (!kIsWeb && !isLandscape(context)) Footer(user: user, cartItems: cartItems, menuPress: menuPress, removeFromCart: removeFromCart,),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewTile(Reviews review) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  review.reviewerName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Text(
                  "(${review.reviewerEmail})",
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                Text('${review.rating}'),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              review.comment,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              'Date: ${review.date.toLocal().toString().split(' ')[0]}',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
