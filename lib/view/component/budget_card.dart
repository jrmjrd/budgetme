import 'package:budgetme/model/expenses_type.dart';
// import 'package:budgetme/view/component/expenses_display.dart';
import 'package:budgetme/view/expenses_page.dart';
import 'package:flutter/material.dart';

class BudgetCard extends StatelessWidget {
  final ExpensesType expensesType;
  final String? amount;
  final String? dateTime;

  const BudgetCard({
    super.key,
    required this.expensesType,
    this.amount,
    this.dateTime
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ExpensesPage(expensesType: expensesType)));
      },
      child: Container(
        margin: const EdgeInsets.only(top: 5),
        padding: const EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height * .17,
        width: MediaQuery.of(context).size.width * .8,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: const Color(0xffe2e2e2) ),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: kElevationToShadow[2],
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
            colors: [
              Color(0xff5988ad),
              Color(0xff7ca2be),
              Color(0xff93b2c7),
              Color(0xffa1afba),
              Color(0xffbbbdc1),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Expenses Type:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white70
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Text(
                        expensesType.type,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white
                        ),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        "Total Cost:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white70
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Text(
                        amount ?? "not working", 
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            const Text(
              "not working", 
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white
              ),
            )
          ],
        ),
      ),
    );
  }
}