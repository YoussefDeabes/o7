part of 'contact_us_mixin.dart';

/// private so i can not use it out side the contact Us mixin file
class _ContactUsModelBottomSheetWidget extends BaseStatelessWidget {
  _ContactUsModelBottomSheetWidget({Key? key}) : super(key: key);
  TextStyle listTextStyle = const TextStyle(
      color: ConstColors.text, fontWeight: FontWeight.w500, fontSize: 14);

  // Call Us and What's app textStyle widget
  TextStyle callUsAndWhatsAppTextStyle = const TextStyle(
      fontSize: 14, fontWeight: FontWeight.w500, color: ConstColors.text);

  @override
  Widget baseBuild(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Text(
              translate(LangKeys.contactUs),
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ConstColors.app),
            ),
          ),
          // Call us Section
          TextButton(
            child: Text(
              translate(LangKeys.callUs),
              style: callUsAndWhatsAppTextStyle,
            ),
            onPressed: () => _callUs(context),
          ),
          // what's app section

          const Padding(padding: EdgeInsets.zero, child: Divider()),
          TextButton(
            child: Text(
              translate(LangKeys.whatsApp),
              style: callUsAndWhatsAppTextStyle,
            ),
            onPressed: () => _whatsAppUs(context),
          ),
          //Mail section

          const Padding(padding: EdgeInsets.zero, child: Divider()),
          TextButton(
            child: Text(
              translate(LangKeys.email),
              style: callUsAndWhatsAppTextStyle,
            ),
            onPressed: () => _emailUs(context),
          ),
        ],
      ),
    );
  }

///////////////////////////////////////////////////////////
//////////////////// Helper methods ///////////////////////
///////////////////////////////////////////////////////////

  _callUs(BuildContext context) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: "+201272222024",
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      const snackBar = SnackBar(
        content: Text("Cannot Make a Phone Call, 201272222024"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  _whatsAppUs(BuildContext context) async {
    final Uri whatsappUri = Uri.parse(Platform.isAndroid
        ? "whatsapp://send?phone=+201224527810"
        : "https://wa.me/201224527810");
    try {
      await launchUrl(whatsappUri);
    } catch (e) {
      const snackBar = SnackBar(
        content:
            Text("Install WhatsApp First Please, https://wa.me/201224527810"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  _emailUs(BuildContext context) async {
    final Uri urlLaunch = Uri(
      scheme: 'mailto',
      path: "support@o7therapy.com",
      queryParameters: {
        'subject': 'Support',
      },
    );
    try {
      await launchUrl(urlLaunch);
    } catch (e) {
      const snackBar = SnackBar(
        content: Text("Cannot Send a mail to support@o7therapy.com"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
