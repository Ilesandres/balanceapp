import 'package:balance_app/components/my_button.dart';
import 'package:balance_app/components/my_text_field.dart';
import 'package:balance_app/models/category.dart';
import 'package:balance_app/models/transaction.dart' as transaction_model;
import 'package:balance_app/models/transaction_type.dart';
import 'package:balance_app/services/category_service.dart';
import 'package:balance_app/services/transaction_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTransactionPage extends StatefulWidget {
  final transaction_model.Transaction? transaction;

  const AddTransactionPage({super.key, this.transaction});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _categoryService = CategoryService();
  final _transactionService = TransactionService();

  TransactionType _selectedType = TransactionType.expense;
  Category? _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  List<Category> _categories = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      _loadTransactionData();
    }
    _loadCategories();
  }

  void _loadTransactionData() {
    final transaction = widget.transaction!;
    _titleController.text = transaction.title;
    _descriptionController.text = transaction.description;
    _amountController.text = transaction.amount.toString();
    _selectedType = transaction.type;
    _selectedDate = transaction.date;
  }

  void _loadCategories() {
    _categoryService.getCategoriesByType(_selectedType).listen((categories) {
      setState(() {
        _categories = categories;
        if (widget.transaction != null && _selectedCategory == null) {
          _selectedCategory = categories.firstWhere(
            (cat) => cat.id == widget.transaction!.categoryId,
            orElse: () => categories.first,
          );
        } else if (_selectedCategory == null && categories.isNotEmpty) {
          _selectedCategory = categories.first;
        }
      });
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _saveTransaction() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona una categoría'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final now = DateTime.now();
      final transaction = transaction_model.Transaction(
        id: widget.transaction?.id ?? '',
        userId: user.uid,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        amount: double.parse(_amountController.text),
        categoryId: _selectedCategory!.id,
        categoryName: _selectedCategory!.name,
        type: _selectedType,
        date: _selectedDate,
        createdAt: widget.transaction?.createdAt ?? now,
        updatedAt: now,
      );

      if (widget.transaction != null) {
        await _transactionService.updateTransaction(transaction);
      } else {
        await _transactionService.addTransaction(transaction);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.transaction != null
                  ? 'Transacción actualizada'
                  : 'Transacción agregada',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.transaction != null ? 'Editar Transacción' : 'Nueva Transacción',
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Transaction type selector
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tipo de Transacción',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<TransactionType>(
                              title: const Text('Gasto'),
                              value: TransactionType.expense,
                              groupValue: _selectedType,
                              onChanged: (value) {
                                setState(() {
                                  _selectedType = value!;
                                  _selectedCategory = null;
                                });
                                _loadCategories();
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<TransactionType>(
                              title: const Text('Ingreso'),
                              value: TransactionType.income,
                              groupValue: _selectedType,
                              onChanged: (value) {
                                setState(() {
                                  _selectedType = value!;
                                  _selectedCategory = null;
                                });
                                _loadCategories();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Title field
              MyTextField(
                label: 'Título',
                controller: _titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un título';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Description field
              MyTextField(
                label: 'Descripción (opcional)',
                controller: _descriptionController,
                maxLines: 3,
              ),

              const SizedBox(height: 16),

              // Amount field
              MyTextField(
                label: 'Monto',
                controller: _amountController,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.attach_money),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un monto';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Por favor ingresa un monto válido';
                  }
                  if (double.parse(value) <= 0) {
                    return 'El monto debe ser mayor a 0';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Category selector
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Categoría',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (_categories.isEmpty)
                        const Text('No hay categorías disponibles')
                      else
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _categories.map((category) {
                            final isSelected = _selectedCategory?.id == category.id;
                            return FilterChip(
                              label: Text(category.name),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedCategory = category;
                                });
                              },
                              avatar: Icon(
                                _getCategoryIcon(category.icon),
                                size: 16,
                              ),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Date selector
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Fecha',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: Text(
                          DateFormat('dd/MM/yyyy').format(_selectedDate),
                        ),
                        trailing: const Icon(Icons.arrow_drop_down),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (date != null) {
                            setState(() {
                              _selectedDate = date;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Save button
              MyButton(
                text: widget.transaction != null ? 'Actualizar' : 'Guardar',
                onPressed: _saveTransaction,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String iconName) {
    switch (iconName) {
      case 'work':
        return Icons.work;
      case 'computer':
        return Icons.computer;
      case 'trending_up':
        return Icons.trending_up;
      case 'restaurant':
        return Icons.restaurant;
      case 'directions_car':
        return Icons.directions_car;
      case 'movie':
        return Icons.movie;
      case 'local_hospital':
        return Icons.local_hospital;
      case 'school':
        return Icons.school;
      case 'more_horiz':
        return Icons.more_horiz;
      default:
        return Icons.category;
    }
  }
}
