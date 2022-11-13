import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NavigationControls extends StatelessWidget {
  const NavigationControls({required this.controller, super.key});

  final Completer<WebViewController> controller;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: controller.future,
      builder: (context, snapshot) {
        final WebViewController? controller = snapshot.data;
        if (snapshot.connectionState != ConnectionState.done ||
            controller == null) {
          return Row(
            children: const <Widget>[],
          );
        }

        return Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: () async {
                await controller.runJavascript('playTheVideo()');
              },
            ),
            IconButton(
              icon: const Icon(Icons.pause),
              onPressed: () async {
                await controller.runJavascript('pauseTheVideo()');
              },
            ),
            IconButton(
              icon: const Icon(Icons.replay),
              onPressed: () {
                controller.reload();
              },
            ),
          ],
        );
      },
    );
  }
}
