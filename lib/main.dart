import 'package:flutter/material.dart';
import 'package:object_box_practice/home_screen.dart';
import 'package:object_box_practice/object_box/object_box.dart';
import 'package:shared_preferences/shared_preferences.dart';
late ObjectBox objectBox;
late SharedPreferences prefs;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  objectBox = await ObjectBox.create();
  prefs = await SharedPreferences.getInstance();
  prefs.setString('firstTime', 'True');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
