import 'package:isar/isar.dart';

part 'expenses_type.g.dart';

@Collection()
class ExpensesType{
  Id id = Isar.autoIncrement;
  final String type;
  double? amount;

  ExpensesType({
    required this.type,
    this.amount
  });
}