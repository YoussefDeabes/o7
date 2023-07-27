part of 'auth_secure_storage_cubit.dart';

abstract class AuthSecureStorageState extends Equatable {
  const AuthSecureStorageState();

  @override
  List<Object> get props => [];
}

class InitialAuthSecureStorage extends AuthSecureStorageState {
  const InitialAuthSecureStorage();
}

class DataAuthSecureStorage extends AuthSecureStorageState {
  final String email;
  final String password;
  const DataAuthSecureStorage({required this.email, required this.password});
}
