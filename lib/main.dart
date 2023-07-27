import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:o7therapy/_base/global_loader_overlay.dart';
import 'package:o7therapy/api/environments/environments.dart';
import 'package:o7therapy/api/models/auth/sign_up_models/sign_up_models.dart';
import 'package:o7therapy/bloc/get_matched_pressed_bloc/get_matched_button_bloc.dart';
import 'package:o7therapy/bloc/internet_connection_bloc/internet_connection_bloc.dart';
import 'package:o7therapy/bloc/internet_connection_bloc/repository/network_info.dart';
import 'package:o7therapy/bloc/mixpanel_booking_bloc/mixpanel_booking_bloc.dart';
import 'package:o7therapy/util/firebase/analytics/analytics_helper.dart';
import 'package:o7therapy/util/precache_svg.dart';
import 'package:o7therapy/ui/screens/activity/activity_logged_in/activity_logged_in_screen.dart';
import 'package:o7therapy/ui/screens/activity/bloc/activity_bloc.dart';
import 'package:o7therapy/ui/screens/activity/bloc/activity_repo.dart';
import 'package:o7therapy/ui/screens/activity/reschedule_screen/reschedule_details_payment.dart';
import 'package:o7therapy/ui/screens/auth/bloc/auth_secure_storage_cubit/auth_secure_storage_cubit.dart';
import 'package:o7therapy/ui/screens/auth/bloc/biometrics_cubit/biometrics_cubit.dart';
import 'package:o7therapy/ui/screens/auth/forget_password/bloc/forget_password_bloc.dart';
import 'package:o7therapy/ui/screens/auth/forget_password/bloc/forget_password_repo.dart';
import 'package:o7therapy/ui/screens/auth/forget_password/models/change_forget_password_data_model.dart';
import 'package:o7therapy/ui/screens/activity/reschedule_screen/reschedule_details.dart';
import 'package:o7therapy/ui/screens/activity/reschedule_screen/reschedule_screen.dart';
import 'package:o7therapy/ui/screens/auth/forget_password/verify_email_for_forget_password_screen.dart';
import 'package:o7therapy/ui/screens/booking/bloc/booking_screen_filter_bloc/booking_screen_filter_bloc.dart';
import 'package:o7therapy/ui/screens/booking/bloc/booking_screen_filter_bloc/filter_repository.dart';
import 'package:o7therapy/ui/screens/booking/bloc/booking_screen_filter_bloc/models/filter_models.dart';

import 'package:o7therapy/ui/screens/booking/bloc/booking_screen_sort_bloc/booking_screen_sort_bloc.dart';
import 'package:o7therapy/ui/screens/booking/bloc/search_bloc/search_bloc.dart';
import 'package:o7therapy/ui/screens/booking/bloc/search_bloc/search_repo.dart';

