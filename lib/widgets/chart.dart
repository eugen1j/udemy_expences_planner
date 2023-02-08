import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/transaction.dart';
import 'package:flutter_complete_guide/widgets/chart_bar.dart';
import 'package:intl/intl.dart';

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

class Chart extends StatelessWidget {
  final List<Transaction> transactions;

  const Chart(this.transactions);

  double get maxSpending {
    return groupedTransactions.fold(0.01, (acc, tr) => max(acc, tr['amount']));
  }

  List<Map<String, Object>> get groupedTransactions {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));

      final amount = transactions
          .where((t) => t.date.isSameDate(weekDay))
          .fold(0.0, (acc, t) => acc + t.amount);

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': amount,
      };
    }).reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactions
              .map(
                (gt) => Flexible(
                  fit: FlexFit.tight,
                  child: ChartBar(gt['day'], gt['amount'],
                      (gt['amount'] as double) / maxSpending),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
