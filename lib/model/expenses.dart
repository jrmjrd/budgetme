import 'package:isar/isar.dart';

part 'expenses.g.dart';

@Collection()
class Expenses{
  Id id = Isar.autoIncrement; 
  final String name;
  final double amount;
  final DateTime date;
  String? type;

  Expenses({
    required this.name,
    required this.amount,
    required this.date,
    this.type
  });
}