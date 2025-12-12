import 'package:flutter/material.dart';

class ChipFilter extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const ChipFilter({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        selectedColor: color.withOpacity(0.12),
        labelStyle: TextStyle(
          color: selected ? color : Colors.black87,
        ),
        onSelected: (_) => onTap?.call(),
      ),
    );
  }
}