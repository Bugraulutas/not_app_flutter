import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kanban_project/SigninScreen.dart';
import 'package:kanban_project/main.dart';




class GirisYap extends StatefulWidget {
   GirisYap({Key? key}) : super(key: key);
   @override
   State<GirisYap> createState() => _GirisYapState();
}


class _GirisYapState extends State<GirisYap> {
  var tfemailForSignIn=TextEditingController();
  var tfpasswordForSignIn =TextEditingController();

  FirebaseAuth auth=FirebaseAuth.instance;

  void SignInEmailAndPassword() async{
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: tfemailForSignIn.text,
          password: tfpasswordForSignIn.text);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyHomePage()));


    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Bu e mail için kullanıcı yok"),
        ));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Hatalı giriş"),
        ));
      }
    }

  }
  void signInWithGoogle() async {
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
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(


      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.blue,Colors.brown],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter
            )
        ),
        child: Center(


          child: Column(


            children: [
              Padding(
                padding: const EdgeInsets.only(top: 66.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.account_balance_sharp,size: 39,color:Colors.white),
                  Text("NOTEPP",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white,fontStyle: FontStyle.italic),),

                  ],
                ),
              ),

              const SizedBox(height: 50),




              Container(
                  margin: EdgeInsets.only(left:13,right: 13),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(21)),
                  color: Colors.black12
                ),
                child: TextField(
                  controller:tfemailForSignIn ,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.email,
                      color:Colors.white
                    ),
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.black38),
                  ),

                ),

              ),
              const SizedBox(height: 20,),
              Container(

                margin:EdgeInsets.only(left:13,right: 13),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(21)),
                  color: Colors.black12,
                  ),
                child: TextField(
                  controller:tfpasswordForSignIn ,
                  style: TextStyle(color:Colors.black),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.password,
                      color: Colors.white,
                    ),
                    hintText: "Password",
                    hintStyle: TextStyle(color:Colors.black38),

                  ),
                ),

              ),
              const SizedBox(height: 20,),




              ElevatedButton(onPressed: (){
                SignInEmailAndPassword();
              },style: ElevatedButton.styleFrom(primary:Colors.white,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),minimumSize: Size(300, 43)), child: Text("Oturum Aç",style: TextStyle(fontSize: 20,color: Colors.black),),),



              ElevatedButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>UyeOl()));
              },style: ElevatedButton.styleFrom(primary:Colors.blue.shade600,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),minimumSize: Size(300, 43)), child: Text("Yeni Hesap Oluştur",style: TextStyle(fontSize: 18,color: Colors.black),),),
                
                SizedBox(height: 30),
              
              SignInButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                Buttons.Google,
                text: "Sign up with Google",
                onPressed: () {
                  signInWithGoogle();
                },
              ),




            ],
          ),
        ),
      )
    );
  }
}
