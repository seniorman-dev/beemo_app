import 'dart:io';

import 'package:beemo/common/enums/message_enum.dart';
import 'package:beemo/common/providers/message_reply_provider.dart';
import 'package:beemo/features/auth/controllers/auth_controller.dart';
import 'package:beemo/features/auth/repository/firebase_auth.dart';
import 'package:beemo/features/chats/repository/chat_repository.dart';
import 'package:beemo/models/chat_contact.dart';
import 'package:beemo/models/message.dart';
import 'package:beemo/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';



final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(ref: ref, chatRepository: chatRepository);
});


class ChatController {

  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({required this.chatRepository, required this.ref});

  // for adding "seen" feature in chats
  void setChatMessageSeen(String receiverUserId, String messageId) {
    chatRepository.setChatMessageSeen(receiverUserId, messageId);
  }

  //for sending texts
  void sendTextMessage(String text, String receiverUserID) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider)
    .whenData(
      (value) => chatRepository.sendTextMessage(text: text, receiverUserID: receiverUserID, senderUser: value!, messageReply: messageReply)
    );
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }
  
  Stream<List<Message>> chatStream(String receiverUserId) {
    return chatRepository.getChatStream(receiverUserId);
  }

  Stream<List<ChatContact>> chatContacts() {
    return chatRepository.getChatContacts();
  }
  
  void deleteTextMessage(String receiverUserID, String messageId) {
    ref.read(userDataAuthProvider).whenData((value) => chatRepository.deleteTextMessage(messageId: messageId, receiverUserID: receiverUserID));
  }

  void deleteChatMessageFromChatScreen(String name, String contactId) {
    ref.read(userDataAuthProvider).whenData((value) => chatRepository.deleteChatMessageFromChatScreen(name: name, contactId: contactId));
  }
  
  ////sends files
  void sendFileMessage(
    File file,
    String receiverUserId,
    MessageEnum messageEnum
  ) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider)
    .whenData(
      (value) => chatRepository.sendFileMessage(file: file, messageEnum: messageEnum, receiverUserId: receiverUserId, senderUserData: value!, ref: ref, messageReply: messageReply)
    );
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  //send GIFs or Sticker
  void sendSticker(BuildContext context, String gifUrl, String receiverUserID){
    final messageReply = ref.read(messageReplyProvider);
    int gifUrlPartIndex = gifUrl.lastIndexOf('-') + 1;
    String gifUrlPart = gifUrl.substring(gifUrlPartIndex);
    String newgifUrl = 'https://i.giphy.com/media/$gifUrlPart/200.gif';
    ref.read(userDataAuthProvider).whenData((value) => chatRepository.sendSticker(context: context, gifUrl: newgifUrl, receiverUserID: receiverUserID, senderUser: value!, messageReply: messageReply));
    
    ////
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }
}