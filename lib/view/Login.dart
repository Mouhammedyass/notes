import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/view/textformfield.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({super.key });

  @override
  State<Login> createState() => _LoginState();
}
class _LoginState extends State<Login>{
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
bool isLoading = false;

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    Get.offAllNamed("/home");
  }

  @override
  Widget build(BuildContext context) {
    // LocalController localCont = Get.find();
    return Scaffold(

      body: isLoading? Center(child: CircularProgressIndicator()) : ListView(
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
                title: Text("Login", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                subtitle: Text("Login to continue using the app", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[500])),
              ),
              SizedBox(height: 10),
              ListTile(
                title: Text("Email", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
              ),
              SizedBox(height: 10),
              CustomTextformfield(hinttext: "Enter your email", myController: email,),
              SizedBox(height: 10),
              ListTile(
                title: Text("Password", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
              ),
              CustomTextformfield(hinttext: "Enter your password", myController: password),
              SizedBox(height: 5),
              InkWell(
                onTap: () async {
                  // 1. التأكد إن حقل الإيميل مش فاضي
                  if (email.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter your email first!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  try {
                    // 2. إرسال إيميل إعادة التعيين (مع عمل trim للمسافات)
                    await FirebaseAuth.instance.sendPasswordResetEmail(
                      email: email.text.trim(),
                    );

                    // 3. طريقة عرض الـ SnackBar الصحيحة
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Reset password email sent! Check your inbox.'),
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  } on FirebaseAuthException catch (e) {
                    // 4. التقاط أخطاء الفايربيس (زي لو الإيميل مش موجود)
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.message ?? 'An error occurred'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: Container(
                  padding: const EdgeInsets.only(right: 20),
                  alignment: Alignment.centerRight,
                  child: const Text("Forgot Password?"),
                ),
              ),
              SizedBox(height: 10),

            ],
          ),
        MaterialButton(
          onPressed: () async {
            // 👈 تأكد إن الحقول مش فاضية قبل ما تبعت لـ Firebase
            if (email.text.isEmpty || password.text.isEmpty) {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.error,
                animType: AnimType.rightSlide,
                title: 'Warning',
                desc: 'Please enter both email and password',
                btnOkOnPress: () {},
              ).show();
              return;
            }

            try {
              isLoading = true;
              final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: email.text.trim(),
                password: password.text,
              );
              isLoading = false;
              setState(() {

              });
              if(credential.user!.emailVerified){
                Get.offAllNamed("/home");
              }
              else{
                AwesomeDialog(
                    context: context,
                    dialogType: DialogType.error,
                    animType: AnimType.rightSlide,
                    title: 'Verify email',
                    desc: 'Please verify your email').show();
              }
            } on FirebaseAuthException catch (e) {
              print("Firebase Auth Error Code: ${e.code}");

              if (e.code == 'invalid-credential' || e.code == 'user-not-found' || e.code == 'wrong-password') {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.error,
                  animType: AnimType.rightSlide,
                  title: 'Login Failed',
                  desc: 'The email or password you entered is incorrect.',
                  btnOkOnPress: () {},
                ).show();
              } else if (e.code == 'invalid-email') {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.error,
                  animType: AnimType.rightSlide,
                  title: 'Invalid Email',
                  desc: 'The email format is invalid.',
                  btnOkOnPress: () {},
                ).show();
              } else {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.error,
                  animType: AnimType.rightSlide,
                  title: 'Error',
                  desc: e.message ?? 'An unknown error occurred',
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
            "Login",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
          SizedBox(height: 10),
          Text("or Login with", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(onPressed: (){
                signInWithGoogle();
              }, icon: FaIcon(FontAwesomeIcons.google))
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 0,
            children: [
              Container(
                child: Text("Don't have an account?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
              ),
              MaterialButton(onPressed: (){
                Get.toNamed("/register");
              }, child: Text("Register" , style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),)
            ],
          )
        ],
      ),

    );
  }
}