import 'package:beemo/common/widgets/colors.dart';
import 'package:beemo/common/widgets/custom_button.dart';
import 'package:beemo/common/widgets/loader.dart';
import 'package:beemo/features/auth/controllers/auth_controller.dart';
import 'package:beemo/features/auth/repository/firebase_auth.dart';
import 'package:beemo/features/auth/screens/user_details.dart';
import 'package:beemo/features/auth/screens/user_information.dart';
import 'package:beemo/features/chats/controller/chat_controller.dart';
import 'package:beemo/features/chats/repository/chat_repository.dart';
import 'package:beemo/features/chats/screens/direct_message.dart';
import 'package:beemo/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:beemo/models/chat_contact.dart';
import 'package:beemo/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';





class ChatScreen extends ConsumerStatefulWidget {
  ChatScreen({Key? key}) : super(key: key);

  @override
  
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> with WidgetsBindingObserver {

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  // widgets binding observer helps us to check if user is actively using the app (online) or not.
  // it check the state of our app
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // TODO: Handle this case.
        ref.read(authControllerProvider).setUserStateOnline(true);
        break;
      case AppLifecycleState.inactive:
        // TODO: Handle this case.
        ref.read(authControllerProvider).setUserStateOnline(false);
        break;
      case AppLifecycleState.paused:
        // TODO: Handle this case.
        ref.read(authControllerProvider).setUserStateOnline(false);
        break;
      case AppLifecycleState.detached:
        // TODO: Handle this case.
        ref.read(authControllerProvider).setUserStateOnline(false);
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /*@override
  void initState() {
    // TODO: implement initState
    getCurrentChats();
    super.initState();
  }*/

  /*Stream<List<ChatContact>> getCurrentChats() {
    //ref.watch(chatControllerProvider).chatContacts();
    return ChatRepository(auth: auth, firestore: firestore)
    .getChatContacts();
  }*/

  @override
  Widget build(BuildContext context,) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        centerTitle: true,
        elevation: 0,
        title: Text('Chats', style: GoogleFonts.comfortaa(color: textColor),),
        leading: IconButton(
          onPressed: () {
            Get.to(() => UserDetails());
          }, 
          icon: Icon(CupertinoIcons.profile_circled, color: textColor,)
          ),
        /*actions: [
          IconButton(
            onPressed: () async{}, 
            icon: Icon(Icons.logout, color: tabColor,)
          )
        ],*/
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 10),
        child: StreamBuilder<List<ChatContact>>(
          stream: /*firestore.collection('users'0
            .doc(auth.currentUser!.uid)
            .collection('chats')
            .snapshots()
            .asyncMap((event) async{
              List<ChatContact> contacts = [];

              for(var document in event.docs) {
                var chatContact = ChatContact.fromMap(document.data());
                var userData = await firestore.collection('users').doc(chatContact.contactId).get();
                var user = UserModel.fromMap(userData.data()!);
                contacts.add(ChatContact(name: user.name, profilePic: user.profilePic, contactId: chatContact.contactId, timeSent: chatContact.timeSent, lastMessage: chatContact.lastMessage));
              }
      
              return contacts;

          }),*/ 
          ref.watch(chatControllerProvider).chatContacts(),
          //getCurrentChats(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return Loader();
            }
            else if(snapshot.hasData) {
              return ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                separatorBuilder: (context, index) {
                  return SizedBox(height: 5,);
                },
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final data = snapshot.data![index];
                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      if(direction == DismissDirection.endToStart) {
                        ref.read(chatControllerProvider).deleteChatMessageFromChatScreen(data.name, data.contactId);
                        setState(() {
                          snapshot.data!.removeAt(index);
                        });
                        print('Chat Deleted from firestore');
                      }
                      else {
                        print('Cool Stuff');
                      }
                    },
                    child: InkWell(
                      /*onTap: () {
                        Get.to(() => DirectMessageScreen(name: data.name, uid: data.contactId));
                      },*/
                      child: ListTile(
                        /*onLongPress: () {
                          ref.read(chatControllerProvider).deleteChatMessageFromChatScreen(data.name, data.contactId);
                          setState(() {
                            snapshot.data!.removeAt(index);
                          });
                          print('Chat Deleted from firestore');
                        },*/
                        onTap: () {
                          Get.to(() => DirectMessageScreen(name: data.name, uid: data.contactId));
                        },
                        leading: CircleAvatar(
                          backgroundColor: Colors.pink.shade400.withOpacity(0.5),
                          radius: 30,
                          child: Text(
                            data.name.substring(0, 1).toUpperCase(),
                            style: GoogleFonts.comfortaa(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)
                          )
                        ),
                        title: Text(
                          data.name,
                          style: GoogleFonts.comfortaa(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)
                        ),
                        subtitle: Text(
                          data.lastMessage,
                          style: GoogleFonts.comfortaa(fontSize: 15, fontWeight: FontWeight.bold, color: textColor)
                        ),
                        //////////////
                        trailing: Text(
                          DateFormat('hh:mm').format(data.timeSent),
                          style: GoogleFonts.comfortaa(fontSize: 17, fontWeight: FontWeight.w800, color: textColor)
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
      ),
      /*floatingActionButton: FloatingActionButton(
        backgroundColor: tabColor,
        onPressed:() {
          Get.to(() => SelectContactScreen());
        },
        child: Icon(Icons.comment_rounded, color: backgroundColor,),
      ),*/
    );
  }
}