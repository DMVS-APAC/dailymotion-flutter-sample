import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class DailymotionPlayerV2 extends StatefulWidget {
  final String playerId;
  final String videoId;
  final double? height;
  final void Function(InAppWebViewController controller)? onLoaded;

  const DailymotionPlayerV2(
      {required this.playerId,
      required this.videoId,
      this.onLoaded,
      this.height,
      super.key});

  @override
  State<DailymotionPlayerV2> createState() => DailymotionPlayerStateV2();
}

class DailymotionPlayerStateV2 extends State<DailymotionPlayerV2> {
  InAppWebViewController? playerControl;

  getIframe() {
    return ('''

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
  <div id="playerArea"></div>
   <script src="https://geo.dailymotion.com/libs/player/${widget.playerId}.js"></script>
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
        setTimeout(()=>{
          player.play()
          console.log("playyinggggg")
        }, 3000)
      }).catch(error=> {
        alert(JSON.stringify(error))
      })

    function play() {
      currentPlayer.play()
    }
    function pause() {
      currentPlayer.pause()
    }
    function fullScreen() {
      currentPlayer.setFullscreen(true)
      console.log('full screen')
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
''');
  }

  play() {
    playerControl?.evaluateJavascript(source: 'play()');
  }

  pause() {
    playerControl?.evaluateJavascript(source: 'pause()');
  }

  fullScreen() {
    playerControl?.evaluateJavascript(source: 'fullScreen()');
  }

  reload() {
    playerControl?.reload();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height ?? 250,
      child: InAppWebView(
        initialUrlRequest: URLRequest(
            url: Uri.dataFromString(getIframe(), mimeType: 'text/html')),
        initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              javaScriptEnabled: true,
              cacheEnabled: true,
              transparentBackground: true,
            ),
            ios: IOSInAppWebViewOptions(allowsInlineMediaPlayback: true)),
        onWebViewCreated: (InAppWebViewController controller) {
          playerControl = controller;
          widget.onLoaded!(controller);
        },
        onConsoleMessage: (controller, consoleMessage) =>
            {print(consoleMessage)},
      ),
    );
  }
}
