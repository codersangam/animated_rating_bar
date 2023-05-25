import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class AnimatedRatingBar extends StatefulWidget {
  const AnimatedRatingBar(
      {super.key,
      this.initialRating = 0.0,
      this.height,
      this.width,
      this.activeFillColor,
      this.strokeColor,
      required this.onRatingUpdate,
      this.animationColor});

  final double? initialRating;
  final double? height;
  final double? width;
  final Color? activeFillColor;
  final Color? strokeColor;
  final Color? animationColor;
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
        "assets/new_rating_animation.riv",
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

          artboard.forEachComponent(
            (child) {
              if (child is Shape) {
                final Shape shape = child;
                if (shape.name == "Star_base_1") {
                  debugPrint("Shape Name====> ${shape.name}");
                  debugPrint(
                      "Shape Fills====> ${shape.fills.first.children[0]}");
                  debugPrint(
                      "Shape Strokes====> ${shape.strokes.elementAt(0).paint.color}");
                }
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
                    // print("IsDarkMode ==> $isDarkMode");
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
    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text("Animated Rating Bar"),
    //     backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    //   ),
    //   body: Column(
    //     children: [
    //       const SizedBox(height: 100),
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           const Text(
    //             "Rating",
    //             style: TextStyle(fontSize: 22),
    //           ),
    //           SizedBox(
    //             height: widget.height ?? 40,
    //             width: widget.width ?? 140,
    //             child: RiveAnimation.asset(
    //               "assets/new_rating_animation.riv",
    //               onInit: (artboard) {
    //                 stateMachineController =
    //                     StateMachineController.fromArtboard(
    //                   artboard,
    //                   "State Machine 1",
    //                   onStateChange: (stateMachineName, stateName) {
    //                     // print("$stateMachineName, $stateName");
    //                     setState(() {
    //                       int? id = initialValue!.id;
    //                       ratingValue =
    //                           stateMachineController!.getInputValue(id);
    //                       widget.onRatingUpdate(ratingValue);
    //                     });
    //                   },
    //                 );
    //                 if (stateMachineController != null) {
    //                   artboard.addController(stateMachineController!);
    //                   initialValue =
    //                       stateMachineController!.findInput("Rating");
    //                   initialValue!.change(widget.initialRating ?? 1);
    //                 }

    //                 artboard.forEachComponent(
    //                   (child) {
    //                     if (child is Shape) {
    //                       final Shape shape = child;
    //                       if (shape.name == "Star_base_1") {
    //                         debugPrint("Shape Name====> ${shape.name}");
    //                         debugPrint(
    //                             "Shape Fills====> ${shape.fills.first.children[0]}");
    //                         debugPrint(
    //                             "Shape Strokes====> ${shape.strokes.elementAt(0).paint.color}");
    //                       }
    //                       if (widget.activeFillColor != null) {
    //                         if (shape.name == "Star_1" ||
    //                             shape.name == "Star_2" ||
    //                             shape.name == "Star_3" ||
    //                             shape.name == "Star_4" ||
    //                             shape.name == "Star_5") {
    //                           (shape.fills.first.children[0] as SolidColor)
    //                               .colorValue = widget.activeFillColor!.value;
    //                         } else if (shape.name == "Star_base_1" ||
    //                             shape.name == "Star_base_2" ||
    //                             shape.name == "Star_base_3" ||
    //                             shape.name == "Star_base_4" ||
    //                             shape.name == "Star_base_5") {
    //                           (shape.strokes.first.children[0] as SolidColor)
    //                                   .colorValue =
    //                               widget.strokeColor?.value ??
    //                                   widget.activeFillColor!.value;
    //                         }
    //                       } else {}
    //                     }
    //                   },
    //                 );
    //               },
    //             ),
    //           ),
    //         ],
    //       ),
    //       Padding(
    //         padding: const EdgeInsets.all(8.0),
    //         child: TextField(
    //           onChanged: (value) {
    //             initialValue?.change(double.parse(value == "" ? "1" : value));
    //           },
    //         ),
    //       ),
    //       const SizedBox(height: 100),
    //       const Text("Rating Value"),
    //       Text(
    //         ratingValue.toString(),
    //         style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    //       ),
    //       const SizedBox(height: 20),
    //       Center(
    //         child: ElevatedButton(
    //           onPressed: () {
    //             int? id = initialValue!.id;
    //             if (kDebugMode) {
    //               print(stateMachineController!.getInputValue(id));
    //             }
    //             setState(() {
    //               ratingValue = stateMachineController!.getInputValue(id);
    //               widget.onRatingUpdate(ratingValue);
    //             });
    //           },
    //           child: const Text("Get Value"),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
