import 'package:isar/isar.dart';

part 'budget.g.dart';

@Collection()
class BudgetModel{
  Id id = Isar.autoIncrement;
  final double budgetAmount;
  final DateTime duration;

  BudgetModel({
    required this.budgetAmount,
    required this.duration
  });
}