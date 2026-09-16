import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/CustomCard.dart';
import 'package:first_app/Notes/view.dart';
import 'package:first_app/view/edit.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key });

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
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
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('categories').where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
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
          Get.toNamed("/add");
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
                btnCancelOnPress: ()async{
                  await FirebaseFirestore.instance.collection("categories").doc(data[i].id).delete();
                  Get.offAllNamed('/home');
              },
                btnOkText: "Edit",
              btnOkOnPress: () async{
                Get.offAll(() => EditPage(
                  docId: data[i].id,
                  oldName: data[i]['name'],
                ),);
              },
            ).show();},
            child: CustomInfoCard(
              title: '${data[i]['name']}',
              onTap: () {
                Get.to(() => ViewPage(categoryId: data[i].id,

                ));
              },
            ),
          );


        },
      ),

    );
  }
}