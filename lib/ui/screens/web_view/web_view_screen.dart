// import 'dart:async';
import 'package:flutter/material.dart';
import 'package:o7therapy/_base/widgets/base_screen_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends BaseScreenWidget {
  static const String routeName = '/Web-view-screen';
  const WebViewScreen({super.key});

  @override
  WebViewState screenCreateState() => WebViewState();
}

class WebViewState extends BaseScreenState<WebViewScreen> {
  late final String url;
  var loadingPercentage = 0;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    url = ModalRoute.of(context)!.settings.arguments as String;
  }

  @override
  Widget buildScreenWidget(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: [
          WebView(
            initialUrl: url,
            javascriptMode: JavascriptMode.unrestricted,
            onPageStarted: (url) {
              setState(() {
                loadingPercentage = 0;
              });
            },
            onProgress: (progress) {
              setState(() {
                loadingPercentage = progress;
              });
            },
            onPageFinished: (url) {
              setState(() {
                loadingPercentage = 100;
              });
            },
          ),
          if (loadingPercentage < 100)
            LinearProgressIndicator(
              minHeight: 5,
              value: loadingPercentage / 100.0,
            ),
        ],
      )),
    );
  }
}
