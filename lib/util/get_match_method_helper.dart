import 'package:url_launcher/url_launcher.dart';

const String getMatchedLink =
    "https://calendly.com/matchingtool-2/45minutes?month=2023-03";

/// launch the get matched in browser
Future<bool> launchGetMatchedUrl() async {
  try {
    if (await canLaunchUrl(Uri.parse(getMatchedLink))) {
      await launchUrl(
        Uri.parse(getMatchedLink),
        mode: LaunchMode.externalApplication,
      );
      return true;
    } else {
      return false;
    }
  } catch (_) {
    return false;
  }
}
