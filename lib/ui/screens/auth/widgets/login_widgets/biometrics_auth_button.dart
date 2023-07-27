import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_auth/local_auth.dart';

import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/ui/screens/auth/bloc/biometrics_cubit/biometrics_cubit.dart';
import 'package:o7therapy/util/lang/app_localization.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class BiometricsAuthButton extends StatelessWidget {
  final void Function() onLoginBioPressed;
  final Function() onLoginPressed;
  const BiometricsAuthButton({
    super.key,
    required this.onLoginPressed,
    required this.onLoginBioPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BiometricsCubit, BiometricsState>(
      builder: (context, state) {
        SupportState supportState = state.supportState;
        bool canCheckBiometrics = state.canCheckBiometrics;

        if (supportState == SupportState.supported &&
            canCheckBiometrics == true) {
          // _getAvailableBiometrics();
          List<BiometricType>? availableBiometrics = state.availableBiometrics;
          if (availableBiometrics != null && availableBiometrics.isNotEmpty) {
            /// android with finger print
            if (Platform.isAndroid &&
                availableBiometrics.contains(BiometricType.weak)) {
              return IconButtonAuthWithBiometrics(
                onLoginBioPressed: onLoginBioPressed,
                onLoginPressed: onLoginPressed,
                icon: SvgPicture.asset(AssPath.fingerPrint),
              );

              /// android with face id
            } else if (Platform.isAndroid &&
                availableBiometrics.contains(BiometricType.strong)) {
              return IconButtonAuthWithBiometrics(
                onLoginBioPressed: onLoginBioPressed,
                onLoginPressed: onLoginPressed,
                icon: SvgPicture.asset(AssPath.faceId),
              );
            }

            /// IOS with face
            if (Platform.isIOS &&
                availableBiometrics.contains(BiometricType.face)) {
              return IconButtonAuthWithBiometrics(
                onLoginBioPressed: onLoginBioPressed,
                onLoginPressed: onLoginPressed,
                icon: SvgPicture.asset(AssPath.faceId),
              );

              /// IOS With Finger Print
            } else if (Platform.isIOS &&
                availableBiometrics.contains(BiometricType.fingerprint)) {
              return IconButtonAuthWithBiometrics(
                onLoginBioPressed: onLoginBioPressed,
                onLoginPressed: onLoginPressed,
                icon: SvgPicture.asset(AssPath.fingerPrint),
              );
            }
          }
        }

        /// not supported
        return const SizedBox.shrink();
      },
    );
  }
}

class IconButtonAuthWithBiometrics extends StatelessWidget {
  final Widget icon;
  final void Function() onLoginBioPressed;
  final Function() onLoginPressed;
  const IconButtonAuthWithBiometrics({
    Key? key,
    required this.icon,
    required this.onLoginBioPressed,
    required this.onLoginPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _onAuthenticateWithBiometrics(context),
      icon: icon,
      iconSize: 40,
    );
  }

  Future<void> _onAuthenticateWithBiometrics(BuildContext context) async {
    BiometricsCubit biometricsCubit = BiometricsCubit.bloc(context);
    await biometricsCubit.checkIsFirstLogin().then(
      (isFirstLogin) async {
        bool authenticated;
        if (isFirstLogin == false) {
          try {
            authenticated = await biometricsCubit.auth.authenticate(
              localizedReason: AppLocalizations.of(context)
                  .translate(LangKeys.scanYourFingerprintOrFaceID),
              options: const AuthenticationOptions(
                useErrorDialogs: true,
                stickyAuth: true,
                biometricOnly: true,
              ),
            );
            if (authenticated) {
              onLoginBioPressed();
            }

            biometricsCubit.setIsAuthenticatingToFalse();
            biometricsCubit.updateAuthorized('Authenticating');
          } on PlatformException catch (e) {
            print(e);
            biometricsCubit.setIsAuthenticatingToFalse();
            biometricsCubit.updateAuthorized('Error - ${e.message}');
            return;
          }

          final String message =
              authenticated ? 'Authorized' : 'Not Authorized';
          biometricsCubit.updateAuthorized(message);
        } else {
          _showNotAuthenticatedDialog(context);
        }
      },
    );
  }

  _showNotAuthenticatedDialog(BuildContext context) {
    String Function(String) translate = AppLocalizations.of(context).translate;
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              translate(LangKeys.unableToLogin),
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
            Text(
              translate(LangKeys.pleaseLoginAtLeastOnce),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
        children: [
          SimpleDialogOption(
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(translate(LangKeys.ok)),
            ),
            onPressed: () {
              BiometricsCubit.bloc(context).cancelAuthentication();
            },
          )
        ],
      ),
    );
  }
}
