import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:o7therapy/_base/widgets/base_screen_widget.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/api/api_keys.dart';
import 'package:o7therapy/api/models/reschedule_session/reschedule_session_send_model.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/activity/bloc/activity_bloc.dart';
import 'package:o7therapy/ui/screens/checkout/payment_details/payment_indebt.dart';
import 'package:o7therapy/ui/screens/home_guest/widgets/footer_widget.dart';
import 'package:o7therapy/ui/widgets/app_bar_more_screens/app_bar_more_screens.dart';
import 'package:o7therapy/ui/widgets/widgets.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:shimmer/shimmer.dart';

class RescheduleDetailsScreen extends BaseScreenWidget {
  static const routeName = '/reschedule-Details-screen';

  const RescheduleDetailsScreen({Key? key}) : super(key: key);

  @override
  BaseState screenCreateState() => _RescheduleDetailsScreenState();
}

class _RescheduleDetailsScreenState
    extends BaseScreenState<RescheduleDetailsScreen> {
  String therapistName = "";
  String therapistProfession = "";
  String sessionDate = '';
  double sessionFees = 0;
  String currency = "";
  String imageUrl = "";
  String promoCode = "";
  int sessionId = 0;
  String slotId = "";
  bool isWallet = false;
  bool requirePayment = false;

  @override
  void initState() {
    super.initState();
    context.read<ActivityBloc>().add(LoadingRescheduleDetailsEvt());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(Duration.zero).then((_) {
      context.read<ActivityBloc>().add(LoadingRescheduleDetailsEvt());
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      therapistName = args['therapistName'] as String;
      therapistProfession = args['therapistProfession'] as String;
      sessionDate = args['sessionDate'] as String;
      sessionFees = args['sessionFees'] as double;
      currency = args['currency'] as String;
      imageUrl = args['image'] as String;
      slotId = args['slotId'] as String;
      sessionId = int.parse(args['sessionId']);
      requirePayment = args['requirePayment'] as bool;
      context.read<ActivityBloc>().add(LoadingRescheduleDetailsEvt());
    });
  }

  @override
  Widget buildScreenWidget(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBarForMoreScreens(
          title:
              '${translate(LangKeys.reschedule)} ${translate(LangKeys.session)}',
        ),
        body: _getBody(),
      ),
    );
  }

///////////////////////////////////////////////////////////
//////////////////// Widget methods ///////////////////////
///////////////////////////////////////////////////////////

  Widget _getBody() {
    return BlocBuilder<ActivityBloc, ActivityState>(builder: (context, state) {
      return SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            _stepsSlide(),
            _bookingHeader(),
            _getDetailsCard(),
            _totalFees(),
            _cancellationPolicy(),
            const FooterWidget(),
            _confirmButton(),
          ],
        ),
      ));
    });
  }

  Widget _stepsSlide() {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0, bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              child: Container(
                  color: ConstColors.accentColor,
                  width: width * 0.60,
                  height: 3.5),
            ),
          ),
        ],
      ),
    );
  }

//Header for what you will book for
  Widget _bookingHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Text(
        translate(LangKeys.paymentDetails),
        style: const TextStyle(
            color: ConstColors.app, fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

//Details card
  Widget _getDetailsCard() {
    return SizedBox(
      width: width,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              _sessionDetailsRow(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 17.0),
                child: lineDivider(),
              ),
              _sessionFees(),
            ],
          ),
        ),
      ),
    );
  }

//Colored Text
  Widget _text(
      String text, FontWeight fontWeight, double fontSize, Color color) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        text,
        style:
            TextStyle(fontWeight: fontWeight, fontSize: fontSize, color: color),
      ),
    );
  }

//Session & therapist info
  Widget _sessionDetailsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _text(therapistName, FontWeight.w600, 14, ConstColors.app),
            SizedBox(
              width: width / 3,
              child: Wrap(
                children: [
                  SizedBox(
                    width: width * 0.35,
                    child: Text(
                      therapistProfession,
                      maxLines: 1,
                      style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: ConstColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            _text(
                sessionDate == ""
                    ? ""
                    : DateFormat('EEEE dd/MM').format(_getDate(sessionDate)),
                FontWeight.w400,
                14,
                ConstColors.text),
            _text(translate(LangKeys.fiftyMinOneOnOne), FontWeight.w400, 12,
                ConstColors.textSecondary),
          ],
        ),
        Column(
          children: [
            imageUrl == ""
                ? SvgPicture.asset(AssPath.infoIcon)
                : ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(16),
                    ),
                    child: SizedBox(
                        width: 60,
                        height: 60,
                        child: CachedNetworkImage(
                          imageUrl: ApiKeys.baseUrl + imageUrl,
                          fit: BoxFit.fitHeight,
                          placeholder: (_, __) => Shimmer.fromColors(
                            baseColor: Colors.black12,
                            highlightColor: Colors.white,
                            child: Container(
                              // height: double.infinity,
                              width: 0.27 * width,
                              decoration:
                                  const BoxDecoration(color: Colors.black26),
                            ),
                          ),
                          errorWidget: (context, url, error) => const SizedBox(
                              width: 30,
                              height: 30,
                              child: Center(child: Icon(Icons.error))),
                        ))),
            _text(
                sessionDate == ""
                    ? ""
                    : DateFormat().add_jm().format(_getDate(sessionDate)),
                FontWeight.w700,
                14,
                ConstColors.accentColor),
          ],
        ),
      ],
    );
  }

