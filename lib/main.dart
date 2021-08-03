import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:wakelock/wakelock.dart';
// import 'package:provider/provider.dart';
// import './provider.dart';

void main() => runApp(PlayerEntry());

class PlayerEntry extends StatefulWidget {
  @override
  _PlayerEntryState createState() => _PlayerEntryState();
}

class _PlayerEntryState extends State<PlayerEntry> {
  // String video = 'http://breezing.me/demovideo.webm';
  // String audio = 'http://breezing.me/demoaudio.webm';
  String video =
      'https://r3---sn-gwpa-pmge.googlevideo.com/videoplayback?expire=1626814746&ei=uuT2YP3zD6aCp-oPqbi2qAY&ip=54.170.20.159&id=o-AAKkzxbTR87J001OAlYkIJxt5lOE-9SdoqS6ETIDCPFd&itag=248&aitags=133%2C134%2C135%2C136%2C137%2C160%2C242%2C243%2C244%2C247%2C248%2C278%2C394%2C395%2C396%2C397%2C398%2C399&source=youtube&requiressl=yes&vprv=1&mime=video%2Fwebm&ns=5gyuKlGHI5HwsJrtirtkHskG&gir=yes&clen=50878299&dur=255.520&lmt=1581358454077244&keepalive=yes&fexp=24001373,24007246&c=WEB&txp=5535432&n=mm-Q2y-Srgwl4Co&sparams=expire%2Cei%2Cip%2Cid%2Caitags%2Csource%2Crequiressl%2Cvprv%2Cmime%2Cns%2Cgir%2Cclen%2Cdur%2Clmt&sig=AOq0QJ8wRQIgWi5hauaPGDGDawIZkwRIDOXitNMM9qlow34zEqaWyykCIQCe9Wl7Nn40NVBIpw3MlAAX5o77385UesSaD_rhrCskHQ==&redirect_counter=1&rm=sn-q0ce77s&req_id=1eee142680d1a3ee&cms_redirect=yes&ipbypass=yes&mh=pX&mip=2405:201:a408:9012:2e49:b0ed:c862:17c0&mm=31&mn=sn-gwpa-pmge&ms=au&mt=1626792765&mv=m&mvi=3&pl=50&lsparams=ipbypass,mh,mip,mm,mn,ms,mv,mvi,pl&lsig=AG3C_xAwRgIhAOQLbwB9SxxUscWfXU_lVyltUMnQXnrthq3eKEHCg83zAiEArp0Up_yswU2iOrhiEjU6r_Mie_KIt66ggSagAiQ2SIc%3D';
  String audio =
      'https://r3---sn-gwpa-pmge.googlevideo.com/videoplayback?expire=1626814746&ei=uuT2YP3zD6aCp-oPqbi2qAY&ip=54.170.20.159&id=o-AAKkzxbTR87J001OAlYkIJxt5lOE-9SdoqS6ETIDCPFd&itag=251&source=youtube&requiressl=yes&vprv=1&mime=audio%2Fwebm&ns=5gyuKlGHI5HwsJrtirtkHskG&gir=yes&clen=4456689&dur=255.541&lmt=1581352389731486&keepalive=yes&fexp=24001373,24007246&c=WEB&txp=5531432&n=mm-Q2y-Srgwl4Co&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cvprv%2Cmime%2Cns%2Cgir%2Cclen%2Cdur%2Clmt&sig=AOq0QJ8wRQIhAOrFjU0iGyIUIWSdR93_QSJiJ-rMxiJNOE9Vk6Ke--N9AiAIadp1lsE2zOfV2lHrKLysLKh7otsBttk-sJDyWMi50g==&redirect_counter=1&rm=sn-q0ce77s&req_id=53db7f496087a3ee&cms_redirect=yes&ipbypass=yes&mh=pX&mip=2405:201:a408:9012:2e49:b0ed:c862:17c0&mm=31&mn=sn-gwpa-pmge&ms=au&mt=1626792765&mv=m&mvi=3&pl=50&lsparams=ipbypass,mh,mip,mm,mn,ms,mv,mvi,pl&lsig=AG3C_xAwRAIgH5Ljq_FqSuH94r-retuqYWzhnRLhR6YXySpDdHZtT4cCIGu-EL9-i_OjEs43Z6bfUtShOWUdbibvROU25J53gE0a';
  //////////////////////////////////////////////////
  bool _isFullScreen = false;
  bool _audioError = false;
  bool _isInit = false;
  bool _isError = false;
  // bool _isbuffering = false;
  late VideoPlayerController _videoController;
  late AudioPlayer _audioController;

