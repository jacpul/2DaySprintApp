import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_screen.dart';

class CompareScreen extends StatefulWidget {
  @override
  _CompareScreenState createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  String _searchMethod = "Title";
  String _searchBarText = "";
  TextEditingController _searchBarController = TextEditingController();
  List<Map<String, dynamic>> bookList = [];
  List<Map<String, dynamic>> updatedList = [];
  List<Map<String, dynamic>> compareList = [];

  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    _functionCounter();
  }

  @override
  void dispose() {
    _searchBarController.dispose();
    super.dispose();
  }

  _functionCounter() async {
    List<Map<String, dynamic>> tempList = [];
    var logData = await FirebaseFirestore.instance.collection('Amazon Books')
        .get();
    logData.docs.forEach((element) {
      tempList.add(element.data());
    });
    bookList = tempList;
    setState(() {});
  }

  bool bookExist = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Compare"),
        centerTitle: true,
        backgroundColor: Colors.deepOrangeAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            tooltip: 'Home',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) {
                  return Home();
                }),
              );
            },
          )
        ],
      ),
      body: Container(
        color: Colors.yellow.shade400,
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Radio<String>(
                    activeColor: Colors.blue,
                    value: "Title",
                    groupValue: _searchMethod,
                    onChanged: (value) {
                      setState(() {
                        _searchMethod = value!;
                      });
                    }),
                const Text(
                  'Title',
                  style: TextStyle(color: Colors.blue),
                ),
                Radio<String>(
                    activeColor: Colors.blue,
                    value: "Author",
                    groupValue: _searchMethod,
                    onChanged: (value) {
                      setState(() {
                        _searchMethod = value!;
                      });
                    }),
                const Text(
                  'Author',
                  style: TextStyle(color: Colors.blue),
                ),
                Radio<String>(
                    activeColor: Colors.blue,
                    value: "ISBN",
                    groupValue: _searchMethod,
                    onChanged: (value) {
                      setState(() {
                        _searchMethod = value!;
                      });
                    }),
                const Text(
                  'ISBN Number',
                  style: TextStyle(color: Colors.blue),
                ),
              ],
            ),
            TextFormField(
              controller: _searchBarController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              onChanged: (value) {
                setState(() {
                  _searchBarText = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Enter Details Here',
                labelText: _searchMethod,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _functionCounter();
                isLoaded = false;
                updateList(_searchBarController.text);
                setState(() {});
              },
              child: const Text('Add To Compare'),
            ),
            isLoaded
                ? compareList.length == 2
                ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: getBookDetailsWidget(compareList[0]),
                ),
                Expanded(
                  child: getBookDetailsWidget(compareList[1]),
                ),
              ],
            )
                : Expanded(child: getListofBooks())
                : Text(" "),
          ],
        ),
      ),
    );
  }

  Widget getBookDetailsWidget(Map<String, dynamic> book) {
    return Card(
      color: Colors.yellow.shade600,
      child: ListTile(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          "Title: ${book["title"]}",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Author: ${book["author"]}"),
            Text("Edition: ${book["edition"]}"),
            Text("Published: ${book["publish_data"]}"),
            Text("Rating: ${book["rating"]}"),
            Text("Price: ${book["price"]}"),
          ],
        ),
      ),
    );
  }

  void updateList(String item) {
// Used to get the database field
    String firebaseField = item;

    print(item);
    isLoaded = true;
    updatedList.clear();

    switch (_searchMethod) {
      case 'Title':
        firebaseField = "title";
        break;
      case 'Author':
        firebaseField = "author";
        break;
      case 'ISBN':
        firebaseField = 'isbn13';
        break;
      default:
        break;
    }

    for (var i = 0; i < bookList.length; i++) {
      if (bookList[i][firebaseField].toString() == item) {
        if (bookList[i]["isbn13"].toString() == item) {
          updatedList.add(bookList[i]);
          bookExist = true;
        }
      }

      if (compareList.length == 2) {
        compareList.clear();
      }

      if (updatedList.isNotEmpty) {
        compareList.add(updatedList[0]);
      }
    }
  }

  getListofBooks() {
    return ListView.builder(
      itemCount: updatedList!.length,
      itemBuilder: (content, index) {
        return Card(
          color: Colors.yellow.shade600,
          child: ListTile(
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(updatedList[index]["title"].toString()),
            subtitle: bookExist
                ? Text(
              "Author: " +
                  updatedList[index]["author"] +
                  "\n" +
                  "Edition: " +
                  updatedList[index]["edition"].toString() +
                  "\n" +
                  "Published: " +
                  updatedList[index]["publish_data"].toString() +
                  "\n" +
                  "Rating: " +
                  updatedList[index]["rating"].toString() +
                  "\n" +
                  "Price: " +
                  updatedList[index]["price"],
            )
                : Text("** NO DATA **"),
          ),
        );
      },
    );
  }
}


