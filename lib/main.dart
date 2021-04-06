import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'I shamelessly stole this code to demo rive',
      home: Scaffold(
        body: MyRiveAnimation(),
      ),
    );
  }
}

class MyRiveAnimation extends StatefulWidget {
  @override
  _MyRiveAnimationState createState() => _MyRiveAnimationState();
}

class _MyRiveAnimationState extends State<MyRiveAnimation> {
  Artboard _artboard;
  RiveAnimationController _bounceController;
  // flag to turn on and off the wipers
  bool _bounce = false;

  @override
  void initState() {
    _loadRiveFile();
    super.initState();
  }

  void _loadRiveFile() async {
    final bytes = await rootBundle.load('assets/flower_bounce.riv');
    final file = RiveFile();
    if (file.import(bytes)) {
      setState(() => _artboard = file.mainArtboard
        ..addController(SimpleAnimation('idle')));
    }
  }

  void _bounceChange(bool bounceOn) {
    if (_bounceController == null) {
      _artboard.addController(
        _bounceController = SimpleAnimation('bounce'),
      );
    }
    setState(() => _bounceController.isActive = _bounce = bounceOn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _artboard != null
              ? Rive(
                  artboard: _artboard,
                  fit: BoxFit.cover,
                )
              : Container(),
        ),
        SizedBox(
          height: 50,
          width: 200,
          child: SwitchListTile(
            title: const Text('Bounce'),
            value: _bounce,
            onChanged: _bounceChange,
          ),
        ),
      ],
    );
  }
}
