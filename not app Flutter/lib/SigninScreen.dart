import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kanban_project/main.dart';




class UyeOl extends StatefulWidget {
  UyeOl({Key? key}) : super(key: key);
  @override
  State<UyeOl> createState() => _UyeOlState();
}


class _UyeOlState extends State<UyeOl> {
  var tfemail=TextEditingController();
  var tfpassword =TextEditingController();

  FirebaseAuth auth=FirebaseAuth.instance;
  FirebaseDatabase database = FirebaseDatabase.instance;

  CreateUser() async{
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: tfemail.text,password: tfpassword.text);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyHomePage()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Şifre çok kısa"),
        ));

      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Hesap zaten var"),
        ));
      }
    } catch (e) {
      print(e);
    }

  }



  @override
  Widget build(BuildContext context) {
    database.setPersistenceEnabled(true);


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

                  margin:EdgeInsets.only(left:13,right: 13),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(21)),
                    color: Colors.black12,
                  ),


                ),

                const SizedBox(height: 20,),

                Container(
                  margin: EdgeInsets.only(left:13,right: 13),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(21)),
                      color: Colors.black12
                  ),
                  child: TextField(
                    controller:tfemail ,
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
                    controller:tfpassword ,
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
                  CreateUser();
                },style: ElevatedButton.styleFrom(primary:Colors.white,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),minimumSize: Size(300, 43)), child: Text("Üye Ol",style: TextStyle(fontSize: 23,color: Colors.black),),),





              ],
            ),
          ),
        )
    );
  }
}
