import 'package:cloud_firestore/cloud_firestore.dart';
import 'transaction_type.dart';

class Transaction {
  final String id;
  final String userId;
  final String title;
  final String description;
  final double amount;
  final String categoryId;
  final String categoryName;
  final TransactionType type;
  final DateTime date;
  final DateTime createdAt;
  final DateTime updatedAt;

  Transaction({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.amount,
    required this.categoryId,
    required this.categoryName,
    required this.type,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Transaction.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return Transaction(
      id: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      amount: (data['amount'] ?? 0.0).toDouble(),
      categoryId: data['categoryId'] ?? '',
      categoryName: data['categoryName'] ?? '',
      type: TransactionType.values.firstWhere(
        (e) => e.toString() == 'TransactionType.${data['type']}',
        orElse: () => TransactionType.expense,
      ),
      date: (data['date'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'amount': amount,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'type': type.toString().split('.').last,
      'date': Timestamp.fromDate(date),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  Transaction copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    double? amount,
    String? categoryId,
    String? categoryName,
    TransactionType? type,
    DateTime? date,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      type: type ?? this.type,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
