// ignore_for_file: unrelated_type_equality_checks, use_build_context_synchronously
import 'package:budgetme/controller/to_pdf.dart';
import 'package:budgetme/converter_functions/functions.dart';
import 'package:budgetme/database/expenses_db.dart';
import 'package:budgetme/model/expenses.dart';
import 'package:budgetme/model/expenses_type.dart';
import 'package:budgetme/view/component/budget_card.dart';
import 'package:budgetme/view/component/expenses_display.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ExpensesPage extends StatefulWidget {
  final ExpensesType expensesType;

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
  TextEditingController dateController = TextEditingController();
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
            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                hintText: "Date (mm/dd/yyyy)"
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

  @override 
  void initState() {
    Provider.of<BudgetExpenseDB>(context, listen: false).readSpecificExpenses(widget.expensesType.type);
    
    //load futures
    refreshExpensesData();
    updateExpensesTypeData();
    super.initState();
  }  
  

  //refresh the data for updated
  void refreshExpensesData(){
    _totalExpenses = Provider.of<BudgetExpenseDB>(context, listen: false).totalSpecificExpenses(widget.expensesType.type);
    updateExpensesTypeData();
  }
  void updateExpensesTypeData() async{
    double amount = 0;
    await Provider.of<BudgetExpenseDB>(context, listen: false).totalSpecificExpenses(widget.expensesType.type).then((value) => amount = value);

    ExpensesType updateExpensesType = ExpensesType(
      type: widget.expensesType.type,
      amount: amount
    );

    int id = widget.expensesType.id;

    Provider.of<BudgetExpenseDB>(context, listen: false).updateExpType(id, updateExpensesType) ;
  
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
              elevation: 0,
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: const Text("Expenses List"),
            ),
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                SafeArea(
                  child: SizedBox(
                    height: 300, 
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          child: 
                          saveToPdf(
                            'Vacation',
                            value.specExpenses
                          )
                          // delete(widget.expensesType.type)
                        ),
                        const Positioned(
                          right: 5,
                          child: Column(
                            children: [
                              SizedBox(height: 15,),
                              Text(
                                "Expenses Type:", 
                                style: TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                )
                              ),
                              Text(
                                "Credit/Debit/Cash",
                                style: TextStyle(
                                  color: Colors.white, 
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                )
                              ),
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

                                return BudgetCard(
                                  expensesType: widget.expensesType,
                                  amount: formatCurrency(totalExpenditures),
                                );
                              }else {
                                return const Text("Loading..");
                              }
                            }
                          ),
                        ),
                      
                        Positioned(
                          left: 5,
                          bottom: 0,
                          child: TextButton(
                            onPressed: newExpense,
                            child: const Text(
                              "+ Add Expenses",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white
                              ),
                            ),
                          ),
                        ),
                        
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
                      var toSort = value.specExpenses..sort((a, b) => a.amount.compareTo(b.amount));
                      Expenses expenses = toSort[index];
                      
                      return ListTile(
                        title: Text(expenses.name),
                        subtitle: Text("Date: ${dateFormat(expenses.date)}"),
                        trailing: Text(formatCurrency(expenses.amount)),
                        
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
            date: dateController.text.isEmpty ? DateTime.now() : DateFormat('MM/dd/yyyy').parse(dateController.text),
            type: widget.expensesType.type
          );

          //add to database
          await context.read<BudgetExpenseDB>().createNewExpenses(newExpenses);

          refreshExpensesData();

          //Clear text fields
          expensesNameController.clear();
          expensesAmountController.clear();
          dateController.clear();
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
      child: const Text(
        "Delete Expenses", 
        style: TextStyle(
          color: Colors.white,
          fontSize: 16
        ),
      )
    );
  }

  saveToPdf(String tableName, List<Expenses> expensesList){
    return TextButton(
      onPressed: (){
        ToPdf(tableName: tableName, expenseList: expensesList).saveToPdf();
        print(expensesList.map((e) => e.id));
      }, 
      child: const Text(
        "save to pdf",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16
        ),
      )
    );
  }
}