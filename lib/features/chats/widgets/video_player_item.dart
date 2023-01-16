import 'package:beemo/common/widgets/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_video_player/cached_video_player.dart';



class VideoPlayerItem extends StatefulWidget {
  const VideoPlayerItem({Key? key, required this.videoUrl}) : super(key: key);
  final String videoUrl;

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {

  bool isPlay = false;

  late CachedVideoPlayerController videoPlayerController;

  @override
  void initState() {
    // TODO: implement initState
    videoPlayerController = CachedVideoPlayerController
    .network(widget.videoUrl)
    ..initialize()
    .then(
      (value) {
        videoPlayerController.setVolume(1);
      }
    );
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16/9,
      child: Stack(
        children: [
          CachedVideoPlayer(videoPlayerController),
          Align(
            alignment: Alignment.center,
            child: IconButton(
              onPressed: () {
                if(isPlay ){
                  videoPlayerController.pause();
                }
                else{
                  videoPlayerController.play();
                }
                setState(() {
                  isPlay = !isPlay;
                });
              }, 
              icon: Icon(
                isPlay 
                ?CupertinoIcons.play_circle
                :CupertinoIcons.pause_circle, 
                color: textColor,
              )
            ),
          )
        ],
      ),
    );
  }
}