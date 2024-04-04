// ignore_for_file: unnecessary_string_escapes

import 'package:intl/intl.dart';


double stringToDouble(String string){
  double? amount = double.parse(string);

  return amount;
}

String formatCurrency(double amount){
  final format = NumberFormat.currency(locale: "en_PH", symbol: "\₱ ", decimalDigits: 2);
  return format.format(amount);
}