//Session fees row
  Widget _sessionFees() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _text(translate(LangKeys.sessionFees), FontWeight.w400, 12,
            ConstColors.text),
        _text("${sessionFees.toInt()} ${translateCurrency(currency)}",
            FontWeight.w400, 16, ConstColors.text),
      ],
    );
  }

//total fees section
  Widget _totalFees() {
    return Padding(
      padding: EdgeInsets.only(top: height / 70),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _text(
              translate(LangKeys.total), FontWeight.w500, 14, ConstColors.app),
          _text("${sessionFees.toInt()} ${translateCurrency(currency)}",
              FontWeight.w600, 16, ConstColors.text),
        ],
      ),
    );
  }

//Cancellation policy expand collapse section
  Widget _cancellationPolicy() {
    return Padding(
      padding: EdgeInsets.only(top: height / 20),
      child: ExpandableNotifier(
        initialExpanded: true,
        child: ScrollOnExpand(
          theme: const ExpandableThemeData(
              iconColor: ConstColors.app,
              tapBodyToCollapse: true,
              tapBodyToExpand: true),
          child: ExpandablePanel(
            header: Row(
              children: [
                SvgPicture.asset(
                  AssPath.cancellationIcon,
                  // scale: 2,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Text(
                    translate(LangKeys.cancellationPolicy),
                    style: const TextStyle(
                      color: ConstColors.app,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            collapsed: const SizedBox(),
            expanded: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _cancellationPolicyText(
                      bold1: translate(LangKeys.a100Percent),
                      bold2: translate(LangKeys.a24Hours),
                      text1: translate(LangKeys.a100PercentRefund1),
                      text2: translate(LangKeys.a100PercentRefund2)),
                  _cancellationPolicyText(
                      bold1: translate(LangKeys.a50Percent),
                      bold2: translate(LangKeys.sixTo24Hours),
                      text1: translate(LangKeys.a50PercentRefund1),
                      text2: translate(LangKeys.a50PercentRefund2)),
                  _cancellationPolicyText(
                      bold2: translate(LangKeys.lessThan6Hours),
                      text1: translate(LangKeys.noRefund1),
                      text2: translate(LangKeys.noRefund2)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

//Cancellation policy
  Widget _cancellationPolicyText(
      {String? bold1,
      required String bold2,
      required String text1,
      required String text2}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text("• ", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(
            width: width * 0.8,
            child: Text.rich(TextSpan(
              style: const TextStyle(fontSize: 12, color: ConstColors.text),
              children: <TextSpan>[
                TextSpan(
                    text: bold1 ?? "",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: text1),
                TextSpan(
                    text: bold2,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: text2),
              ],
            )),
          ),
        ],
      ),
    );
  }

  Widget _confirmButton() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(
          top: 20.0, left: width / 10, right: width / 10, bottom: 20),
      child: SizedBox(
        width: width,
        height: 45,
        child: ElevatedButton(
          onPressed: () {
            context.read<ActivityBloc>().add(RescheduleActivityEvt(sessionId,
                RescheduleSessionSendModel(slotId: slotId), sessionDate));
          },
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ))),
          child: Text(translate(LangKeys.confirm)),
        ),
      ),
    );
  }

///////////////////////////////////////////////////////////
/////////////////// Helper methods ////////////////////////
///////////////////////////////////////////////////////////

  DateTime _getDate(String date) {
    String year = date.substring(0, 4);
    String month = date.substring(4, 6);
    String day = date.substring(6, 8);
    String hour = date.substring(8, 10);
    String minute = date.substring(10, 12);
    String second = date.substring(12, 14);
    String formattedDate = "$year-$month-${day}T$hour:$minute:${second}Z";
    return DateTime.parse(formattedDate);
  }
}
