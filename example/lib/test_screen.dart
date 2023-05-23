import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  StateMachineController? stateMachineController;
  SMIInput<double>? initialValue;

  double ratingValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Animated Rating Bar"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          const SizedBox(height: 100),
          SizedBox(
            height: 40,
            width: 200,
            child: RiveAnimation.asset(
              "assets/rating_animation.riv",
              onInit: (artboard) {
                stateMachineController = StateMachineController.fromArtboard(
                  artboard,
                  "State Machine 1",
                  onStateChange: (stateMachineName, stateName) {
                    // print("$stateMachineName, $stateName");
                  },
                );
                if (stateMachineController != null) {
                  artboard.addController(stateMachineController!);
                  initialValue = stateMachineController!.findInput("Rating");
                  initialValue!.change(1);
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

                      if (shape.name == "Star_1") {
                        (shape.fills.first.children[0] as SolidColor)
                            .colorValue = const Color(0xFFF44336).value;
                      } else if (shape.name == "Star_base_1") {
                        (shape.strokes.first.children[0] as SolidColor)
                            .colorValue = const Color(0xFFF44336).value;
                      } else if (shape.name == "Star_2") {
                        (shape.fills.first.children[0] as SolidColor)
                            .colorValue = const Color(0xFFF4E736).value;
                      }
                    }
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                initialValue?.change(double.parse(value == "" ? "1" : value));
              },
            ),
          ),
          const SizedBox(height: 100),
          const Text("Rating Value"),
          Text(
            ratingValue.toString(),
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              int? id = initialValue!.id;
              if (kDebugMode) {
                print(stateMachineController!.getInputValue(id));
                setState(() {
                  ratingValue = stateMachineController!.getInputValue(id);
                });
              }
            },
            child: const Text("Get Value"),
          ),
        ],
      ),
    );
  }
}
