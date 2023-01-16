import 'dart:io';

import 'package:beemo/common/enums/message_enum.dart';
import 'package:beemo/common/providers/message_reply_provider.dart';
import 'package:beemo/common/repository/common_firebase_storage_repository.dart';
import 'package:beemo/models/chat_contact.dart';
import 'package:beemo/models/message.dart';
import 'package:beemo/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:uuid/uuid.dart';



//this was created for chat controller
final chatRepositoryProvider = Provider((ref) => ChatRepository(auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance));



class ChatRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  ChatRepository({required this.auth, required this.firestore});
  
  //for getting stream of direct messages between two users for chat list(direct message screen)
  //Stream
  Stream<List<Message>> getChatStream(String receiverUserId) {
    return firestore.collection('users')
    .doc(auth.currentUser!.uid)
    .collection('chats')
    .doc(receiverUserId)
    .collection('messages')
    .orderBy('timeSent')
    .snapshots()
    .map(
      (event) {
        List<Message> messages = [];

        for(var document in event.docs) {
          messages.add(Message.fromMap(document.data()));
        }
        return  messages;

      }
    );
  }

  //for getting recent chat messgaes with contacts on chat screen
  Stream<List<ChatContact>> getChatContacts() {
    return firestore.collection('users')
    .doc(auth.currentUser!.uid)
    .collection('chats')
    .snapshots()
    .asyncMap((event) async{
      List<ChatContact> contacts = [];

      for(var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());
        var userData = await firestore.collection('users').doc(chatContact.contactId).get();
        var user = UserModel.fromMap(userData.data()!);                             //|
        contacts.add(ChatContact(name: user.name, profilePic: user.profilePic, contactId: chatContact.contactId, lastMessage: chatContact.lastMessage, timeSent: chatContact.timeSent));
      }
      
      return contacts;

    });
  }

  ///for chat screen
  void _saveDataToContactsSubcollection(
    // process of chat contact sub-collection for ChatScreen
    UserModel senderUserData,
    UserModel receiverUserData,
    String text,
    DateTime timeSent,
    String receiverUserID
  ) async{
    //users -> receiver user id -> chats -> current user id ->set data
    var receiverChatContact = ChatContact(name: senderUserData.name, profilePic: senderUserData.profilePic, contactId: senderUserData.uid, lastMessage: text, timeSent: timeSent);
    await firestore.collection('users').doc(receiverUserID).collection('chats').doc(auth.currentUser!.uid).set(receiverChatContact.toMap());
    
    //users -> current user id -> chats -> receiver user id ->set data
    var senderChatContact = ChatContact(name: receiverUserData.name, profilePic: receiverUserData.profilePic, contactId: receiverUserData.uid, lastMessage: text, timeSent: timeSent);
    await firestore.collection('users').doc(auth.currentUser!.uid).collection('chats').doc(receiverUserID).set(senderChatContact.toMap());

  }

  //for adding and saving messages in private chat (message screen)
  void _saveMessageToMessageSubcollection(
    String receiverUserID,
    String text,
    String messageId,
    String senderUserName,
    String receiverUserName,
    MessageEnum messageType,
    DateTime timeSent,
    MessageReply? messageReply,
    MessageEnum repliedMessageType,
  ) async{
    final message = Message(senderId: auth.currentUser!.uid, receiverId: receiverUserID, text: text, type: messageType, messageId: messageId, isSeen: false, timeSent: timeSent, repliedMessage: messageReply == null ? '' : messageReply.message, repliedMessageType: messageReply == null ? repliedMessageType : messageReply.messageEnum, repliedTo: messageReply == null ? '' : messageReply.isMe ? senderUserName : receiverUserName,);
    // users(collection) -> sender id -> receiver id -> messages(collection) -> message id -> store message
    await firestore.collection('users').doc(auth.currentUser!.uid).collection('chats').doc(receiverUserID).collection('messages').doc(messageId).set(message.toMap());

    // users(collection) -> receiver id -> sender id -> messages(collection) -> message id -> store message
    await firestore.collection('users').doc(receiverUserID).collection('chats').doc(auth.currentUser!.uid).collection('messages').doc(messageId).set(message.toMap());
    

  }


  //for deleting a message from private chat (message screen)
  void _deleteMessagefromMessageSubcollection(
    String receiverUserID,
    //String text,
    String messageId
    //String senderUserName,
    //String receiverUserName,
    //MessageEnum messageType,
    //DateTime timeSent
  ) async{
    //final message = Message(senderId: auth.currentUser!.uid, receiverId: receiverUserID, text: text, type: messageType, messageId: messageId, isSeen: false, timeSent: timeSent,);
    // users(collection) -> sender id -> receiver id -> messages(collection) -> message id -> store message
    await firestore.collection('users').doc(auth.currentUser!.uid).collection('chats').doc(receiverUserID).collection('messages').doc(messageId).delete();

    // users(collection) -> receiver id -> sender id -> messages(collection) -> message id -> store message
    await firestore.collection('users').doc(receiverUserID).collection('chats').doc(auth.currentUser!.uid).collection('messages').doc(messageId).delete(); 

  }
  ///for deleting message from last sent message in chat screen
  void _deleteDataFromContactsSubcollection(
    // process of chat contact sub-collection for ChatScreen
    //UserModel senderUserData,
    //UserModel receiverUserData,
    //String text,
    //DateTime timeSent,
    String receiverUserID
  ) async{
    //users -> receiver user id -> chats -> current user id ->set data
    //var receiverChatContact = ChatContact(name: senderUserData.name, profilePic: senderUserData.profilePic, contactId: senderUserData.uid, lastMessage: text, timeSent: timeSent);
    await firestore.collection('users').doc(receiverUserID).collection('chats').doc(auth.currentUser!.uid).delete();  //.set(receiverChatContact.toMap());
    
    //users -> current user id -> chats -> receiver user id ->set data
    //var senderChatContact = ChatContact(name: receiverUserData.name, profilePic: receiverUserData.profilePic, contactId: receiverUserData.uid, lastMessage: text, timeSent: timeSent);
    await firestore.collection('users').doc(auth.currentUser!.uid).collection('chats').doc(receiverUserID).delete();  //.set(senderChatContact.toMap());

  }

  ////sub delete function 
  void deleteTextMessage({
    required String receiverUserID,
    required String messageId
  }) {
    //_deleteDataFromContactsSubcollection(receiverUserID);
    _deleteMessagefromMessageSubcollection(receiverUserID, messageId);
  }

  ////main delete function that combines the two
  void deleteChatMessageFromChatScreen({
    required String name,
    required String contactId
  }) {
    _deleteDataFromContactsSubcollection(name);
    _deleteMessagefromMessageSubcollection(name, contactId);
  }



  void sendTextMessage({

    required String text,
    required String receiverUserID,
    required UserModel senderUser,
    required MessageReply? messageReply,

  }) async{
    // process of storing messages between two users
    // users(collection) -> sender id -> receiver id -> messages(collection) -> message id -> store message
    try {
      var timeSent = DateTime.now();
      //we are basically getting the data of the receiver and then converting it to a map 
      UserModel receiverUserData;
      var userDataMap = await firestore.collection('users').doc(receiverUserID).get();
      receiverUserData = UserModel.fromMap(userDataMap.data()!);
      
      //created my unique messageId with the help of uuid pub package
      var messageId = const Uuid().v1();

      // process of chat contact sub-collection for ChatScreen
      _saveDataToContactsSubcollection(
        senderUser,
        receiverUserData,
        text,
        timeSent,
        receiverUserID
      );
      
      //to save message to "message sub-collection"
      _saveMessageToMessageSubcollection(
        receiverUserID,
        text,
        messageId,
        senderUser.name,
        receiverUserData.name,
        MessageEnum.text,
        timeSent,
        messageReply,
        messageReply == null ? MessageEnum.text : messageReply.messageEnum,
      );
    }
    catch (e) {
      Get.snackbar('Uh oh!', "$e", duration: Duration(seconds: 3), isDismissible: false, colorText: Colors.black, borderRadius: 10, backgroundColor: Colors.white, snackPosition: SnackPosition.BOTTOM, dismissDirection: DismissDirection.down);
    }
  }

  ///for sending images and videos betwwen two users
  void sendFileMessage({
    required File file,
    required String receiverUserId,
    required UserModel senderUserData,
    required ProviderRef ref,
    required MessageEnum messageEnum,
    required MessageReply? messageReply,
    }) async{
    try {
      var timeSent = DateTime.now();
      //created our unique messageId with uuid pub package
      var messageId = const Uuid().v1();
      String imageUrl = await ref.read(commonFirebaseStorageRepositoryProvider).storeFileToFirebase('chat/${messageEnum.type}/${senderUserData.uid}/$receiverUserId/$messageId', file);
      UserModel receiverUserData;
      var userDataMap = await firestore.collection('users').doc(receiverUserId).get();
      receiverUserData = UserModel.fromMap(userDataMap.data()!);
      String contactMsg;

      switch (messageEnum) {
        case MessageEnum.image:
        contactMsg = 'Photo'; //add a camera emoji to this string later
        break;
        case MessageEnum.video:
        contactMsg = 'Video'; //add a camera emoji to this string later
        break;
        case MessageEnum.audio:
        contactMsg = 'Audio'; //add a camera emoji to this string later
        break;
        case MessageEnum.gif:
        contactMsg = 'Sticker'; //add a camera emoji to this string later
        break;
        default:
        contactMsg = 'Sticker';
      }
      _saveDataToContactsSubcollection(senderUserData, receiverUserData, contactMsg, timeSent, receiverUserId);
      _saveMessageToMessageSubcollection(receiverUserId, imageUrl, messageId, senderUserData.name, receiverUserData.name, messageEnum, timeSent, messageReply, messageReply == null ? MessageEnum.text : messageReply.messageEnum,);

    }
    catch (e) {
      Get.snackbar('Uh oh!', "$e", duration: Duration(seconds: 3), isDismissible: false, colorText: Colors.black, borderRadius: 10, backgroundColor: Colors.white, snackPosition: SnackPosition.BOTTOM, dismissDirection: DismissDirection.down);
    }
  }

  //for sending gif or sticker
  void sendSticker({
    required BuildContext context,
    required String gifUrl,
    required String receiverUserID,
    required UserModel senderUser,
    required MessageReply? messageReply,
  }) async{
    // process of storing messages between two users
    // users(collection) -> sender id -> receiver id -> messages(collection) -> message id -> store message
    try {
      var timeSent = DateTime.now();
      //we are basically getting the data of the receiver and then converting it to a map 
      UserModel receiverUserData;
      var userDataMap = await firestore.collection('users').doc(receiverUserID).get();
      receiverUserData = UserModel.fromMap(userDataMap.data()!);
      
      //created my unique messageId with the help of uuid pub package
      var messageId = const Uuid().v1();

      // process of chat contact sub-collection for ChatScreen
      _saveDataToContactsSubcollection(
        senderUser,
        receiverUserData,
        'Sticker',
        timeSent,
        receiverUserID
      );
      
      //to save message to "message sub-collection"
      _saveMessageToMessageSubcollection(
        receiverUserID,
        gifUrl,
        messageId,
        senderUser.name,
        receiverUserData.name,
        MessageEnum.gif,
        timeSent,
        messageReply,
        messageReply == null ? MessageEnum.text : messageReply.messageEnum,
      );
    }
    catch (e) {
      Get.snackbar('Uh oh!', "$e", duration: Duration(seconds: 3), isDismissible: false, colorText: Colors.black, borderRadius: 10, backgroundColor: Colors.white, snackPosition: SnackPosition.BOTTOM, dismissDirection: DismissDirection.down);
    }
  }

  // for adding "seen" feature in chats
  void setChatMessageSeen(
    String receiverUserId,
    String messageId,
  ) async{
    try {
      // users(collection) -> sender id -> receiver id -> messages(collection) -> message id -> store message
    await firestore.collection('users').doc(auth.currentUser!.uid).collection('chats').doc(receiverUserId).collection('messages').doc(messageId).update({'isSeen': true});

    // users(collection) -> receiver id -> sender id -> messages(collection) -> message id -> store message
    await firestore.collection('users').doc(receiverUserId).collection('chats').doc(auth.currentUser!.uid).collection('messages').doc(messageId).update({'isSeen': true});
 
    }
    catch(e) {
      Get.snackbar('Uh oh!', "$e", duration: Duration(seconds: 3), isDismissible: false, colorText: Colors.black, borderRadius: 10, backgroundColor: Colors.white, snackPosition: SnackPosition.BOTTOM, dismissDirection: DismissDirection.down);
    }
  }

}