import 'package:flutter/material.dart';

class SkillChip extends StatelessWidget {
  final String label;
  final Color color;

  const SkillChip({
    super.key,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final r = (color.r * 255).round();
    final g = (color.g * 255).round();
    final b = (color.b * 255).round();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Color.fromRGBO(r, g, b, 0.1),
        borderRadius: const BorderRadius.all(Radius.circular(25)),
        border: Border.all(
          color: Color.fromRGBO(r, g, b, 0.3),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }
}