  void _errorChecker() {
    if (_videoController.value.hasError) {
      // Provider.of<ProviderState>(context, listen: false).setError();
      this.setState(() {
        _isError = true;
      });
    } else {
      _audioController.onPlayerError.isEmpty.then((value) {
        if (!value) {
          // Provider.of<ProviderState>(context, listen: false).setError();
          this.setState(() {
            _audioError = true;
          });
        }
      });
    }
  }

  void _enterFullScreen() {
    this.setState(() {
      _isFullScreen = true;
    });
  }

  void _exitFullScreen() {
    this.setState(() {
      _isFullScreen = false;
    });
  }

  // void _syncAudioVideo() async {
  //   if (_videoController.value.isBuffering && !_isbuffering) {
  //     _isbuffering = true;
  //     await _audioController.pause();
  //   } else if (!_videoController.value.isBuffering && _isbuffering) {
  //     _isbuffering = false;
  //     await _audioController.resume();
  //   }
  // }

  void _syncAudioVideo() async {
    if (_videoController.value.isBuffering) {
      await _audioController.pause();
    } else if (!_videoController.value.isBuffering) {
      await _audioController.resume();
    }
  }

  @override
  void initState() {
    super.initState();
    _audioController = AudioPlayer();
    _videoController = VideoPlayerController.network(
      video,
    )..initialize().then((_) async {
        try {
          await _audioController.setUrl(audio);
          await _audioController.setVolume(100);
          await _videoController.setVolume(100);
          await _videoController.play();
          await _audioController.resume();
          this.setState(() {
            _isInit = true;
          });
        } catch (e) {
          if (_videoController.value.isPlaying) {
            await _videoController.pause();
          }
          this.setState(() {
            _isInit = true;
            _isError = true;
          });
        }
      }, onError: (e) {
        this.setState(() {
          _isInit = true;
          _isError = true;
        });
      });
    _videoController.addListener(_errorChecker);
    _videoController.addListener(_syncAudioVideo);
    Wakelock.enable();
  }

