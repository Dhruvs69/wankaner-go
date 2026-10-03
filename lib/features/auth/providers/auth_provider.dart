import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/user_model.dart';
import '../repositories/auth_repository.dart';

final authStateProvider = StreamProvider<String?>((ref) async* {
  String? lastId;
  bool isFirst = true;
  while (true) {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('user_id');
    if (isFirst || id != lastId) {
      yield id;
      lastId = id;
      isFirst = false;
    }
    await Future.delayed(const Duration(seconds: 2));
  }
});

final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final userId = ref.watch(authStateProvider).value;
  if (userId == null) return null;
  
  return await ref.watch(authRepositoryProvider).getUserData(userId);
});

final currentUserStreamProvider = StreamProvider<UserModel?>((ref) {
  final userId = ref.watch(authStateProvider).value;
  if (userId == null) return Stream.value(null);
  
  return ref.watch(authRepositoryProvider).getUserDataStream(userId);
});