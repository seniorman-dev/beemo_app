import 'package:beemo/common/widgets/colors.dart';
import 'package:beemo/common/widgets/errors.dart';
import 'package:beemo/common/widgets/loader.dart';
import 'package:beemo/features/chats/screens/chat_screen.dart';
import 'package:beemo/features/select_contacts/controllers/select_contacts_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';




class SelectContactScreen extends ConsumerStatefulWidget {
  SelectContactScreen({super.key});

  @override
  ConsumerState<SelectContactScreen> createState() => _SelectContactScreenState();
}

class _SelectContactScreenState extends ConsumerState<SelectContactScreen> {
  void selectContact(WidgetRef ref, Contact selectedContact, int index) {
    ref.read(selectContactControllerProvider).selectContact(selectedContact, index);
  }

  bool isLoading = false;

  List<Contact>? contacts;
  List<Contact> suggestionsOnSearch = [];

  final formKey = GlobalKey<FormState>();
  final textController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    textController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getContacts();
    super.initState();
  }

  void getContacts() async{
    if(await FlutterContacts.requestPermission()) {
      contacts = await FlutterContacts.getContacts(withPhoto: true, withProperties: true);
      //print(contacts);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context,) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        /*title: Text(
          'Select Contact',
          style: GoogleFonts.comfortaa(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)
        ),*/
        /*leading: IconButton(
          onPressed: () {
            Get.back();
            //Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textColor,),
        ),*/
        flexibleSpace: SafeArea(
          child: SizedBox(
            child: Row(
              children: [
                SizedBox(width: 7,),
                //back button could be here
                Icon(CupertinoIcons.person, color: textColor,),
                SizedBox(width: 12,),
                SizedBox(
                  height: 80,
                  width: size.width * 0.8,
                  child: TextFormField(
                    key: formKey,
                    controller: textController,
                    keyboardType: TextInputType.text,
                    autocorrect: true,
                    inputFormatters: [],
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
                      /*errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2.0),
                        borderRadius: BorderRadius.all(
                          const Radius.circular(30.0),
                        ),
                      ),*/
                      //hintText: 'phone number',
                      //hintStyle: TextStyle(color: Colors.grey),                     
                      labelStyle: TextStyle(color: Colors.grey),
                      labelText: 'search',
                      prefixIcon: Icon(CupertinoIcons.search, color: Colors.grey),
                      suffixIcon: IconButton(
                        onPressed: () {
                          textController.clear();                    
                        }, 
                        icon: Icon(CupertinoIcons.clear_circled, color: tabColor),
                      ),
                      //filled: true,
                      //fillColor: Colors.grey,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2.0),
                        borderRadius: BorderRadius.all(
                          const Radius.circular(30.0),
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        //textController.text = value;
                        suggestionsOnSearch = contacts!.where((element) => element.displayName.toLowerCase().contains(value.toLowerCase())).toList();
                      });
                    },
                    /*validator: (value) {
                      if (value!.isEmpty) {
                        return 'Empty Field!';
                      }
                      return null;
                    },*/
                  ),
                ),
                SizedBox(width: 5,),
                /*IconButton(
                  onPressed: () {
                    textController.clear();
                    /*setState(() {
                      textController.clear();
                    });*/
                  }, 
                  icon: Icon(CupertinoIcons.clear_circled, color: tabColor),
                ),*/
              ],
            ),
          )
        ),
        actions: [
          /*IconButton(
            onPressed: () {
              textController.clear();
              /*setState(() {
                textController.clear();
              });*/
            }, 
            icon: Icon(CupertinoIcons.clear_circled, color: tabColor),
          ),*/
          /*IconButton(
            onPressed: () {},
            icon: Icon(CupertinoIcons.search, color: tabColor,)
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert_rounded, color: tabColor,)
          ),*/
        ],
      ),

      body: (contacts) == null //isLoading
      ? Loader()

      : textController.text.isNotEmpty && suggestionsOnSearch.isEmpty? Center(  //certified
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, color: greyColor, size: 70,),
            Text(
              'No results found!', 
              style: GoogleFonts.comfortaa(color: greyColor, fontWeight: FontWeight.bold, fontSize: 15)
            )  
          ],
        ),
      )
      : ListView.separated(
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          separatorBuilder: (context, index) {
            return SizedBox(height: 5,);
          },
          itemCount: textController.text.isNotEmpty ? suggestionsOnSearch.length: 0,
          itemBuilder: (context, index) {
            //final contact = contacts![index];
            final contact = suggestionsOnSearch[index];
            return InkWell(
              onTap: () {
                //selectContact(ref, contact, index);
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: contact.photo == null 
                  ?CircleAvatar(
                    backgroundColor: Colors.pink.shade400.withOpacity(0.5),
                    radius: 30,
                    child: Text(
                      contact.displayName.substring(0, 1).toUpperCase(),
                      style: GoogleFonts.comfortaa(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)
                    )  
                  )
                  :CircleAvatar(
                    backgroundImage: MemoryImage(contact.photo!),
                    radius: 30,
                  ),
                  title: Text(
                    contact.displayName,
                    style: GoogleFonts.comfortaa(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)
                  ),
                  onTap: () {
                    selectContact(ref, contact, index);
                  },
                ),
              ),
            );
          }, 
        ),
        /*ref.watch(getContactsProvider).when(
        data: (contacts) {
          ListView.separated(
            scrollDirection: Axis.vertical,
            physics: BouncingScrollPhysics(),
            separatorBuilder: (context, index) {
              return SizedBox(height: 5,);
            },
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return InkWell(
                onTap: () {
                  selectContact(ref, contact, index);
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: contact.photo == null 
                    ?CircleAvatar(
                      backgroundColor: Colors.pink.shade400.withOpacity(0.5),
                      radius: 30,
                      child: Text(
                        contact.displayName.substring(0, 1).toUpperCase(),
                        style: GoogleFonts.comfortaa(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)
                      )  
                    )
                    :CircleAvatar(
                      backgroundImage: MemoryImage(contact.photo!),
                      radius: 30,
                    ),
                    title: Text(
                      contact.displayName,
                      style: GoogleFonts.comfortaa(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)
                    ),
                    onTap: () {},
                  ),
                ),
              );
            }, 
          );
          return null;
        }, 
        error: (error, stackTrace) {
          return ErrorScreen(error: error.toString());
        }, 
        loading: () => const Loader(),
      ),*/
    );
  }
}