import 'package:animated_rating_bar/animated_rating_bar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animated Rating Bar',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      home: const RatingScreen(),
    );
  }
}

class RatingScreen extends StatelessWidget {
  const RatingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Animated Rating Bar"),
      ),
      body: Center(
        child: AnimatedRatingBar(
          activeFillColor: Theme.of(context).colorScheme.inversePrimary,
          strokeColor: Colors.green,
          initialRating: 0,
          height: 60,
          width: MediaQuery.of(context).size.width,
          animationColor: Colors.red,
          onRatingUpdate: (rating) {
            debugPrint(rating.toString());
          },
        ),
      ),
    );
  }
}
