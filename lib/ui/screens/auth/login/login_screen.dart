import 'package:adjust_sdk/adjust.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:o7therapy/api/adjust_manager.dart';
import 'package:o7therapy/api/api_keys.dart';
import 'package:o7therapy/api/mixpanel_manager.dart';
import 'package:o7therapy/api/models/auth/check_verified_email/CheckVerifiedEmailData.dart';
import 'package:o7therapy/api/models/auth/login/login_send_model.dart';
import 'package:o7therapy/prefs/pref_manager.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/auth/bloc/auth_bloc/auth_bloc.dart';
import 'package:o7therapy/ui/screens/auth/bloc/auth_secure_storage_cubit/auth_secure_storage_cubit.dart';
import 'package:o7therapy/ui/screens/auth/forget_password/forget_password_screen.dart';
import 'package:o7therapy/ui/screens/auth/signup/verify_email_screen.dart';
import 'package:o7therapy/ui/screens/auth/widgets/login_widgets/email_form_field.dart';
import 'package:o7therapy/ui/screens/auth/widgets/login_widgets/forget_password_button.dart';
import 'package:o7therapy/ui/screens/auth/widgets/login_widgets/login_row.dart';
import 'package:o7therapy/ui/screens/auth/widgets/login_widgets/not_registered_row.dart';
import 'package:o7therapy/ui/screens/auth/widgets/login_widgets/password_form_field.dart';
import 'package:o7therapy/ui/screens/booking/bloc/therapists_booked_before_bloc/therapists_booked_before_bloc.dart';
import 'package:o7therapy/ui/screens/get_started/get_started_screen.dart';
import 'package:o7therapy/ui/screens/home/home_main_logged_in/home_main_logged_in/home_main_logged_in_screen.dart';
import 'package:o7therapy/ui/screens/splash/cubit/refresh_token_cubit.dart';

import 'package:o7therapy/util/check_force_update_util.dart';
import 'package:o7therapy/util/extensions/extensions.dart';
import 'package:o7therapy/util/firebase/analytics/auth_analytics.dart';

import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/util/secure_storage_helper/secure_storage.dart';
import 'package:o7therapy/util/ui/feedback_controller.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login-screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with WidgetsBindingObserver {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  DateTime? currentBackPressTime;

  late final Mixpanel _mixpanel;

  @override
  void initState() {
    RefreshTokenCubit.cubit(context).reset();

    /// reset the therapist booked before
    TherapistsBookedBeforeBloc.bloc(context)
        .add(const ResetTherapistsBookedBeforeEvent());

    super.initState();
    // Track with event-name
    _initMixpanel();
    WidgetsBinding.instance.addObserver(this);
    AdjustManager.initPlatformState();
    // auth.isDeviceSupported().then(
    //       (bool isSupported) => setState(() => _supportState = isSupported
    //           ? _SupportState.supported
    //           : _SupportState.unsupported),
    //     );
    // _checkBiometrics();
    CheckForceUpdateUtil.checkForceUpdate(context);
    // Firebase.initializeApp();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        Adjust.onResume();
        break;
      case AppLifecycleState.paused:
        Adjust.onPause();
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  void _hideKeyBoard() {
    _emailFocusNode.unfocus();
    _passwordFocusNode.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
        // show or hide loader
        if (state is LoadingAuthState) {
          context.showLoader();
        } else {
          context.hideLoader();
        }

        if (state is NetworkError) {
          // showSnackBarWithContext(createSnackBar(state.message), context);
          showToast(state.message);
        } else if (state is ErrorState) {
          showToast(state.message);
        } else if (state is VerifiedEmailAuthState &&
            state.isVerified == false) {
          _notVerifiedState(state.userId, state.date);
        }
        //else if (state is ClientProfile) {
        //_successLoginWithClientProfile(state.profileInfo);
        if (state is VerifiedEmailAuthState && state.isVerified) {
          _successLoginWithClientProfile();
        } else if (state is OpenForgetPassword) {
          _openForgetPasswordScreen();
        } else if (state is SuccessGoogleLogin) {
          _googleLoginSuccessful();
        }
      }, builder: (context, state) {
        if (state is EmailEmptyError) {
          return loginFormWidget(
              errorEmail: context.translate(LangKeys.emailEmptyErr));
        } else if (state is EmailFormattedError) {
          return loginFormWidget(
              errorEmail: context.translate(LangKeys.invalidEmail));
        } else if (state is EmailFormatCorrect) {
          return loginFormWidget(errorEmail: null);
        } else if (state is PasswordEmptyError) {
          return loginFormWidget(
              errorPassword: context.translate(LangKeys.passwordEmptyErr));
        } else {
          return loginFormWidget();
        }
      }),
    );
  }

