import 'package:chat/bloc/firebase_auth_bloc.dart';
import 'package:chat/cache/local_database.dart';
import 'package:chat/screens/auth/check_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  DBManager();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocProvider<FirebaseAuthBloc>(
          create: (context) => FirebaseAuthBloc(), child: CheckAuth()),
      // home: BlocProvider<ChatBloc>(
      //     create: (context) => ChatBloc(), child: ChatScreen()),
      // home: ChatScreen(),
    );
  }
}

