import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newsapplication/views/shownewsdetailspage.dart';

class GetNews extends StatefulWidget {
  const GetNews({Key? key}) : super(key: key);

  @override
  State<GetNews> createState() => _GetNewsState();
}

class _GetNewsState extends State<GetNews> {
  final _news = FirebaseFirestore.instance.collection('news').snapshots();
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  List<String> newsID = [];

  getNewsID() async{
    await FirebaseFirestore.instance.collection('news').get().then(
          (snapshot) => snapshot.docs.forEach((news) {
        if (news.exists) {
          newsID.add(news.reference.id);
        } else {
          print("Ntg to see here");
        }
      }),
    );
  }

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
              'News',
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

                  else if (snapshot.hasData) {
                    QuerySnapshot querySnapshot = snapshot.data!;
                    List<QueryDocumentSnapshot> documents = querySnapshot.docs;
                    List<Map> items = documents.map((e) => e.data() as Map).toList();
                    List<Map> filteredItems = items
                        .where((item) => item['title']
                        .toString()
                        .toLowerCase()
                        .contains(_searchText.toLowerCase()))
                        .toList();

                    return ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (BuildContext context, int index) {
                        String documentId = documents[index].id;
                        return buildCardWidget(filteredItems[index], documentId);
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

  Widget buildCardWidget(Map item, String dID) {
    return InkWell(
      onTap: () async {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => NewsDetails(newsId: dID,),
          ),
        );
      },
      child: Card(
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
                      '${dID}',
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
        ),
      ),
    );
  }
}
