import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/utils/variables.dart';
import 'package:timeago/timeago.dart' as timeago;
class CommmentPage extends StatefulWidget {

  final String documentid;

  const CommmentPage({Key key, this.documentid}) : super(key: key);

  @override
  _CommmentPageState createState() => _CommmentPageState(documentid);
}

class _CommmentPageState extends State<CommmentPage> {
  final String documentid;

  _CommmentPageState(this.documentid);
  var commentcontroller = TextEditingController();


  addcomment() async{
    var firebaseuser = FirebaseAuth.instance.currentUser;
      DocumentSnapshot userdoc = await usercollection.doc(firebaseuser.uid).get(); 
      tweetcollection.doc(documentid).collection('comments').doc().set(
        {
          'comment': commentcontroller.text, 
          'username': userdoc['username'],
          'uid' : userdoc['uid'],
          'profilepicture':userdoc['profilepicture'],
          'time':DateTime.now()

        }
      );
      DocumentSnapshot commentcount = await tweetcollection.doc(documentid).get();

      tweetcollection.doc(documentid).update(
        {
            'commentcount' : commentcount['commentcount']+1
        }
      );
      commentcontroller.clear();
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
          ],
        )
      ),
    
      body:
      SingleChildScrollView(
        physics: ScrollPhysics() ,

              child: Container(
                width: MediaQuery.of(context).size.width ,
                height: MediaQuery.of(context).size.height -70 ,
                child: Column(
                  children: [

                    Expanded(
                      child: StreamBuilder(
                     stream: tweetcollection.doc(documentid).collection('comments').snapshots(),
          builder:(context,snapshot){
            if(!snapshot.hasData){
                      return CircularProgressIndicator();
            }
            return ListView.builder(
              shrinkWrap: true,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder:(context,index){
                        DocumentSnapshot commentdoc = snapshot.data.documents[index];
                          return ListTile(
                            leading : CircleAvatar(
                                  backgroundColor: Colors.white,
                                  backgroundImage: NetworkImage(commentdoc['profilepicture']),

                            ),
                            title: Row(
                              children: [
                            
                                Text(commentdoc['username'] , style:mystyle(18,Colors.black,FontWeight.w700)),
                                SizedBox(width:60),
                            Text(
                            timeago.format(commentdoc['time'].toDate()).toString()
                            ),
                            
                              ],
                            ) , 
                            subtitle: 
                            Column(
                              children: [
                                 SizedBox(height:15),
                                Text(commentdoc['comment'] , style:mystyle(16,Colors.black , FontWeight.w300)),
                              Divider(
                                thickness: 3,
                              ),
                            
                              ],
                            ),
                             
                          );
                        }
                          );
                      
            
          }
        ),
                    ),
                    Divider(),
                    ListTile(
                      title:TextFormField(
                        controller: commentcontroller,
                        decoration: InputDecoration(
                          hintText:'Add a comment ...' , 
                          hintStyle:mystyle(18),
                          enabledBorder: UnderlineInputBorder(
                            borderSide:BorderSide(color:Colors.grey) ,
                            ),
                            focusedBorder: UnderlineInputBorder(
                            borderSide:BorderSide(color:Colors.grey) ,
                            )


                        )
                      ) ,
                      trailing: OutlineButton(
                        onPressed: ()=>{addcomment()},
                        borderSide:BorderSide.none,
                        child:Text("Publish" , style:mystyle(16))

                      ),
                      )
                  ],
                ),

              ),
      )
      
      );
  }
}