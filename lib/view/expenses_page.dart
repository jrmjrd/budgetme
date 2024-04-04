// ignore_for_file: unrelated_type_equality_checks

import 'package:budgetme/converter_functions/functions.dart';
import 'package:budgetme/database/expenses_db.dart';
import 'package:budgetme/model/expenses.dart';
import 'package:budgetme/view/component/expenses_display.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpensesPage extends StatefulWidget {
  final String expensesType;

  const ExpensesPage({
    super.key,
    required this.expensesType
  });

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  TextEditingController expensesNameController = TextEditingController();
  TextEditingController expensesAmountController = TextEditingController();
  TextEditingController budgetAmountController = TextEditingController();
  TextEditingController budgetDurationController = TextEditingController();

  //load total expenses data
  Future<double>? _totalExpenses;

  void newExpense(){
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text("New Expenses"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: expensesNameController,
              decoration: const InputDecoration(
                hintText: "Expenses Name"
              ),
            ),
            TextField(
              controller: expensesAmountController,
              decoration: const InputDecoration(
                hintText: "Amount"
              ),
            ),
          ],
        ),
        actions: [
          _cancelButton(),
          _saveButton(),
        ],
      )
    );
  }

  void addBudget(){

  }


  @override 
  void initState() {
    Provider.of<BudgetExpenseDB>(context, listen: false).readSpecificExpenses(widget.expensesType);
    
    //load futures
    refreshExpensesData();

    super.initState();
  }  
  

  //refresh the data for updated
  void refreshExpensesData(){
    _totalExpenses = Provider.of<BudgetExpenseDB>(context, listen: false).totalSpecificExpenses(widget.expensesType);
  }


  
  @override
  Widget build(BuildContext context) {
    return Consumer<BudgetExpenseDB>(
      builder: (context, value, child) {


        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [
                Color(0xff5988ad),
                Color(0xff7ca2be),
                Color(0xff93b2c7),
                Color(0xffa1afba),
                Color(0xffbbbdc1),
              ],
            )
          ),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: newExpense,
              child: const Icon(Icons.add),
            ),
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                SafeArea(
                  child: SizedBox(
                    height: 300, 
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      // alignment: Alignment.center,
                      children: [
                        Positioned(
                          left: 0,
                          child: delete(widget.expensesType)
                        ),
                        Positioned(
                          right: 5,
                          child: Column(
                            children: [
                              const SizedBox(height: 15,),
                              const Text("Expenditure Type:", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                              Text(widget.expensesType, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                            ],
                          )
                        ),
                        Center(
                          child: FutureBuilder(
                            future: _totalExpenses, 
                            builder: (context, snapshot){
                              if(snapshot.connectionState == ConnectionState.done){
                                final totalAmount = snapshot.data ?? 0;
                                double totalExpenditures = totalAmount;

                                return Text(totalExpenditures.toString());
                              }

                              else {
                                return const Text("Loading..");
                              }
                            }
                          ),
                        )
                      ],
                    )
                  )
                ),
                ExpensesDisplay(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const Divider(thickness: 1, height: 0,),
                    shrinkWrap: true,
                    itemCount: value.specExpenses.length,
                    itemBuilder: (context, index) {
                      //Get expenses
                      Expenses expensesList = value.specExpenses[index];
                  
                      return ListTile(
                        title: Text(expensesList.name),
                        subtitle: Text("Type: ${expensesList.type.toString()}"),
                        trailing: Text(formatCurrency(expensesList.amount)),
                        
                      );
                    }
                  ),
                )
                
              ],
            ),
          ),
        );
    
      }
    );
  }


  Widget _cancelButton(){
    return MaterialButton(
      onPressed: (){
        //pop/close the Box(UI)
        Navigator.pop(context);
        //clear text fields
        expensesNameController.clear();
        expensesAmountController.clear();
      },
      child: const Text("Cancel"),
    );
  }

  Widget _saveButton(){
    return MaterialButton(
      onPressed: () async{
        if(expensesNameController.text.isNotEmpty && expensesAmountController.text.isNotEmpty) {
          //pop/close the Box(UI)
          Navigator.pop(context);
          
          //Create the Expense Data
          Expenses newExpenses = Expenses(
            name: expensesNameController.text, 
            amount: stringToDouble(expensesAmountController.text), 
            date: DateTime.now(),
            type: widget.expensesType
          );

          //add to database
          await context.read<BudgetExpenseDB>().createNewExpenses(newExpenses);

          refreshExpensesData();

          //Clear text fields
          expensesNameController.clear();
          expensesAmountController.clear();

          refreshExpensesData();
        }
      },
      child: const Text("Add Expense"),
    );
  }

  delete(String type){
    return TextButton(
      onPressed: () async{
        await context.read<BudgetExpenseDB>().delete(type);
        refreshExpensesData();
      }, 
      child: const Text("Delete all", style: TextStyle(color: Colors.white),)
    );
  }
}