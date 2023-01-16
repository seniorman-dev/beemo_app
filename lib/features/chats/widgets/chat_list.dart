import 'package:beemo/common/enums/message_enum.dart';
import 'package:beemo/common/providers/message_reply_provider.dart';
import 'package:beemo/common/widgets/colors.dart';
import 'package:beemo/common/widgets/loader.dart';
import 'package:beemo/features/chats/controller/chat_controller.dart';
import 'package:beemo/features/chats/repository/chat_repository.dart';
import 'package:beemo/features/chats/widgets/display_text_image_gif.dart';
import 'package:beemo/models/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';





class ChatList extends ConsumerStatefulWidget {
  const ChatList({Key? key, required this.receiverUserId, required this.name}) : super(key: key);
  final String receiverUserId;
  final String name;

  @override
  ConsumerState<ChatList> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {

  //it makes messages list automatically scroll up after a message has been sent
  final ScrollController messageController = ScrollController();
  @override
  void dispose() {
    // TODO: implement dispose
    messageController.dispose();
    super.dispose();
  }

  void onMessageSwipe(String message, bool isMe, MessageEnum messageEnum) {
    ref.read(messageReplyProvider.notifier).update((state) => MessageReply(message, isMe, messageEnum, auth));
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  //final dismissKey = GlobalKey();


  /*@override
  void initState() {
    //ref.read(chatControllerProvider).chatStream(widget.receiverUserId);
    super.initState();
  }

  Stream<List<Message>> getCurrentChatStream() {
    //ref.watch(chatControllerProvider).chatContacts();
    return ChatRepository(auth: auth, firestore: firestore)
    .getChatStream(widget.receiverUserId);
  }*/


  @override
  Widget build(BuildContext context,) {

    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: StreamBuilder<List<Message>>(
        //ref.read
        stream: /*firestore.collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(widget.receiverUserId)
          .collection('messages')
          .orderBy('timeSent')
          .snapshots()
          .map(
            (event) {
            List<Message> messages = [];

            for(var document in event.docs) {
              messages.add(Message.fromMap(document.data()));
            }
            return messages;

         }
        ),*/
        ref.read(chatControllerProvider).chatStream(widget.receiverUserId),
        //getCurrentChatStream(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Loader();
          }
          else if(snapshot.hasData) {
            //it makes messages list automatically scroll up after a message has been sent
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              messageController.jumpTo(messageController.position.maxScrollExtent);
            });
            return ListView.builder(
              padding: EdgeInsets.all(8),
              //reverse: true,
              controller: messageController,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              //separatorBuilder: (context, index) {
                //return SizedBox(height: 5,);
              //},
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {

                final messageData = snapshot.data![index];
                final isReplying = messageData.repliedMessage.isNotEmpty;
                //below is the logic for seen feature
                if(!messageData.isSeen && messageData.receiverId == FirebaseAuth.instance.currentUser!.uid) {
                  ref.read(chatControllerProvider).setChatMessageSeen(widget.receiverUserId, messageData.messageId);
                }

                ////////Message Card
                return Dismissible(
                  key: UniqueKey(), //Key("item $messageData"),  //ValueKey(messageData) or UniqueKey()
                  background: Icon(Icons.reply_rounded, size: 18, color: greyColor,),
                  onDismissed: (direction) {
                    if(direction == DismissDirection.endToStart && messageData.senderId == FirebaseAuth.instance.currentUser!.uid) {
                      ref.read(chatControllerProvider).deleteTextMessage(widget.receiverUserId, messageData.messageId);
                      setState(() {
                        snapshot.data!.removeAt(index);
                      });
                      print('My Own Message Deleted from firestore');
                    }
                    else if(direction == DismissDirection.startToEnd && messageData.senderId == FirebaseAuth.instance.currentUser!.uid) {
                      onMessageSwipe(messageData.text, true, messageData.type);
                      print('Swiped to reply chat buddy');
                    }
                    else if(direction == DismissDirection.endToStart && messageData.senderId != FirebaseAuth.instance.currentUser!.uid) {
                      onMessageSwipe(messageData.text, true, messageData.type);
                      print('Swiped to reply chat buddy');
                    }
                    else if(direction == DismissDirection.startToEnd && messageData.senderId != FirebaseAuth.instance.currentUser!.uid) {
                      ref.read(chatControllerProvider).deleteTextMessage(widget.receiverUserId, messageData.messageId);
                      setState(() {
                        snapshot.data!.removeAt(index);
                      });
                      print('Receiver Message Deleted from firestore');
                    }
                    else {
                      //onMessageSwipe(messageData.text, true, messageData.type);
                      print('cool stuffffff');
                    }
                  },
                  child: Align(
                    alignment: 
                    // ignore: unrelated_type_equality_checks
                    messageData.senderId == FirebaseAuth.instance.currentUser!.uid
                    ? Alignment.bottomRight
                    : Alignment.bottomLeft,
                    child: Card(
                      color:
                      messageData.senderId == FirebaseAuth.instance.currentUser!.uid
                      ? messageColor 
                      : senderMessageColor,
                      shape: 
                      messageData.senderId == FirebaseAuth.instance.currentUser!.uid
                      ? RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15)
                        )
                      )
                      : RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomRight: Radius.circular(15)
                        )
                      ),
                      elevation: 8,
                      child: Padding(
                        padding: messageData.type == MessageEnum.text
                        ?EdgeInsets.all(12)
                        :EdgeInsets.only(
                          left: 5,
                          top: 5,
                          right: 5,
                          bottom: 25,
                        ),
                        ///////Wrap with center if need be
                        child: Column(
                          //crossAxisAlignment: CrossAxisAlignment.center,
                          children: [                   
                            ///if statements will only all us to pass in one widget but with cascade operator, we can  pass in multiple widgets
                            if(isReplying)...[
                              /////figure out the username 
                              //Text(widget.name, style: GoogleFonts.comfortaa(fontWeight: FontWeight.w900, color: textColor)),
                              SizedBox(height: 3,),
                              Container(
                                decoration: BoxDecoration(
                                  color: backgroundColor.withOpacity(0.5),
                                  borderRadius: BorderRadius.all(Radius.circular(5))
                                ),
                                padding: EdgeInsets.all(10),
                                child: DisplayTextImageGIF(message: messageData.repliedMessage, type: messageData.repliedMessageType),
                              ),
                              SizedBox(height: 8,),

                            ],
                            ///////
                            DisplayTextImageGIF(message: messageData.text, type: messageData.type),
                            SizedBox(height: 5,),
                            //find a way to align this later                        
                            SizedBox(
                              width: 70,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [

                                  Text(
                                    textAlign: messageData.senderId == FirebaseAuth.instance.currentUser!.uid
                                    ? TextAlign.right
                                    : TextAlign.left,
                                    DateFormat('hh:mm').format(messageData.timeSent),
                                    style: GoogleFonts.comfortaa(fontSize: 14, fontWeight: FontWeight.normal, color: textColor)
                                  ),
                                  SizedBox(width: 10),
                                  Icon(
                                    messageData.isSeen && messageData.senderId == FirebaseAuth.instance.currentUser!.uid
                                    ? Icons.done_all_rounded
                                    : messageData.senderId == FirebaseAuth.instance.currentUser!.uid ? Icons.done_rounded : null,
                                    size: 20,
                                    color: 
                                    messageData.isSeen && messageData.senderId == FirebaseAuth.instance.currentUser!.uid
                                    ? backgroundColor
                                    : messageData.senderId == FirebaseAuth.instance.currentUser!.uid ? Colors.white60 : null,
                                  ),
                            
                                ],
                              ),
                            ),          
                          
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            );
          }
          else if(snapshot.hasError) {
            print('${snapshot.error}');
            return Center(child: CircularProgressIndicator(strokeWidth: 3, color: Colors.red,),);
          }
          else {
            return Text('something went wrong...', style: GoogleFonts.comfortaa(color: textColor),); //Center(child: CircularProgressIndicator(strokeWidth: 3, color: Colors.red,),);
          }
        }
      )
    );
  }

}