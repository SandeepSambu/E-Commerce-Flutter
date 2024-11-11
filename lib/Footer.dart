import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipeapp_flutter/Cart.dart';
import 'package:recipeapp_flutter/ProductListScreen.dart';
import 'package:recipeapp_flutter/network.dart';

class Footer extends StatelessWidget {
  final User? user;
  final Map<Products, int> cartItems;
  final Function menuPress;
  final Function removeFromCart;
  const Footer({super.key, required this.user, required this.cartItems, required this.menuPress, required this.removeFromCart});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.symmetric(horizontal: 25),
          decoration: BoxDecoration(
            color: Colors.deepPurple[100]?.withOpacity(0.8),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductListScreen(user: user, cartItems: cartItems,)
                    )
                  );
                },
                icon: const Icon(Icons.home_filled, size: 40)
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Cart(user: user, cartItems: cartItems, removeFromCart: removeFromCart,)));
                    },
                    icon: const Icon(Icons.add_shopping_cart, size: 40)),
                  Text("${cartItems.length}", style: const TextStyle(fontSize: 25),)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}