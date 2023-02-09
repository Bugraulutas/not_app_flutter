import 'dart:collection';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kanban_project/CardAdd.dart';
import 'package:kanban_project/Class/CardClass.dart';
import 'package:kanban_project/DeleteUserScreen.dart';
import 'package:kanban_project/DetailScreen.dart';
import 'package:kanban_project/SettingsScreen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'LoginScreen.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: ThemeData(
        primaryColor: Colors.blue
      ),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, userSnapshot) {
          if (userSnapshot.hasData) {
            return MyHomePage();
          }
          return GirisYap();
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {

  const MyHomePage({super.key});






  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool aramaYapiliyorMu = false;
  String aramaKelimesi = "";

FirebaseAuth auth=FirebaseAuth.instance;
var refList=FirebaseDatabase.instance.ref().child(FirebaseAuth.instance.currentUser!.uid.toString());
var tflist_name=TextEditingController();

Future<void> delete(String card_id) async{
  refList.child(card_id).remove();

}
Future<void> kayit( String list_name) async{
  var info=HashMap<String,dynamic>();
  info["list_id"]="";
  info["list_name"]=list_name;

  refList.push().set(info);

}

void signOut() async {
  var user=GoogleSignIn().currentUser;
  if(user!=null){
    await GoogleSignIn().disconnect();
  }

  await FirebaseAuth.instance.signOut();
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>GirisYap()));

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: aramaYapiliyorMu ?
          TextField(
            decoration: InputDecoration(hintText: "Not Başlığında Ara"),
            onChanged: (aramaSonucu){
              setState(() {
                aramaKelimesi = aramaSonucu;
              });
            },
          )
              : Text("Notepp"),
        actions: [
          aramaYapiliyorMu ?
          IconButton(
            icon: Icon(Icons.cancel),
            onPressed: (){
              setState(() {
                aramaYapiliyorMu = false;
                aramaKelimesi = "";
              });
            },
          ) : IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              setState(() {
                aramaYapiliyorMu = true;
              });
            },
          ),
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

      ),
      body: StreamBuilder<DatabaseEvent> (


        stream: refList.onValue,
        builder: (context,event){
          if(event.hasData){
            var noteList=<CardClass>[];

            var incomingValues=event.data!.snapshot.value as dynamic;

            if(incomingValues != null ){
              incomingValues.forEach((key,nesne){
                var incomingList=CardClass.fromJson(key,nesne);

               if(aramaYapiliyorMu){
                 if(incomingList.card_name.contains(aramaKelimesi)){
                   noteList.add(incomingList);
                 }
               }else{
                 noteList.add(incomingList);
               }





              });

            }
            return MasonryGridView.builder(gridDelegate:
            SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemCount: noteList.length,
              itemBuilder: (BuildContext context, int index) {
                var note=noteList[index];

                return ClipRect(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: 100,),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DetailScreen(note:note, )));
                        },
                        child: Container(


                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black,width: 0.3,style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white12,
                          ),

                        child: SingleChildScrollView(
                          child: Column(

                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0,left: 10),
                                child: Text(note.card_name,style: TextStyle(fontSize: 21,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0,left: 10),
                                child: Text(note.card_article,style: TextStyle(fontSize: 15,),),
                              ),
                            ],
                          ),
                        ),
                        ),
                      ),
                    ),
                  ),
                );
              },);




          }else{
            return Center();
          }

        },

      ),
      floatingActionButton:   FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>CardAdd()));
          // Add your onPressed code here!
        },

        backgroundColor: Colors.green,
        splashColor: Colors.blue,
        icon: const Icon(Icons.add,color: Colors.deepOrange), label: Text("Not Ekle"),
      ),
      drawer: Drawer(



        child: ListView(

          padding: EdgeInsets.zero,//başlığın tam yukarı 0 a 0 a olması için
          children: [
            UserAccountsDrawerHeader(
                accountName: Text(" "), accountEmail: Text(auth.currentUser!.email!),
              currentAccountPicture: Icon(Icons.account_balance_sharp,size: 100,color: Colors.white,),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.blue,Colors.brown],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter
                  )


              ),



            ),


            ListTile(
              leading: Icon(Icons.settings,color: Colors.black,),
              title: Text("Ayarlar",style: TextStyle(fontSize:16),),
              onTap: (){
                Navigator.pop(context);
                _createRoute();
                Navigator.push(context, MaterialPageRoute(builder: (context)=>SettingsScreen()));


                // Navigator.of(context).push(_createRoute());


              },

            ),
            ListTile(
              leading: Icon(Icons.exit_to_app,color: Colors.black,),
              title: Text("Hesaptan Çıkış Yap",style: TextStyle(fontSize:16),),
              onTap: (){
                  signOut();
              },
            ),
            ListTile(
              leading: Icon(Icons.delete,color: Colors.black,),
              title: Text("Hesabı Sil",style: TextStyle(fontSize:16),),
              onTap: (){
                _createRoute();
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>DeleteUserScreen()));
              },
            ),

          ],
        ),
      ),
    );

  }
    Route _createRoute() {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const SettingsScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1, 0);
          const end = Offset.zero;
          const curve = Curves.linear;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
    }
showAlertDialog(BuildContext context) {

  // set up the button
  Widget okButton = TextButton(
    child: Text("Oluştur"),
    onPressed: () {

        kayit(tflist_name.text);

      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Liste adı girin"),
    content: TextField(
      controller: tflist_name,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
       // border: InputBorder,

        hintText: 'Liste adı',
        hintStyle: TextStyle(color: Colors.black26),
      ),
    ),
    backgroundColor: Colors.white,


    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}



}



