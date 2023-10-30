import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:platform/platform.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewScreen extends StatefulWidget {
  const WebviewScreen({Key? key, required this.webviewUrl, required this.appBarTitle}) : super(key: key);
  final String webviewUrl;
  final String appBarTitle;
  @override
  State<WebviewScreen> createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<WebviewScreen> {
  bool canNavigate(String url) {
    return url.startsWith('https://');
  }

  String convertToStandardUrl(String url) {
    log(url);
    if (url.startsWith('intent://')) {
      int start = url.indexOf("scheme=");
      if (start != -1) {
        start += "scheme=".length;
        int end = url.indexOf(";", start);
        if (end != -1) {
          String scheme = url.substring(start, end);
          return url.replaceFirst("intent://", "$scheme://");
        }
      }
    }
    log(url);
    return url;
  }

  WebViewController? controller;

  bool _isWebViewLoading = false;

  bool downlaodClicked = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        // backgroundColor: Colors.blueGrey,
        title: Column(
          children: [
            Container(
              width: double.infinity,
              child: Text(
                widget.appBarTitle,
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
      body: _isWebViewLoading
          ? LinearProgressIndicator()
          : WebViewWidget(
              controller: WebViewController()
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..setBackgroundColor(const Color(0x00000000))
                ..enableZoom(false)
                ..setNavigationDelegate(
                  NavigationDelegate(
                    onUrlChange: (change) async {},
                    onProgress: (int progress) {
                      debugPrint('On progress: $progress');
                    },
                    onPageStarted: (String url) {
                      debugPrint('Page started: $url');
                    },
                    onPageFinished: (String url) {
                      debugPrint('Page finished: $url');
                    },
                    onWebResourceError: (WebResourceError error) {},
                    onNavigationRequest: (NavigationRequest request) async {
                      // String url = convertToStandardUrl(request.url);
                      // String packageName = getPackageNameFromUrl(request.url);

                      // if (const LocalPlatform().isAndroid && !canNavigate(url)) {
                      //   // final intent = AndroidIntent(
                      //   //   action: 'action_view',
                      //   //   data: url,
                      //   //   package: packageName,
                      //   // );

                      //   log('mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm');
                      //   // await intent.launch();
                      // }

                      if (request.url.contains('googleusercontent.com')) {
                        if (!downlaodClicked) {
                          downlaodClicked = true;
                          launchUrl(Uri.parse(widget.webviewUrl), mode: LaunchMode.externalApplication);
                          Navigator.pop(context);
                        }
                      }
                      return NavigationDecision.navigate;
                      // return canNavigate(request.url) ? NavigationDecision.navigate : NavigationDecision.prevent;
                    },
                  ),
                )
                ..loadRequest(Uri.parse(widget.webviewUrl))),
    );
  }
}

String getPackageNameFromUrl(String url) {
  final packageIndex = url.indexOf("package=");
  if (packageIndex != -1) {
    int startIndex = packageIndex + "package=".length;
    int endIndex = url.indexOf(";", startIndex);
    if (endIndex == -1) {
      endIndex = url.length;
    }
    String packageName = url.substring(startIndex, endIndex);
    return packageName;
  }
  return "";
}
