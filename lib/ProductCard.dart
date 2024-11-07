import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipeapp_flutter/network.dart';
import 'ProductDetailScreen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// A StatefulWidget for representing the ProductCard widget
class ProductCard extends StatefulWidget {
  final Products product;
  final User? user;
  final Function cart;
  final Map<Products, int> cartItems;
  final Function menuPress;

  const ProductCard({
    required this.product,
    super.key,
    required this.user,
    required this.cart,
    required this.cartItems,
    required this.menuPress
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {

  bool pressed = false;  // A boolean to track if the product is already added to cart

  late List<Products> items;

  @override
  void initState() {
    super.initState();
    items = widget.cartItems.keys.toList();
    // Loop through cartItems and check if this product is already added
    for(var i=0; i<items.length; i++) {
      if(items[i].id == widget.product.id) {
        pressed = true;
        break;
      }
    }
  }

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
                        if(widget.cartItems.isNotEmpty && !items.contains(widget.product)) {
                          widget.cart(widget.product);
                        } else {
                          widget.cart(widget.product);
                        }
                        setState(() {
                          pressed = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: pressed ? Colors.grey[300] : Colors.blue,
                          foregroundColor: pressed ? Colors.black : Colors.white
                      ),
                      child: pressed ? const Text("Added to cart") : const Text("Add to cart")
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