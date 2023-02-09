import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kanban_project/main.dart';

import 'LoginScreen.dart';




class DeleteUserScreen extends StatefulWidget {
  DeleteUserScreen({Key? key}) : super(key: key);
  @override
  State<DeleteUserScreen> createState() => _DeleteUserScreenState();
}


class _DeleteUserScreenState extends State<DeleteUserScreen> {
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
          content: Text("bu email için kullanıcı yok"),
        ));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("hatalı giriş"),
        ));
      }
    }

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

                      Text("Hesabınızı Silmek İçin Mail Ve Parolanızı Tekrar Girin",
                        style:
                        TextStyle(fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontStyle: FontStyle.italic),

                      ),

                    ],
                  ),
                ),

                const SizedBox(height: 50),


                const SizedBox(height: 20,),

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
                  deleteUser();
                  signOut();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>GirisYap()));
                },style: ElevatedButton.styleFrom(primary:Colors.white,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),minimumSize: Size(300, 43)), child: Text("Hesabı Sil",style: TextStyle(fontSize: 23,color: Colors.black),),),








              ],
            ),
          ),
        )
    );
  }

  void deleteUser() async{
    if(auth.currentUser!=null){

      await auth.currentUser!.delete();
    }else{

    }

  }
  void signOut() async {
    await FirebaseAuth.instance.signOut();

  }
}
