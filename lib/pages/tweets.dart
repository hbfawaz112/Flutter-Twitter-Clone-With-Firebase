import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/utils/variables.dart';

import '../addtweets.dart';
import '../comments.dart';

class TweetsPage extends StatefulWidget {
  @override
  _TweetsPageState createState() => _TweetsPageState();
}

class _TweetsPageState extends State<TweetsPage> {
    String uid;

    initState(){
      super.initState();
      getcurrentusrerid();
    }

      logout()async{
        await FirebaseAuth.instance.signOut();
      }
    getcurrentusrerid() async {
         var fiebaseuser = await FirebaseAuth.instance.currentUser;
         setState(() {
           uid=fiebaseuser.uid;
         });
    }
    
    likepost(String documentid) async {
          var fiebaseuser = await FirebaseAuth.instance.currentUser;
          DocumentSnapshot document = await tweetcollection.doc(documentid).get();

          if(document['likes'].contains(fiebaseuser.uid))
          {
                tweetcollection.doc(documentid).update({
              'likes' : FieldValue.arrayRemove([fiebaseuser.uid])
            });
          } 
          else{
            tweetcollection.doc(documentid).update({
              'likes' : FieldValue.arrayUnion([fiebaseuser.uid])
            });
          }
          
    }

    sharepost(String postid, String tweet) async {
          Share.text('Twitter CLONE', tweet, 'text/plain');

          DocumentSnapshot document = await tweetcollection.doc(postid).get();
          tweetcollection.doc(postid).update({
            'shares' : document['shares']+1
          });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:  Drawer(
      child: ListView(
         padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
               Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
              Navigator.pop(context);
              },
            ),
          ],
        )),
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
       
        title:Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left:60),
              child: Text('Twitter' , style:mystyle(21,Colors.black , FontWeight.w900)),
            ),
           //Image(image: AssetImage('images/twitter-icon.png')),
           Image(image:NetworkImage('https://assets.stickpng.com/images/580b57fcd9996e24bc43c53e.png', 
           
           ) , width: 50 , height: 50,),
           Padding(
             padding: const EdgeInsets.only(left:25),
             child: IconButton(
               onPressed: ()=>{logout()},
               icon:Icon(Icons.logout)
             ),
           )
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed : (){
              Navigator.push(context,
               MaterialPageRoute(builder:(context)=>AddTweet())
               );
          } , 
        child: Icon(Icons.add , size:32)
      ) ,

      body: StreamBuilder(
        stream: tweetcollection.snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return CircularProgressIndicator();
          }
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder : (BuildContext context , int index){
              DocumentSnapshot tweetdoc = snapshot.data.documents[snapshot.data.documents.length-(index+1)];
                return Card(
                   
                  child: ListTile(
                    leading : CircleAvatar(
                      backgroundColor:Colors.white,
                      backgroundImage: NetworkImage(tweetdoc['profilepicture']),
                    ),

                    title: Text(tweetdoc['username'] , style: mystyle(18,Colors.black,FontWeight.w600)),
                   
                    subtitle:
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children:[ 
                        if(tweetdoc['type'] == 1)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(tweetdoc['tweet'] , style:mystyle(17, Colors.black, FontWeight.w300)),
                        ),
                      
                        if(tweetdoc['type'] == 2)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image(image: NetworkImage(tweetdoc['image'])),
                        ),

                          if(tweetdoc['type'] == 3)
                          Column(
                            children:[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(tweetdoc['tweet'] , style:mystyle(17,Colors.black, FontWeight.w300)),
                                ),
                                
                                Image(image: NetworkImage(tweetdoc['image'])),
                            ]
                          ),
                        
                        
                      SizedBox(height:10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: ()=>{
                                    Navigator.push(context,
                                    MaterialPageRoute(
                                      builder:(context)=>CommmentPage(documentid: tweetdoc['id'])
                                        )
                                    )
                                },
                                child: Icon(Icons.comment)) , 
                              SizedBox(width:10),
                              Text(tweetdoc['commentcount'].toString(), style: mystyle(16),),
                            ],
                          ),
                          
                          Row(
                            children: [
                              InkWell(
                                onTap: ()=>{likepost(tweetdoc['id'])},
                                child: 
                                tweetdoc['likes'].contains(uid)
                                 ?
                                Icon(Icons.favorite , color:Colors.red) : Icon(Icons.favorite_border)) ,
                              SizedBox(width:10),
                              Text(tweetdoc['likes'].length.toString(), style: mystyle(16),),
                            ],
                          ),
                         
                          Row(
                            children: [
                              InkWell(
                                onTap:()=>{ sharepost( tweetdoc['id'] , tweetdoc['tweet']  ) },
                                child: Icon(Icons.share)),
                              SizedBox(width:10),
                              Text(tweetdoc['shares'].toString(), style: mystyle(16),),
                            ],
                          ),
                         
                        ],)
                    ],),
                    
                  ),
                 
                );
                
            }
          );
        }
      ),
    );
  }
}