import 'package:o7therapy/ui/screens/booking/bloc/services_categories_bloc/services_categories_bloc.dart';
import 'package:o7therapy/ui/screens/booking/bloc/therapists_bloc/therapists_bloc.dart';
import 'package:o7therapy/ui/screens/booking/bloc/therapists_bloc/therapists_repo.dart';
import 'package:o7therapy/ui/screens/booking/bloc/therapists_booked_before_bloc/therapists_booked_before_bloc.dart';
import 'package:o7therapy/ui/screens/booking/bloc/therapists_booked_before_bloc/therapists_booked_before_repo.dart';
import 'package:o7therapy/ui/screens/booking/booking_screen/booking_screen.dart';
import 'package:o7therapy/ui/screens/booking/search-results-screen.dart';
import 'package:o7therapy/ui/screens/booking_guest/bloc/services_guest_bloc.dart';
import 'package:o7therapy/ui/screens/booking_guest/bloc/services_guest_repo.dart';
import 'package:o7therapy/ui/screens/booking_guest/booking_guest_screen/workshops_details_screen.dart';
import 'package:o7therapy/ui/screens/booking_guest/cubit/selected_tab_cubit.dart';
import 'package:o7therapy/ui/screens/checkout/payment_details/payment_cancel_indebt.dart';
import 'package:o7therapy/ui/screens/guest_therapist_profile/bloc/therapist_bio_bloc/therapist_bio_bloc.dart';
import 'package:o7therapy/ui/screens/guest_therapist_profile/therapist_profile_screen/guest_therapist_profile_screen.dart';
import 'package:o7therapy/ui/screens/home_logged_in/bloc/check_user_discount_cubit/check_user_discount_cubit.dart';
import 'package:o7therapy/ui/screens/home_logged_in/bloc/check_user_discount_cubit/check_user_discount_repo.dart';
import 'package:o7therapy/ui/screens/home_logged_in/bloc/rassel_card_bloc/rassel_card_bloc.dart';
import 'package:o7therapy/ui/screens/messages/blocs/current_opened_chat_bloc/current_opened_chat_bloc.dart';
import 'package:o7therapy/ui/screens/messages/blocs/record_audio_bloc/record_audio_bloc.dart';
import 'package:o7therapy/ui/screens/group_assessment/screen/fail_group_assessment_screen.dart';
import 'package:o7therapy/ui/screens/group_assessment/screen/group_assessment_screen.dart';
import 'package:o7therapy/ui/screens/group_assessment/screen/success_group_assessment_screen.dart';
import 'package:o7therapy/ui/screens/messages/blocs/search_contacts_bloc/search_contacts_bloc.dart';
import 'package:o7therapy/ui/screens/messages/blocs/search_contacts_bloc/search_contacts_repo.dart';
import 'package:o7therapy/ui/screens/messages/blocs/send_bird_bloc/send_bird_bloc.dart';
import 'package:o7therapy/ui/screens/messages/blocs/send_bird_bloc/send_bird_repo.dart';
import 'package:o7therapy/ui/screens/messages/blocs/send_bird_channels_bloc/sb_channels_repo.dart';
import 'package:o7therapy/ui/screens/messages/blocs/send_bird_channels_bloc/sb_channels_bloc.dart';
import 'package:o7therapy/ui/screens/messages/blocs/un_read_messages_count_bloc/un_read_messages_count_bloc.dart';
import 'package:o7therapy/ui/screens/messages/screens/contacts_screen.dart';
import 'package:o7therapy/ui/screens/messages/screens/chatting_screen.dart';
import 'package:o7therapy/ui/screens/change_password/bloc/change_password_bloc.dart';
import 'package:o7therapy/ui/screens/change_password/bloc/change_password_repo.dart';
import 'package:o7therapy/ui/screens/change_password/screens/change_password_screen.dart';
import 'package:o7therapy/ui/screens/checkout/bloc/checkout_bloc.dart';
import 'package:o7therapy/ui/screens/checkout/bloc/checkout_repo.dart';
import 'package:o7therapy/ui/screens/checkout/checkout_screen/checkout_screen.dart';
import 'package:o7therapy/ui/screens/checkout/checkout_screen/confirm_booking_screen.dart';
import 'package:o7therapy/ui/screens/checkout/fail_payment_screen/fail_payment_screen.dart';
import 'package:o7therapy/ui/screens/checkout/payment_details/payment_details_screen.dart';
import 'package:o7therapy/ui/screens/checkout/payment_details/payment_indebt.dart';
import 'package:o7therapy/ui/screens/checkout/success_payment_screen/success_payment_screen.dart';
import 'package:o7therapy/ui/screens/ewp/bloc/ewp_bloc.dart';
import 'package:o7therapy/ui/screens/ewp/bloc/ewp_repo.dart';
import 'package:o7therapy/ui/screens/ewp/ewp_screen.dart';
import 'package:o7therapy/ui/screens/home/home_main_logged_in/home_main_logged_in/home_main_logged_in_screen.dart';
import 'package:o7therapy/ui/screens/home/home_main_logged_in/home_main_logged_in_notification_bloc/home_main_logged_in_notification_bloc.dart';
import 'package:o7therapy/ui/screens/home_guest/home_guest/filtered_screen.dart';

