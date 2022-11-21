import 'dart:async'; // Add this import

import 'package:flutter/material.dart';
import 'package:flutter_dm_player/DailymotionPlayer.dart';
import 'package:flutter_dm_player/DailymotionPlayerV2.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webview_flutter/webview_flutter.dart'; // Add this import back

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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
  late final WebViewController theController;
  InAppWebViewController? theControllerv2;

  final GlobalKey<DailymotionPlayerState> dmPlayer =
      GlobalKey<DailymotionPlayerState>();

  final GlobalKey<DailymotionPlayerStateV2> dmPlayer2 =
      GlobalKey<DailymotionPlayerStateV2>();

  double playerHeight = 200;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dailymotion Player'),
        centerTitle: false,
      ),
      body: Column(
        children: [
          DailymotionPlayer(
            playerId: "xathg",
            videoId: "x8fl3xz",
            key: dmPlayer,
            height: playerHeight,
            onLoaded: (controller) {
              print('loaded');
            },
            onPageFinished: (p0) => {print("finish loaded")},
          ),
          Row(
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.play_arrow),
                onPressed: () => {dmPlayer.currentState?.play()},
              ),
              IconButton(
                icon: const Icon(Icons.pause),
                onPressed: () => {dmPlayer.currentState?.pause()},
              ),
              IconButton(
                icon: const Icon(Icons.replay_outlined),
                onPressed: () => {dmPlayer.currentState?.reload()},
              ),
              IconButton(
                icon: const Icon(Icons.fullscreen),
                onPressed: () => {
                  setState(() {
                    playerHeight = 500;
                  })
                },
              ),
            ],
          ),
          // DailymotionPlayerV2(
          //   playerId: "xathg",
          //   videoId: "x8fl3xz",
          //   key: dmPlayer2,
          //   onLoaded: (controller) {
          //     print('loaded');
          //   },
          // ),
          // Row(
          //   children: <Widget>[
          //     IconButton(
          //       icon: const Icon(Icons.play_arrow),
          //       onPressed: () => {dmPlayer2.currentState?.play()},
          //     ),
          //     IconButton(
          //       icon: const Icon(Icons.pause),
          //       onPressed: () => {dmPlayer2.currentState?.pause()},
          //     ),
          //     IconButton(
          //       icon: const Icon(Icons.replay_outlined),
          //       onPressed: () => {dmPlayer2.currentState?.reload()},
          //     ),
          //     IconButton(
          //       icon: const Icon(Icons.fullscreen),
          //       onPressed: () => {dmPlayer2.currentState?.fullScreen()},
          //     ),
          //   ],
          // )
        ],
      ),
    );
  }
}
