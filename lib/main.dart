import 'dart:async'; // Add this import

import 'package:flutter/material.dart';
import 'package:flutter_dm_player/navigation_controls.dart';
import 'package:webview_flutter/webview_flutter.dart'; // Add this import back

void main() {
  runApp(
    const MaterialApp(
      home: WebViewApp(),
    ),
  );
}

class WebViewApp extends StatefulWidget {
  const WebViewApp({super.key});

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  final controller =
      Completer<WebViewController>(); // Instantiate the controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dailymotion Player'),
        centerTitle: false,
        actions: [
          NavigationControls(controller: controller),
        ],
      ),
      body: WebView(
        initialUrl: 'https://MintyHoneydewInstitutes.arryanggaputra.repl.co',
        onWebViewCreated: (webViewController) {
          controller.complete(webViewController);
        },
        javascriptMode: JavascriptMode.unrestricted,
        allowsInlineMediaPlayback: true,
        initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
      ),
    );
  }
}
