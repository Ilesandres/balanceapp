import 'package:balance_app/models/category.dart';
import 'package:balance_app/models/transaction_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get categories stream for current user
  Stream<List<Category>> getCategoriesStream() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _firestore
        .collection('categories')
        .where('userId', isEqualTo: user.uid)
        .orderBy('name')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Category.fromFirestore(doc)).toList();
    });
  }

  // Get categories by type
  Stream<List<Category>> getCategoriesByType(TransactionType type) {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _firestore
        .collection('categories')
        .where('userId', isEqualTo: user.uid)
        .where('type', isEqualTo: type.toString().split('.').last)
        .orderBy('name')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Category.fromFirestore(doc)).toList();
    });
  }

  // Add new category
  Future<String> addCategory(Category category) async {
    try {
      final docRef = await _firestore.collection('categories').add(
        category.toFirestore(),
      );
      return docRef.id;
    } catch (e) {
      throw Exception('Error al agregar categoría: $e');
    }
  }

  // Update category
  Future<void> updateCategory(Category category) async {
    try {
      await _firestore.collection('categories').doc(category.id).update(
        category.toFirestore(),
      );
    } catch (e) {
      throw Exception('Error al actualizar categoría: $e');
    }
  }

  // Delete category
  Future<void> deleteCategory(String categoryId) async {
    try {
      await _firestore.collection('categories').doc(categoryId).delete();
    } catch (e) {
      throw Exception('Error al eliminar categoría: $e');
    }
  }

  // Create default categories for new user
  Future<void> createDefaultCategories(String userId) async {
    final defaultCategories = [
      // Income categories
      Category(
        id: '',
        userId: userId,
        name: 'Salario',
        icon: 'work',
        color: '#4CAF50',
        type: TransactionType.income,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Category(
        id: '',
        userId: userId,
        name: 'Freelance',
        icon: 'computer',
        color: '#2196F3',
        type: TransactionType.income,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Category(
        id: '',
        userId: userId,
        name: 'Inversiones',
        icon: 'trending_up',
        color: '#FF9800',
        type: TransactionType.income,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      // Expense categories
      Category(
        id: '',
        userId: userId,
        name: 'Alimentación',
        icon: 'restaurant',
        color: '#F44336',
        type: TransactionType.expense,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Category(
        id: '',
        userId: userId,
        name: 'Transporte',
        icon: 'directions_car',
        color: '#9C27B0',
        type: TransactionType.expense,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Category(
        id: '',
        userId: userId,
        name: 'Entretenimiento',
        icon: 'movie',
        color: '#E91E63',
        type: TransactionType.expense,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Category(
        id: '',
        userId: userId,
        name: 'Salud',
        icon: 'local_hospital',
        color: '#00BCD4',
        type: TransactionType.expense,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Category(
        id: '',
        userId: userId,
        name: 'Educación',
        icon: 'school',
        color: '#795548',
        type: TransactionType.expense,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Category(
        id: '',
        userId: userId,
        name: 'Otros',
        icon: 'more_horiz',
        color: '#607D8B',
        type: TransactionType.expense,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    try {
      final batch = _firestore.batch();
      for (var category in defaultCategories) {
        final docRef = _firestore.collection('categories').doc();
        batch.set(docRef, category.toFirestore());
      }
      await batch.commit();
    } catch (e) {
      throw Exception('Error al crear categorías por defecto: $e');
    }
  }
}