import 'package:o7therapy/ui/screens/home_logged_in/home_logged_in/home_logged_in_screen.dart';
import 'package:o7therapy/ui/screens/home_logged_in/home_screen_therapists_bloc/home_screen_therapists_bloc.dart';
import 'package:o7therapy/ui/screens/home_logged_in/home_screen_therapists_bloc/home_screen_therapists_repo.dart';
import 'package:o7therapy/ui/screens/insurance/bloc/insurance_list_bloc/insurance_list_bloc.dart';

import 'package:o7therapy/ui/screens/insurance/bloc/insurance_status_bloc/insurance_status_bloc.dart';
import 'package:o7therapy/ui/screens/insurance/bloc/insurance_status_bloc/insurance_status_repository.dart';
import 'package:o7therapy/ui/screens/insurance/bloc/phone_masked_number_bloc/phone_masked_number_bloc.dart';
import 'package:o7therapy/ui/screens/insurance/bloc/send_verification_code_bloc/send_verification_code_bloc.dart';
import 'package:o7therapy/ui/screens/insurance/screen/edit_insurance_data_screen.dart';
import 'package:o7therapy/ui/screens/insurance/screen/insurance_screen.dart';
import 'package:o7therapy/ui/screens/insurance/screen/search_providers_insurance_screen.dart';
import 'package:o7therapy/ui/screens/insurance/screen/verified_insurance_screen.dart';
import 'package:o7therapy/ui/screens/rassel/bloc/checkout_bloc/rassel_checkout_bloc.dart';
import 'package:o7therapy/ui/screens/rassel/bloc/rassel_bloc/rassel_bloc.dart';
import 'package:o7therapy/ui/screens/rassel/bloc/rassel_bloc/rassel_repo.dart';
import 'package:o7therapy/ui/screens/rassel/bloc/checkout_bloc/rassel_checkout_repo.dart';
import 'package:o7therapy/ui/screens/rassel/screens/rassel_guest_screen.dart';
import 'package:o7therapy/ui/screens/my-subscriptions/bloc/my_subscriptions_bloc.dart';
import 'package:o7therapy/ui/screens/my-subscriptions/screens/my_subscriptions_screen.dart';
import 'package:o7therapy/ui/screens/rassel/screens/rassel_checkout_screen.dart';
import 'package:o7therapy/ui/screens/rassel/screens/rassel_payment_screen.dart';
import 'package:o7therapy/ui/screens/rassel/screens/rassel_screen.dart';
import 'package:o7therapy/ui/screens/notifications/screen/notifications_screen.dart';

import 'package:o7therapy/ui/screens/notifications/bloc/notifications_bloc.dart';

