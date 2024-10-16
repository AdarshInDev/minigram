/* 
Auth Cubit: StateManagement
*/

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minigram/features/auth/domain/repository/auth_repo.dart';
import 'package:minigram/features/auth/presentation/cubits/auth_states.dart';

import '../../domain/entities/app_user.dart';

class AuthCubit extends Cubit<AuthState> {
   
  final AuthRepo authRepo;
  AppUser? _currentUser;
  AuthCubit({required this.authRepo}) : super(AuthInitial());

  //check if the user is alreasy authenticated
  void checkAuth() async {
    final AppUser? user = await authRepo.getCurrentUser();
    if (user != null) {
      _currentUser = user;
      emit(Authenticated(user));
    } else {
      emit(UnAuthenticated());
    }
  }

  //get current user
  AppUser? get currentUser => _currentUser;

  //login with email + pw
  Future<void> login(String email, String pw) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.loginWithEmailPassword(email, pw);
      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(UnAuthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(UnAuthenticated());
    }
  }

  //register with email +pw
  Future<void> register(String name, String email, String pw) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.registerWithEmailPassword(name, email, pw);
      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(UnAuthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(UnAuthenticated());
    }
  }

  //logout
  Future<void> logout() async {
    authRepo.logout();
    emit(UnAuthenticated());
  }
}
