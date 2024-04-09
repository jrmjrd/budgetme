// ignore_for_file: file_names
import 'package:budgetme/model/budget.dart';
import 'package:budgetme/model/expenses.dart';
import 'package:budgetme/model/expenses_type.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class BudgetExpenseDB extends ChangeNotifier {
  static late Isar expensesDB;
  // static late Isar budgetDB;

  final List<Expenses> _allExpenses = [];
  final List<ExpensesType> _type = [];
  final List<Expenses> _specificExpenses = [];

  static Future<void> initialize() async{
    final dir = await getApplicationDocumentsDirectory();
    expensesDB = await Isar.open([ExpensesSchema, BudgetModelSchema, ExpensesTypeSchema], directory: dir.path); //Creation of Database instance or Table

  }

  List<Expenses> get allExpenses => _allExpenses; //use to retrieve the data for display uses
  List<ExpensesType> get expensesType => _type;
  List<Expenses> get specExpenses => _specificExpenses;

  /* GENERAL CRUD Operation Below */
  //Create
  Future<void> createNewExpensesType(ExpensesType newExpensesType)async{
    await expensesDB.writeTxn(() => expensesDB.expensesTypes.put(newExpensesType));

    await readExpensesType();
  }

  //Read
  Future<void> readExpenses() async{
    List<Expenses> fetchExpenses = await expensesDB.expenses.where().findAll();

    _allExpenses.clear();
    _allExpenses.addAll(fetchExpenses);

    //To update UI
    notifyListeners();
  }
  
  Future<void> readExpensesType() async{
    List<ExpensesType> fetchType = await expensesDB.expensesTypes.where().findAll();

    _type.clear();
    _type.addAll(fetchType);

    notifyListeners();
  }


  //Update
  Future<void> updateExpenses(int id, Expenses updateExpenses) async{
    updateExpenses.id = id;

    //Update the expenses with the same ID
    await expensesDB.writeTxn(() => expensesDB.expenses.put(updateExpenses));

    await readExpenses();
  }


  Future<void> updateExpType(int id, ExpensesType updateExpensesType) async{
    updateExpensesType.id = id;

    await expensesDB.writeTxn(() => expensesDB.expensesTypes.put(updateExpensesType));
    
    await readExpensesType();
  }
  //Delete
  Future<void> deleteExpensesTypeList() async{
    await expensesDB.writeTxn(() => expensesDB.expensesTypes.clear());
    await expensesDB.writeTxn(() => expensesDB.expenses.clear());

    await readExpensesType();
    await readExpenses();
  }
  Future<double> totalAllExpenses() async{
    await readExpenses();

    double expenses = 0;

    for (var expense in _allExpenses){
      expenses = expenses + expense.amount;
    }
    return expenses;
  }


  


  
  /* Expenses Page */
  // Create Expenditures
  Future<void> createNewExpenses(Expenses newExpenses)async{
    //add to DB
    await expensesDB.writeTxn(() => expensesDB.expenses.put(newExpenses));
    
    //re-read the DB
    await readExpenses();
  }

  // Read Expenditures
  Future<void> readSpecificExpenses(String type) async{
    List<Expenses> fetchSpecExpenses = await expensesDB.expenses.where().filter().typeContains(type).findAll();

    _specificExpenses.clear();
    _specificExpenses.addAll(fetchSpecExpenses);

    //To update UI
    notifyListeners();
  }

  //Compute Total Specific Expenditures
  Future<double> totalSpecificExpenses(String type) async{
    await readSpecificExpenses(type);
    
    double totalAmount = 0;
    for (var data in specExpenses){
      totalAmount = totalAmount + data.amount;
    }
    return totalAmount;
  }

  //DELETE
  Future<void> delete(String type) async{
    await expensesDB.writeTxn(() => expensesDB.expenses.where().filter().typeEqualTo(type).deleteAll());

    await readSpecificExpenses(type);
  }
  
}
