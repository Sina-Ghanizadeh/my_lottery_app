import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:my_lottery_app/arrow.dart';
import 'package:roulette/roulette.dart';

void main() => runApp(const ConfettiSample());

class ConfettiSample extends StatelessWidget {
  const ConfettiSample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'My Lottery App',
        home: Scaffold(
          backgroundColor: Colors.grey[900],
          body: HomePage(),
        ));
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  bool _clockwise = true;
  static final _random = Random();
  var units = <RouletteUnit>[
    RouletteUnit.text("Amir", weight: 1, color: Colors.green),
    RouletteUnit.text("Mehdi", weight: 0.68, color: Colors.pink),
    RouletteUnit.text("Jamshidi", weight: 0.27, color: Colors.blue),
    RouletteUnit.text("Sina", weight: 0.67, color: Colors.red),
    RouletteUnit.text("Arman", weight: 0.66, color: Colors.orange),
  ];
  //Confetti
  late ConfettiController _controllerCenter;
  late ConfettiController _controllerCenterRight;
  late ConfettiController _controllerCenterLeft;
  late ConfettiController _controllerTopCenter;
  late ConfettiController _controllerBottomCenter;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerCenterRight =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerCenterLeft =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerTopCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerBottomCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    // Create roulette units
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    _controllerCenterRight.dispose();
    _controllerCenterLeft.dispose();
    _controllerTopCenter.dispose();
    _controllerBottomCenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _controller = RouletteController(
      group: RouletteGroup(units),
      vsync: this,
    );
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        floatingActionButton: Row(
          children: [
            // FloatingActionButton(
            //   // Use the controller to run the animation with rollTo method
            //   onPressed: () {
            //     showDialog(
            //       context: context,
            //       builder: (context) {
            //         return AlertDialog(
            //           content: Column(
            //             children: [
            //               TextField(
            //                 controller: _nameController,
            //                 decoration: InputDecoration(
            //                   hintText: "Enter Name",
            //                 ),
            //               ),
            //               TextField(
            //                 controller: _weightController,
            //                 decoration: InputDecoration(
            //                   hintText: "Enter Weight",
            //                 ),
            //               ),
            //               IconButton(
            //                   onPressed: () {
            //                     units.add(RouletteUnit.text(
            //                         _nameController.text,
            //                         weight:
            //                             double.parse(_weightController.text),
            //                         color: Color(
            //                                 (Random().nextDouble() * 0xFFFFFF)
            //                                     .toInt())
            //                             .withOpacity(1.0)));
            //                     _nameController.clear();
            //                     _weightController.clear();
            //                   },
            //                   icon: Icon(Icons.add))
            //             ],
            //           ),
            //         );
            //       },
            //     );
            //     setState(() {});
            //   },
            //   child: const Icon(Icons.add),
            // ),
            FloatingActionButton(
              // Use the controller to run the animation with rollTo method
              onPressed: () async {
                var sec = 50;
                _controller.rollTo(
                  duration: Duration(seconds: sec),
                  3,
                  clockwise: _clockwise,
                  offset: _random.nextDouble() * units.length,
                  curve: Curves.easeInOutQuart,
                );
                await Future.delayed(Duration(seconds: sec - 1));
                _controllerCenterRight.play();
                _controllerTopCenter.play();
                _controllerBottomCenter.play();
                _controllerCenterLeft.play();
              },
              child: const Icon(Icons.refresh_rounded),
            ),
          ],
        ),
        body: Stack(
          children: <Widget>[
            // Padding(
            //   padding: const EdgeInsets.all(20.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Icon(
            //         Icons.emoji_events,
            //         color: Colors.yellow,
            //       ),
            //       Text(
            //         'Sina',
            //         style: TextStyle(
            //             color: Colors.white,
            //             fontSize: 32,
            //             fontWeight: FontWeight.bold),
            //       ),
            //       Icon(
            //         Icons.emoji_events,
            //         color: Colors.yellow,
            //       ),
            //     ],
            //   ),
            // ),
            //CENTER -- Blast
            Center(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    color: Colors.transparent,
                    width: 600,
                    height: 600,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Roulette(
                        // Provide controller to update its state
                        controller: _controller,
                        // Configure roulette's appearance
                        style: const RouletteStyle(
                          dividerThickness: 1,
                          dividerColor: Colors.white,
                          centerStickSizePercent: 0.05,
                          centerStickerColor: Colors.brown,
                        ),
                      ),
                    ),
                  ),
                  const Arrow(),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: ConfettiWidget(
                confettiController: _controllerCenter,
                blastDirectionality: BlastDirectionality
                    .explosive, // don't specify a direction, blast randomly
                shouldLoop:
                    true, // start again as soon as the animation is finished
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple
                ], // manually specify the colors to be used
                createParticlePath: drawStar, // define a custom shape/path.
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                  onPressed: () {
                    _controllerCenter.play();
                  },
                  child: _display('blast\nstars')),
            ),

            //CENTER RIGHT -- Emit left
            Align(
              alignment: Alignment.centerRight,
              child: ConfettiWidget(
                confettiController: _controllerCenterRight,
                blastDirection: pi, // radial value - LEFT
                particleDrag: 0.05, // apply drag to the confetti
                emissionFrequency: 0.05, // how often it should emit
                numberOfParticles: 20, // number of particles to emit
                gravity: 0.05, // gravity - or fall speed
                shouldLoop: false,
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink
                ], // manually specify the colors to be used
                strokeWidth: 1,
                strokeColor: Colors.white,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: () {
                    _controllerCenterRight.play();
                  },
                  child: _display('pump left')),
            ),

            //CENTER LEFT - Emit right
            Align(
              alignment: Alignment.centerLeft,
              child: ConfettiWidget(
                confettiController: _controllerCenterLeft,
                blastDirection: 0, // radial value - RIGHT
                emissionFrequency: 0.6,
                minimumSize: const Size(10,
                    10), // set the minimum potential size for the confetti (width, height)
                maximumSize: const Size(50,
                    50), // set the maximum potential size for the confetti (width, height)
                numberOfParticles: 1,
                gravity: 0.1,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                  onPressed: () {
                    _controllerCenterLeft.play();
                  },
                  child: _display('singles')),
            ),

            //TOP CENTER - shoot down
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _controllerTopCenter,
                blastDirection: pi / 2,
                maxBlastForce: 5, // set a lower max blast force
                minBlastForce: 2, // set a lower min blast force
                emissionFrequency: 0.05,
                numberOfParticles: 50, // a lot of particles at once
                gravity: 1,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: TextButton(
                  onPressed: () {
                    _controllerTopCenter.play();
                  },
                  child: _display('goliath')),
            ),
            //BOTTOM CENTER
            Align(
              alignment: Alignment.bottomCenter,
              child: ConfettiWidget(
                confettiController: _controllerBottomCenter,
                blastDirection: -pi / 2,
                emissionFrequency: 0.01,
                numberOfParticles: 20,
                maxBlastForce: 100,
                minBlastForce: 80,
                gravity: 0.3,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: TextButton(
                  onPressed: () {
                    _controllerBottomCenter.play();
                  },
                  child: _display('hard and infrequent')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _display(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white, fontSize: 20),
    );
  }

  /// A custom Path to paint stars.
  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }
}