import 'package:o7therapy/ui/screens/payment_history/screen/payment_history_screen.dart';
import 'package:o7therapy/ui/screens/payment_methods/bloc/payment_methods_bloc.dart';
import 'package:o7therapy/ui/screens/payment_methods/bloc/payment_methods_repo.dart';
import 'package:o7therapy/ui/screens/payment_methods/payment_methods/payment_methods_screen.dart';
import 'package:o7therapy/ui/screens/profile/bloc/profile_bloc.dart';
import 'package:o7therapy/ui/screens/profile/bloc/profile_repo.dart';
import 'package:o7therapy/ui/screens/profile/screens/profile_screen.dart';
import 'package:o7therapy/ui/screens/rassel/screens/success_rassel_subscription.dart';
import 'package:o7therapy/ui/screens/sessions_credit/bloc/sessions_credit_bloc.dart';
import 'package:o7therapy/ui/screens/sessions_credit/bloc/sessions_credit_repo.dart';
import 'package:o7therapy/ui/screens/sessions_credit/sessions_wallet_screen/sessions_wallet_screen.dart';
import 'package:o7therapy/ui/screens/splash/bloc/splash_bloc.dart';
import 'package:o7therapy/ui/screens/splash/bloc/splash_repo.dart';
import 'package:o7therapy/ui/screens/splash/cubit/refresh_token_cubit.dart';
import 'package:o7therapy/ui/screens/therapist_profile/bloc/therapist_profile_bloc.dart';
import 'package:o7therapy/ui/screens/therapist_profile/bloc/therapist_profile_repo.dart';
import 'package:o7therapy/ui/screens/therapist_profile/therapist_available_slots_cubit/therapist_available_slots_cubit.dart';
import 'package:o7therapy/ui/screens/therapist_profile/therapist_profile_screen/therapist_profile_screen.dart';
import 'package:o7therapy/ui/screens/web_view/web_view_screen.dart';
import 'package:o7therapy/ui/widgets/video_player/video_screen.dart';
import 'package:o7therapy/util/notifications/notifications_services.dart';
import 'package:o7therapy/util/secure_storage_helper/secure_storage.dart';
import 'package:overlay_support/overlay_support.dart';

import 'package:path_provider/path_provider.dart';

import 'package:o7therapy/bloc/lang/language_cubit.dart';
import 'package:o7therapy/ui/screens/activity/activity_guest/activity_guest_screen.dart';
import 'package:o7therapy/ui/screens/auth/bloc/auth_bloc/auth_bloc.dart';
import 'package:o7therapy/ui/screens/auth/bloc/auth_bloc/auth_repo.dart';
import 'package:o7therapy/ui/screens/auth/forget_password/create_new_password_screen.dart';
import 'package:o7therapy/ui/screens/auth/forget_password/forget_password_screen.dart';
import 'package:o7therapy/ui/screens/auth/login/login_screen.dart';
import 'package:o7therapy/ui/screens/auth/signup/signup_screen.dart';
import 'package:o7therapy/ui/screens/auth/signup/verify_email_screen.dart';
import 'package:o7therapy/ui/screens/booking_guest/booking_guest_screen/booking_guest_screen.dart';
import 'package:o7therapy/ui/screens/get_started/get_started_screen.dart';
import 'package:o7therapy/ui/screens/home/home_main/home_main_screen.dart';
import 'package:o7therapy/ui/screens/home_guest/home_guest/home_guest_screen.dart';
import 'package:o7therapy/ui/screens/more_guest/more_guest_screen/more_guest_screen.dart';
import 'package:o7therapy/ui/screens/more_logged_in_user/more_logged_in_screen/more_logged_in_screen.dart';
import 'package:o7therapy/ui/screens/splash/splash_screen.dart';
import 'package:o7therapy/util/lang/app_localization.dart';
import 'package:o7therapy/util/theme/app_theme.dart';

import 'ui/screens/activity/reschedule_screen/reschedule_payment_screen.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// choose which environment (Stg -- prod -- dev)
  /// this will changes the keys in (apiKey file and fort constants and zoom)

  Environment.init(envType: EnvType.stg);
  await AnalyticsHelper.enableAnalytics();

  SecureStorage.init();
  await NotificationsServices.instance.init();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  await Future.wait([
    PrecacheSvg.loadPictures(),
    FirebasePerformance.instance.app
        .setAutomaticResourceManagementEnabled(true),
    FirebasePerformance.instance.app.setAutomaticDataCollectionEnabled(true),
    FirebasePerformance.instance.setPerformanceCollectionEnabled(true),
  ]);

  // _checkFirebasePerformanceEnableOrNot();
  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);

    var swAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE);
    var swInterceptAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);

    if (swAvailable && swInterceptAvailable) {
      AndroidServiceWorkerController serviceWorkerController =
          AndroidServiceWorkerController.instance();

      await serviceWorkerController
          .setServiceWorkerClient(AndroidServiceWorkerClient(
        shouldInterceptRequest: (request) async {
          return null;
        },
      ));
    }
  }

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const O7TherapyApp());
}

