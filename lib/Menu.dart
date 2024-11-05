import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipeapp_flutter/Authentication.dart';

class Menu extends StatefulWidget {
  final User? user;
  const Menu({super.key, required this.user});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> with SingleTickerProviderStateMixin {
  late AnimationController _staggeredController;
  late Animation<Offset> slideAnimation;
  static const slideInDuration = Duration(milliseconds: 20);
  static const initialDelayTime = Duration(milliseconds: 50);
  static const itemSlideTime = Duration(milliseconds: 450);
  static const staggerTime = Duration(milliseconds: 50);
  static const buttonDelayTime = Duration(milliseconds: 350);
  static const buttonTime = Duration(milliseconds: 500);
  final animationDuration = slideInDuration + initialDelayTime + (staggerTime * menuTitles.length) + buttonDelayTime + buttonTime;
  static const menuTitles = [
    "Trending",
    "Shop by Category",
    "Help and Setting",
  ];
  final List<Interval> itemSlideIntervals = [];
  late Interval buttonInterval;

  @override
  void initState() {
    super.initState();
    _staggeredController = AnimationController(vsync: this, duration: animationDuration);

    slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero
    ).animate(CurvedAnimation(
        parent: _staggeredController,
        curve: Curves.easeInOut
    ));

    _staggeredController.forward();

    createAnimationIntervals();
  }

  void createAnimationIntervals() {
    for(var i=0;i<menuTitles.length;i++) {
      final startTime = initialDelayTime + (staggerTime * i);
      final endTime = startTime + itemSlideTime;
      itemSlideIntervals.add(
        Interval(startTime.inMilliseconds / animationDuration.inMilliseconds, endTime.inMilliseconds / animationDuration.inMilliseconds)
      );
    }

    final buttonStartTime = Duration(milliseconds: (menuTitles.length * 50)) + buttonDelayTime;
    final buttonEndTime = buttonStartTime + buttonTime;
    buttonInterval = Interval(buttonStartTime.inMilliseconds / animationDuration.inMilliseconds, buttonEndTime.inMilliseconds / animationDuration.inMilliseconds);
  }

  @override
  void dispose() {
    super.dispose();

    _staggeredController.dispose();
  }

  void slideOutMenu() {
    _staggeredController.reverse();
  }

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