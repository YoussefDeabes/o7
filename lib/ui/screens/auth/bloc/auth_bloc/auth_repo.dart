import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:o7therapy/api/auth_api_manager.dart';
import 'package:o7therapy/api/errors/network_exceptions.dart';
import 'package:o7therapy/api/models/auth/check_verified_email/check_verified_email.dart';
import 'package:o7therapy/api/models/auth/login/LoginWrapper.dart';
import 'package:o7therapy/api/models/auth/login/login_send_model.dart';
import 'package:o7therapy/api/models/auth/my_profile/my_profile_wrapper.dart';
import 'package:o7therapy/api/models/auth/send_verification_email/send_verification_email_wrapper.dart';
import 'package:o7therapy/api/models/auth/sign_up_models/sign_up_models.dart';
import 'package:o7therapy/api/models/auth/verify_client_email/verify_client_email_wrapper.dart';
import 'package:o7therapy/ui/screens/auth/bloc/auth_bloc/auth_bloc.dart';
import '../../../../../api/profile_api_manager.dart';

abstract class BaseAuthenticationRepo {
  Future<AuthState> loginApi(LoginSendModel loginSendModel);

  Future<AuthState> googleLogin();

  Future<AuthState> signupApi(SignUpSendModel signUpSendModel);

  Future<AuthState> verifyClientEmailApi({
    required String userId,
    required String code,
  });

  Future<AuthState> resendVerificationCodeEmail({
    required String userId,
  });

  Future<AuthState> checkIsEmailVerified({
    required String userId,
  });
  Future<AuthState> checkIsEmailVerifiedAfterSignup({
    required String userId,
  });

  Future<AuthState> getMyProfile();
}

class AuthenticationRepo extends BaseAuthenticationRepo {
  @override
  Future<AuthState> loginApi(LoginSendModel loginSendModel) async {
    AuthState? authState;
    NetworkExceptions? detailsModel;
    try {
      await AuthApiManager.loginApi(
        loginSendModel,
        (LoginWrapper loginWrapper) {
          authState = SuccessLogin(loginWrapper);
        },
        (NetworkExceptions details) {
          detailsModel = details;
          authState = NetworkError(details.errorMsg!);
        },
      );
    } catch (error) {
      authState = ErrorState(detailsModel?.errorMsg ?? "Unknown error");
    }
    return authState!;
  }

  @override
  Future<AuthState> googleLogin() async {
    AuthState? authState;
    final googleSignIn = GoogleSignIn();
    GoogleSignInAccount? _user;
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      return const ErrorState('Empty user');
    }
    _user = googleUser;
    final googleAuth = await _user.authentication;
    print("Access Token: " +
        googleAuth.accessToken! +
        "ID Token: " +
        googleAuth.idToken!);
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      authState = const SuccessGoogleLogin();
    } on FirebaseAuthException catch (error) {
      authState = ErrorState(error.code);
    }
    return authState;
  }

  @override
  Future<AuthState> signupApi(SignUpSendModel signUpSendModel) async {
    AuthState? authState;
    NetworkExceptions? detailsModel;
    try {
      await AuthApiManager.signUpApi(
        signUpSendModel,
        (SignUpWrapper signUpWrapper) {
          /// the user signed up successfully
          authState = SuccessSignUP(signUpWrapper);
        },
        (NetworkExceptions details) {
          detailsModel = details;
          authState = NetworkError(details.errorMsg!);
        },
      );
    } catch (error) {
      authState = ErrorState(detailsModel?.errorMsg ?? "Unknown error");
    }
    return authState!;
  }

  @override
  Future<AuthState> verifyClientEmailApi({
    required String userId,
    required String code,
  }) async {
    AuthState? authState;
    NetworkExceptions? detailsModel;
    try {
      await AuthApiManager.verifyClientEmailApi(
        code: code,
        userId: userId,
        success: (VerifyClientEmailWrapper verifyClientEmailWrapper) {
          authState =  SuccessVerifiedAuthState(verifyClientEmailWrapper.data?.corporateName,verifyClientEmailWrapper.data?.isCorporate);
        },
        fail: (NetworkExceptions details) {
          detailsModel = details;
          authState = NetworkError(details.errorMsg!);
        },
      );
    } catch (error) {
      authState = ErrorState(detailsModel?.errorMsg ?? "Unknown error");
    }
    return authState!;
  }

  @override
  Future<AuthState> getMyProfile() async {
    AuthState? authState;
    NetworkExceptions? detailsModel;
    try {
      await ProfileApiManager.getMyProfileApi(
        success: (MyProfileWrapper myProfileWrapper) {
          // the profile of the user contains all data about him successfully
          authState = ClientProfile(profileInfo: myProfileWrapper.data!);
        },
        fail: (NetworkExceptions details) {
          detailsModel = details;
          authState = NetworkError(details.errorMsg!);
        },
      );
    } catch (error) {
      authState = ErrorState(detailsModel?.errorMsg ?? "Unknown error");
    }
    return authState!;
  }

  @override
  Future<AuthState> resendVerificationCodeEmail({
    required String userId,
  }) async {
    AuthState? authState;
    NetworkExceptions? detailsModel;
    try {
      await AuthApiManager.resendVerificationCodeEmailApi(
        userId: userId,
        success: (SendVerificationEmailWrapper resendVerificationWrapper) {
          authState = const SuccessCodeResentAuthState();
        },
        fail: (NetworkExceptions details) {
          detailsModel = details;
          authState = NetworkError(details.errorMsg!);
        },
      );
    } catch (error) {
      authState = ErrorState(detailsModel?.errorMsg ?? "Unknown error");
    }
    return authState!;
  }

  @override
  Future<AuthState> checkIsEmailVerified({required String userId}) async {
    AuthState? authState;
    NetworkExceptions? detailsModel;
    try {
      await AuthApiManager.checkVerifiedEmailApi(
        userId: userId,
        success: (CheckVerifiedEmailWrapper verifiedWrapper) {
          authState = VerifiedEmailAuthState(
            date: verifiedWrapper.data,
            userId: userId,
            isVerified: verifiedWrapper.data?.isVerified ?? false,
          );
        },
        fail: (NetworkExceptions details) {
          detailsModel = details;
          authState = NetworkError(details.errorMsg!);
        },
      );
    } catch (error) {
      authState = ErrorState(detailsModel?.errorMsg ?? "Unknown error");
    }
    return authState!;
  }
  @override
  Future<AuthState> checkIsEmailVerifiedAfterSignup({required String userId}) async {
    AuthState? authState;
    NetworkExceptions? detailsModel;
    try {
      await AuthApiManager.checkVerifiedEmailApi(
        userId: userId,
        success: (CheckVerifiedEmailWrapper verifiedWrapper) {
          authState = VerifiedEmailAfterSignupScreenAuthState(
            date: verifiedWrapper.data,
            userId: userId,
            isVerified: verifiedWrapper.data?.isVerified ?? false,
          );
        },
        fail: (NetworkExceptions details) {
          detailsModel = details;
          authState = NetworkError(details.errorMsg!);
        },
      );
    } catch (error) {
      authState = ErrorState(detailsModel?.errorMsg ?? "Unknown error");
    }
    return authState!;
  }

}
