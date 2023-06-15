import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:newsapplication/data/newsdata.dart';
import 'package:firebase_storage/firebase_storage.dart'
    show FirebaseStorage, Reference, SettableMetadata, TaskSnapshot, UploadTask;
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:file_picker/file_picker.dart';

class PostNews extends StatefulWidget {
  final String userId;

  const PostNews({required this.userId, Key? key}) : super(key: key);

  @override
  _PostNewsState createState() => _PostNewsState();
}

class _PostNewsState extends State<PostNews> {
  CollectionReference news = FirebaseFirestore.instance.collection("news");

  final currentUser = FirebaseAuth.instance.currentUser!;
  CollectionReference user = FirebaseFirestore.instance.collection("users");

  TextEditingController controllerTitle = TextEditingController();
  TextEditingController controllerSummary = TextEditingController();

  GlobalKey<FormState> key = GlobalKey();

  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  String userId = '';
  String userDocumentId = '';

  @override
  void initState() {
    super.initState();
    // Set the userId in the initState method
    userId = widget.userId;
    // Retrieve the user document ID
    retrieveUserDocumentId();
  }

  void retrieveUserDocumentId() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('userId', isEqualTo: widget.userId)
        .get();

    if (snapshot.docs.isNotEmpty) {
      setState(() {
        userDocumentId = snapshot.docs[0].id;
      });
    }
  }

  String? urlDownload;

  String? countryValue = "";
  String? stateValue = "";
  String? cityValue = "";

  var time = DateTime.now();

  Future<String?> uploadFile() async {
    if (pickedFile == null) {
      Fluttertoast.showToast(
        msg: 'Please select an image',
        toastLength: Toast.LENGTH_SHORT,
      );
      return null;
    }

    final path = 'contents/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    final metadata = SettableMetadata(
        contentType:
        'image/jpeg'); // Adjust the content type based on your image type
    uploadTask = ref.putFile(file, metadata);

    final snapshot = await uploadTask!.whenComplete(() {});
    urlDownload = await snapshot.ref.getDownloadURL();

    setState(() {
      uploadTask = null;
    });
    return urlDownload.toString();
  }

  void retrieveUrl() async {
    urlDownload = await uploadFile();
    if (urlDownload != null) {
      // Use the urlDownload value here
      print(urlDownload);
    }
  }

  @override
  void dispose() {
    controllerTitle.dispose();
    controllerSummary.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DefaultTextStyle(
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20, // Increase the font size
                ),
                child: AnimatedTextKit(
                  animatedTexts: [
                    RotateAnimatedText("Add"),
                    RotateAnimatedText("+"),
                  ],
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "News",
                style: TextStyle(color: Colors.orange[900]),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Text('Add Interesting News',
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(color: Colors.black, fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 5,
          ),
          const Text(
            'Interesting news from user experience',
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: controllerTitle,
            decoration: const InputDecoration(
              hintText: 'Title',
            ),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: controllerSummary,
            decoration: const InputDecoration(
              hintText: 'Summary',
            ),
          ),
          const SizedBox(height: 30),
          CSCPicker(
            onCountryChanged: (value) {
              setState(() {
                countryValue = value;
              });
            },
            onStateChanged: (value) {
              setState(() {
                stateValue = value;
              });
            },
            onCityChanged: (value) {
              setState(() {
                cityValue = value;
              });
            },
          ),
          const SizedBox(height: 30),
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(currentUser.email.toString())
                .snapshots(),
            builder: (context, snapshot) {
              //get user data
              if (snapshot.hasData) {
                final userData = snapshot.data!.data() as Map<String, dynamic>;

              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error${snapshot.error}'),
                );
              }
              return SizedBox.shrink(); // Return an empty widget if snapshot doesn't have data
            },
          ),
          Center(
            child: Text(
              'Current Time: $time',
              style: const TextStyle(fontSize: 10),
            ),
          ),
          ElevatedButton(
            onPressed: selectFile,
            style: ElevatedButton.styleFrom(
              shape: StadiumBorder(),
              backgroundColor: Colors.black,
            ),
            child: const Text(
              'Select Image',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          if (pickedFile != null)
            Expanded(
              child: Container(
                child: Center(
                  child: Image.file(
                    File(pickedFile!.path!),
                    width: 500,
                    height: 300,
                  ),
                ),
              ),
            ),
          const SizedBox(
            height: 70,
          ),
          ElevatedButton(
            onPressed: () async {
              if (controllerTitle.text.isNotEmpty &&
                  controllerSummary.text.isNotEmpty) {
                String title = controllerTitle.text;
                String summary = controllerSummary.text;

                // Upload the file if a new file is selected
                if (uploadTask == null) {
                  urlDownload = await uploadFile();
                }

                if (urlDownload != null) {
                  // Create a Map of data
                  Map<String, dynamic> dataToSend = {
                    'title': title,
                    'summary': summary,
                    'image': urlDownload,
                    'country': countryValue,
                    'state': stateValue,
                    'city': cityValue,
                    'time': DateTime.now(), // Include the current time
                    'user_email': currentUser.email, // Save the user email
                  };

                  // Add a new item
                  await news.add(dataToSend);

                  Fluttertoast.showToast(
                    msg: 'Successfully added',
                    toastLength: Toast.LENGTH_SHORT,
                  );
                } else {
                  Fluttertoast.showToast(
                    msg: 'Failed to upload image',
                    toastLength: Toast.LENGTH_SHORT,
                  );
                }
              } else {
                Fluttertoast.showToast(
                  msg: 'Please enter the title and summary',
                  toastLength: Toast.LENGTH_SHORT,
                );
              }
            },
            child: const Text(
              'Submit',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}