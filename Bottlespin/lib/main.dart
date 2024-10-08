import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(SpinBottleApp());
}

class SpinBottleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spin the Bottle',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SpinBottleScreen(),
    );
  }
}

class SpinBottleScreen extends StatefulWidget {
  @override
  _SpinBottleScreenState createState() => _SpinBottleScreenState();
}

class _SpinBottleScreenState extends State<SpinBottleScreen>
    with SingleTickerProviderStateMixin {
  final List<String> _playerNames = [];
  final _playerController = TextEditingController();
  final _dearController = TextEditingController();
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _spinning = false;
  String? _selectedPlayer;

  final List<String> bottleImages = [
    'assets/1.png',
    'assets/2.png',
    'assets/3.png',
  ];
  String selectedBottle = 'assets/1.png';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 0).animate(_controller);
  }

  void _addPlayer() {
    if (_playerController.text.isNotEmpty &&
        !_playerNames.contains(_playerController.text) &&
        _playerNames.length < 10) {
      setState(() {
        _playerNames.add(_playerController.text);
        _playerController.clear();
      });
    }
  }

  void _spinBottle() {
    if (_playerNames.isEmpty) return;

    setState(() {
      _spinning = true;
    });

    int fullRotations = 1;
    double randomOffset = (Random().nextDouble() * 2 * pi);
    double endValue = (fullRotations * 2 * pi) + randomOffset;

    _animation = Tween<double>(begin: _animation.value, end: endValue).animate(_controller);

    _controller.forward(from: 0).then((_) {
      final randomIndex = Random().nextInt(_playerNames.length);
      setState(() {
        _selectedPlayer = _playerNames[randomIndex];
        _spinning = false;
      });

      _showSelectedPlayer();
    });
  }

  void _showSelectedPlayer() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Selected Player'),
        content: Text('Dear ${_dearController.text}, $_selectedPlayer is chosen!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Spin the Bottle & Add Players')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _dearController,
              decoration: InputDecoration(labelText: 'Dear Message'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _playerController,
              decoration: InputDecoration(labelText: 'Player Name'),
            ),
            ElevatedButton(onPressed: _addPlayer, child: Text('Add Player')),
            Expanded(
              child: ListView.builder(
                itemCount: _playerNames.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_playerNames[index]),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: selectedBottle,
              onChanged: (String? newValue) {
                setState(() {
                  selectedBottle = newValue!;
                });
              },
              items: bottleImages.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    children: [
                      Image.asset(value, width: 50, height: 50),
                      SizedBox(width: 10),
                      Text(value.split('/').last),
                    ],
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            RotationTransition(
              turns: _animation,
              child: Image.asset(selectedBottle, height: 200),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: !_spinning && _playerNames.isNotEmpty
                  ? _spinBottle
                  : null,
              child: Text(_spinning ? 'Spinning...' : 'Spin the Bottle'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
