import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../view/addtextformfield.dart';

class EditNote extends StatefulWidget {

  final String noteDocId;
  final String value;
  final String categoryDocId;
  const EditNote({super.key, required this.noteDocId, required this.value, required this.categoryDocId});

  @override
  State<EditNote> createState() => _EditNote();
}

class _EditNote extends State<EditNote> {

  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController note = TextEditingController();
  CollectionReference categories = FirebaseFirestore.instance.collection('categories');

  @override
  void initState() {
    super.initState();
    note.text = widget.value;
  }

  Future<void> editNote() async {

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {

      await FirebaseFirestore.instance
          .collection('categories')
          .doc(widget.categoryDocId)
          .collection('note')
          .doc(widget.noteDocId)
          .update({
        'note': note.text,
      });

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Category updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Get.offAllNamed("/home");

    } catch (error) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update category: $error'),
          backgroundColor: Colors.red,
        ),
      );
      print("Failed to update category: $error");
    }
  }


  @override
  void dispose() {
    super.dispose();
    note.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Category"),
        backgroundColor: Colors.grey[400],
        shadowColor: Colors.black,
      ),
      body: Form(
        key: formState,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: AddCustomTextFormField(
                hinttext: "Enter Category Name",
                myController: note,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "Can't be empty";
                  }
                  return null;
                },
              ),
            ),
            MaterialButton(
              onPressed: () {
                if (formState.currentState!.validate()) {
                  editNote();
                }
              },
              color: Colors.blue,
              height: 50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: const Text(
                "Save",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
