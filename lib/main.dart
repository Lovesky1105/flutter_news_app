import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:newsapplication/views/edit_delete_newspage.dart';
import 'package:newsapplication/views/first_page.dart';
import 'package:newsapplication/views/homepage.dart';
import 'package:newsapplication/views/postnewspage.dart';
import 'package:newsapplication/views/profile_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:newsapplication/views/shownewspage.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FirstPage(key: UniqueKey()),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({required Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> pages = [
    HomePage(key: UniqueKey(),),
    GetNews(key: UniqueKey(),),
    PostNews(key: UniqueKey(), userId: '',),
    GetNews(key: UniqueKey(),),
    EditDeleteNews(key: UniqueKey(),),
    ProfileScreen(key: UniqueKey(), userId: '',),
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.white,
        backgroundColor: Colors.lightBlueAccent.shade100,
        buttonBackgroundColor: Colors.white,
        index: currentIndex,
        items: const <Widget>[
          Icon(
            Icons.home,
            size: 25,
            color: Colors.black,
          ),
          Icon(
            Icons.sports_basketball,
            size: 25,
            color: Colors.black,
          ),
          Icon(
            Icons.chrome_reader_mode_outlined,
            size: 25,
            color: Colors.black,
          ),
          Icon(
            Icons.add,
            size: 25,
            color: Colors.black,
          ),
          Icon(
            Icons.settings,
            size: 25,
            color: Colors.black,
          ),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}

