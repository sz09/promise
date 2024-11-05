import 'package:flutter/material.dart';
class WrapCheckbox extends StatelessWidget {
  final String label; 
  final bool isChecked;
  final ValueChanged<bool> onChanged;

  const WrapCheckbox({super.key, required this.label, required this.isChecked, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:() => onChanged,  // Taps on the entire row toggle the checkbox
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Checkbox(
            value: isChecked,
            onChanged: (bool? value) {
              onChanged(value ?? false);
            },
          ),
          Text(label)
        ],
      ),
    );
  }
}