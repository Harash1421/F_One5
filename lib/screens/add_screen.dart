import 'package:ABooks/databases/sqlite_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddScreen extends StatefulWidget {
  const AddScreen(
      {super.key, required this.id, required this.bName, required this.bNote});
  final int id;
  final String bName;
  final String bNote;
  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  TextEditingController edBookName = TextEditingController();
  TextEditingController edBookNote = TextEditingController();
  BookDatabase bookDatabase = BookDatabase();
  @override
  Widget build(BuildContext context) {
    edBookName = TextEditingController(text: widget.bName);
    edBookNote = TextEditingController(text: widget.bNote);
    return Scaffold(
      backgroundColor: const Color(0xffBDBDBD),
      appBar: AppBar(
        backgroundColor: const Color(0xff3F51B5),
        title: Text(widget.id != 0 ? "Update Book" : "Add Book"),
        centerTitle: false,
      ),
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical, child: _page()),
      ),
    );
  }

  //Method For Page
  Widget _page() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(children: [
        //Text View Fot Title Home
        //Text Field For Book Name
        _textField("Book Name", edBookName),
        //Text Field For Book Note
        _sizedBox(24, 0),
        _textField("Book Note", edBookNote, isNote: true),
        //Button For Add Book
        _sizedBox(45, 0),
        _button(widget.id != 0 ? "Update Book" : "Add Book")
      ]),
    );
  }

  //Method For Text Fields
  Widget _textField(String hintText, TextEditingController controller,
      {isNote = false}) {
    var border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.black, width: 2.4));
    return TextField(
        textAlign: TextAlign.start,
        minLines: isNote ? 10 : 1,
        maxLines: isNote ? 10 : 2,
        autocorrect: false,
        style: const TextStyle(fontSize: 24, color: Colors.black),
        controller: controller,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            enabledBorder: border,
            focusedBorder: border));
  }

  //Method For Button
  Widget _button(String title) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(200, 57),
            backgroundColor: Colors.black,
            textStyle: const TextStyle(fontSize: 20),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        onPressed: () async {
          var edBName = edBookName.text;
          var edBNote = edBookNote.text;
          if (widget.id == 0) {
            if (edBName.isNotEmpty && edBNote.isNotEmpty) {
              await bookDatabase.insertData(edBName, edBNote);
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop(true);
              _toast("Save Completed", Colors.black);
            } else {
              _toast("Please Fill All Fields", Colors.red);
            }
          } else if (edBName.isNotEmpty && edBNote.isNotEmpty) {
            await bookDatabase.updateData(
                "UPDATE books SET BName = '$edBName', BNote = '$edBNote' WHERE Id = ${widget.id}");
            // ignore: use_build_context_synchronously
            Navigator.of(context).pop(true);
            _toast("Update Complete", Colors.green);
          }
        },
        child: Text(title));
  }

  //Method For Sized Box
  Widget _sizedBox(double height, double width) {
    return SizedBox(height: height, width: width);
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
