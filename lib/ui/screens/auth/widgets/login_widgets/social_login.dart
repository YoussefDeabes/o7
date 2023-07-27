import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/util/lang/app_localization.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

/// Social and apple Id login row
class SocialLogin extends StatelessWidget {
  const SocialLogin({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return defaultTargetPlatform == TargetPlatform.iOS
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AppleIdButton(),
              SizedBox(width: size.width / 4),
              const GoogleLoginButton(),
            ],
          )
        : const GoogleLoginButton();
  }
}

/// Apple ID button
class AppleIdButton extends StatelessWidget {
  const AppleIdButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FloatingActionButton(
          heroTag: 'appleId',
          onPressed: () async {
            // final credential = await SignInWithApple.getAppleIDCredential(
            //   scopes: [
            //     AppleIDAuthorizationScopes.email,
            //     AppleIDAuthorizationScopes.fullName,
            //   ],
            //   // webAuthenticationOptions: WebAuthenticationOptions(
            //   //   // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
            //   //   clientId: 'de.lunaone.flutter.signinwithappleexample.service',
            //
            //   // redirectUri:
            //   //     // For web your redirect URI needs to be the host of the "current page",
            //   //     // while for Android you will be using the API server that redirects back into your app via a deep link
            //   //     kIsWeb
            //   //         ? Uri.parse('https://${window.location.host}/')
            //   //         : Uri.parse(
            //   //             'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple',
            //   //           ),
            //   // ),
            //   // TODO: Remove these if you have no need for them
            //   nonce: 'example-nonce',
            //   state: 'example-state',
            // );
            //
            // // ignore: avoid_print
            // print(credential);
            //
            // // This is the endpoint that will convert an authorization code obtained
            // // via Sign in with Apple into a session in your system
            // final signInWithAppleEndpoint = Uri(
            //   scheme: 'https',
            //   host: 'flutter-sign-in-with-apple-example.glitch.me',
            //   path: '/sign_in_with_apple',
            //   queryParameters: <String, String>{
            //     'code': credential.authorizationCode,
            //     if (credential.givenName != null)
            //       'firstName': credential.givenName!,
            //     if (credential.familyName != null)
            //       'lastName': credential.familyName!,
            //     'useBundleId': !kIsWeb && (Platform.isIOS || Platform.isMacOS)
            //         ? 'true'
            //         : 'false',
            //     if (credential.state != null) 'state': credential.state!,
            //   },
            // );
            //
            // final session = await BaseApi.dio.post(
            //   'https://flutter-sign-in-with-apple-example.glitch.me/sign_in_with_apple',
            //   data: {
            //     'firstName': credential.givenName,
            //     'lastName': credential.familyName,
            //     'useBundleId': true,
            //     'state': credential.state
            //   },
            // );
            //
            // // If we got this far, a session based on the Apple ID credential has been created in your system,
            // // and you can now set this as the app's session
            // // ignore: avoid_print
            // print(session);
          },
          elevation: 5,
          backgroundColor: Colors.white,
          child: const Icon(
            Icons.apple,
            color: Colors.black,
            size: 40,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Text(
            AppLocalizations.of(context).translate(LangKeys.appleId),
            style: const TextStyle(fontSize: 14, color: ConstColors.text),
          ),
        ),
      ],
    );
  }
}

/// Google login button
class GoogleLoginButton extends StatelessWidget {
  const GoogleLoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FloatingActionButton(
          heroTag: 'googleLogin',
          onPressed: _googleLoginClicked,
          elevation: 5,
          backgroundColor: Colors.white,
          child: Image.asset(AssPath.googleIcon),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Text(
            AppLocalizations.of(context).translate(LangKeys.google),
            style: const TextStyle(fontSize: 14, color: ConstColors.text),
          ),
        ),
      ],
    );
  }

  void _googleLoginClicked() {}
}
