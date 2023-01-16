import 'package:beemo/bottom_nav_bar.dart';
import 'package:beemo/common/widgets/colors.dart';
import 'package:beemo/common/widgets/errors.dart';
import 'package:beemo/common/widgets/loader.dart';
import 'package:beemo/features/auth/controllers/auth_controller.dart';
import 'package:beemo/features/chats/screens/chat_screen.dart';
import 'package:beemo/features/auth/screens/landing_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';




void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //initialize getstorage to get access to the storage+
  await GetStorage.init('ThemeBox'); //boolean
  await GetStorage.init('SelectedTheme'); //boolean
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      //theme: Themes().lightTheme,
      //darkTheme: Themes().darkTheme,
      //themeMode: ThemeService().getThemeMode(),
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: AppBarTheme(
          color: appBarColor,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: backgroundColor
        )
      ),

      title: 'Beemo',

      home: ref.watch(userDataAuthProvider).when(
        data: (user) {
          if(user == null) {
            return const LandingScreen();
          }
          else {
            return BottomNavBar(); //ChatScreen()
          }
        }, 
        error: (error, stackTrace) {
          return ErrorScreen(error: error.toString());
        }, 
        loading: () => const Loader(),
      ),
      //FirebaseCheck()
    );
  }
}

class FirebaseCheck extends StatelessWidget {
  const FirebaseCheck({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(strokeWidth: 3, color: tabColor));
          }
          else if(snapshot.hasData) {
            return BottomNavBar(); ////navigates to home screen  //HomeScreen() 
          }
          else if (snapshot.hasError) {
            return Center(child: CircularProgressIndicator(strokeWidth: 3, color: Colors.red));
          }
          else {
            return LandingScreen(); ////navigates to login screen //LoginScreen()       
          }
        }
      )
    );
  }
}