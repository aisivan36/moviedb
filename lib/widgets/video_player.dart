import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late YoutubePlayerController controller;
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    controller = YoutubePlayerController(
        initialVideoId: widget.id, flags: const YoutubePlayerFlags());
  }

  @override
  void dispose() {
    controller.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [
        SystemUiOverlay.top,
        SystemUiOverlay.bottom,
      ],
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black45,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ColoredBox(
            color: Colors.black,
            child: YoutubePlayer(
              controller: controller,
              fullscreenButton: IconButton(
                  icon: const Icon(
                    Icons.fullscreen_exit,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    SystemChrome.setPreferredOrientations([
                      DeviceOrientation.portraitUp,
                      DeviceOrientation.portraitDown,
                    ]);
                    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                        overlays: [
                          SystemUiOverlay.top,
                          SystemUiOverlay.bottom
                        ]);
                    Future.delayed(const Duration(seconds: 1), () {
                      Navigator.pop(context);
                    });
                  }),
              showVideoProgressIndicator: true,
              progressColors: const ProgressBarColors(
                playedColor: Colors.amber,
                handleColor: Colors.blueGrey,
              ),
              onEnded: (youtube) {
                SystemChrome.setPreferredOrientations(
                  [
                    DeviceOrientation.portraitUp,
                    DeviceOrientation.portraitDown,
                  ],
                );

                SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                    overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
                Future.delayed(
                  const Duration(seconds: 1),
                  () {
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
