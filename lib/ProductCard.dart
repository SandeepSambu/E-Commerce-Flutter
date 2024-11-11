import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipeapp_flutter/network.dart';
import 'ProductDetailScreen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// A StatefulWidget for representing the ProductCard widget
class ProductCard extends StatefulWidget {
  final Products product;
  final User? user;
  final Function addToCart;
  final Function removeFromCart;
  final Map<Products, int> cartItems;
  final bool isAdded;
  final Function menuPress;

  const ProductCard({
    required this.product,
    super.key,
    required this.user,
    required this.addToCart,
    required this.removeFromCart,
    required this.cartItems,
    required this.isAdded,
    required this.menuPress
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    // GestureDetector to detect tap on the product card
    return GestureDetector(
      onTap: (){
        // Navigating to the ProductDetailScreen when the card is tapped
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailScreen(
                  product: widget.product,
                  user: widget.user,
                  cartItems: widget.cartItems,
                  menuPress: widget.menuPress,
                  removeFromCart: widget.removeFromCart
                )
            )
        );
      },
      child: SizedBox(
        width: 250,
        height: 256,
        child: Card(
          elevation: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: 120,
                  color: Colors.grey[300],
                  child: Center(child: Image.network(widget.product.images[0]))
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  widget.product.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "\$${widget.product.price.toStringAsFixed(2)}",
                  style: const TextStyle(
                      color: Colors.green,
                      fontSize: 14
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  widget.product.category,
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14
                  ),
                ),
              ),
              Padding(
                padding: kIsWeb ? const EdgeInsets.only(top: 6) : const EdgeInsets.only(top: 25),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                      onPressed: () {
                        if(!widget.isAdded || widget.cartItems.isEmpty) {
                          widget.addToCart(widget.product);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: widget.isAdded ? Colors.grey[300] : Colors.blue,
                          foregroundColor: widget.isAdded ? Colors.black : Colors.white
                      ),
                      child: widget.isAdded ? const Text("Added to cart") : const Text("Add to cart")
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}