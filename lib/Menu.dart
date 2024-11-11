import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipeapp_flutter/Authentication.dart';

class Menu extends StatefulWidget {
  final User? user;
  const Menu({super.key, required this.user});

  @override
  State<Menu> createState() => _MenuState();
}

// Menu class that accepts a User object to manage the authentication state
class _MenuState extends State<Menu> with SingleTickerProviderStateMixin {
  late AnimationController _staggeredController;  // Controller for the staggered animations
  late Animation<Offset> slideAnimation;  // Slide animation for the menu transition
  static const slideInDuration = Duration(milliseconds: 20);  // Duration for the menu slide-in animation
  static const initialDelayTime = Duration(milliseconds: 50);  // Initial delay before the first item slides in
  static const itemSlideTime = Duration(milliseconds: 450);   // Duration for each item to slide in
  static const staggerTime = Duration(milliseconds: 50);  // Time between each menu item animation
  static const buttonDelayTime = Duration(milliseconds: 350);   // Delay before the sign-in button slides in
  static const buttonTime = Duration(milliseconds: 500);    // Duration for the button animation
  final animationDuration = slideInDuration + initialDelayTime + (staggerTime * menuTitles.length) + buttonDelayTime + buttonTime;

  // List of menu titles to display
  static const menuTitles = [
    "Trending",
    "Shop by Category",
    "Help and Setting",
  ];
  final List<Interval> itemSlideIntervals = [];  // Intervals for each menu item's animation timing
  late Interval buttonInterval;  // Interval for the sign-in button animation

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller with the defined animation duration
    _staggeredController = AnimationController(vsync: this, duration: animationDuration);

    // Create the slide-in animation for the entire menu
    slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero
    ).animate(CurvedAnimation(
        parent: _staggeredController,
        curve: Curves.easeInOut
    ));

    // Start the menu slide-in animation
    _staggeredController.forward();

    // Generate the intervals for the staggered item animations
    createAnimationIntervals();
  }

  // Method to create intervals for each item in the menu
  void createAnimationIntervals() {
    for(var i=0;i<menuTitles.length;i++) {
      final startTime = initialDelayTime + (staggerTime * i);  // Calculate start time based on item index
      final endTime = startTime + itemSlideTime;  // Calculate end time for the slide animation
      itemSlideIntervals.add(
        Interval(startTime.inMilliseconds / animationDuration.inMilliseconds, endTime.inMilliseconds / animationDuration.inMilliseconds)
      );
    }

    // Calculate the timing interval for the sign-in button animation
    final buttonStartTime = Duration(milliseconds: (menuTitles.length * 50)) + buttonDelayTime;
    final buttonEndTime = buttonStartTime + buttonTime;
    buttonInterval = Interval(buttonStartTime.inMilliseconds / animationDuration.inMilliseconds, buttonEndTime.inMilliseconds / animationDuration.inMilliseconds);
  }

  // Clean up the animation controller when the widget is disposed
  @override
  void dispose() {
    super.dispose();

    _staggeredController.dispose();
  }

  // Reverse the animation (slide the menu out)
  void slideOutMenu() {
    _staggeredController.reverse();
  }

  // Method to build the list items for the menu
  List<Widget> buildListItems() {
    final listItems = <Widget>[];
    for(var i=0;i<menuTitles.length;i++) {
      listItems.add(
        AnimatedBuilder(
          animation: _staggeredController,
          builder: (context, child) {
            final animationPercent = Curves.easeOut.transform(
              itemSlideIntervals[i].transform(_staggeredController.value),
            );
            final opacity = animationPercent;
            final slideDistance = (1.0 - animationPercent) * 150;

            return Opacity(
              opacity: opacity,
              child: Transform.translate(
                offset: Offset(slideDistance, 0),
                child: child,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text(
              menuTitles[i],
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.normal
              ),
            ),
          ),
        )
      );
    }
    return listItems;
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slideAnimation,
      child: Container(
          width: 300,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15,),
                      ...buildListItems()
                    ]
                ),
                SizedBox(
                    width: 200,
                    child: AnimatedBuilder(
                      animation: _staggeredController,
                      builder: (context, child) {
                        final animationPercent = Curves.elasticOut.transform(
                            buttonInterval.transform(_staggeredController.value));
                        final opacity = animationPercent.clamp(0.0, 1.0);
                        final scale = (animationPercent * 0.5) + 0.5;

                        return Opacity(
                          opacity: opacity,
                          child: Transform.scale(
                            scale: scale,
                            child: child,
                          ),
                        );
                      },
                      child: ElevatedButton(
                          onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const Authentication()));},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
                            widget.user != null ? "Sign Out" : "Sign In",
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w200
                            ),
                          )
                      ),
                    )
                )
              ],
            ),
          )
      ),
    );
  }
}