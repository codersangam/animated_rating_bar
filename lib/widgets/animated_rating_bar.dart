import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class AnimatedRatingBar extends StatefulWidget {
  /// [AnimatedRatingBar] can be used for rating which enhaces User Experince
  ///
  /// by displaying beautiful animation like glows and sparks.
  ///
  /// Exmple:
  /// ```dart
  /// return AnimatedRatingBar(
  ///          activeFillColor: Theme.of(context).colorScheme.inversePrimary,
  ///          strokeColor: Theme.of(context).colorScheme.inversePrimary,
  ///          initialRating: 0,
  ///          height: 60,
  ///          width: MediaQuery.of(context).size.width,
  ///          animationColor: Theme.of(context).colorScheme.inversePrimary,
  ///          onRatingUpdate: (rating) {
  ///            debugPrint(rating.toString());
  ///          },
  ///        );
  /// ```
  const AnimatedRatingBar(
      {super.key,
      this.initialRating = 0.0,
      this.height,
      this.width,
      this.activeFillColor,
      this.strokeColor,
      required this.onRatingUpdate,
      this.animationColor});

  /// This sets Initial Rating of the Animated Rating Bar
  ///
  /// If not provided, by default it will start from 0.0
  final double? initialRating;

  /// Holds the height of the widget. You can customise it
  ///
  /// accoring to your requirements.
  final double? height;

  /// Holds the width of the widget. You can customise it
  ///
  /// accoring to your requirements.
  final double? width;

  /// Fills color on inner layer of icon except stroke.
  final Color? activeFillColor;

  /// You can even modify stroke color using this property.
  final Color? strokeColor;

  /// Animation color holds both glow and sparks color
  ///
  /// Use it accordingly.
  final Color? animationColor;

  /// This holds double value on updation of the rating.
  final ValueChanged<double> onRatingUpdate;

  @override
  State<AnimatedRatingBar> createState() => _AnimatedRatingBarState();
}

class _AnimatedRatingBarState extends State<AnimatedRatingBar> {
  StateMachineController? stateMachineController;
  SMIInput<double>? initialValue;
  double ratingValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height ?? 40,
      width: widget.width ?? 140,
      child: RiveAnimation.asset(
        "packages/animated_rating_bar/assets/new_rating_animation.riv",
        onInit: (artboard) {
          stateMachineController = StateMachineController.fromArtboard(
            artboard,
            "State Machine 1",
            onStateChange: (stateMachineName, stateName) {
              // print("$stateMachineName, $stateName");
              setState(() {
                int? id = initialValue!.id;
                ratingValue = stateMachineController!.getInputValue(id);
                widget.onRatingUpdate(ratingValue);
              });
            },
          );
          if (stateMachineController != null) {
            artboard.addController(stateMachineController!);
            initialValue = stateMachineController!.findInput("Rating");
            initialValue!.change(widget.initialRating ?? 1);
          }

          /// Customisation of each components from rive.
          artboard.forEachComponent(
            (child) {
              if (child is Shape) {
                final Shape shape = child;
                // if (shape.name == "Star_base_1") {
                //   debugPrint("Shape Name====> ${shape.name}");
                //   debugPrint(
                //       "Shape Fills====> ${shape.fills.first.children[0]}");
                //   debugPrint(
                //       "Shape Strokes====> ${shape.strokes.elementAt(0).paint.color}");
                // }
                if (widget.activeFillColor != null) {
                  if (shape.name == "Star_1" ||
                      shape.name == "Star_2" ||
                      shape.name == "Star_3" ||
                      shape.name == "Star_4" ||
                      shape.name == "Star_5") {
                    (shape.fills.first.children[0] as SolidColor).colorValue =
                        widget.activeFillColor!.value;
                  } else if (shape.name == "Star_base_1" ||
                      shape.name == "Star_base_2" ||
                      shape.name == "Star_base_3" ||
                      shape.name == "Star_base_4" ||
                      shape.name == "Star_base_5") {
                    (shape.strokes.first.children[0] as SolidColor).colorValue =
                        widget.strokeColor?.value ??
                            widget.activeFillColor!.value;
                  } else if (shape.name == "Star_4_glow" ||
                      shape.name == "Star_5_glow" ||
                      shape.name == "Star_5_sparks") {
                    (shape.strokes.first.children[0] as SolidColor).colorValue =
                        widget.animationColor?.value ??
                            widget.activeFillColor!.value;
                  }
                } else {
                  var brightness = MediaQuery.of(context).platformBrightness;
                  bool isDarkMode = brightness == Brightness.dark;
                  if (shape.name == "Star_1" ||
                      shape.name == "Star_2" ||
                      shape.name == "Star_3" ||
                      shape.name == "Star_4" ||
                      shape.name == "Star_5") {
                    (shape.fills.first.children[0] as SolidColor).colorValue =
                        isDarkMode
                            ? ThemeData.light().primaryColor.value
                            : ThemeData.dark().primaryColor.value;
                  } else if (shape.name == "Star_4_glow" ||
                      shape.name == "Star_5_glow" ||
                      shape.name == "Star_5_sparks") {
                    (shape.strokes.first.children[0] as SolidColor).colorValue =
                        isDarkMode
                            ? ThemeData.light().primaryColor.value
                            : ThemeData.dark().primaryColor.value;
                  }
                }
              }
            },
          );
        },
      ),
    );
  }
}
