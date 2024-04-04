import 'package:budgetme/database/expenses_db.dart';
import 'package:budgetme/view/expenses_page.dart';
import 'package:budgetme/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await BudgetExpenseDB.initialize();
  runApp(
    ChangeNotifierProvider(
      create: (context) => BudgetExpenseDB(), 
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: false,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
