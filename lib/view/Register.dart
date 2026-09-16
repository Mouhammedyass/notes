import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:first_app/view/textformfield.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
class Register extends StatefulWidget {
  const Register({super.key });
  @override
  State<Register> createState() => _RegisterState();
}
class _RegisterState extends State<Register>{
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // LocalController localCont = Get.find();
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        children: [
          SizedBox(height: 80),
          Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(51),
                        spreadRadius: 10.0,
                        blurRadius: 10.0,
                      ),
                    ],
                  ),
                  child: Icon(Icons.note_add_outlined, size: 100)),
              SizedBox(height: 30),
              ListTile(
                title: Text("Register", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                subtitle: Text("Enter your personal information", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[500])),
              ),
              SizedBox(height: 1),
              ListTile(
                title: Text("Username", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
              ),
              SizedBox(height: 1),
              CustomTextformfield(hinttext: "Enter your username", myController: username),
              SizedBox(height: 5),
              ListTile(
                title: Text("Email", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
              ),
              SizedBox(height: 1),
              CustomTextformfield(hinttext: "Enter your email", myController: email),
              SizedBox(height: 5),
              ListTile(
                title: Text("Password", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
              ),
              CustomTextformfield(hinttext: "Enter your password", myController: password),
              SizedBox(height: 5),
              ListTile(
                title: Text("Confirm password", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
              ),
              CustomTextformfield(hinttext: "Enter Confirm password", myController: confirmPassword),
              SizedBox(height: 30),
            ],
          ),
        MaterialButton(
          onPressed: () async {
            if (email.text.isEmpty || password.text.isEmpty) {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.warning,
                animType: AnimType.rightSlide,
                title: 'Warning',
                desc: 'Please enter your personal information',
                btnOkOnPress: () {},
              ).show();
              return;
            }

            try {
              // 2️⃣ Register user without unused variable

              final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(

                email: email.text.trim(),
                password: password.text,
              );
              // جوه صفحة الـ Register بعد إنشاء الحساب مباشرة:
              await credential.user!.updateDisplayName(username.text.trim());
              await FirebaseAuth.instance.currentUser!.sendEmailVerification();
              AwesomeDialog(
                context: context,
                dialogType: DialogType.error,
                animType: AnimType.rightSlide,
                title: 'Verify Your Email',
                desc: 'A verification link has been sent to your email. Please verify and login.',
                btnOkOnPress: () {
                  Get.offNamed("/login");
                },
              ).show();
            } on FirebaseAuthException catch (e) {
              print("Firebase Auth Register Error Code: ${e.code}");

              if (e.code == 'email-already-in-use') {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.error,
                  animType: AnimType.rightSlide,
                  title: 'Registration Failed',
                  desc: 'The email address is already in use by another account.',
                  btnOkOnPress: () {},
                ).show();
              } else if (e.code == 'weak-password') {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.error,
                  animType: AnimType.rightSlide,
                  title: 'Weak Password',
                  desc: 'The password provided is too weak. It must be at least 6 characters.',
                  btnOkOnPress: () {},
                ).show();
              } else if (e.code == 'invalid-email') {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.error,
                  animType: AnimType.rightSlide,
                  title: 'Invalid Email',
                  desc: 'The email address format is not valid.',
                  btnOkOnPress: () {},
                ).show();
              } else {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.error,
                  animType: AnimType.rightSlide,
                  title: 'Error',
                  desc: e.message ?? 'An unknown error occurred.',
                  btnOkOnPress: () {},
                ).show();
              }
            } catch (e) {
              print("General Error: $e");
            }
          },
          color: Colors.blue,
          height: 50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: const Text(
            "Register",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 0,
            children: [
              Text("Have an account?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              MaterialButton(onPressed: (){
                Get.toNamed("/login");
              }, child: Text("Login" , style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),)
            ],
          )
        ],
      ),

    );
  }
}