import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widget/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widget/new_expense.dart';
import 'package:expense_tracker/widget/chart/chart.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _Expenses();
  }
}

class _Expenses extends State<Expenses> {
  final List<Expense> _registeredExpenses = [];

  void _addNewExpense(Expense newExpense) {
    setState(() {
      _registeredExpenses.add(newExpense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 2),
      padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
      content: const Text("Expense Deleted"),
      action: SnackBarAction(
        label: "undo",
        onPressed: () {
          setState(() {
            _registeredExpenses.insert(expenseIndex, expense);
          });
        },
      ),
    ));
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (context) => NewExpense(
              addExpense: _addNewExpense,
            ));
  }

  @override
  Widget build(context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true, to centre the title or false it.
        title: const Text(
          "Expense Tracker",
          style: TextStyle(fontSize: 25),
        ),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: width < height
          ? Column(
              children: [
                Chart(expenses: _registeredExpenses),
                Expanded(
                  child: _registeredExpenses.isNotEmpty
                      ? ExpensesList(
                          expenses: _registeredExpenses,
                          onRemoveExpense: _removeExpense,
                        )
                      : const Center(
                          child: Text("No expenses found. Start adding some!!",
                              style: TextStyle(
                                color: Color.fromARGB(
                                  140,
                                  0,
                                  0,
                                  0,
                                ),
                                fontSize: 18,
                              )),
                        ),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Chart(expenses: _registeredExpenses),
                ),
                Expanded(
                  child: _registeredExpenses.isNotEmpty
                      ? ExpensesList(
                          expenses: _registeredExpenses,
                          onRemoveExpense: _removeExpense,
                        )
                      : const Center(
                          child: Text("No expenses found. Start adding some!!",
                              style: TextStyle(
                                color: Color.fromARGB(
                                  140,
                                  0,
                                  0,
                                  0,
                                ),
                                fontSize: 18,
                              )),
                        ),
                ),
              ],
            ),
    );
  }
}
