import 'package:flutter/material.dart';

class BudgetDisplay extends StatelessWidget {
  final String? budget;

  const BudgetDisplay({
    super.key,
    this.budget
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.amber,
        child: Text(budget ?? "na"),
      ),
    );
  }
}