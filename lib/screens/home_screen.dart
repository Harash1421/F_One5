import 'package:ABooks/databases/books_modal.dart';
import 'package:ABooks/databases/sqlite_database.dart';
import 'package:ABooks/screens/add_screen.dart';
import 'package:ABooks/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Database Fetching Variables
  List<Map<String, dynamic>> bookList = [];
  BookDatabase bookDatabase = BookDatabase();

  //get All Data From Book Database
  fetchAllBooks() async {
    bookList = [];
    var books = await bookDatabase.readData();
    var data = books.map((e) {
      return {"Id": e['Id'], "BName": e['BName'], "BNote": e['BNote']};
    }).toList();
    bookList = data.reversed.toList();
    setState(() {});
  }

  @override
  void initState() {
    fetchAllBooks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffBDBDBD),
        //App Bar Coding
        appBar: AppBar(
          centerTitle: false,
          title: const Text("ABooks"),
          backgroundColor: const Color(0xff3F51B5),
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: ((context) =>
                              const AddScreen(id: 0, bName: "", bNote: ""))))
                      .then((value) => fetchAllBooks());
                },
                icon: const Icon(Icons.add_sharp))
          ],
        ),

        //Body Container
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              alignment: Alignment.center,
              child: ListView.builder(
                  itemExtent: 75,
                  itemCount: bookList.length,
                  itemBuilder: ((context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.white,
                      child: tvBooks(index),
                    );
                  })),
            ),
          ),
        ));
  }

  //Method For Buttons
  Widget _button(String title, VoidCallback onPressed) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(240, 58),
            backgroundColor: const Color(0xff3F51B5)),
        onPressed: () {
          onPressed();
          setState(() {});
        },
        child: Text(title));
  }

  Widget _text(String text, double textSize, Color textColor) {
    return Text(text, style: TextStyle(fontSize: textSize, color: textColor));
  }

  Widget tvBooks(int index) {
    var bookInfo = bookList[index];

    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _text(bookInfo['BName'], 25, Colors.black),
          Expanded(child: Container()),
          //Button For Edit Book Details
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => AddScreen(
                            id: bookInfo['Id'],
                            bName: bookInfo['BName'],
                            bNote: bookInfo['BNote'])))
                    .then((value) => fetchAllBooks());
              },
              icon: const Icon(
                Icons.edit,
                color: Colors.green,
              )),
          //Button For Delete Book
          IconButton(
              onPressed: () {
                showAlertDialog(context, bookInfo['BName'], (() async {
                  await bookDatabase.deleteData(bookInfo['Id']);
                  _toast("${bookInfo['BName']} Delete Complete", Colors.green);
                  fetchAllBooks();
                }));
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              )),
        ],
      ),
    );
  }

  //Method For Toast Message
  Future<bool?> _toast(String toastMessage, Color textColor) {
    return Fluttertoast.showToast(
        msg: toastMessage,
        textColor: textColor,
        backgroundColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 15.0);
  }
}
