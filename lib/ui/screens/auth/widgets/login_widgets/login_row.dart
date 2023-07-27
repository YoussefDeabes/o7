import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/ui/screens/auth/bloc/biometrics_cubit/biometrics_cubit.dart';
import 'package:o7therapy/util/lang/app_localization.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/ui/screens/auth/widgets/login_widgets/biometrics_auth_button.dart';

/// Login row that includes login button and biometrics
class LoginRow extends StatelessWidget {
  final void Function() onLoginBioPressed;
  final void Function() onLoginPressed;

  const LoginRow({
    super.key,
    required this.onLoginBioPressed,
    required this.onLoginPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BiometricsCubit, BiometricsState>(
      builder: (context, state) {
        final BiometricsCubit biometricsCubit = BiometricsCubit.bloc(context);
        final bool canCheckBiometrics =
            biometricsCubit.state.canCheckBiometrics;
        if (canCheckBiometrics == false) {
          return LoginButtonWithoutBiometrics(
            onLoginPressed: onLoginPressed,
          );
        } else {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LoginButton(
                onLoginPressed: onLoginPressed,
              ),
              BiometricsAuthButton(
                onLoginBioPressed: onLoginBioPressed,
                onLoginPressed: onLoginPressed,
              ),
            ],
          );
        }
      },
    );
  }
}

/// Login button without biometrics
class LoginButtonWithoutBiometrics extends StatelessWidget {
  final void Function()? onLoginPressed;
  const LoginButtonWithoutBiometrics({
    super.key,
    required this.onLoginPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onLoginPressed,
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ))),
        child: Text(
          AppLocalizations.of(context).translate(LangKeys.loginButton),
        ),
      ),
    );
  }
}

/// Login button
class LoginButton extends StatelessWidget {
  final void Function() onLoginPressed;
  const LoginButton({
    super.key,
    required this.onLoginPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width * 0.70,
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: onLoginPressed,
          style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ))),
          child: Text(
            AppLocalizations.of(context).translate(LangKeys.loginButton),
          ),
        ),
      ),
    );
  }
}