///////////////////////////////////////////////////////////
//////////////////// Widget methods ///////////////////////
///////////////////////////////////////////////////////////
  Widget loginFormWidget({String? errorEmail, String? errorPassword}) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => _hideKeyBoard(),
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: context.height / 20),
                  _headingTextWidget(context.translate(LangKeys.welcomeBack)),
                  _getWelcomeMessageWidget(
                      context.translate(LangKeys.weAreGlad)),
                  SizedBox(height: context.height / 14),
                  EmailFormField(
                    emailController: _emailController,
                    emailFocusNode: _emailFocusNode,
                    passwordFocusNode: _passwordFocusNode,
                  ),
                  SizedBox(height: context.height / 20),
                  PasswordFormField(
                    passwordController: _passwordController,
                    passwordFocusNode: _passwordFocusNode,
                  ),
                  const ForgetPasswordButton(),
                  SizedBox(height: context.height / 30),
                  LoginRow(
                    onLoginBioPressed: _onLoginBioPressed,
                    onLoginPressed: _onLoginPressed,
                  ),
                  // SizedBox(height: context.height / 20),
                  // const ContinueWithRow(),
                  // SizedBox(height: context.height / 20),
                  // const SocialLogin(),
                  SizedBox(height: context.height / 20),
                  const NotRegisteredRow(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //Welcome heading
  Widget _headingTextWidget(String text) {
    return Padding(
      padding: EdgeInsets.only(top: context.height / 20),
      child: Text(
        text,
        style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: ConstColors.appTitle,
            fontSize: 24),
      ),
    );
  }

  //Welcome message
  Widget _getWelcomeMessageWidget(String text) {
    return SizedBox(
      width: 250,
      child: RichText(
        text: TextSpan(
            text: text,
            style: const TextStyle(color: ConstColors.text, fontSize: 14)),
        textAlign: TextAlign.center,
      ),
    );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////
  AuthBloc get authBloc => BlocProvider.of<AuthBloc>(context);
  AuthSecureStorageCubit get authSecureStorageCubit =>
      AuthSecureStorageCubit.bloc(context);

  void _onLoginPressed() async {
    _hideKeyBoard();
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    authBloc.add(LoginApiEvent(LoginSendModel(
      userEmail: _emailController.text, // userEmail: emailTxt,
      password: _passwordController.text, // password: passwordTxt,
    )));
    _hideKeyBoard();
  }

  Future<void> _onLoginBioPressed() async {
    _hideKeyBoard();
    await authSecureStorageCubit.onEnableLocalAuth();
    DataAuthSecureStorage data = await authSecureStorageCubit.readFromStorage();
    _emailController.text = data.email;
    _passwordController.text = data.password;
    authBloc.add(LoginApiEvent(LoginSendModel(
      userEmail: _emailController.text,
      password: _passwordController.text,
    )));
  }

  void _googleLoginClicked() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    authBloc.add(const GoogleLoginApiEvent());
  }

  void _onForgetPasswordPressed() {
    authBloc.add(const OpenForgetPasswordEvent());
  }

  void _openForgetPasswordScreen() {
    Navigator.of(context).pushNamed(ForgetPasswordScreen.routeName);
  }

  Future<void> _successLoginWithClientProfile() async {
    await PrefManager.setFirstLogin();
    await PrefManager.setLoggedIn();
    await SecureStorage.setFirstLogin();
    await SecureStorage.setLoggedIn();
    authSecureStorageCubit.onEnableLocalAuth();
    // Write values
    authSecureStorageCubit.writeToStorage(
      email: _emailController.text,
      password: _passwordController.text,
    );

    Adjust.trackEvent(
        AdjustManager.buildSimpleEvent(eventToken: ApiKeys.loginEventToken));
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeMainLoggedInScreen(fromLogin: true),
      ),
      (route) => false,
    );
  }

  Future<void> _googleLoginSuccessful() async {
    // await PrefManager.setLoggedIn();
    // await PrefManager.setFirstLogin();
    // await PrefManager.setEmail(emailTxt);
    // await PrefManager.setPassword(passwordTxt);
    // await PrefManager.setUser(
    //   loginWrapper.data?.userDisplayName,
    //   loginWrapper.data?.accessToken,
    //   loginWrapper.data?.allowedRoles?[0],
    //   loginWrapper.data?.userId,
    // );
    await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeMainLoggedInScreen(fromLogin: true),
        ),
        (route) => false);
  }

  _notVerifiedState(String userId, CheckVerifiedEmailData? data) {
    DateTime? dateOfBirth =
        data?.dob != null ? DateTime.parse(data!.dob!) : null;
    String dateToSend =
        "${dateOfBirth?.day}/${dateOfBirth?.month}/${dateOfBirth?.year}";
    AuthAnalytics.i.unverifiedSignUp();
    AuthAnalytics.i.setUserDateOfBirth(dateOfBirth: dateToSend);

    _mixpanel.track("Signup unverified", properties: {
      "Gender": data?.gender != null
          ? Gender.values.elementAt(data!.gender!).name
          : null,
      "Date Of Birth": dateToSend,
      "I Want to(Therapy goal)":
          data?.clientGoals != null ? data!.clientGoals! : null,
    });
    Navigator.of(context).pushNamedAndRemoveUntil(
      VerifyEmailScreen.routeName,
          (Route<dynamic> route) => false,
      arguments: {
        "userId": userId,
        "date": data,
      },
    );
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime ?? now) >
            const Duration(seconds: 3)) {
      currentBackPressTime = now;
      showToast(context.translate(LangKeys.pressAgainToExitLogin));
      Navigator.of(context).pushNamedAndRemoveUntil(
          GetStartedScreen.routeName, (route) => false);
      return Future.value(false);
    }
    return Future.value(true);
  }

  Future<void> _initMixpanel() async {
    _mixpanel = await MixpanelManager.init();
    _mixpanel.unregisterSuperProperty("User Reference Number");
  }
}
