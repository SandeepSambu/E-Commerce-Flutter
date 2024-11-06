import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:recipeapp_flutter/Menu.dart';
import 'package:recipeapp_flutter/ProductListScreen.dart';
import 'network.dart';

class Cart extends StatefulWidget {
  final User? user;
  final List<Products> cartItems;

  const Cart({
    super.key,
    required this.user,
    required this.cartItems
  });

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  Map<int, int> itemCounts = {};

  var totalPrice = 0.0;

  bool isExpanded = false;

  void menuPress() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.cartItems.length; i++) {
      itemCounts[i] = 1; // Assuming each item is initially added once to the cart
    }
    calculateTotalPrice();
  }

  void calculateTotalPrice() {
    double total = 0.0;
    for (var i = 0; i < widget.cartItems.length; i++) {
      // Multiply price of each item by its quantity and add to the total
      total += widget.cartItems[i].price * itemCounts[i]!;
    }

    setState(() {
      totalPrice = total; // Update the total price
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 3,
          leading: IconButton(
            onPressed: () {
              menuPress();
            },
            icon: const Icon(Icons.menu),
          ),
          title: const Text("My Cart"),
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 70,
                    child: const Card(
                      elevation: 3,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Shopping Cart",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                            ),
                            Text("price", style: TextStyle(fontSize: 25),)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.cartItems.length,
                      itemBuilder: (context, index) {
                        final product = widget.cartItems[index];
                        return Card(
                            elevation: 3,
                            margin: const EdgeInsets.all(5),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 180,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15, top: 40),
                                      child: Row(
                                        children: [
                                          Image.network(
                                              product.images[0],
                                              width: kIsWeb ? 200 : 100, height: kIsWeb ? 200 : 100),
                                          const SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 150,
                                                height: 50,
                                                child: Text(
                                                  product.title,
                                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                                  maxLines: 2,
                                                ),
                                              ),
                                              product.stock > 0
                                                  ? const Text("In Stock", style: TextStyle(color: Colors.green))
                                                  : const Text("Out of Stock", style: TextStyle(color: Colors.red)),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Container(
                                                width: 150,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                    border: Border.all(width: 1, color: Colors.grey),
                                                    borderRadius: BorderRadius.circular(10)
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          if(itemCounts[index]! > 0) {
                                                            itemCounts[index] = itemCounts[index]! - 1;
                                                          }
                                                          calculateTotalPrice();
                                                        });
                                                      },
                                                      icon: const Icon(Icons.remove),
                                                      padding: EdgeInsets.zero,
                                                    ),
                                                    Container(
                                                      width: 3,
                                                      height: 20,
                                                      color: Colors.grey,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 15),
                                                      child: Text("${itemCounts[index]}"),
                                                    ),
                                                    Container(
                                                      width: 3,
                                                      height: 20,
                                                      color: Colors.grey,
                                                    ),
                                                    IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          itemCounts[index] = itemCounts[index]! + 1;
                                                          calculateTotalPrice();
                                                        });
                                                      },
                                                      icon: const Icon(Icons.add),
                                                      padding: EdgeInsets.zero,
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      )
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10, bottom: 10, right: 30),
                                    child: Text(
                                      "\$${product.price.toStringAsFixed(2)}",
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                                  )
                                ],
                              ),
                            )
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Text(
                              "Total Price: \$${totalPrice.toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 2,
                          color: Colors.grey,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ProductListScreen(
                                        user: widget.user,
                                        cartItems: widget.cartItems
                                      ))
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white
                                ),
                                child: const Text("Shop More")
                            ),
                            ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white
                                ),
                                child: const Text("Proceed to Buy")
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            isExpanded ? Menu(user: widget.user) : const SizedBox()
          ],
        )
    );
  }
}
