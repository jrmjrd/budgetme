import 'package:budgetme/converter_functions/functions.dart';
import 'package:budgetme/database/expenses_db.dart';
import 'package:budgetme/model/expenses_type.dart';
import 'package:budgetme/view/component/budget_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController expensesType = TextEditingController();

  void addType(){
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text("Expenses Type"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: expensesType,
            ),
          ],
        ),
        actions: [
          _cancelButton(),
          _saveButton(),
        ],
      ),
    );
  }
  

  
  @override
  void initState() {
    Provider.of<BudgetExpenseDB>(context, listen: false).readExpensesType();

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return  Consumer<BudgetExpenseDB>(
      builder: (context, value, child) => Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Image.asset("assets/3713899254_95684a8dff_o.jpg", fit: BoxFit.fill,),
          ),
          Scaffold(
            appBar: AppBar(
              elevation: .3,
              backgroundColor: const Color(0xffe2e2e2),
              centerTitle: true,
              title: const Text(
                "Budget List",
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xff25494c),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            backgroundColor: const Color(0xffe2e2e2).withOpacity(.8),
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: addType, 
                        child: const Text(
                          "Add new expenses",
                          style: TextStyle(
                            fontSize: 14  ,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff25494c)
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: (){
                          Provider.of<BudgetExpenseDB>(context, listen: false).deleteExpensesTypeList();
                        }, 
                        child: const Text(
                          "Clear All Data",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff25494c)
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    flex: 1,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: value.expensesType.length,
                      itemBuilder: (context, index) {
                        ExpensesType type = value.expensesType[index];
                    
                        return Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                            bottom: 5
                          ),
                          child: BudgetCard(
                            expensesType: type,
                            amount: formatCurrency(type.amount!),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            )
          ),
        ],
      ),
    );
  }

  Widget _saveButton(){
    return MaterialButton(
      onPressed: ()async{
        if(expensesType.text.isNotEmpty){
          Navigator.pop(context);

          ExpensesType newExpensesType = ExpensesType(type: expensesType.text, amount: 0);
          await context.read<BudgetExpenseDB>().createNewExpensesType(newExpensesType);

          expensesType.clear();
        }
      },
      child: const Text("Add"),
    );
  }
  Widget _cancelButton(){
    return MaterialButton(
      onPressed: () {
        Navigator.pop(context);

        expensesType.clear();
      },
      child: const Text("Cancel"),
    );
  }
}