# Dailymotion Player in Flutter

- [Dailymotion Player in Flutter](#dailymotion-player-in-flutter)
  - [What you'll need](#what-youll-need)
- [Getting started](#getting-started)
  - [Video Player](#video-player)
  - [Flutter Preparation](#flutter-preparation)
    - [Adding WebView Flutter plugin as a dependency](#adding-webview-flutter-plugin-as-a-dependency)
    - [Putting a Webview on the screen](#putting-a-webview-on-the-screen)
    - [Enable the JavaScript](#enable-the-javascript)
    - [Crafting Navigation Controls](#crafting-navigation-controls)
    - [Adding navigation controls to the AppBar](#adding-navigation-controls-to-the-appbar)
- [Issues](#issues)

In this repository, you'll build a mobile app step by step featuring a WebView using the Flutter SDK. Your app will:

- Display Dailymotion Video Player in a WebView
- Play, Pause Dailymotion Video Player

## What you'll need
- Android Studio 4.1 or later (for Android development)
- Xcode 12 or later (for iOS development)
- Flutter SDK


There are different integration methods available depending on your technical preference or environment. We recommend using one of the script embeds type where possible as it provides access to all player functionality and the Player API.

 Embed type | Info
 -----------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Player Embed Script   | Embed using JavaScript, the single line script will load the Player at the point where you add it to the HTML page\. This also provides access to the Player API         
 Player Library Script | Add just the library and create the player programmatically using the Player API
 Player iFrame         | Embed the player without JavaScript to use a basic player configuration\. Advanced functionality such as&nbsp;PiP&nbsp;and&nbsp;firstTimeView&nbsp;will not be available 


In this repository, we will be using the Player Library Script, as we will be creating a player embed that can be controlled via **Flutter WebView** plugin programmatically using the **Player API**.

# Getting started

## Video Player

As a first step you need to prepare a simple HTML page that contain a Dailymotion Video that created using Player Library Script.

```html
<!-- Embed the player JS -->
<script src="https://geo.dailymotion.com/libs/player/x46a.js"></script>

<!-- Prepare element to inject the player -->
<div id="player1"></div>

<!-- JS code to load the player -->
<script>
    // initiate a variable to store the player object.
    var currentPlayer;

    // Create player in #player1
    dailymotion
      .createPlayer("player1", {
        video: "x84sh87",
        params: {
          startTime: 0,
          loop: false,
          mute: false,
        },
      }).then(player => {
        // if it's successfully loaded, save the player result into currentPlayer variable
        currentPlayer = player
      })

    // create a function to play the video
    function playTheVideo() {
        currentPlayer.play()
    }

    // create a function to pause the video
    function pauseTheVideo() {
      currentPlayer.pause()
    }
</script>

```

You can save the file to a server or provider such as Codepen, Repl.it, and so on. So you have a URL ready to be displayed in the application. You can access the sample file  https://MintyHoneydewInstitutes.arryanggaputra.repl.co

## Flutter Preparation

### Adding WebView Flutter plugin as a dependency

Add webview dependency by using this command `flutter pub add webview_flutter`

```bash
$ flutter pub add webview_flutter
Resolving dependencies...
  async 2.8.1 (2.8.2 available)
  characters 1.1.0 (1.2.0 available)
  matcher 0.12.10 (0.12.11 available)
+ plugin_platform_interface 2.0.2
  test_api 0.4.2 (0.4.8 available)
  vector_math 2.1.0 (2.1.1 available)
+ webview_flutter 3.0.0
+ webview_flutter_android 2.8.0
+ webview_flutter_platform_interface 1.8.0
+ webview_flutter_wkwebview 2.7.0
Downloading webview_flutter 3.0.0...
Downloading webview_flutter_wkwebview 2.7.0...
Downloading webview_flutter_android 2.8.0...
Changed 5 dependencies!
```

### Putting a Webview on the screen

Replace the content of lib/main.dart with the following:

```dart
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dailymotion Player'),
      ),
      body: const WebView(
        initialUrl: 'https://MintyHoneydewInstitutes.arryanggaputra.repl.co',
      ),
    );
  }
}
```

Running this on iOS or Android will show a WebView as a full bleed browser window on your device, which means that the browser is shown on your device in fullscreen without any form of border or margin. As you scroll, you will notice parts of the page that might look a bit odd. This is because JavaScript is currently disabled and rendering the web itself properly requires JavaScript.

### Enable the JavaScript
To make the web inside the WebView more interactive, we can enable the JavaScript by adding this option into the WebView Widget.
```dart

class _WebViewAppState extends State<WebViewApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dailymotion Player'),
      ),
      body: const WebView(
        initialUrl: 'https://MintyHoneydewInstitutes.arryanggaputra.repl.co',
        javascriptMode: JavascriptMode.unrestricted, //enable the JavaScript
      ),
    );
  }
}
```

### Crafting Navigation Controls

Having a working `WebView` with the Dailymotion Player is great, but being able to control the Player through the app, would be a useful set of additions. Thankfully, with a `WebViewController` you can add this functionality to your app.

Create a new source file at `lib/navigation_controls.dart` and fill it with the following:

```dart
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

```

If you notice in `IconButton` for the `Play Icon`, inside the `onPressed` method we put this line
```dart
await controller.runJavascript('playTheVideo()');
```
The code above will call `playTheVideo()` function that you already define inside the WebPage.

### Adding navigation controls to the AppBar

Update `lib/main.dart` as follows:
```dart

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
          NavigationControls(controller: controller), // put navigation controls in the AppBar
        ],
      ),
      body: WebView(
        initialUrl: 'https://MintyHoneydewInstitutes.arryanggaputra.repl.co',
        onWebViewCreated: (webViewController) {
          controller.complete(webViewController); // store webviewController in controller
        },
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}

```

# Issues
I'm sure that you will face some issues such as the video player is always loaded in `FullScreen`, the `autoplay` not working, etc.

You need to add more options to the `WebView` to add inline video player functionality. You can update the `WebView` widget as follows

> For android the `FullScreen` capability is still not available till today, you can read more about it in [here](https://github.com/flutter/flutter/issues/27101)

```dart
WebView(
    initialUrl: 'https://MintyHoneydewInstitutes.arryanggaputra.repl.co',
    onWebViewCreated: (webViewController) {
      controller.complete(webViewController);
    },
    javascriptMode: JavascriptMode.unrestricted,
    allowsInlineMediaPlayback: true, //enable inline
    initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow, // enable auto play
),
```