import 'package:flutter/material.dart';

class MoodSlider extends StatefulWidget {
  final double initialValue;
  final ValueChanged<double> onChanged;

  const MoodSlider({
    super.key,
    this.initialValue = 3.0,
    required this.onChanged,
  });

  @override
  State<MoodSlider> createState() => _MoodSliderState();
}

class _MoodSliderState extends State<MoodSlider> {
  late double _currentValue;

  final List<String> _moodLabels = [
    "😔 Sad",
    "😐 Neutral",
    "🙂 Good",
    "😊 Happy",
    "🤩 Excellent"
  ];

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  Color _getMoodColor(double value) {
    if (value <= 1.5) return Colors.redAccent;
    if (value <= 2.5) return Colors.orange;
    if (value <= 3.5) return Colors.yellow.shade700;
    if (value <= 4.5) return Colors.lightGreen;
    return Colors.deepPurple;
  }

  String _getMoodLabel(double value) {
    int index = (value - 1).round().clamp(0, 4);
    return _moodLabels[index];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 🔹 Mood Label
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            _getMoodLabel(_currentValue),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _getMoodColor(_currentValue),
            ),
          ),
        ),

        // 🔹 Slider
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: _getMoodColor(_currentValue),
            inactiveTrackColor: Colors.grey.shade300,
            thumbColor: _getMoodColor(_currentValue),
            overlayColor: _getMoodColor(_currentValue).withOpacity(0.2),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
          ),
          child: Slider(
            min: 1,
            max: 5,
            divisions: 4,
            value: _currentValue,
            label: _getMoodLabel(_currentValue),
            onChanged: (value) {
              setState(() {
                _currentValue = value;
              });
              widget.onChanged(value);
            },
          ),
        ),
      ],
    );
  }
}
