import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/api/models/auth/check_verified_email/CheckVerifiedEmailData.dart';
import 'package:o7therapy/api/models/auth/login/LoginWrapper.dart';
import 'package:o7therapy/api/models/auth/login/login_send_model.dart';
import 'package:meta/meta.dart';
import 'package:o7therapy/api/models/auth/my_profile/my_profile_wrapper.dart';
import 'package:o7therapy/api/models/auth/my_profile/my_profile_wrapper.dart';
import 'package:o7therapy/api/models/auth/sign_up_models/sign_up_models.dart';
import 'package:o7therapy/prefs/pref_manager.dart';
import 'package:o7therapy/ui/screens/auth/bloc/auth_bloc/auth_repo.dart';
import 'package:o7therapy/ui/screens/auth/bloc/auth_bloc/exceptions/exceptions.dart';
import 'package:o7therapy/util/secure_storage_helper/secure_storage.dart';
import 'package:o7therapy/util/validator.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  static int _comingStepNumber = 1;
  static int _currentStepNumber = 0;
  final SignUpSendModel _signUp;
  final BaseAuthenticationRepo authRepository;

  AuthBloc(
      {required BaseAuthenticationRepo authenticationRepo,
      required SignUpSendModel signUp})
      : authRepository = authenticationRepo,
        _signUp = signUp,
        super(InitialState()) {
    on<ResendVerificationCodeAuthEvent>(_onResendVerificationCodeAuthEvent);
    on<VerifyClientEmailEvent>(_onVerifyClientEmailEvent);
    on<CheckStepEvent>(_onCheckStepEvent);
    on<ChangeStepEvent>(_onChangeStepEvent);
    on<NickNameChangedEvent>(_onNickNameChanged);
    on<GenderChangedEvent>(_onGenderChangedEvent);
    on<BirthDateChangedEvent>(_onBirthDateChangedEvent);
    on<GoalsChangedEvent>(_onGoalsChangedEvent);
    on<LoginApiEvent>(_onLoginApiEvent);
    on<LoginAfterSignupApiEvent>(_onLoginAfterSignupApiEvent);
    on<GoogleLoginApiEvent>(_onGoogleLoginApiEvent);
    on<OpenForgetPasswordEvent>(_onOpenForgetPasswordEvent);
    on<SignupApiEvent>(_onSignupApiEvent);
    on<ValidateEmailEvent>(_onValidateEmailEvent);
    on<ValidatePasswordEvent>(_onValidatePasswordEvent);
    on<_CheckIsAccountVerifiedEvent>(_onCheckIsAccountVerifiedEvent);
    on<_CheckIsAccountVerifiedAfterSignupEvent>(
        _onCheckIsAccountVerifiedAfterSignupEvent);
    on<_GetProfileAuthEvent>(_onGetProfileAuthEvent);
  }

  static AuthBloc bloc(BuildContext context) => context.read<AuthBloc>();

  ///  in the CheckStepEvent
  /// 1. we will check the step number
  /// 2. and before letting the user get to the next page
  /// 3. we will check the current value.
  _onCheckStepEvent(CheckStepEvent event, emit) {
    emit(const LoadingAuthState());
    _comingStepNumber = event.comingStepNumber;
    _currentStepNumber = event.currentStepNumber;
    log("comingStepNumber: $_comingStepNumber");
    log("currentStepNumber: $_currentStepNumber");

    // if the _comingStepNumber < _currentStepNumber then the user need to back
    // and this allowed so he can edit his data :: emit SignupChangeStepState()
    // else if _comingStepNumber > _currentStepNumber then the user cannot move to the next step
    // and if every thing is good :: emit SignupChangeStepState() and let the user move to next step
    // if not good :: emit the exception user cannot move to next step
    if (_comingStepNumber < _currentStepNumber) {
      emit(SigupUpdateStepIndex(
        currentStepIndex: _currentStepNumber,
        newStepIndex: _comingStepNumber,
      ));
    } else if (_currentStepNumber == 0) {
      bool isValidName = _isUserEnteredNameOrNickName();
      log("isValidName $isValidName");
      if (isValidName) {
        emit(SigupUpdateStepIndex(
          currentStepIndex: _currentStepNumber,
          newStepIndex: _comingStepNumber,
        ));
      } else {
        emit(const SignUpStepsExceptionState(
            SignUpCustomExceptions.nameException));
      }
    } else if (_currentStepNumber == 1) {
      bool isValidGender = !_isGenderEqualNull();
      log("isValidGender $isValidGender");
      if (isValidGender) {
        emit(SigupUpdateStepIndex(
          currentStepIndex: _currentStepNumber,
          newStepIndex: _comingStepNumber,
        ));
      } else {
        emit(const SignUpStepsExceptionState(
            SignUpCustomExceptions.noGenderException));
      }
    } else if (_currentStepNumber == 2) {
      SignUpCustomExceptions? birthDateException =
          _getBirthDateException(_signUp.birthDate);
      log("isValid Birth Date ${birthDateException ?? "yes"}");
      // if birthDateException == null then every thing is good and continue
      if (birthDateException == null) {
        emit(SigupUpdateStepIndex(
          currentStepIndex: _currentStepNumber,
          newStepIndex: _comingStepNumber,
        ));
      } else {
        emit(SignUpStepsExceptionState(birthDateException));
      }
    } else if (_currentStepNumber == 3) {
      // if the user choose goals or not
      // he will be able to move to next step
      emit(SigupUpdateStepIndex(
        currentStepIndex: _currentStepNumber,
        newStepIndex: _comingStepNumber,
      ));
    }
  }

  /// here we will change only the _comingStepNumber and _currentStepNumber
  _onChangeStepEvent(ChangeStepEvent event, emit) {
    _currentStepNumber = _comingStepNumber;
    emit(const SignupStepChangedState());
  }

  /// here we listen each time the user change his nickName
  /// and save it in the state
  _onNickNameChanged(NickNameChangedEvent event, emit) {
    String name = event.name;
    log("user entered Name: $name");
    _signUp.name = name;
  }

  /// here we listen each time the user change his Gender
  /// and save it in the state
  _onGenderChangedEvent(GenderChangedEvent event, emit) {
    Gender gender = event.gender;
    log("user gender: $gender");
    _signUp.gender = gender;
  }

  /// here we listen each time the user change his age
  /// and save it in the state
  _onBirthDateChangedEvent(BirthDateChangedEvent event, emit) {
    DateTime? birthDate = event.birthDate;
    log("user BirthDate: $birthDate");
    _signUp.birthDate = birthDate;
  }

  /// when the user select his Goals >> this event will triggered
  _onGoalsChangedEvent(GoalsChangedEvent event, emit) {
    _signUp.goals = event.goals;
    log("user Goals: ${_signUp.goals}");
  }

  ///  Login  button Clicked
  _onLoginApiEvent(LoginApiEvent event, emit) async {
    if (event.loginSendModel.userEmail!.isEmpty) {
      emit(const EmailEmptyError());
    } else if (!Validator.isEmail(event.loginSendModel.userEmail!)) {
      emit(const EmailFormattedError());
    } else if (event.loginSendModel.password!.isEmpty) {
      emit(const PasswordEmptyError());
    } else {
      emit(const LoadingAuthState());
      AuthState state = await authRepository.loginApi(event.loginSendModel);
      // if login is success >> then add token and data to pref
      // then check if the user is Verified Account
      if (state is SuccessLogin) {
        await SecureStorage.setEmail(event.loginSendModel.userEmail);
        await PrefManager.setEmail(event.loginSendModel.userEmail);
        // await PrefManager.setPassword(event.loginSendModel.password);
        await SecureStorage.setUser(
          refreshToken: state.loginWrapper.data?.refreshToken,
          state.loginWrapper.data?.userDisplayName,
          state.loginWrapper.data?.accessToken,
          state.loginWrapper.data?.userId,
        );
        await PrefManager.setUser(
          refreshToken: state.loginWrapper.data?.refreshToken,
          state.loginWrapper.data?.userDisplayName,
          state.loginWrapper.data?.accessToken,
          state.loginWrapper.data?.userId,
        );
        add(_CheckIsAccountVerifiedEvent(
            userId: state.loginWrapper.data!.userId!));
      } else {
        emit(state);
      }
    }
  }

  _onLoginAfterSignupApiEvent(LoginAfterSignupApiEvent event, emit) async {
    if (event.loginSendModel.userEmail!.isEmpty) {
      emit(const EmailEmptyError());
    } else if (!Validator.isEmail(event.loginSendModel.userEmail!)) {
      emit(const EmailFormattedError());
    } else if (event.loginSendModel.password!.isEmpty) {
      emit(const PasswordEmptyError());
    } else {
      emit(const LoadingAuthState());
      AuthState state = await authRepository.loginApi(event.loginSendModel);
      // if login is success >> then add token and data to pref
      // then check if the user is Verified Account
      if (state is SuccessLogin) {
        await SecureStorage.setEmail(event.loginSendModel.userEmail);
        await PrefManager.setEmail(event.loginSendModel.userEmail);
        // await PrefManager.setPassword(event.loginSendModel.password);
        await SecureStorage.setUser(
          refreshToken: state.loginWrapper.data?.refreshToken,
          state.loginWrapper.data?.userDisplayName,
          state.loginWrapper.data?.accessToken,
          state.loginWrapper.data?.userId,
        );
        await PrefManager.setUser(
          refreshToken: state.loginWrapper.data?.refreshToken,
          state.loginWrapper.data?.userDisplayName,
          state.loginWrapper.data?.accessToken,
          state.loginWrapper.data?.userId,
        );
        add(_CheckIsAccountVerifiedAfterSignupEvent(
            userId: state.loginWrapper.data!.userId!));
      } else {
        emit(state);
      }
    }
  }

  ///  Google Login  button Clicked
  _onGoogleLoginApiEvent(GoogleLoginApiEvent event, emit) async {
    emit(await authRepository.googleLogin());
  }

  /// SignUp button clicked
  _onSignupApiEvent(SignupApiEvent event, emit) async {
    if (event.email!.isEmpty) {
      emit(const EmailEmptyError());
    } else if (!Validator.isEmail(event.email!)) {
      emit(const EmailFormattedError());
    } else if (event.password!.isEmpty) {
      emit(const PasswordEmptyError());
    } else if (event.password!.length < 8) {
      emit(const PasswordFormattedError());
    } else if (event.password!.length < 8) {
      // TODO not matched passwords
      emit(const PasswordFormattedError());
    } else {
      emit(const LoadingAuthState());
      _signUp.email = event.email;
      _signUp.password = event.password;
      // _signUp.phoneNumber = event.phoneNumber;
      AuthState singUpApiState = await authRepository.signupApi(_signUp);
      //! after singUp then >>  must login to get accessToken
      if (singUpApiState is SuccessSignUP) {
        add(LoginAfterSignupApiEvent(
          LoginSendModel(
            userEmail: event.email,
            password: event.password,
          ),
        ));
      } else {
        emit(singUpApiState);
      }
    }
  }

  _onOpenForgetPasswordEvent(OpenForgetPasswordEvent event, emit) {
    emit(const OpenForgetPassword());
  }

  /// check the Email
  _onValidateEmailEvent(ValidateEmailEvent event, emit) {}

  /// check the Password
  _onValidatePasswordEvent(ValidatePasswordEvent event, emit) {}

