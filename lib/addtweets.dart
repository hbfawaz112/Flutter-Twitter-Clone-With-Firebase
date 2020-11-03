import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/utils/variables.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddTweet extends StatefulWidget {
  @override
  _AddTweetState createState() => _AddTweetState();
}

class _AddTweetState extends State<AddTweet> {

  File imagepath ; 
  TextEditingController tweetcontroller = TextEditingController();
  bool uploading = false;
  pickImage( ImageSource source ) async {
    final image  = await ImagePicker().getImage(source:source) ;
    setState(() {
      imagepath=File(image.path);

    });

    Navigator.pop(context);
  }

    optionsdialog(){
      return showDialog(
        context:context,
        builder:(context){

          return SimpleDialog(

            children:[

              SimpleDialogOption(
                    onPressed: ()=>{pickImage(ImageSource.gallery)},
                    child:Text("Image From Gallery" , style:mystyle(20),)
              ),

              SimpleDialogOption(
                    onPressed: ()=>{pickImage(ImageSource.camera)},
                    child:Text("Image From Camera" , style:mystyle(20),)
              ),
              
              SimpleDialogOption(
                    onPressed: ()=>{Navigator.pop(context)},
                    child:Text("Cancel" , style:mystyle(20),)
              ),
              
            ]
          ); 
        }
      ); 
    }

    uploadimage(String id) async{
      StorageUploadTask storageUploadTask =  tweetpicures.child(id).putFile(imagepath);
      StorageTaskSnapshot storageTaskSnapshot = await storageUploadTask.onComplete;

      String downloadurl = await storageTaskSnapshot.ref.getDownloadURL();
      return downloadurl;
    }

 posttweet() async{
    setState(() {
      uploading = true;
    });
    var firebaseuser=  await FirebaseAuth.instance.currentUser;
    DocumentSnapshot userdoc = await usercollection.doc(firebaseuser.uid).get() as DocumentSnapshot;

      var alldocument = await tweetcollection.get();
      var length = alldocument.docs.length;

      //3 conditions: 

      /*1- Only Tweet (without image)*/
         if(tweetcontroller.text!='' && imagepath == null)
         {
              tweetcollection.doc('Tweet $length').set(
                {
                  'username': userdoc['username'],
                  'profilepicture': userdoc['profilepicture'],
                  'uid' : firebaseuser.uid,
                  'id' : 'Tweet $length',
                  'Datetime' : DateTime.now(),
                  'tweet':tweetcontroller.text,
                  'likes':[],
                  'commentcount':0,
                  'shares':0,
                  'type':1

                }
              );
              Navigator.pop(context); 
         }
         


      /*2- Only image (without tweet) */
       if(tweetcontroller.text=='' && imagepath != null)
         {
           String imageurl = await uploadimage('Tweet $length');
            tweetcollection.doc('Tweet $length').set(
                {
                  'username': userdoc['username'],
                  'profilepicture': userdoc['profilepicture'],
                  'uid' : firebaseuser.uid,
                  'id' : 'Tweet $length',
                  'Datetime' : DateTime.now(),
                  'image':imageurl,
                  'likes':[],
                  'commentcount':0,
                  'shares':0,
                  'type':2

                }
              );
              Navigator.pop(context); 
         }
      /*3- Both tweet and image*/
       if(tweetcontroller.text!='' && imagepath != null)
         {
            String imageurl = await uploadimage('Tweet $length');
            tweetcollection.doc('Tweet $length').set(
                {
                  'username': userdoc['username'],
                  'profilepicture': userdoc['profilepicture'],
                  'uid' : firebaseuser.uid,
                  'id' : 'Tweet $length',
                  'Datetime' : DateTime.now(),
                  'tweet':tweetcontroller.text,
                  'image':imageurl,
                  'likes':[],
                  'commentcount':0,
                  'shares':0,
                  'type':3

                }
              );
              Navigator.pop(context); 
         }
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:FloatingActionButton(

      onPressed : ()=>{posttweet()},
        child:Icon(Icons.publish , size:30)
      ),
      appBar:AppBar(
            leading:InkWell(
              onTap: ()=>{Navigator.pop(context)},
              child: Icon(Icons.arrow_back , size:32)
              ),
            title:Text("Add Tweets" , style:mystyle(20)),
            centerTitle: true,
            actions: [
              InkWell(
                onTap: ()=>optionsdialog(),
                child:Icon(Icons.photo,size:40)
              )
            ],
      ),

      body: uploading == false ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            Expanded(
              child: TextField(
                controller: tweetcontroller,
                  maxLines:null,
                  style:mystyle(20),
                  decoration:InputDecoration(
                    labelText:"What's happeninig now ??" , 
                    labelStyle: mystyle(25),
                    border: InputBorder.none
                  )
              ),
            ),
            imagepath == null ? Container() : 
            MediaQuery.of(context).viewInsets.bottom > 0 ? Container() : Image(
              width:200 , height:200 , image: FileImage(imagepath),
            )
      ],) : Container(
        child:Center(child: Text("Uploading....", style:mystyle(30)),)
      )

    );
  }
}