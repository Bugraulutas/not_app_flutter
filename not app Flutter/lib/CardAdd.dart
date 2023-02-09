import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kanban_project/main.dart';

class CardAdd extends StatefulWidget {
  const CardAdd({Key? key}) : super(key: key);

  @override
  State<CardAdd> createState() => _CardAddState();
}

class _CardAddState extends State<CardAdd> {
  var refCard=FirebaseDatabase.instance.ref().child(FirebaseAuth.instance.currentUser!.uid.toString());
  var tfCardName=TextEditingController();
  var tfCardArticle=TextEditingController();

  Future<void> kayitCard( String card_name,String card_article) async{
    var info=HashMap<String,dynamic>();
    info["card_id"]="";
    info["card_name"]=card_name;
    info["card_article"]=card_article;

    refCard.push().set(info);

  }
  Future<bool> backButton(BuildContext context) async{
    kayitCard(tfCardName.text, tfCardArticle.text);
    return true;
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(

        appBar: AppBar(
          leading: BackButton(
            onPressed: (){

              kayitCard(tfCardName.text, tfCardArticle.text);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyApp()));

            },
            color: Colors.white,
          ),

          flexibleSpace: Container(

            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                gradient: LinearGradient(
                    colors: [Colors.blue,Colors.brown],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter
                )
            ),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight:  Radius.circular(20))),
          title: Text("Notepp"),
        ),

        backgroundColor: Colors.white,
        body: WillPopScope(
          onWillPop: ()=>backButton(context),

          child: Center(


            child: Column(

              children: [


                const SizedBox(height: 50),
                Container(
                  margin:EdgeInsets.only(left:3,top: 1),
                  decoration: BoxDecoration(
                    color: Colors.white


                  ),
                  child: TextField(
                    controller:tfCardName ,
                    style: TextStyle(color:Colors.black),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.title,
                        color: Colors.black,
                      ),
                      hintText: "Not Başlığı",
                      hintStyle: TextStyle(color:Colors.black38),

                    ),
                  ),

                ),
                  Divider(),


                Expanded(
                  child: Container(


                    margin: EdgeInsets.only(left:3,top: 1),
                    decoration: BoxDecoration(


                    ),
                    child: TextFormField(
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller:tfCardArticle ,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        border: InputBorder.none,

                        hintText: '     Not Gir',
                        hintStyle: TextStyle(color: Colors.black38),
                      ),

                    ),

                  ),
                ),


              ],
            ),
          ),
        )
    );


  }
}
