import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:o7therapy/_base/loading_manager.dart';
import 'package:o7therapy/_base/translator.dart';
import 'package:o7therapy/api/api_keys.dart';
import 'package:o7therapy/api/fort_constants.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/util/ui/feedback_controller.dart';

// TODO https://github.com/pichillilorenzo/flutter_inappwebview

class AddCardWidget extends StatefulWidget {
  final String cardNum;
  final String cvv;
  final String expiryDate;
  final bool debuggingEnabled;
  final String userId;
  final String countryCode;
  final String ip;
  final String token;
  final void Function(String reference) callback;

  const AddCardWidget(
      {required this.cardNum,
      required this.cvv,
      required this.expiryDate,
      required this.callback,
      required this.userId,
      required this.countryCode,
      required this.ip,
      required this.token,
      this.debuggingEnabled = false,
      Key? key})
      : super(key: key);

  @override
  AddCardWidgetState createState() => AddCardWidgetState();
}

class AddCardWidgetState extends State<AddCardWidget> with LoadingManager {
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
                initialData: InAppWebViewInitialData(data: postCreateToken()),
                onLoadStop: (controller, url) async {
                  await controller.evaluateJavascript(
                      source: "document.getElementById('formData').submit()");
                },
                onLoadStart: (controller, url) {
                  if (url.toString().contains('success')) {
                    widget.callback('success');
                  } else if (url.toString().contains('failed')) {
                    widget.callback('fail');
                  }
                },
                onLoadError:
                    (appWebViewController, url, int code, String message) {
                  debugPrint('onLoadError: $message');
                  // if (message != null) {
                  //   showToast(message);
                  // }
                },
                onLoadHttpError:
                    (appWebViewController, url, int code, String message) {
                  debugPrint('onLoadHttpError: $message');
                  // if (message != null) {
                  //   showToast(message);
                  // }
                  // Navigator.of(context).popAndPushNamed(FailPaymentScreen.routeName);
                },
                onProgressChanged:
                    (InAppWebViewController controller, int progress) async {
                  final url = await controller.getUrl();
                  if (url.toString().contains('success')) {
                    widget.callback('success');
                  } else if (url.toString().contains('failed')) {
                    widget.callback('fail');
                  }
                  setState(() {
                    this.progress = progress / 100;
                  });
                },
              ),
              buildLeadWidget(),
              // loadingManagerWidget()
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
    return 'RSI-${(ticks + (random.nextInt(99) * 100000)).toString()}';
  }

  String postCreateToken() {
    String referenceNumber = getRandomNumber();
    String signaturePhrase = FortConstants.shaRequestPhrase;
    String signature = "$signaturePhrase"
        "${FortConstants.accessCodeAttr}=${FortConstants.accessCode}"
        "${FortConstants.languageAttr}=${FortConstants.language}"
        "${FortConstants.merchantIdentifierAttr}=${FortConstants.merchantIdentifier}"
        "${FortConstants.merchantReferenceAttr}=$referenceNumber"
        "${FortConstants.returnUrlAttr}=${FortConstants.getReturnUrl(widget.userId, widget.countryCode)}"
        "${FortConstants.serviceCommandAttr}=${FortConstants.createTokenCommand}"
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
    <input name='${FortConstants.serviceCommandAttr}' value='${FortConstants.createTokenCommand}'/>
    <input name='${FortConstants.cardNumberAttr}' value='${widget.cardNum.replaceAll(" ", "")}' />
    <input name='${FortConstants.expiryDateAttr}' value='${widget.expiryDate}' />
    <input name='${FortConstants.languageAttr}' value='${FortConstants.language}' />
    <input name='${FortConstants.merchantIdentifierAttr}' value='${FortConstants.merchantIdentifier}' />
    <input name='${FortConstants.returnUrlAttr}' value='${FortConstants.getReturnUrl(widget.userId, widget.countryCode)}' />
    <input name='${FortConstants.merchantReferenceAttr}' value='$referenceNumber' />
    <input name='${FortConstants.signatureAttr}' value='$hashedSignature' />
"</form>
 </body></html>"
  ''';
    return htmlForm;
  }

  @override
  Translator provideTranslate() {
    // TODO: implement provideTranslate
    throw UnimplementedError();
  }

  @override
  void runChangeState() {
    // TODO: implement runChangeState
  }
}
