import 'package:beemo/common/enums/message_enum.dart';
import 'package:beemo/common/widgets/colors.dart';
import 'package:beemo/features/chats/widgets/video_player_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:audioplayers/audioplayers.dart';



class DisplayTextImageGIF extends StatefulWidget {
  DisplayTextImageGIF({Key? key, required this.message, required this.type}) : super(key: key);
  final String message;
  final MessageEnum type;

  @override
  State<DisplayTextImageGIF> createState() => _DisplayTextImageGIFState();
}

class _DisplayTextImageGIFState extends State<DisplayTextImageGIF> {
  @override
  Widget build(BuildContext context) {
    ////boolean & AudioPlayer for playing audio
    bool isPlaying = false;
    final AudioPlayer audioPlayer = AudioPlayer();
    return widget.type == MessageEnum.text
    ?Text(
      widget.message, 
      style: GoogleFonts.comfortaa(fontSize: 14, fontWeight: FontWeight.w700, color: textColor)
    ) 
    :widget.type == MessageEnum.audio  
      ?StatefulBuilder(
        builder: (context, setState) {
          return IconButton(
            constraints: BoxConstraints(
              minWidth: 250
            ),
            onPressed: () async{
              if(isPlaying) {
                //don't mind the dead code,it's because of StatelessWidget
                await audioPlayer.pause();
                setState(() {
                  isPlaying = false;
                });
              }
              else {
                await audioPlayer.play(UrlSource(widget.message));
                setState(() {
                  isPlaying = true;
                });
              }
            }, 
            icon: Icon(
              isPlaying
              ?CupertinoIcons.pause_circle
              :CupertinoIcons.play_circle
            )
          );
        }
      )
      :widget.type == MessageEnum.video
        ?VideoPlayerItem(videoUrl: widget.message)
        :widget.type == MessageEnum.gif 
          ?CachedNetworkImage(imageUrl: widget.message)
          :CachedNetworkImage(imageUrl: widget.message);
  }
}