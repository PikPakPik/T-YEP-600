import 'package:flutter/material.dart';

class DynamicRangeSlider extends StatelessWidget {
  final String label;
  final RangeValues currentRangeValues;
  final double min, max;
  final ValueChanged<RangeValues> onChanged;
  final ValueChanged<RangeValues>? onChangeEnd;
  final int divisions;
  final String unit;

  const DynamicRangeSlider({
    super.key,
    required this.label,
    required this.currentRangeValues,
    required this.min,
    required this.max,
    required this.onChanged,
    required this.divisions,
    this.onChangeEnd,
    this.unit = 'km',
    required RangeValues initialRangeValues,
  });

  String _formatValue(double value) {
    return value.toStringAsFixed(0);
  }

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
              '${_formatValue(currentRangeValues.start)} - ${_formatValue(currentRangeValues.end)} $unit',
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
            divisions: divisions,
            labels: RangeLabels(
              '${_formatValue(currentRangeValues.start)} $unit',
              '${_formatValue(currentRangeValues.end)} $unit',
            ),
            onChanged: onChanged,
            onChangeEnd: onChangeEnd,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('min: ${_formatValue(min)} $unit', style: kTextStyle),
            Text('max: ${_formatValue(max)} $unit', style: kTextStyle),
          ],
        ),
      ],
    );
  }
}