class O7TherapyApp extends StatelessWidget {
  const O7TherapyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: GlobalLoaderOverlay(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<RefreshTokenCubit>(
                lazy: false,
                create: (BuildContext context) => RefreshTokenCubit()),
            BlocProvider<LanguageCubit>(
                create: (BuildContext context) => LanguageCubit()),
            BlocProvider<AuthBloc>(
              create: (BuildContext context) => AuthBloc(
                authenticationRepo: AuthenticationRepo(),
                signUp: SignUpSendModel(),
              ),
            ),
            BlocProvider<BookingScreenFilterBloc>(
              lazy: false,
              create: (_) => BookingScreenFilterBloc(
                  repo: FilterRepository(
                filterModel: FilterModel(),
              )),
            ),
            BlocProvider<BookingScreenSortBloc>(
              lazy: false,
              create: (BuildContext context) => BookingScreenSortBloc(),
            ),
            BlocProvider<SearchBloc>(
              lazy: false,
              create: (_) => SearchBloc(repo: const SearchRepo()),
            ),
            BlocProvider<TherapistsBloc>(
              create: (BuildContext context) => TherapistsBloc(
                filterBloc: context.read<BookingScreenFilterBloc>(),
                sortBloc: context.read<BookingScreenSortBloc>(),
                searchBloc: SearchBloc.bloc(context),
                repo: const TherapistsRepo(),
              ),
            ),
            BlocProvider<ServicesCategoriesBloc>(
              create: (BuildContext context) => ServicesCategoriesBloc(),
            ),
            BlocProvider<TherapistProfileBloc>(
              create: (BuildContext context) =>
                  TherapistProfileBloc(const TherapistProfileRepo()),
            ),
            BlocProvider<InternetConnectionBloc>(
              lazy: false,
              create: (BuildContext context) => InternetConnectionBloc(
                connectionCheck: NetworkInfoRepository(
                  connectivity: Connectivity(),
                ),
              ),
            ),
            BlocProvider<ActivityBloc>(
              create: (BuildContext context) =>
                  ActivityBloc(const ActivityRepo()),
            ),
            BlocProvider<PaymentMethodsBloc>(
              create: (BuildContext context) =>
                  PaymentMethodsBloc(const PaymentMethodsRepo()),
            ),
            BlocProvider<SessionsCreditBloc>(
              create: (BuildContext context) =>
                  SessionsCreditBloc(const SessionsCreditRepo()),
            ),
            BlocProvider<CheckoutBloc>(
                create: (BuildContext context) =>
                    CheckoutBloc(const CheckoutRepo())),
            BlocProvider<InsuranceListBloc>(
              create: (BuildContext context) => InsuranceListBloc(),
            ),
            BlocProvider<SendVerificationCodeBloc>(
              lazy: false,
              create: (_) => SendVerificationCodeBloc(),
            ),
            BlocProvider<InsuranceStatusBloc>(
              create: (BuildContext context) => InsuranceStatusBloc(
                statusRepository: const InsuranceStatusRepository(),
              ),
            ),
            BlocProvider<SendVerificationCodeBloc>(
              create: (_) => SendVerificationCodeBloc(),
            ),
            BlocProvider<NotificationsBloc>(
              create: (BuildContext context) => NotificationsBloc(),
            ),
            BlocProvider<ChangePasswordBloc>(
              create: (BuildContext context) =>
                  ChangePasswordBloc(ChangePasswordRepo()),
            ),
            BlocProvider<EwpBloc>(
                create: (_) => EwpBloc(const EwpRepository())),
            BlocProvider<TherapistsBookedBeforeBloc>(
              create: (_) => TherapistsBookedBeforeBloc(
                  const TherapistsBookedBeforeRepo()),
            ),
            BlocProvider<ForgetPasswordBloc>(
              create: (_) => ForgetPasswordBloc(ForgetPasswordRepo(
                model: ChangeForgetPasswordDataModel(),
              )),
            ),
            BlocProvider<HomeScreenTherapistsBloc>(
                create: (BuildContext context) => HomeScreenTherapistsBloc(
                    baseHomeScreenTherapistsRepo:
                        const HomeScreenTherapistsRepo())),
            BlocProvider<PhoneMaskedNumberBloc>(
                create: (BuildContext context) => PhoneMaskedNumberBloc()),
            BlocProvider<HomeMainLoggedInNotificationBloc>(
              create: (BuildContext context) =>
                  HomeMainLoggedInNotificationBloc(),
            ),
            BlocProvider<ProfileBloc>(
                create: (BuildContext context) =>
                    ProfileBloc(profileRepo: const ProfileRepo())),
            BlocProvider<SplashBloc>(
              create: (BuildContext context) => SplashBloc(const SplashRepo()),
            ),
            BlocProvider<SendBirdBloc>(
              /// lazy here is used to initialize the applications id for sendBird when app start
              lazy: false,
              create: (BuildContext context) => SendBirdBloc(
                const SendBirdRepository(),
              ),
            ),
            BlocProvider<SBChannelsBloc>(
              create: (BuildContext context) => SBChannelsBloc(
                sbChannelsRepository: const SBChannelsRepository(),
              ),
            ),
            BlocProvider<UnReadMessagesCountBloc>(
              create: (context) => UnReadMessagesCountBloc(),
            ),
            BlocProvider<SearchContactsBloc>(
              create: (context) =>
                  SearchContactsBloc(repo: const SearchContactsRepo()),
            ),
            BlocProvider<HomeMainLoggedInNotificationBloc>(
              create: (BuildContext context) =>
                  HomeMainLoggedInNotificationBloc(),
            ),
            BlocProvider<RecordAudioBloc>(
              create: (context) => RecordAudioBloc(),
            ),
            BlocProvider<CurrentOpenedChatBloc>(
                create: (_) => CurrentOpenedChatBloc()),
            BlocProvider<ServicesGuestBloc>(
                create: (_) => ServicesGuestBloc(GuestServicesRepo())),
            BlocProvider<SelectedTabCubit>(create: (_) => SelectedTabCubit()),
            BlocProvider<TherapistBioBloc>(
                create: (_) => TherapistBioBloc(const TherapistBioRepo())),
            BlocProvider<CheckUserDiscountCubit>(
              create: (_) => CheckUserDiscountCubit(
                const CheckUserDiscountRepository(),
              ),
            ),
            BlocProvider<AuthSecureStorageCubit>(
              create: (_) => AuthSecureStorageCubit(
                const FlutterSecureStorage(),
              ),
            ),
            BlocProvider<BiometricsCubit>(
              create: (_) => BiometricsCubit(
                LocalAuthentication(),
              ),
            ),
            BlocProvider<TherapistAvailableSlotsCubit>(
                create: (_) => TherapistAvailableSlotsCubit()),
            BlocProvider<RasselCardBloc>(create: (_) => RasselCardBloc()),
            BlocProvider<MySubscriptionsBloc>(
              create: (BuildContext context) => MySubscriptionsBloc(),
            ),
            BlocProvider<RasselBloc>(
              create: (BuildContext context) => RasselBloc(const RasselRepo()),
            ),
            BlocProvider<RasselCheckoutBloc>(
              create: (BuildContext context) =>
                  RasselCheckoutBloc(const RasselCheckoutRepo()),
            ),
            BlocProvider<MixpanelBookingBloc>(
              create: (_) {
                return MixpanelBookingBloc()..add(const InitMixpanelEvent());
              },
            ),
            BlocProvider<GetMatchedButtonBloc>(
              create: (_) => GetMatchedButtonBloc(),
            ),
          ],
          child: BlocBuilder<LanguageCubit, Locale>(
              builder: (context, localeState) {
            // Intl.defaultLocale = localeState.languageCode;
            // Format ;
            return MaterialApp(
              title: 'O7 Therapy',
              theme: AppTheme(localeState).themeDataLight,
              debugShowCheckedModeBanner: false,

              /// the list of our supported locals for our app
              /// currently we support only 2 English, Arabic ...
              supportedLocales: AppLocalizations.supportLocales,

              /// these delegates make sure that the localization data for the proper
              /// language is loaded ...
              localizationsDelegates: const [
                /// this for selecting the county localization
                CountryLocalizations.delegate,

                /// A class which loads the translations from JSON files
                AppLocalizations.delegate,

                /// Built-in localization of basic text for Material widgets
                GlobalMaterialLocalizations.delegate,

                /// Built-in localization for text direction LTR/RTL
                GlobalWidgetsLocalizations.delegate,

                GlobalCupertinoLocalizations.delegate,
              ],

              /// Returns a locale which will be used by the app
              localeResolutionCallback:
                  AppLocalizations.localeResolutionCallback,
              locale: localeState,
              navigatorObservers: AnalyticsHelper.navigatorObserver,
              // home: const SearchProvidersInsuranceScreen(),
              // home: const CreateNewPasswordScreen(),
              home: const SplashScreen(),
              routes: {
                GuestTherapistProfileScreen.routeName: (ctx) =>
                    const GuestTherapistProfileScreen(),
                FailGroupAssessmentScreen.routeName: (ctx) =>
                    const FailGroupAssessmentScreen(),
                SuccessGroupAssessmentScreen.routeName: (ctx) =>
                    const SuccessGroupAssessmentScreen(),
                GroupAssessmentScreen.routeName: (ctx) =>
                    GroupAssessmentScreen(),
                ContactsScreen.routeName: (ctx) => const ContactsScreen(),
                ChattingScreen.routeName: (ctx) => const ChattingScreen(),
                WebViewScreen.routeName: (ctx) => const WebViewScreen(),
                InsuranceScreen.routeName: (ctx) => const InsuranceScreen(),
                VerifiedInsuranceScreen.routeName: (ctx) =>
                    const VerifiedInsuranceScreen(),
                SearchProvidersInsuranceScreen.routeName: (ctx) =>
                    const SearchProvidersInsuranceScreen(),
                EditInsuranceDataScreen.routeName: (ctx) =>
                    const EditInsuranceDataScreen(),
                NotificationsScreen.routeName: (ctx) =>
                    const NotificationsScreen(),
                EwpScreen.routeName: (ctx) => EwpScreen(),
                PaymentHistoryScreen.routeName: (ctx) => PaymentHistoryScreen(),
                SplashScreen.routeName: (ctx) => const SplashScreen(),
                HomeMainScreen.routeName: (ctx) => const HomeMainScreen(),
                LoginScreen.routeName: (ctx) => const LoginScreen(),
                GetStartedScreen.routeName: (ctx) => const GetStartedScreen(),
                SignupScreen.routeName: (ctx) => const SignupScreen(),
                VerifyEmailScreen.routeName: (ctx) => const VerifyEmailScreen(),
                VerifyEmailForForgetPasswordScreen.routeName: (ctx) =>
                    const VerifyEmailForForgetPasswordScreen(),
                ForgetPasswordScreen.routeName: (ctx) =>
                    const ForgetPasswordScreen(),
                CreateNewPasswordScreen.routeName: (ctx) =>
                    const CreateNewPasswordScreen(),
                HomeGuestScreen.routeName: (ctx) => const HomeGuestScreen(),
                BookingGuestScreen.routeName: (ctx) =>
                    const BookingGuestScreen(),
                ActivityGuestScreen.routeName: (ctx) =>
                    const ActivityGuestScreen(),
                MoreGuestScreen.routeName: (ctx) => const MoreGuestScreen(),
                FilteredGuestScreen.routeName: (ctx) =>
                    const FilteredGuestScreen(),
                MoreLoggedInUserScreen.routeName: (ctx) =>
                    const MoreLoggedInUserScreen(),
                BookingScreen.routeName: (ctx) => const BookingScreen(),
                TherapistProfileScreen.routeName: (ctx) =>
                    const TherapistProfileScreen(),
                CheckoutScreen.routeName: (ctx) => const CheckoutScreen(),
                PaymentDetailsScreen.routeName: (ctx) =>
                    const PaymentDetailsScreen(),
                SuccessPaymentScreen.routeName: (ctx) =>
                    const SuccessPaymentScreen(),
                HomeMainLoggedInScreen.routeName: (ctx) =>
                    const HomeMainLoggedInScreen(),
                HomeLoggedInScreen.routeName: (ctx) =>
                    const HomeLoggedInScreen(),
                ActivityLoggedInScreen.routeName: (ctx) =>
                    const ActivityLoggedInScreen(),
                PaymentMethodsScreen.routeName: (ctx) =>
                    const PaymentMethodsScreen(),
                SessionsWalletScreen.routeName: (ctx) =>
                    const SessionsWalletScreen(),
                ChangePasswordScreen.routeName: (ctx) =>
                    const ChangePasswordScreen(),
                FailPaymentScreen.routeName: (ctx) => const FailPaymentScreen(),
                RescheduleScreen.routeName: (ctx) => const RescheduleScreen(),
                RescheduleDetailsScreen.routeName: (ctx) =>
                    const RescheduleDetailsScreen(),
                RescheduleDetailsPaymentScreen.routeName: (ctx) =>
                    const RescheduleDetailsPaymentScreen(),
                ReschedulePaymentScreen.routeName: (ctx) =>
                    const ReschedulePaymentScreen(),
                ConfirmBookingScreen.routeName: (ctx) =>
                    const ConfirmBookingScreen(),
                PaymentInDebtScreen.routeName: (ctx) =>
                    const PaymentInDebtScreen(),
                ProfileScreen.routeName: (ctx) => const ProfileScreen(),
                PaymentCancelInDebtScreen.routeName: (ctx) =>
                    const PaymentCancelInDebtScreen(),
                VideoScreen.routeName: (ctx) => const VideoScreen(),
                RasselScreen.routeName: (ctx) => const RasselScreen(),
                WorkshopsDetailsScreen.routeName: (ctx) =>
                    WorkshopsDetailsScreen(),
                SearchResultsScreen.routeName: (ctx) =>
                    const SearchResultsScreen(),
                RasselGuestScreen.routeName: (ctx) => const RasselGuestScreen(),
                MySubscriptionScreen.routeName: (ctx) =>
                    const MySubscriptionScreen(),
                RasselCheckoutScreen.routeName: (ctx) =>
                    const RasselCheckoutScreen(),
                RasselPaymentScreen.routeName: (ctx) =>
                    const RasselPaymentScreen(),
                SuccessRasselSubscriptionScreen.routeName: (ctx) =>
                    const SuccessRasselSubscriptionScreen(),
              },
            );
          }),
        ),
      ),
    );
  }
}

// Future<void> _checkFirebasePerformanceEnableOrNot() async {
//   if (kDebugMode) {
//     debugPrint("PerformanceCollectionEnabled:Disable \n kDebugMode: true");
//     await FirebasePerformance.instance.setPerformanceCollectionEnabled(false);
//   } else {
//     debugPrint("PerformanceCollectionEnabled:Enabled \n kDebugMode: false");
//     await FirebasePerformance.instance.setPerformanceCollectionEnabled(true);
//   }
// }
