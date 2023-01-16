import 'dart:io';

import 'package:beemo/common/enums/message_enum.dart';
import 'package:beemo/common/providers/message_reply_provider.dart';
import 'package:beemo/common/utils/utils.dart';
import 'package:beemo/common/widgets/colors.dart';
import 'package:beemo/features/chats/controller/chat_controller.dart';
import 'package:beemo/features/chats/widgets/message_reply_preview.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';





class BottomChatField extends ConsumerStatefulWidget {
  const BottomChatField({Key? key, required this.receiverUserId}) : super(key: key);
  final String receiverUserId;

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  final formKey = GlobalKey<FormState>();
  final textController = TextEditingController();
  bool isShowEmojiContainer = false;
  bool isShowSendButton = false;
  bool isRecorderInitialized = false;
  bool isRecording = false;
  FocusNode focusNode = FocusNode(); //keeps track of the keyboard for emoji and texting purposes
  FlutterSoundRecorder? _soundRecorder;

  @override
  void initState() {
    // TODO: implement initState
    _soundRecorder = FlutterSoundRecorder();
    openAudio();
    super.initState();
  }
  //for recording audio
  void openAudio() async{
    final status = await Permission.microphone.request();
    if(status != PermissionStatus.granted) {
      //throw RecordingPermissionException('Mic Permission denied!');
      print ('Mic Permission denied!');
      Get.snackbar('Uh oh!', "Mic permission denied!", duration: Duration(seconds: 3), isDismissible: false, colorText: Colors.black, borderRadius: 10, backgroundColor: Colors.white, snackPosition: SnackPosition.BOTTOM, dismissDirection: DismissDirection.down);
    }
    await _soundRecorder!.openRecorder();
    isRecorderInitialized = true;
  }




