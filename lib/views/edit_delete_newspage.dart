import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newsapplication/views/edit_delete_newspage_details.dart';

class EditDeleteNews extends StatefulWidget {
  const EditDeleteNews({Key? key}) : super(key: key);

  @override
  State<EditDeleteNews> createState() => _EditDeleteNewsState();
}

class _EditDeleteNewsState extends State<EditDeleteNews> {
  final _news = FirebaseFirestore.instance.collection('news').snapshots();
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void dispose() {
    _searchController.dispose();
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
                    RotateAnimatedText("Show"),
                    RotateAnimatedText("Search"),
                    RotateAnimatedText("Find"),
                    RotateAnimatedText("Discover"),
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Discover',
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            Text(
              'News from all over the world',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search',
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchText = value;
                  });
                },
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _news,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                        child: Text('Some error occurred ${snapshot.error}'));
                  }

                  if (snapshot.hasData) {
                    QuerySnapshot querySnapshot = snapshot.data!;
                    List<QueryDocumentSnapshot> documents = querySnapshot.docs;
                    List<Map> items =
                    documents.map((e) => e.data() as Map).toList();
                    List<Map> filteredItems = items
                        .where((item) => item['title']
                        .toString()
                        .toLowerCase()
                        .contains(_searchText.toLowerCase()))
                        .toList();

                    return ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (BuildContext context, int index) {
                        Map thisItem = filteredItems[index];
                        return buildCardWidget(thisItem);
                      },
                    );
                  }

                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCardWidget(Map item) {
    return Card(
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 16.0,
        ),
        title: Row(
          children: [
            Expanded(
              flex: 1,
              child: item.containsKey('image')
                  ? Image.network(
                '${item['image']}',
                fit: BoxFit.cover,
              )
                  : Container(),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${item['title']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  // subtitle: Text('${item['summary']}'),
                ],
              ),
            ),
          ],
        ),
        onTap: () async {
          final snapshot = await FirebaseFirestore.instance
              .collection('news')
              .where('Id', isEqualTo: item['Id'])
              .get();

          if (snapshot.size > 0) {
            final document = snapshot.docs.first;
            final documentId = document.id; // Get the document ID
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EditDeleteNewsDetails(documentId),
              ),
            );
          }
        },
      ),
    );
  }
}