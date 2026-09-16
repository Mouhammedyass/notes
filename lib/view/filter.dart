import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FilterFireStore extends StatefulWidget {
  const FilterFireStore({super.key});

  @override
  State<FilterFireStore> createState() => _FilterFireStore();
}

class _FilterFireStore extends State<FilterFireStore> {
  File? file;

  getImage() async{
    final picker = ImagePicker();
    // final XFile? imageGallery = await picker.pickImage(source: ImageSource.gallery);
    final XFile? photoCamera = await picker.pickImage(source: ImageSource.camera);

    file = File(photoCamera!.path);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Image picker"), backgroundColor: Colors.blue,),

      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: MaterialButton(
                shape: RoundedRectangleBorder(),
                color: Colors.blue,
                textColor: Colors.white,
                onPressed: () async{
                await getImage();
              },child: Text("Get a photo from camera"),),
            ),

            if(file!=null) Image.file(file!)

          ],
        ),

      ),
    );
  }
}







































/*



  // final Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance.collection("users").snapshots();
  // List<QueryDocumentSnapshot> data = [];
  //
  // initialDate()async{
  //   data.clear();
  //   CollectionReference users = FirebaseFirestore.instance.collection("users");
  //   QuerySnapshot userData = await users.get();
  //   userData.docs.forEach((element){
  //     data.add(element);
  //   });
  //   setState(() {});
  // }
  //
  // @override
  // void initState() {
  //   initialDate();
  //   super.initState();
  // }

return Scaffold(
      appBar: AppBar(title: Text("Filter", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),backgroundColor: Colors.blue,),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: (){
          CollectionReference users = FirebaseFirestore.instance.collection("users");
          WriteBatch batch = FirebaseFirestore.instance.batch();


        },child: Icon(Icons.add),),

      body: Container(
        child: StreamBuilder(
          stream: usersStream,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.hasError){
              return Text("Error");
            }
            if(snapshot.connectionState == ConnectionState.waiting){
              return Text("Loading...");
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, i){
                  return InkWell(
                    onTap: (){
                      DocumentReference documentReference = FirebaseFirestore.instance
                          .collection('users')
                          .doc(data[i].id);

                      FirebaseFirestore.instance.runTransaction((transaction) async {
                        DocumentSnapshot snapshot = await transaction.get(documentReference);

                        if (snapshot.exists) {
                          var snapshotData = snapshot.data();
                          if (snapshotData is Map<String , dynamic>){
                            int money = snapshotData['money'] + 100;
                            transaction.update(documentReference, {'money' : money}
                            );
                          }

                        }
                      }).then((value){
                        Navigator.of(context).pushNamedAndRemoveUntil("filter", (route) => false);
                      });

                    },
                    child: Card(
                      child: ListTile(
                        title: Text(data[i]['username'], style: TextStyle(fontSize: 20),),
                        subtitle: Text("age: ${data[i]['age']}"),
                        trailing: Text("${data[i]['money']}\$", style: TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold),),

                      ),
                    ),
                  );
                }

            );
          }

        ),
      ),

    );
 */