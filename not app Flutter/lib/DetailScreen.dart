import 'dart:collection';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'Class/CardClass.dart';

class DetailScreen extends StatefulWidget {

  CardClass note;


  DetailScreen({required this.note});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  var tfCardName=TextEditingController();
  var tfCardArticle=TextEditingController();
  var refList=FirebaseDatabase.instance.ref().child(FirebaseAuth.instance.currentUser!.uid.toString());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var c=widget.note;
    tfCardName.text=c.card_name;
    tfCardArticle.text=c.card_article;

  }
  Future<void> guncelle(String card_id,String card_name,String card_article) async {
    var info=HashMap<String,dynamic>();
    info["card_name"]=card_name;
    info["card_article"]=card_article;
    refList.child(card_id).update(info);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyApp()));


  }
  Future<void> delete(String card_id) async{
    refList.child(card_id).remove();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyApp()));


  }
  Future<bool> backButton(BuildContext context) async{
    print( widget.note.card_name);
    guncelle(widget.note.card_id, tfCardName.text, tfCardArticle.text);

    return true;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          leading: BackButton(
            onPressed: (){

              guncelle(widget.note.card_id, tfCardName.text, tfCardArticle.text);
                      print(widget.note.card_id);
                      print(widget.note.card_name);
                      print(widget.note.card_article);




            },
            color: Colors.white,
          ),
          actions: [
            IconButton(onPressed: (){ delete(widget.note.card_id);}, icon: Icon(Icons.delete),),


          ],
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
          backgroundColor: Colors.transparent,
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
                      hintStyle: TextStyle(color:Colors.black12),

                    ),
                  ),

                ),
                Divider(),
                const SizedBox(height: 20,),

                Expanded(
                  child: Container(


                    margin: EdgeInsets.only(left:3,top: 1),
                    decoration: BoxDecoration(

                       color: Colors.white
                    ),
                    child: TextFormField(
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller:tfCardArticle ,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                            Icons.note_add,
                            color:Colors.black
                        ),
                        hintText: 'Not',
                        hintStyle: TextStyle(color: Colors.black12),
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
