part of 'biometrics_cubit.dart';

class BiometricsState extends Equatable {
  final List<BiometricType>? availableBiometrics;
  final bool canCheckBiometrics;
  final bool isAuthenticating;
  final String authorized;
  final SupportState supportState;
  const BiometricsState({
    required this.availableBiometrics,
    required this.canCheckBiometrics,
    required this.isAuthenticating,
    required this.authorized,
    required this.supportState,
  });

  factory BiometricsState.init() => const BiometricsState(
        availableBiometrics: [],
        canCheckBiometrics: false,
        isAuthenticating: false,
        authorized: 'Not Authorized',
        supportState: SupportState.unknown,
      );

  @override
  List<Object?> get props => [
        availableBiometrics,
        canCheckBiometrics,
        isAuthenticating,
        authorized,
        supportState,
      ];

  BiometricsState copyWith({
    List<BiometricType>? availableBiometrics,
    bool? canCheckBiometrics,
    bool? isAuthenticating,
    String? authorized,
    SupportState? supportState,
  }) {
    return BiometricsState(
      availableBiometrics: availableBiometrics ?? this.availableBiometrics,
      canCheckBiometrics: canCheckBiometrics ?? this.canCheckBiometrics,
      isAuthenticating: isAuthenticating ?? this.isAuthenticating,
      authorized: authorized ?? this.authorized,
      supportState: supportState ?? this.supportState,
    );
  }

  @override
  String toString() {
    return 'BiometricsState(availableBiometrics: $availableBiometrics, canCheckBiometrics: $canCheckBiometrics, isAuthenticating: $isAuthenticating, authorized: $authorized, supportState: $supportState)';
  }
}
