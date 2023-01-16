import 'package:beemo/common/providers/message_reply_provider.dart';
import 'package:beemo/common/widgets/colors.dart';
import 'package:beemo/features/chats/widgets/display_text_image_gif.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';


class MessageReplyPreview extends ConsumerWidget {
  const MessageReplyPreview({super.key});

  void cancelReply(WidgetRef ref) {
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageReply = ref.watch(messageReplyProvider);
    return Container(
      decoration: BoxDecoration(
        //shape: BoxShape.circle,
        color: backgroundColor.withOpacity(0.5),  //Colors.transparent,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        )
      ),
      width: 350,
      padding: EdgeInsets.all(8),
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 5,),
          /*Row(
            children: [
              Expanded(
                child: Text(
                  messageReply!.isMe && messageReply.auth == FirebaseAuth.instance.currentUser!.uid
                  ? '' //Me
                  : '',  //Receiver
                  style: GoogleFonts.comfortaa(color: textColor, fontWeight: FontWeight.w900),
                )
              ),
              InkWell(
                onTap: () {cancelReply(ref);},
                child: const Icon(Icons.close_rounded, size: 18, color: textColor,) //16
              )
            ],
          ),*/
          //SizedBox(height: 10,),
          //if this doesn't work, make crossAxis to start
          //Align(
            //alignment: Alignment.bottomLeft,
            //child: DisplayTextImageGIF(message: messageReply!.message, type: messageReply.messageEnum,)
          //),
          /////////////
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.bottomLeft,
                child: DisplayTextImageGIF(message: messageReply!.message, type: messageReply.messageEnum,)
              ),
              InkWell(
                onTap: () {cancelReply(ref);},
                child: const Icon(Icons.close_rounded, size: 18, color: textColor,) //16
              )
            ],
          )
        ],
      )
    );
  }


}