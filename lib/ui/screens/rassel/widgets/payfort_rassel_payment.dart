import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:o7therapy/api/fort_constants.dart';
import 'package:o7therapy/res/const_colors.dart';

// TODO https://github.com/pichillilorenzo/flutter_inappwebview

class PayfortRasselPaymentWidget extends StatefulWidget {
  final String cardNum;
  final String cvv;
  final String expiryDate;
  final bool rememberMe;
  final String cardHolderName;
  final bool debuggingEnabled;
  final void Function(String reference) callback;
  final String subscriptionId;
  final String ip;
  final String token;

  const PayfortRasselPaymentWidget(
      {required this.cardNum,
      required this.cvv,
      required this.expiryDate,
      required this.rememberMe,
      required this.cardHolderName,
      required this.callback,
      this.debuggingEnabled = false,
      required this.ip,
      required this.token,
      required this.subscriptionId,
      Key? key})
      : super(key: key);

  @override
  PayfortRasselPaymentWidgetState createState() =>
      PayfortRasselPaymentWidgetState();
}

class PayfortRasselPaymentWidgetState
    extends State<PayfortRasselPaymentWidget> {
  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));
  late PullToRefreshController pullToRefreshController;
  Uri url = Uri.parse("");
  String errorMessage = "";
  double progress = 0;
  final urlController = TextEditingController();
  bool haveError = false;
  int? errorCode;
  String errorURL = "";

  @override
  void initState() {
    super.initState();
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: ConstColors.app,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              InAppWebView(
                initialData: InAppWebViewInitialData(data: postDataToWebView()),
                onLoadStop: (controller, url) async {
                  debugPrint(url.toString());
                  await controller.evaluateJavascript(
                      source: "document.getElementById('formData').submit()");
                },
                shouldOverrideUrlLoading: (controller, action) {
                  return Future(() => null);
                },
                onLoadResource: (controller, resource) {},
                onLoadStart: (controller, url) {
                  debugPrint(url.toString());
                  if (url.toString().contains('success')) {
                    widget.callback('success');
                  } else if (url.toString().contains('failed') || url.toString().contains('Failed')) {
                    widget.callback('fail');
                  }
                },
                onLoadError:
                    (appWebViewController, url, int code, String message) {
                  debugPrint('onLoadError: $message');
                },
                onLoadHttpError:
                    (appWebViewController, url, int code, String message) {
                  debugPrint('onLoadHttpError: $message');
                },
                onProgressChanged:
                    (InAppWebViewController controller, int progress) async {
                  final url = await controller.getUrl();
                  if (url.toString().contains('success')) {
                    widget.callback('success');
                  } else if (url.toString().contains('failed')|| url.toString().contains('Failed')) {
                    widget.callback('fail');
                  }
                  setState(() {
                    this.progress = progress / 100;
                  });
                },
              ),
              buildLeadWidget()
            ],
          ),
        ),
      ],
    );
  }

  buildLeadWidget() {
    return progress < 1.0
        ? const Center(child: CupertinoActivityIndicator())
        : Container();
  }

  String getRandomNumber() {
    final ticks =
        621355968000000000 + (DateTime.now().microsecondsSinceEpoch * -10000);
    Random random = Random();
    return 'SUB-${(ticks + (random.nextInt(99) * 100000)).toString()}';
  }

  String postDataToWebView() {
    String referenceNumber = getRandomNumber();
    String signaturePhrase = FortConstants.shaRequestPhrase;
    String signature = "$signaturePhrase"
        "${FortConstants.accessCodeAttr}=${FortConstants.accessCode}"
        "${FortConstants.languageAttr}=${FortConstants.language}"
        "${FortConstants.merchantExtraAttr}=${FortConstants.merchantExtraRasselSubscribe}"
        "${FortConstants.merchantExtra1Attr}=${widget.subscriptionId}"
        "${FortConstants.merchantExtra2Attr}=${widget.token}"
        "${FortConstants.merchantExtra3Attr}=${widget.ip}"
        "${FortConstants.merchantIdentifierAttr}=${FortConstants.merchantIdentifier}"
        "${FortConstants.merchantReferenceAttr}=$referenceNumber"
        "${FortConstants.returnUrlAttr}=${FortConstants.rasselSubscribeReturnUrl}"
        "${FortConstants.serviceCommandAttr}=${FortConstants.tokenizationCommand}"
        "$signaturePhrase";
    var hashedSignature = sha256
        .convert(Uint8List.fromList(utf8.encode(signature)))
        .toString()
        .toUpperCase();
    String htmlForm = '''
    <html><body>
<form id='formData' style='visibility: hidden;'
action='${FortConstants.payfortTokenization}' method='POST'>

    <input name='${FortConstants.accessCodeAttr}' value='${FortConstants.accessCode}' />
    <input name='${FortConstants.serviceCommandAttr}' value='${FortConstants.tokenizationCommand}'/>
    <input name='${FortConstants.cardNumberAttr}' value='${widget.cardNum.replaceAll(" ", "")}' />
    <input name='${FortConstants.accessCodeAttr}' value='${FortConstants.accessCode}' />
    <input name='${FortConstants.expiryDateAttr}' value='${widget.expiryDate}' />
    <input name='${FortConstants.cardSecurityCodeAttr}' value='${widget.cvv}' />
    <input name='${FortConstants.languageAttr}' value='${FortConstants.language}' />
    <input name='${FortConstants.merchantExtraAttr}' value='${FortConstants.merchantExtraRasselSubscribe}' />
    <input name='${FortConstants.merchantExtra1Attr}' value='${widget.subscriptionId}' />
    <input name='${FortConstants.merchantExtra2Attr}' value='${widget.token}' />
    <input name='${FortConstants.merchantExtra3Attr}' value='${widget.ip}' />
    <input name='${FortConstants.merchantIdentifierAttr}' value='${FortConstants.merchantIdentifier}' />
    <input name='${FortConstants.rememberMeAttr}' value='YES' />
    <input name='${FortConstants.returnUrlAttr}' value='${FortConstants.rasselSubscribeReturnUrl}' />
    <input name='${FortConstants.merchantReferenceAttr}' value='$referenceNumber' />
    <input name='${FortConstants.signatureAttr}' value='$hashedSignature' />
"</form>
 </body></html>"
  ''';
    return htmlForm;
  }

  String rememberMeApi() {
    return widget.rememberMe ? "YES" : "NO";
  }
}
