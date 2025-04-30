import 'package:flutter/material.dart';

void main() {
  runApp(const HealthyLifeApp());
}

class HealthyLifeApp extends StatelessWidget {
  const HealthyLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HealthyLife Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const WaterTrackerScreen(),
    );
  }
}

class WaterTrackerScreen extends StatefulWidget {
  const WaterTrackerScreen({super.key});

  @override
  State<WaterTrackerScreen> createState() => _WaterTrackerScreenState();
}

class _WaterTrackerScreenState extends State<WaterTrackerScreen>
    with SingleTickerProviderStateMixin {
  double _progress = 0.0;
  int _currentMessageIndex = 0;
  bool _showReminder = false;

  late final AnimationController _balloonController;
  late final Animation<double> _balloonAnimation;

  final List<String> _messages = [
    "💧 Stay refreshed!",
    "🚀 Keep it up!",
    "🏁 Few more sips!",
    "🎉 Congratulations! You are Hydrated",
  ];

  @override
  void initState() {
    super.initState();

    _balloonController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _balloonAnimation = Tween<double>(begin: 0, end: -240).animate(
      CurvedAnimation(parent: _balloonController, curve: Curves.easeOut),
    );

    _startHydrationReminder();
  }

  void _startHydrationReminder() {
    Future.delayed(const Duration(seconds: 8), () {
      if (_progress < 1.0) {
        setState(() => _showReminder = true);
        Future.delayed(const Duration(seconds: 4), () {
          setState(() => _showReminder = false);
        });
      }
    });
  }

  void _addWater() {
    setState(() {
      _progress += 0.25;
      if (_progress >= 1.0) {
        _progress = 1.0;
        _balloonController.forward();
      } else {
        _currentMessageIndex = (_progress * 4).floor();
      }
    });
  }

  @override
  void dispose() {
    _balloonController.dispose();
    super.dispose();
  }

  Widget _buildProgressBar() {
    return Container(
      height: 28,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(16),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        width: MediaQuery.of(context).size.width * _progress,
        decoration: BoxDecoration(
          color: Colors.teal.shade400,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildMotivationalMessage() {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 600),
      firstChild: Text(
        _messages[_currentMessageIndex],
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 26,
          color: Colors.teal.shade800,
          fontWeight: FontWeight.w700,
        ),
      ),
      secondChild: Text(
        _messages[(_currentMessageIndex + 1) % _messages.length],
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 26,
          color: Colors.deepPurple.shade600,
          fontWeight: FontWeight.w700,
        ),
      ),
      crossFadeState: _progress % 0.5 == 0
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
    );
  }

  Widget _buildHydrationReminder() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 800),
      opacity: _showReminder ? 1.0 : 0.0,
      child: Text(
        " Time for a sip!",
        style: TextStyle(
          fontSize: 18,
          color: Colors.blueGrey.shade600,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildBalloonAnimation() {
    return AnimatedBuilder(
      animation: _balloonAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _balloonAnimation.value),
          child: _progress >= 1.0
              ? Icon(Icons.emoji_food_beverage,
              size: 90, color: Colors.pink.shade300)
              : const SizedBox.shrink(),
        );
      },
    );
  }

  Widget _buildAddButton() {
    return ElevatedButton.icon(
      onPressed: _addWater,
      icon: const Icon(Icons.local_drink, size: 28),
      label: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Text(
          "Add Water",
          style: TextStyle(fontSize: 22),
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal.shade400,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 5,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(" HealthyLife Water Tracker"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          elevation: 6,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildProgressBar(),
                const SizedBox(height: 36),
                _buildMotivationalMessage(),
                const SizedBox(height: 20),
                _buildHydrationReminder(),
                const SizedBox(height: 36),
                _buildAddButton(),
                const SizedBox(height: 50),
                Expanded(child: _buildBalloonAnimation()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
