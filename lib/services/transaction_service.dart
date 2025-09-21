import 'package:balance_app/models/transaction.dart' as transaction_model;
import 'package:balance_app/models/transaction_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get transactions stream for current user
  Stream<List<transaction_model.Transaction>> getTransactionsStream() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _firestore
        .collection('transactions')
        .where('userId', isEqualTo: user.uid)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => transaction_model.Transaction.fromFirestore(doc)).toList();
    });
  }

  // Get transactions for a specific month
  Stream<List<transaction_model.Transaction>> getTransactionsForMonth(DateTime month) {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

    return _firestore
        .collection('transactions')
        .where('userId', isEqualTo: user.uid)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth))
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => transaction_model.Transaction.fromFirestore(doc)).toList();
    });
  }

  // Add new transaction
  Future<String> addTransaction(transaction_model.Transaction transaction) async {
    try {
      final docRef = await _firestore.collection('transactions').add(
        transaction.toFirestore(),
      );
      return docRef.id;
    } catch (e) {
      throw Exception('Error al agregar transacción: $e');
    }
  }

  // Update transaction
  Future<void> updateTransaction(transaction_model.Transaction transaction) async {
    try {
      await _firestore.collection('transactions').doc(transaction.id).update(
        transaction.toFirestore(),
      );
    } catch (e) {
      throw Exception('Error al actualizar transacción: $e');
    }
  }

  // Delete transaction
  Future<void> deleteTransaction(String transactionId) async {
    try {
      await _firestore.collection('transactions').doc(transactionId).delete();
    } catch (e) {
      throw Exception('Error al eliminar transacción: $e');
    }
  }

  // Get monthly summary
  Future<Map<String, double>> getMonthlySummary(DateTime month) async {
    final user = _auth.currentUser;
    if (user == null) return {'income': 0.0, 'expense': 0.0};

    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

    try {
      final snapshot = await _firestore
          .collection('transactions')
          .where('userId', isEqualTo: user.uid)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth))
          .get();

      double totalIncome = 0.0;
      double totalExpense = 0.0;

      for (var doc in snapshot.docs) {
        final transaction = transaction_model.Transaction.fromFirestore(doc);
        if (transaction.type == TransactionType.income) {
          totalIncome += transaction.amount;
        } else {
          totalExpense += transaction.amount;
        }
      }

      return {
        'income': totalIncome,
        'expense': totalExpense,
        'balance': totalIncome - totalExpense,
      };
    } catch (e) {
      throw Exception('Error al obtener resumen mensual: $e');
    }
  }

  // Get transactions by category
  Future<List<transaction_model.Transaction>> getTransactionsByCategory(
    String categoryId,
    DateTime month,
  ) async {
    final user = _auth.currentUser;
    if (user == null) return [];

    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

    try {
      final snapshot = await _firestore
          .collection('transactions')
          .where('userId', isEqualTo: user.uid)
          .where('categoryId', isEqualTo: categoryId)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth))
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs.map((doc) => transaction_model.Transaction.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Error al obtener transacciones por categoría: $e');
    }
  }
}
