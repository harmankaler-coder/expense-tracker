import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/repositories/expense_repository.dart';
import '../../../data/models/expense_model.dart';

part 'expense_provider.g.dart';

@riverpod
class ExpenseList extends _$ExpenseList {
  final _repository = ExpenseRepository();

  @override
  Future<List<Expense>> build() async {
    return _repository.getExpenses();
  }

  Future<void> addExpense({
    required String title,
    required double amount,
    required String category,
    required DateTime date,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      await _repository.addExpense(
        title: title,
        amount: amount,
        category: category,
        date: date,
      );
      return _repository.getExpenses();
    });
  }

  Future<void> deleteExpense(String id) async {
    final previousState = state.value;
    if (previousState != null) {
      state = AsyncValue.data(
        previousState.where((e) => e.id != id).toList(),
      );
    }

    try {
      await _repository.deleteExpense(id);
    } catch (e) {
      if (previousState != null) state = AsyncValue.data(previousState);
      throw Exception("Failed to delete");
    }
  }
  Future<void> updateExpense(Expense expense) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.updateExpense(expense);
      return _repository.getExpenses();
    });
  }
}
