import 'package:balance_app/models/transaction.dart';
import 'package:balance_app/models/transaction_type.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const TransactionCard({
    super.key,
    required this.transaction,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    final amountColor = isIncome ? Colors.green : Colors.red;
    final amountPrefix = isIncome ? '+' : '-';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: amountColor.withOpacity(0.1),
          child: Icon(
            _getCategoryIcon(transaction.categoryName),
            color: amountColor,
          ),
        ),
        title: Text(
          transaction.title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(transaction.categoryName),
            Text(
              DateFormat('dd/MM/yyyy').format(transaction.date),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$amountPrefix\$${NumberFormat('#,##0.00').format(transaction.amount)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: amountColor,
                fontSize: 16,
              ),
            ),
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete, size: 20),
                onPressed: onDelete,
                color: Colors.red,
              ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'salario':
        return Icons.work;
      case 'freelance':
        return Icons.computer;
      case 'inversiones':
        return Icons.trending_up;
      case 'alimentación':
        return Icons.restaurant;
      case 'transporte':
        return Icons.directions_car;
      case 'entretenimiento':
        return Icons.movie;
      case 'salud':
        return Icons.local_hospital;
      case 'educación':
        return Icons.school;
      default:
        return Icons.category;
    }
  }
}
