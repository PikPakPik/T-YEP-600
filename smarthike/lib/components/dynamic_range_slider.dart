import 'package:flutter/material.dart';

class DynamicRangeSlider extends StatelessWidget {
  final String label;
  final RangeValues currentRangeValues;
  final double min, max;
  final ValueChanged<RangeValues> onChanged;
  final ValueChanged<RangeValues>? onChangeEnd;

  const DynamicRangeSlider({
    super.key,
    required this.label,
    required this.currentRangeValues,
    required this.min,
    required this.max,
    required this.onChanged,
    this.onChangeEnd,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle kTextStyle = const TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(label, style: kTextStyle),
            ),
            Text(
              '${currentRangeValues.start.round().toString()} - ${currentRangeValues.end.round().toString()}',
              style: kTextStyle,
            ),
          ],
        ),
        const SizedBox(height: 20),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 1.0,
            activeTrackColor: Colors.black,
            inactiveTrackColor: Colors.black.withOpacity(0.3),
            thumbColor: Colors.black,
            overlayColor: Colors.black.withOpacity(0.2),
            valueIndicatorColor: Colors.black,
          ),
          child: RangeSlider(
            values: currentRangeValues,
            min: min,
            max: max,
            divisions: 100,
            labels: RangeLabels(
              currentRangeValues.start.round().toString(),
              currentRangeValues.end.round().toString(),
            ),
            onChanged: onChanged,
            onChangeEnd: onChangeEnd,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('min: ${min.round()}',
                style: kTextStyle), // Assurez-vous que min est arrondi
            Text('max: ${max.round()}',
                style: kTextStyle), // Assurez-vous que max est arrondi
          ],
        ),
      ],
    );
  }
}