  @override
  void dispose() {
    _videoController.removeListener(_errorChecker);
    _videoController.removeListener(_syncAudioVideo);
    _videoController.dispose();
    _audioController.release();
    _audioController.dispose();
    Wakelock.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return /*ChangeNotifierProvider(
      create: (_) => ProviderState(),
      child: */
        MaterialApp(
      theme: ThemeData(primarySwatch: Colors.pink),
      home: Scaffold(
        appBar: _isFullScreen
            ? null
            : AppBar(
                title: Text('AVPlayer'),
              ),
        body: Stack(
          fit: _isFullScreen ? StackFit.expand : StackFit.loose,
          children: [
            AspectRatio(
              aspectRatio: _videoController.value.aspectRatio,
              child: Stack(
                children: [
                  VideoPlayer(_videoController),
                  AVControls(
                    videoController: _videoController,
                    audioController: _audioController,
                    isError: _isError,
                    isInit: _isInit,
                    audioError: _audioError,
                    // pushvideo: pushFullScreenVideo,
                    enterfs: _enterFullScreen,
                    exitfs: _exitFullScreen,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

//      ),
    );
  }
}

class AVControls extends StatefulWidget {
  final VideoPlayerController videoController;
  final AudioPlayer audioController;
  final bool isError;
  final bool isInit;
  final bool audioError;
  // final Function pushvideo;
  final Function enterfs;
  final Function exitfs;
  AVControls({
    required this.videoController,
    required this.isError,
    required this.isInit,
    required this.audioController,
    required this.audioError,
    // required this.pushvideo,
    required this.enterfs,
    required this.exitfs,
  });
  @override
  _AVControlsState createState() => _AVControlsState();
}

class _AVControlsState extends State<AVControls> {
  bool _showControls = true;
  bool _audiomsgshown = false;
  bool _isFullScreen = false;
  bool _videomsgshown = false;
  // bool _isbuffering = false;
  // bool _localbuffering = false;
  // bool _videoComplete = false;
  // bool _isplaying = true;
  // late Duration _seek = Duration(minutes: 0, seconds: 0);
  late double width = 100, height = 100;
  double _seekPos = 0.0;
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = duration.inMinutes.remainder(60).toString();
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inDays <= 0) {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
    return "${duration.inHours}:$twoDigitMinutes:$twoDigitSeconds";
  }

  Duration _secondsToDuration(double receivedSeconds) {
    return Duration(seconds: receivedSeconds.toInt());
  }

  double _percentageCalc(int curr, int total, bool abs) {
    if (abs) {
      return (curr / total) * 100;
    }
    return curr / total;
  }

  double _progressCalc(double base, int totalValue, int currentValue) {
    double x1 = _percentageCalc(currentValue, totalValue, false);
    double x2 = base * x1;
    return x2;
  }

  void _seekHandler() {
    if (widget.videoController.value.isPlaying &&
        !widget.isError &&
        widget.isInit) {
      this.setState(() {
        _seekPos = _progressCalc(
          width - 24,
          widget.videoController.value.duration.inSeconds,
          widget.videoController.value.position.inSeconds,
        );
      });
    }
  }

  // void _playingListner() {
  //   _isplaying = widget.videoController.value.isPlaying;
  // }

  bool _videoCompleted() {
    if (widget.videoController.value.position.inSeconds >=
        widget.videoController.value.duration.inSeconds) {
      return true;
    }
    return false;
  }

  Widget _playerControls() {
    if (widget.isError) {
      return Icon(
        Icons.report_problem_rounded,
        size: 70,
        color: Colors.grey[350],
      );
    } else if (_videoCompleted()) {
      return Icon(
        Icons.replay_rounded,
        size: 70,
        color: Colors.grey[350],
      );
    } else if (!widget.videoController.value.isPlaying) {
      return Icon(
        Icons.play_arrow_rounded,
        size: 80,
        color: Colors.grey[350],
      );
    } else if (widget.videoController.value.isPlaying) {
      return Icon(
        Icons.pause,
        size: 70,
        color: Colors.grey[350],
      );
    }
    return Icon(
      Icons.report_problem_rounded,
      size: 70,
      color: Colors.grey[350],
    );
  }

  void _syncAV() async {
    if (_videoCompleted()) {
      await widget.audioController.pause();
      if (widget.videoController.value.isPlaying) {
        await widget.videoController.pause();
      }
      // this.setState(() {
      //   _videoComplete = true;
      // });
    }
  }

  Widget _playerControlsparent() {
    if (widget.videoController.value.isBuffering && !_videoCompleted() ||
        !widget.isInit) {
      return CircularProgressIndicator();
    }
    return InkWell(
      onTap: () async {
        if (widget.isInit && !widget.isError) {
          if (_videoCompleted()) {
            _audiomsgshown = true;
            await widget.videoController.seekTo(const Duration(seconds: 0));
            // widget.audioController.seek(Duration(seconds: 0));
            await widget.audioController.stop();
            // this.setState(() {
            //   _videoComplete = false;
            // });
          }
          if (widget.videoController.value.isPlaying) {
            await widget.videoController.pause();
            await widget.audioController.pause();
            this.setState(() {});
            // this.setState(() {
            //   _isplaying = false;
            // });
            return;
          }
          await widget.videoController.play();
          await widget.audioController.resume();
          // this.setState(() {
          //   _isplaying = true;
          // });
        }
      },
      child: _playerControls(),
    );
  }

  // int _handleErrorProgress() {
  //   if (widget.videoController.value.duration.inSeconds <= 0) {
  //     return 10;
  //   }
  //   return widget.videoController.value.duration.inSeconds;
  // }

  void callSnackBar(BuildContext context, String msg) {
    try {
      final snackBar = SnackBar(
        duration: Duration(seconds: 5),
        content: Text(
          msg,
          style: TextStyle(fontSize: 15),
          // textAlign: TextAlign.center,
        ),
        action: SnackBarAction(
          label: 'Hide',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      );
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        snackBar,
      );
    } catch (e) {
      // print(e);
      print('error in snackbar <Digested>');
    }
  }

  // void _syncAudioVideo() async {
  //   if (widget.videoController.value.isBuffering && !_isbuffering) {
  //     _isbuffering = true;
  //     await widget.audioController.pause();
  //   } else if (!widget.videoController.value.isBuffering && _isbuffering) {
  //     _isbuffering = false;
  //     await widget.audioController.resume();
  //   }
  // }

  void _syncAudioVideo() async {
    if (widget.videoController.value.isBuffering) {
      await widget.audioController.pause();
    } else if (!widget.videoController.value.isBuffering) {
      await widget.audioController.resume();
    }
  }

  void _errorListner() async {
    // print('listning');
    // print(widget.isError);
    if (widget.audioError && !_audiomsgshown) {
      callSnackBar(context, 'Failed to load audio file');
      _audiomsgshown = true;
      return;
    }
    if (widget.isError) {
      if (widget.videoController.value.isPlaying) {
        await widget.videoController.pause();
      }
      await widget.audioController.pause();
      this.setState(() {});
      return;
    }
    if (widget.videoController.value.hasError && !_videomsgshown) {
      _videomsgshown = true;
      callSnackBar(context, 'Failed to load video file');
      await widget.audioController.pause();
    }
  }

  void _enterFullScreen() {
    widget.enterfs();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
    );
    double nprog = _progressCalc(
      height - 24,
      (width - 24).toInt(),
      _seekPos.toInt(),
    );
    this.setState(() {
      double tmp = height;
      height = width;
      width = tmp;
      _seekPos = nprog;
      _isFullScreen = true;
    });
  }

  void _exitFullScreen() {
    widget.exitfs();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    double nprog = _progressCalc(
      height - 24,
      (width - 24).toInt(),
      _seekPos.toInt(),
    );
    this.setState(() {
      double tmp = width;
      width = height;
      height = tmp;
      _seekPos = nprog;
      _isFullScreen = false;
    });
  }

  @override
  void initState() {
    super.initState();
    widget.videoController.addListener(_seekHandler);
    widget.videoController.addListener(_errorListner);
    widget.videoController.addListener(_syncAV);
    widget.videoController.addListener(_syncAudioVideo);
    Future.delayed(Duration.zero, () {
      final mq = MediaQuery.of(context).size;
      height = mq.height;
      width = mq.width;
    });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    widget.videoController.removeListener(_syncAV);
    widget.videoController.removeListener(_errorListner);
    widget.videoController.removeListener(_seekHandler);
    widget.videoController.removeListener(_syncAudioVideo);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var handle = Provider.of<ProviderState>(context);
    // if (handle.getError) {
    //   WidgetsBinding.instance?.addPostFrameCallback((_) {
    //     widget.videoController.pause();
    //     this.setState(() {});
    //   });
    // }
    int buffered = 0;
    try {
      buffered = widget.videoController.value.buffered.first.end.inSeconds;
    } catch (_) {}
    return GestureDetector(
      onTap: () {
        this.setState(() {
          _showControls = !_showControls;
        });
      },
      child: _showControls
          ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black87,
                    Colors.black12,
                    Colors.black12,
                    Colors.black87,
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Positioned(
                  //   top: height * 0.23,
                  //   left: 0,
                  //   right: 0,
                  //   child:
                  // ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ' ',
                        style: TextStyle(
                            // color: Colors.white,
                            // fontWeight: FontWeight.bold,
                            fontSize: 50),
                      ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      _playerControlsparent(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  '${_formatDuration(widget.videoController.value.position)} / ${_formatDuration(widget.videoController.value.duration)}',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (_isFullScreen) {
                                    _exitFullScreen();
                                    return;
                                  }
                                  _enterFullScreen();
                                  // widget.pushvideo(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Icon(
                                    _isFullScreen
                                        ? Icons.fullscreen_exit_rounded
                                        : Icons.fullscreen_rounded,
                                    size: 30,
                                    color: Colors.grey[350],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // SizedBox(
                          //   height: 7,
                          // ),
                          GestureDetector(
                            onPanUpdate: (details) async {
                              if (widget.isInit && !widget.isError) {
                                double posSeek = details.localPosition.dx;
                                double posTime = _progressCalc(
                                  widget
                                      .videoController.value.duration.inSeconds
                                      .toDouble(),
                                  (width - 24).toInt(),
                                  posSeek.toInt(),
                                );
                                if (posSeek > width - 24) {
                                  //clamping the values
                                  posSeek = width - 24;
                                }
                                Duration std = _secondsToDuration(posTime);
                                if (std >
                                    widget.videoController.value.duration) {
                                  //clamping the values
                                  posTime = widget
                                      .videoController.value.duration.inSeconds
                                      .toDouble();
                                  std = _secondsToDuration(posTime);
                                }
                                await widget.videoController.seekTo(
                                  std,
                                );
                                await widget.audioController.seek(
                                  std,
                                );
                                // widget.audioController.onSeekComplete
                                //     .listen((_) {
                                //   this.setState(() {
                                //     _seekPos = details.localPosition.dx;
                                //     _localbuffering = true;
                                //   });
                                // });
                                this.setState(() {
                                  _seekPos = details.localPosition.dx;
                                });
                              }
                            },
                            onPanStart: (_) {
                              if (widget.videoController.value.isPlaying &&
                                  !widget.isError) {
                                widget.videoController.pause();
                                widget.audioController.pause();
                              }
                            },
                            onPanEnd: (_) {
                              if (!widget.isError) {
                                widget.videoController.play();
                                widget.audioController.resume();
                              }
                            },
                            child: Container(
                              height: 40,
                              // width: width - 24,
                              decoration: BoxDecoration(
                                color: Colors.black45,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              margin: EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    //custom progress bar on the way xD
                                    width: width - 24,
                                    height: 3,
                                    color: Colors.white24,
                                    child: Stack(
                                      // clipBehavior: Clip.none,
                                      children: [
                                        Container(
                                          width:
                                              widget.isError || !widget.isInit
                                                  ? 0
                                                  : _progressCalc(
                                                      width - 24,
                                                      widget
                                                          .videoController
                                                          .value
                                                          .duration
                                                          .inSeconds,
                                                      buffered,
                                                    ),
                                          decoration: BoxDecoration(
                                            color: Colors.white24,
                                          ),
                                        ),
                                        Container(
                                          width: _seekPos,
                                          decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    left: _seekPos,
                                    child: Container(
                                      height: 18,
                                      width: 18,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          //code injection 2.3
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
          : null,
    );
  }
}

///////////////////////////////////
//////[code injection 2.3]/////////
///////////////////////////////////
// SizedBox(
//   height: 8,
// ),
// Container(
//   child: SliderTheme(
//     data: SliderThemeData(),
//     child: Slider(
//       value: _seek.inSeconds.floorToDouble(),
//       min: 0,
//       divisions: _handleErrorProgress(),
//       label: _formatDuration(
//         _secondsToDuration(
//           widget.videoController.value.position
//               .inSeconds
//               .floorToDouble(),
//         ),
//       ),
//       max: widget
//           .videoController.value.duration.inSeconds
//           .floorToDouble(),
//       onChangeStart: (_) {
//         widget.videoController.pause();
//       },
//       onChangeEnd: (_) {
//         widget.videoController.play();
//       },
//       onChanged: (double value) {
//         widget.videoController.seekTo(
//           _secondsToDuration(value),
//         );
//         this.setState(() {
//           _seek = _secondsToDuration(value);
//         });
//       },
//     ),
//   ),
// ),
////////////////////////////////////////
/////////[code injection ends]//////////
////////////////////////////////////////


////////////////////////////////////////
///                                 ///
///////////////////////////////////////
//   void pushFullScreenVideo(BuildContext cntxt) {
// //This will help to hide the status bar and bottom bar of Mobile
// //also helps you to set preferred device orientations like landscape
//     SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
//     SystemChrome.setEnabledSystemUIOverlays([]);
//     SystemChrome.setPreferredOrientations(
//       [
//         DeviceOrientation.landscapeLeft,
//         DeviceOrientation.landscapeRight,
//       ],
//     );
// //This will help you to push fullscreen view of video player on top of current page
//     Navigator.of(cntxt)
//         .push(
//       PageRouteBuilder(
//         opaque: false,
//         settings: RouteSettings(),
//         pageBuilder: (
//           BuildContext context,
//           Animation<double> animation,
//           Animation<double> secondaryAnimation,
//         ) {
//           return Scaffold(
//             backgroundColor: Colors.transparent,
//             resizeToAvoidBottomInset: false,
//             body: Dismissible(
//               key: const Key('key'),
//               direction: DismissDirection.vertical,
//               onDismissed: (_) => Navigator.of(context).pop(),
//               child: OrientationBuilder(
//                 builder: (context, orientation) {
//                   bool isPortrait = orientation == Orientation.portrait;
//                   return Center(
//                     child: Stack(
//                       //This will help to expand video in Horizontal mode till last pixel of screen
//                       fit: isPortrait ? StackFit.loose : StackFit.expand,
//                       children: [
//                         AspectRatio(
//                           aspectRatio: _videoController.value.aspectRatio,
//                           child: Stack(children: [
//                             VideoPlayer(_videoController),
//                             // AVControls(
//                             //   videoController: _videoController,
//                             //   audioController: _audioController,
//                             //   isError: _isError,
//                             //   isInit: _isInit,
//                             //   audioError: _audioError,
//                             //   pushvideo: pushFullScreenVideo,
//                             // ),
//                           ]),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           );
//         },
//       ),
//     )
//         .then(
//       (value) {
// //This will help you to set previous Device orientations of screen so App will continue for portrait mode
//         SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
//         SystemChrome.setPreferredOrientations(
//           [
//             DeviceOrientation.portraitUp,
//             DeviceOrientation.portraitDown,
//           ],
//         );
//       },
//     );
//   }
////////////////////////////////////////
///                                 ///
///////////////////////////////////////