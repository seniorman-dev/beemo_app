import 'package:intl/intl.dart';

class ChatContact {
  final String name;
  final String profilePic;
  final String contactId;
  final DateTime timeSent;
  final String lastMessage;

  ChatContact({required this.name, required this.profilePic, required this.contactId, required this.timeSent, required this.lastMessage});
  
  //to map(this is how firebase will store the provided data)
  Map<String, dynamic> toMap() {
    return {
      'name' : name,
      'contactId' : contactId,
      'profilePic' : profilePic,
      'lastMessage': lastMessage,
      'timeSent': timeSent,
    };
  }

  //from map
  factory ChatContact.fromMap(Map<String, dynamic> map) {
    return ChatContact(
      name: map['name'] ?? '',
      contactId: map['contactId'] ?? '',
      profilePic: map['profilePic'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
      timeSent: DateTime.now()
    );
  }
}