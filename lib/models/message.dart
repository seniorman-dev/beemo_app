import 'package:beemo/common/enums/message_enum.dart';
import 'package:intl/intl.dart';



class Message{

  final String senderId;
  final String receiverId;
  final String text;
  final MessageEnum type;
  final DateTime timeSent;
  final String messageId;
  final bool isSeen;
  ///added this later for replying a particular text purpose
  final String repliedMessage;
  final String repliedTo;
  final MessageEnum repliedMessageType;

  Message({required this.repliedMessage, required this.repliedTo, required this.repliedMessageType, required this.timeSent, required this.senderId, required this.receiverId, required this.text, required this.type, required this.messageId, required this.isSeen,});
  
  //Bellow is called Json Serialization
  //toMap or toJson(this is the provided data gotten from our model that we want firebase cloudfirestore to store)
  Map<String, dynamic> toMap() {
    return {
      'senderId' : senderId,
      'receiverId' : receiverId,
      'text' : text,
      'messageId': messageId,
      'timeSent': timeSent,
      'isSeen': isSeen,
      'type': type.type,
      'repliedMessage': repliedMessage,
      'repliedMessageType': repliedMessageType.type,
      'repliedTo': repliedTo
    };
  }

  //fromMap or fromJson (this is how firebase will store the provided data)
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      text: map['text'] ?? '',
      messageId: map['messageId'] ?? '',
      isSeen: map['isSeen'] ?? false, 
      type: (map['type'] as String).toEnum(), 
      timeSent: DateTime.now(),
      repliedMessage: map['repliedMessage'] ?? '', 
      repliedMessageType: (map['repliedMessageType'] as String).toEnum(),
      repliedTo: map['repliedTo'] ?? '',
    );
  }

}