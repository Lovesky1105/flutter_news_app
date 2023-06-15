import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:newsapplication/widgets/custom_tag.dart';
import 'package:csc_picker/csc_picker.dart';

class EditDeleteNewsDetails extends StatefulWidget {
  const EditDeleteNewsDetails(this.documentId, {Key? key}) : super(key: key);

  final String documentId;

  @override
  State<EditDeleteNewsDetails> createState() => _EditDeleteNewsDetailsState();
}

class _EditDeleteNewsDetailsState extends State<EditDeleteNewsDetails> {
  final TextEditingController _updateTitleController = TextEditingController();
  final TextEditingController _updateSummaryController =
      TextEditingController();
  String _updatedTitle = '';
  String _updatedSummary = '';
  String? countryValue;
  String? stateValue;
  String? cityValue;

  @override
  void dispose() {
    _updateTitleController.dispose();
    _updateSummaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),
        centerTitle: true,
        title: const Text(
          'User Post',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('news')
            .doc(widget.documentId)
            .get(),
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

          return const Center(child: CircularProgressIndicator());
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _updateTitleController,
              decoration: const InputDecoration(
                hintText: 'Update title',
                fillColor: Colors.white,
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _updatedTitle = value;
                });
              },
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _updateSummaryController,
              decoration: const InputDecoration(
                hintText: 'Update summary',
                fillColor: Colors.white,
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _updatedSummary = value;
                });
              },
            ),
            const SizedBox(
              height: 25,
            ),
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
            const SizedBox(height: 10.0),
            Column(
              children: [
                Container(
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () {
                      updateNews();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      primary: Colors.green,
                    ),
                    child: const Text('Update'),
                  ),
                ),
                const SizedBox(height: 10.0),
                Container(
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () {
                      deleteNews();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      primary: Colors.red,
                    ),
                    child: const Text('Delete'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void updateNews() {
    // Get the updated values from the text fields
    String updatedTitle = _updatedTitle;
    String updatedSummary = _updatedSummary;

    // Update the news document in Firebase
    FirebaseFirestore.instance.collection('news').doc(widget.documentId).update({
      'title': updatedTitle,
      'summary': updatedSummary,
      'country': countryValue,
      'state': stateValue,
      'city': cityValue,
    }).then((_) {
      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('News updated successfully'),
        ),
      );
    }).catchError((error) {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update news: $error'),
        ),
      );
    });
  }

  void deleteNews() {
    // Delete the news document from Firebase
    FirebaseFirestore.instance
        .collection('news')
        .doc(widget.documentId)
        .delete()
        .then((_) {
      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('News deleted successfully'),
        ),
      );
    }).catchError((error) {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete news: $error'),
        ),
      );
    });
  }
}
