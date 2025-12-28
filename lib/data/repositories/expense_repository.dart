import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/expense_model.dart';

class ExpenseRepository {
  final _client = Supabase.instance.client;

  Future<List<Expense>> getExpenses() async {
    try {
      final response = await _client
          .from('expenses')
          .select()
          .order('expense_date', ascending: false);

      return (response as List).map((e) => Expense.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Error fetching expenses: $e');
    }
  }

  Future<void> addExpense({
    required String title,
    required double amount,
    required String category,
    required DateTime date,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    await _client.from('expenses').insert({
      'user_id': user.id,
      'title': title,
      'amount': amount,
      'category': category,
      'expense_date': date.toIso8601String(),
    });
  }

  Future<void> deleteExpense(String id) async {
    await _client.from('expenses').delete().eq('id', id);
  }

  Future<void> updateExpense(Expense expense) async {
    await _client.from('expenses').update({
      'title': expense.title,
      'amount': expense.amount,
      'category': expense.category,
      'expense_date': expense.expenseDate.toIso8601String(),
    }).eq('id', expense.id);
  }
}
