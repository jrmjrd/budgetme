import 'package:flutter/material.dart';

class ExpensesDisplay extends StatelessWidget {
  final Widget? child;

  const ExpensesDisplay({
    super.key,
    this.child
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        // margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration:  BoxDecoration(
          border: const Border(
            top: BorderSide(width: 1, color: Colors.white),
            left: BorderSide(width: 1, color: Colors.white),
            right: BorderSide(width: 1, color: Colors.white)
          ),
          borderRadius:  BorderRadius.only(
            topLeft: radius(),
            topRight: radius()
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade50,
              offset: const Offset(0, 0),
              spreadRadius: 0,
              blurRadius: 0
            )
          ],
          color: Colors.white
        ),
        child: child,
      ),
    );
  }

  radius(){
    return const Radius.circular(30);
  }

}