///////////////////////////////////////////////////////
////////////////// helper methods /////////////////////
///////////////////////////////////////////////////////

  /// if the user entered (empty value or null or spaces only ) will return false
  bool _isUserEnteredNameOrNickName() {
    log("name Checked: ${_signUp.name?.trim()}");
    if (_signUp.name == null) return false;
    return !Validator.isEmptyOrNull(_signUp.name?.trim());
  }

  /// check if the gender is null >> if null will return true
  bool _isGenderEqualNull() => _signUp.gender == null ? true : false;

  /// if user not entered his age :: will return noAgeEnteredException
  /// if user < 18 years old :: will return kidException
  /// if no exception will return null
  SignUpCustomExceptions? _getBirthDateException(DateTime? birthDate) {
    if (birthDate == null) {
      return SignUpCustomExceptions.noAgeEnteredException;
    } else if (!_signUp.isOlderThan18Years()) {
      return SignUpCustomExceptions.kidException;
    }
    return null;
  }

  _onVerifyClientEmailEvent(VerifyClientEmailEvent event, emit) async {
    emit(const LoadingAuthState());
    AuthState state = await authRepository.verifyClientEmailApi(
      code: event.code,
      userId: event.userId,
    );
    if (state is SuccessVerifiedAuthState) {
      emit(SuccessVerifiedAuthState(state.companyName, state.isCorporate));
      add(const _GetProfileAuthEvent());
    } else {
      emit(state);
    }
  }

  _onResendVerificationCodeAuthEvent(
    ResendVerificationCodeAuthEvent event,
    emit,
  ) async {
    emit(const LoadingAuthState());
    emit(await authRepository.resendVerificationCodeEmail(
      userId: event.userId,
    ));
  }

  _onCheckIsAccountVerifiedEvent(
    _CheckIsAccountVerifiedEvent event,
    emit,
  ) async {
    emit(const LoadingAuthState());
    AuthState state = await authRepository.checkIsEmailVerified(
      userId: event.userId,
    );
    emit(state);
  }

  _onCheckIsAccountVerifiedAfterSignupEvent(
    _CheckIsAccountVerifiedAfterSignupEvent event,
    emit,
  ) async {
    emit(const LoadingAuthState());
    AuthState state = await authRepository.checkIsEmailVerifiedAfterSignup(
      userId: event.userId,
    );
    emit(state);
  }

  _onGetProfileAuthEvent(
    _GetProfileAuthEvent event,
    emit,
  ) async {
    emit(const LoadingAuthState());
    AuthState state = await authRepository.getMyProfile();
    if (state is ClientProfile) {
      await PrefManager.setLoggedIn();
      await PrefManager.setFirstLogin();
      await SecureStorage.setFirstLogin();
      await SecureStorage.setLoggedIn();
    }
    emit(state);
  }

  /// SignUp model Data Getters
////////////////////////////////////////////////////////////////////
////////////////// SignUp model Data Getters ///////////////////////
////////////////////////////////////////////////////////////////////

  // getting the user name
  String? get getUserName => _signUp.name;

  // getting the user gender
  Gender? get getUserGender => _signUp.gender;

  // getting the user birthDate
  DateTime? get getUserBirthDate => _signUp.birthDate;

  // getting DateTime Before 18 Years
  DateTime get getDateTimeBefore18Years => _signUp.getDateTimeBefore18Years;

  // getting the user goals
  List<Goals> get getUserGoals => _signUp.goals;

  void reset() {
    _signUp.name = null;
    _signUp.email = null;
    _signUp.birthDate = null;
    _signUp.gender = null;
    _signUp.goals = [];
    _signUp.password = null;
  }
}
