import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DailymotionPlayer extends StatefulWidget {
  final String playerId;
  final String videoId;
  final double? height;
  final WebViewCreatedCallback? onLoaded;
  final Function(String)? onPageFinished;

  const DailymotionPlayer(
      {required this.playerId,
      required this.videoId,
      this.onLoaded,
      this.height,
      this.onPageFinished,
      super.key});

  @override
  State<DailymotionPlayer> createState() => DailymotionPlayerState();
}

class DailymotionPlayerState extends State<DailymotionPlayer> {
  late final WebViewController playerControl;

  getIframe() {
    return new Uri.dataFromString('''
<html lang="en">
<head>
  <meta name="viewport"
    content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
  <script>
      if(!document.__defineGetter__) {
            Object.defineProperty(document, 'cookie', {
                get: function(){return ''},
                set: function(){return true},
            });
        } else {
            document.__defineGetter__("cookie", function() { return '';} );
            document.__defineSetter__("cookie", function() {} );
        }
  </script>    
</head>
<body>
  <script src="https://geo.dailymotion.com/libs/player/${widget.playerId}.js"></script>
  <div id="playerArea"></div>
  <script>
    var currentPlayer;
    dailymotion
      .createPlayer("playerArea", {
        video: "${widget.videoId}",
        params: {
          startTime: 0,
          loop: false,
          mute: false,
        },
      }).then(player => {
        currentPlayer = player
      })

    function play() {
      currentPlayer.play()
    }
    function pause() {
      currentPlayer.pause()
    }
    function fullScreen() {
      console.log('set fullscreen')
      currentPlayer.setFullscreen(true)
    }
    function cancelFullScreen() {
      currentPlayer.setFullscreen(false)
    }
  </script>
  <style>
    body { margin: 0px; padding: 0px; height: 100%; overflow: hidden; }
    #playerArea { width: 100%; height: 100%; }
    .dailymotion-player { height: 100vh; }
  </style>
</body>
</html>
''', mimeType: 'text/html').toString();
  }

  play() {
    playerControl.runJavascript('play()');
  }

  pause() {
    playerControl.runJavascript('pause()');
  }

  fullScreen() {
    playerControl.runJavascript('fullScreen()');
  }

  reload() {
    playerControl.reload();
  }

  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height ?? 250,
      child: WebView(
        initialUrl: 'about:blank',
        onWebViewCreated: (controller) => {
          controller.loadUrl(getIframe()),
          widget.onLoaded!(controller),
          playerControl = controller
        },
        backgroundColor: Colors.black,
        onPageFinished: widget.onPageFinished,
        javascriptMode: JavascriptMode.unrestricted,
        allowsInlineMediaPlayback: true,
        initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
      ),
    );
  }
}
