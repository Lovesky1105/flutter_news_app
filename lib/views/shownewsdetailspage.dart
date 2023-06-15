import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:newsapplication/widgets/custom_tag.dart';

class NewsDetails extends StatelessWidget {

  final String newsId;

  NewsDetails({Key? key, required this.newsId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),
        title: FutureBuilder<DocumentSnapshot>(
          future:
          FirebaseFirestore.instance.collection('news').doc(newsId).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              DocumentSnapshot documentSnapshot = snapshot.data!;
              Map<String, dynamic>? data =
              documentSnapshot.data() as Map<String, dynamic>?;

              if (data != null && data.containsKey('title')) {
                return Text(
                  data['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.red,
                  ),
                );
              }
            }

            return const Text('News Details');
          },
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('news').doc(newsId).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Some error occurred ${snapshot.error}'));
          }

          if (snapshot.hasData && snapshot.data != null) {
            DocumentSnapshot documentSnapshot = snapshot.data!;
            Map<String, dynamic>? data =
            documentSnapshot.data() as Map<String, dynamic>?;

            if (data != null &&
                data.containsKey('image') &&
                data.containsKey('title') &&
                data.containsKey('summary')) {
              String documentId = documentSnapshot.id; // Get the document ID

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: NetworkImage(data['image']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      data['title'],
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      data['summary'],
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(
                            right: 5.0,
                          ),
                        ),
                        CustomTag(
                          backgroundColor: Colors.grey.withAlpha(150),
                          children: [
                            Text(
                              data['country'],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        CustomTag(
                          backgroundColor: Colors.grey.withAlpha(150),
                          children: [
                            Text(
                              data['state'],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(
                            right: 5.0,
                          ),
                        ),
                        CustomTag(
                          backgroundColor: Colors.grey.withAlpha(150),
                          children: [
                            Text(
                              data['city'],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              );
            }
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('news').doc(newsId).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            DocumentSnapshot documentSnapshot = snapshot.data!;
            Map<String, dynamic>? data =
            documentSnapshot.data() as Map<String, dynamic>?;

            if (data != null &&
                data.containsKey('image') &&
                data.containsKey('summary')) {
              return FloatingActionButton(
                  onPressed: () async {
                    final urlImage = data['image'];
                    final url = Uri.parse(urlImage);
                    final response = await http.get(url);
                    final bytes = response.bodyBytes;
                    final temp = await getTemporaryDirectory();
                    final path = '${temp.path}/image.jpg';
                    File(path).writeAsBytesSync(bytes);

                    await Share.shareFiles(
                      [path],
                      text: 'Check out this news: ${data['summary']}',
                      mimeTypes: [
                        'image/jpeg'
                      ], // Specify the MIME type as 'image/jpeg'
                    );
                  },
                  backgroundColor:
                  Colors.black, // Set the desired background color
                  child: Icon(Icons.share));
            }
          }
          return Container(); // Return an empty container if conditions are not met
        },
      ),
    );
  }
}