  Future sendTextMessage() async{ //change to void if any
    if(isShowSendButton) {
      ref.read(chatControllerProvider).sendTextMessage(textController.text.trim(), widget.receiverUserId);
      //uncomment this if you want to change to 'void'
      /*setState(() {
        textController.text = '';
      });*/
    }
    else {
      /////everything here is for audio
      //path variable
      var tempDirectory = await getTemporaryDirectory();
      var path = '${tempDirectory.path}/flutter_sound.aac';
      if(!isRecorderInitialized) {
        return;
      }
      if(isRecording) {
        await _soundRecorder!.stopRecorder();
        sendFileMessage(File(path), MessageEnum.audio);
      }
      else {
        await _soundRecorder!.startRecorder(
          toFile: path,
        );
      }
      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  //for sending images
  void sendFileMessage(
    File file,
    MessageEnum messageEnum
  ) {
    ref.read(chatControllerProvider).sendFileMessage(file, widget.receiverUserId, messageEnum);
  }
  void selectImage() async{
    File? image = await pickImageFromGallery();
    if(image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  //for sending videos
  void selectVideo() async{
    File? video = await pickVideoFromGallery();
    if(video != null) {
      sendFileMessage(video, MessageEnum.video);
    }
  }

  //for sending GIFs or Stickers(use in when you want to)
  /*void selectSticker() async{
    final gif = await pickGIF(context);
    if(gif != null) {
      ref.read(chatControllerProvider).sendSticker(context, gif.url, widget.receiverUserId);
    }
  }*/

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
    _soundRecorder!.closeRecorder();
    isRecorderInitialized = false;
  }

  void hideEmojiContainer() {
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  void showEmojiContainer() {
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  void showKeyboard() {
    focusNode.requestFocus();
  }

  void hideKeyboard() {
    focusNode.unfocus();
  }

  void toggleEmojiKeyboardContainer() {
    if(isShowEmojiContainer) {
      showKeyboard();
      hideEmojiContainer();
    }
    else {
      hideKeyboard();
      showEmojiContainer();
    }
  }


  @override
  Widget build(BuildContext context) {

    final messageReply = ref.watch(messageReplyProvider);
    final isShowMessageReply = messageReply != null;

    return SizedBox(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Column(      ////hmmmmm
          children: [
            isShowMessageReply ? MessageReplyPreview() : SizedBox(),
            Row(  
              children: [
                Expanded(
                  child: TextFormField(
                    key: formKey,
                    focusNode: focusNode,
                    controller: textController,
                    keyboardType: TextInputType.text,
                    autocorrect: true,
                    enableSuggestions: true,
                    enableInteractiveSelection: true,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(                      
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2.0),
                        borderRadius: BorderRadius.all(
                          const Radius.circular(30.0),
                        ),
                      ),
                      hintText: 'Type a message...',
                      hintStyle: TextStyle(color: Colors.grey),
                      prefixIcon: InkWell(
                        onTap: () {
                          toggleEmojiKeyboardContainer();
                        },
                        child: SizedBox(
                          width: 50,
                          child: Icon(
                            isShowEmojiContainer 
                            ? CupertinoIcons.keyboard_chevron_compact_down
                            : Icons.emoji_emotions_rounded,
                            color: greyColor
                          ),
                        ),
                      ),
                      suffixIcon: SizedBox(
                        //padding: EdgeInsets.symmetric(horizontal: 20),
                        width: 100,
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {
                                selectImage();
                                //pickerDialogueBox();
                              }, 
                              icon: Icon(Icons.camera_alt_rounded),
                              color: Colors.grey,
                            ),
                            IconButton(
                              onPressed: () {
                                selectVideo();
                              }, 
                              icon: Icon(Icons.attach_file_rounded),  //Icons.attach_file_rounded
                              color: Colors.grey,
                            )
                          ]
                        ),
                      ),
                                        
                      //labelStyle: TextStyle(color: Colors.grey),
                      //labelText: 'Type a message....',
                      //filled: true,
                      //fillColor: Colors.grey,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2.0),
                        borderRadius: BorderRadius.all(
                          const Radius.circular(30.0),
                        ),
                      ),
                      contentPadding: EdgeInsets.all(10)                 
                    ),
                    //onFieldSubmitted: (val) {},
                    onChanged: (val) {
                      if(val.isNotEmpty) {
                        setState(() {
                          isShowSendButton = true;
                        });
                      }
                      else {
                        setState(() {
                          isShowSendButton = false;
                        });
                      }
                    },
                  ),
                ),
                isShowSendButton 
                ?InkWell(
                  onTap: () {
                    sendTextMessage().whenComplete(() => textController.clear());
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8, right:  2, left: 4), //left: 2
                    child: Container(
                      width: 60, 
                      height: 40, //40
                      decoration: BoxDecoration(
                        color: tabColor,
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Center(child: Icon(Icons.send_rounded, color: textColor))
                    ),
                  ),
                )
                :InkWell(
                  onLongPress: () {
                    sendTextMessage();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8, right:  2, left: 4), //left: 2
                    child: CircleAvatar(
                      backgroundColor: isRecording 
                      ?textColor
                      :tabColor,
                      radius: 23,
                      child: Icon(
                        isRecording
                        ?Icons.done_rounded
                        :Icons.mic_rounded ,
                        color: isRecording 
                        ?tabColor
                        :textColor
                      )
                    ),
                  ),
                ),
              ],
            ),
            /////
            isShowEmojiContainer
            ?SizedBox(
              height: 200, //250
              child: EmojiPicker(
                onEmojiSelected: (category, emoji) {
                  setState(() {
                    textController.text = textController.text + emoji.emoji;
                  });
                  //set showSendButton to true
                  if(!isShowSendButton) {
                    setState(() {
                      isShowSendButton = true;
                    });
                  }
                },
              ),
            )
            : SizedBox(),
            /////
          ],
        ),
      ),
    );
  }


  ///dialog for selecting image or video
  void pickerDialogueBox() {
    Get.defaultDialog(
      barrierDismissible: true,
      title: 'Select Item',
      titleStyle: GoogleFonts.comfortaa(color: textColor, fontWeight: FontWeight.w900, fontSize: 18,),
      titlePadding: EdgeInsets.only(top: 10, bottom: 10),
      backgroundColor: backgroundColor,
      content: Text('choose an item you wish to send', style: GoogleFonts.comfortaa(color: textColor, fontWeight: FontWeight.w600, fontSize: 15,)),
      contentPadding: EdgeInsets.all(10),
      confirm: SizedBox(
        height: 50, 
        width: 200, //double.infinity,
        child: ElevatedButton(
          onPressed: () {
            selectImage();
            //Get.back();
          }, 
          child: Text('Image', style: GoogleFonts.comfortaa(fontSize: 20, color: textColor)),
          style: ElevatedButton.styleFrom(
            //shadowColor: Colors.white,
            foregroundColor: tabColor, 
            backgroundColor: tabColor,
            elevation: 2,
            //surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              //side: BorderSide(
                //color: Colors.black,
                //style: BorderStyle.solid
              //)
            )
          ),
        ),
      ),
      cancel: SizedBox(
        height: 50, 
        width: 200, //double.infinity,
        child: ElevatedButton(
          onPressed: () {
            selectVideo();
            //Get.back();
          }, 
          child: Text('Video', style: GoogleFonts.comfortaa(fontSize: 20, color: textColor)),
          style: ElevatedButton.styleFrom(
            //shadowColor: Colors.white,
            foregroundColor: tabColor, 
            backgroundColor: tabColor,
            elevation: 2,
            //surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              //side: BorderSide(
                //color: Colors.black,
                //style: BorderStyle.solid
              //)
            )
          ),
        ),
      ),
    );
  }


}