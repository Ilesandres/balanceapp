import 'package:cloud_firestore/cloud_firestore.dart';
import 'transaction_type.dart';

class Category {
  final String id;
  final String userId;
  final String name;
  final String icon;
  final String color;
  final TransactionType type;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category({
    required this.id,
    required this.userId,
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return Category(
      id: doc.id,
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      icon: data['icon'] ?? 'category',
      color: data['color'] ?? '#4CAF50',
      type: TransactionType.values.firstWhere(
        (e) => e.toString() == 'TransactionType.${data['type']}',
        orElse: () => TransactionType.expense,
      ),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'name': name,
      'icon': icon,
      'color': color,
      'type': type.toString().split('.').last,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  Category copyWith({
    String? id,
    String? userId,
    String? name,
    String? icon,
    String? color,
    TransactionType? type,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Category(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
