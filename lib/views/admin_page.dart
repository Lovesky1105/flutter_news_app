import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth/get_user_name.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final user = FirebaseAuth.instance.currentUser!;
  FirebaseAuth auth = FirebaseAuth.instance;

  List<String> docIDs = [];

  //get gocID
  Future getDocId() async {
    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              print(document.reference);
              docIDs.add(document.reference.id);
            }));
  }

  @override
  Widget build(BuildContext context) {
    // Check if the user's email matches the admin email
    if (user.email == 'tommy1004@gmail.com') {
      return Scaffold(
        appBar: AppBar(
          title: Text("Admin Page"),
          backgroundColor: Colors.grey[900],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Signed in as: ${user.email!}',
                style: TextStyle(fontSize: 20),
              ),
              Expanded(
                child: FutureBuilder(
                    future: getDocId(),
                    builder: (context, snapshot) {
                      return ListView.builder(
                        itemCount: docIDs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: GetUserName(documentID: docIDs[index]),
                              tileColor: Colors.deepPurple[100],
                            ),
                          );
                        },
                      );
                    }),
              ),
            ],
          ),
        ),
      );
    } else {
      // Show a different screen or display a message for non-admin users
      return Scaffold(
        body: Center(
          child: Text('Only admin can access this page!'),
        ),
      );
    }
  }
}
