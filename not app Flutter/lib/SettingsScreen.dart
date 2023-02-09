import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';



class SettingsScreen extends StatefulWidget{
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.blue,Colors.brown],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter
          )
      ),
      child: ListView(

        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Padding(
              padding: const EdgeInsets.only(top:3.0),
              child: ListTile(

                onTap: (){

                },
                leading: Icon(Icons.drive_file_rename_outline,color: Colors.green,),
                title:Text("Kullanıcı Adı Gir"),


              ),
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Padding(
              padding: const EdgeInsets.only(top:3.0),
              child: ListTile(

                onTap: (){

                },
                leading: Icon(Icons.account_circle_rounded,color: Colors.green,),
                title: Text('Profil Resmi Ekle'),

              ),
            ),
          ),
        ],



      ),
    );
  }


}
