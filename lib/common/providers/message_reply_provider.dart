import 'package:beemo/common/enums/message_enum.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class MessageReply {
  final String message;
  final bool isMe;
  final MessageEnum messageEnum;
  final FirebaseAuth auth;


  MessageReply(this.message, this.isMe, this.messageEnum, this.auth);
   
}

final messageReplyProvider = StateProvider<MessageReply?>((ref) => null);