import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/CustomCard.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'addNote.dart';
import 'editNote.dart';

class ViewPage extends StatefulWidget {
  final String categoryId;
  const ViewPage({super.key, required this.categoryId,});

  @override
  State<ViewPage> createState() => _ViewPage();
}

class _ViewPage extends State<ViewPage> {
  String? userName;
  Future<void> getUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
      setState(() {
        userName = FirebaseAuth.instance.currentUser?.displayName;
      });
    }
  }

  List<QueryDocumentSnapshot> data = [];
  bool loading = true;
  Future<void> getData()async{
    data.clear();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('categories').doc(widget.categoryId).collection('note').get();
    data.addAll(querySnapshot.docs);
    loading = false;
    setState(() {

    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null || !user.emailVerified) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed("/login");
      });
    }
    // LocalController localCont = Get.find();
    return Scaffold(
      // appBar: AppBar(title: Text("1".tr), backgroundColor: Colors.grey,),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: (){
            Get.to(() => AddNote(docId: widget.categoryId))?.then((value) {
              setState(() {
                loading = true; // عشان يظهر الـ Progress Indicator لحظياً
              });
              getData(); // يجيب الداتا الجديدة من الفايربيس
            });
          },child: Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Text("Firebase"),
          backgroundColor: Colors.grey[400],
          shadowColor: Colors.black,
          actions: [
            IconButton(onPressed: () async{
              GoogleSignIn googleSignIn = GoogleSignIn();
              googleSignIn.disconnect();
              await FirebaseAuth.instance.signOut();
              Get.offAllNamed("/login");
            }, icon: Icon(Icons.exit_to_app))
          ],
        ),

        body: loading? Center(child: CircularProgressIndicator()) : GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisExtent: 170, crossAxisSpacing: 8, mainAxisSpacing: 8),
          itemCount: data.length,
          itemBuilder: (context, i){
            return InkWell(
              onLongPress: (){
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.warning,
                  animType: AnimType.rightSlide,
                  title: 'Warning',
                  desc: 'Choose what do you want to do with this category',

                  btnCancelText: "Delete",
                  btnCancelOnPress: () async {
                    // ✅ مسار الحذف الصحيح من الـ Subcollection
                    await FirebaseFirestore.instance
                        .collection("categories")
                        .doc(widget.categoryId) // ID الكاتيجوري
                        .collection("note")
                        .doc(data[i].id) // ID النوت
                        .delete();

                    // تحديث الصفحة الحالية بدون ما نعمل Get.off
                    setState(() { loading = true; });
                    getData();
                  },
                  btnOkText: "Edit",
                  btnOkOnPress: () async {
                    // ✅ استدعاء صفحة EditNote وتمرير الـ 3 متغيرات
                    Get.to(() => EditNote(
                      noteDocId: data[i].id,
                      value: data[i]['note'],
                      categoryDocId: widget.categoryId,
                    ))?.then((value) {
                      // لما يرجع من التعديل يعمل ريفريش
                      setState(() { loading = true; });
                      getData();
                    });
                  },
                ).show();},
              child: CustomInfoCard(
                title: '${data[i]['note']}',
                onTap: () {
                  print('Navigating to profile...');
                },
              ),
            );


          },
        ),
    );
  }
}