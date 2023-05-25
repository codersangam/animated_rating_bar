import 'package:animated_rating_bar/animated_rating_bar.dart';
import 'package:flutter/material.dart';

class RatingScreen extends StatelessWidget {
  const RatingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Lol"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 100),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // const Text("Lol"),
              AnimatedRatingBar(
                activeFillColor: Colors.red,
                strokeColor: Colors.red,
                // initialRating: 0,
                animationColor: Colors.green,
                onRatingUpdate: (rating) {
                  debugPrint(rating.toString());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
