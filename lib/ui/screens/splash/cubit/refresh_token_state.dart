part of 'refresh_token_cubit.dart';

abstract class RefreshTokenState extends Equatable {
  const RefreshTokenState();

  @override
  List<Object> get props => [];
}

class RefreshTokenInitial extends RefreshTokenState {
  const RefreshTokenInitial();
}

class TrueRefreshToken extends RefreshTokenState {
  const TrueRefreshToken();
}

class FalseRefreshToken extends RefreshTokenState {
  const FalseRefreshToken();
}
