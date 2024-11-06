import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipeapp_flutter/Cart.dart';
import 'package:recipeapp_flutter/Menu.dart';
import 'package:recipeapp_flutter/ProductCard.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'Footer.dart';
import "network.dart";

class ProductListScreen extends StatefulWidget {
  final User? user;
  final List<Products> cartItems;
  const ProductListScreen({super.key, required this.user, required this.cartItems});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Products>> productData;

  var searchText = TextEditingController();

  var isExpanded = false;

  bool visible = true;

  int visibleImage = 0;

  late List<Products> cartItems;

  final List<String> images = [
    "Images/beauty.jpeg",
    "Images/electronics.jpeg",
    "Images/furniture.jpeg",
    "Images/grocery.jpeg"
  ];

  void cart(Products product) {
    setState(() {
      cartItems.add(product);
    });
  }

  @override
  void initState() {
    super.initState();
    if(widget.cartItems.isNotEmpty) {
      cartItems = widget.cartItems;
    } else {
      cartItems = [];
    }

    productData = fetchProductsData();
    Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      setState(() {
        visible = !visible;
        visibleImage = (visibleImage + 1) % images.length;
      });
    });
  }

  void menuPress() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height + 50;
    final childAspectRatio = screenWidth / screenHeight;
    const crossAxisCount = kIsWeb ? 3 : 2;
    return MaterialApp(
      title: "MyProducts",
      home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: menuPress,
                icon: const Icon(Icons.menu)
            ),
            title: const Text("MyProducts"),
            actions:  [
              SizedBox(
                width: kIsWeb ? 500 : 240,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        child: SizedBox(
                          width: kIsWeb ? 400 : 230,
                          child: SearchAnchor(
                            builder: (BuildContext context, SearchController controller) {
                              return SearchBar(
                                controller: controller,
                                hintText: "Search",
                                onChanged: (_) {
                                  setState(() {
                                    searchText.text = controller.text;
                                    print("productList - $cartItems");
                                  });
                                },
                                leading: const Icon(Icons.search),
                              );
                            },
                            suggestionsBuilder: (BuildContext context, SearchController controller) {
                              return List.empty();
                            },
                          ),
                        )
                    ),
                  ],
                ),
              ),
              if(kIsWeb)
                 Row(
                  children: [
                    widget.user != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text("Hello, ${widget.user!.displayName}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)
                      )
                    : const Text(""),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("${cartItems.length}", style: const TextStyle(fontSize: 20),),
                          const SizedBox(width: 5),
                          IconButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> Cart(user: widget.user, cartItems: cartItems,)));
                            },
                            icon: const Icon(Icons.add_shopping_cart)
                          ),
                        ],
                      )
                    )
                  ],
                )
            ],
          ),
          body: Stack(
            children: [
              FutureBuilder(
                  future: productData,
                  builder: (context, snapshot) {
                    if(snapshot.hasData) {
                      List<dynamic> filteredProducts = snapshot.data!.where((product) =>
                          product.title.toLowerCase().startsWith(searchText.text.toLowerCase())).toList();
                      return Stack(
                        children: [
                          SingleChildScrollView(
                            child: Column(
                            children: [
                                !kIsWeb && widget.user != null
                                  ? Padding(
                                      padding: const EdgeInsets.only(left: 10, top: 8, bottom: 8),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            "Hello, ${widget.user!.displayName}",
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30)
                                        ),
                                      ),
                                    )
                                  : const Text(""),
                                AnimatedOpacity(
                                  opacity: visible ? 1.0 : 0.0,
                                  duration: const Duration(milliseconds: 3000),
                                  child: Image.asset(
                                    images[visibleImage],
                                    width: screenWidth,
                                    height: kIsWeb ? 300 : 230,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 120),
                                  child: GridView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      mainAxisSpacing: 5,
                                      crossAxisSpacing: 5,
                                      childAspectRatio: kIsWeb ? childAspectRatio : 0.7
                                    ),
                                    itemCount: filteredProducts.length,
                                    itemBuilder: (context, index) {
                                      final product = filteredProducts[index];
                                      return ProductCard(
                                        product: product,
                                        user: widget.user,
                                        cart: cart,
                                        menuPress: menuPress,
                                        cartItems: cartItems,
                                      );
                                    }
                                  ),
                                ),
                              ],
                            ),
                          ),
                          kIsWeb ? const SizedBox() : Footer(user: widget.user, menuPress: menuPress, cartItems: cartItems,)
                        ],
                      );
                    } else if(snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }
              ),
              // Align(
              //   alignment: Alignment.topCenter,
              //   child: Image.asset("Images/dessert.jpeg", width: screenWidth, height: 230, fit: BoxFit.cover,),
              // ),
              if(isExpanded) Menu(user: widget.user,)
            ],
          )
      ),
    );
  }
}