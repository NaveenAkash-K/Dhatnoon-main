// import 'dart:io';
// import 'package:components/utils/tabBar.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:video_player/video_player.dart';

// class VideoPage extends StatefulWidget {
//   VideoPage({required this.videoLink, required this.videoMode});

//   final String videoLink;

//   final String videoMode;

//   @override
//   _VideoPageState createState() => _VideoPageState();
// }

// class _VideoPageState extends State<VideoPage> {
//   late VideoPlayerController controller;

//   @override
//   void initState() {
//     loadVideoPlayer();
//     super.initState();
//   }

//   loadVideoPlayer() async {
//     controller = VideoPlayerController.network(widget.videoLink);
//     print(widget.videoLink);
//     try {
//       await controller.initialize();
//     } catch (e) {
//       print("Error initializing video player: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("${widget.videoMode} Camera video"),
//         backgroundColor: Colors.purple,
//       ),
//       body: Container(
//           child: Column(children: [
//         Expanded(
//           child: AspectRatio(
//             aspectRatio: controller.value.aspectRatio,
//             child: VideoPlayer(controller),
//           ),
//         ),
//         Container(
//           //duration of video
//           child:
//               Text("Total Duration: " + controller.value.duration.toString()),
//         ),
//         Container(
//             child: VideoProgressIndicator(controller,
//                 allowScrubbing: true,
//                 colors: VideoProgressColors(
//                   backgroundColor: Colors.redAccent,
//                   playedColor: Colors.green,
//                   bufferedColor: Colors.purple,
//                 ))),
//         Container(
//           child: Row(
//             children: [
//               IconButton(
//                   onPressed: () {
//                     if (controller.value.isPlaying) {
//                       controller.pause();
//                     } else {
//                       controller.play();
//                     }

//                     setState(() {});
//                   },
//                   icon: Icon(controller.value.isPlaying
//                       ? Icons.pause
//                       : Icons.play_arrow)),
//               IconButton(
//                   onPressed: () {
//                     controller.seekTo(Duration(seconds: 0));

//                     setState(() {});
//                   },
//                   icon: Icon(Icons.stop))
//             ],
//           ),
//         )
//       ])),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPage extends StatefulWidget {
  VideoPage({required this.videoLink, required this.videoMode});

  final String videoLink;
  final String videoMode;

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoLink));
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 16 / 9, // You can adjust the aspect ratio as needed
      autoPlay: true,
      looping: false,
      // You can customize the appearance here
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.red,
        handleColor: Colors.blue,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.lightGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text("${widget.videoMode} Camera video"),
          backgroundColor: Colors.purple,
        ),
        body: Center(
          child: Chewie(
            controller: _chewieController,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _videoPlayerController.value.isPlaying
                  ? _videoPlayerController.pause()
                  : _videoPlayerController.play();
            });
          },
          child: Icon(
            _videoPlayerController.value.isPlaying
                ? Icons.pause
                : Icons.play_arrow,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
    _chewieController.dispose();
  }
}
