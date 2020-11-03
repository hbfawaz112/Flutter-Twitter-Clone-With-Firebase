import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/utils/variables.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  var usernamecontroller = TextEditingController();
  var passwordcontroller = TextEditingController();
  var emailcontroller = TextEditingController();
  
   signup(){

      FirebaseAuth.instance.createUserWithEmailAndPassword
         (
        email: emailcontroller.text,password: passwordcontroller.text
         ).then((signeduser) => {
           usercollection.doc(signeduser.user.uid).set({
             'uid':signeduser.user.uid,
             'username': usernamecontroller.text,
             'password' : passwordcontroller.text,
             'email': emailcontroller.text,
             'profilepicture' : 'https://resource3.s3-ap-southeast-2.amazonaws.com/img/defaults/default-user-avatar.png'
           })
         }) ;



  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
    body: SingleChildScrollView(
   physics: ScrollPhysics(),
          child: Container(
        alignment:Alignment.center,
        child:Padding(
          padding: const EdgeInsets.only(top:90),
          child: Column(
               
               mainAxisAlignment: MainAxisAlignment.center,
            
               children: <Widget>[


                Text(
                  "Get Started !!",
                   style: mystyle(40,Colors.white,FontWeight.w700),
                   ) , 

                   SizedBox(height:10),


                Text(
                  "Create an account",
                   style: mystyle(25,Colors.white,FontWeight.w700),
                   ) , 


                   SizedBox(height:30),

                   Container(
                     width: MediaQuery.of(context).size.width,
                     margin: EdgeInsets.only(left:20 , right: 20),
                     child: TextField(
                       controller:usernamecontroller ,
                       //keyboardType:TextInputType.emailAddress,
                       decoration:InputDecoration(
                         filled: true,
                         labelText: 'User Name',
                         fillColor: Colors.white,
                         labelStyle: mystyle(15),
                         border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(20)
                         ),
                         prefixIcon: Icon(Icons.person)
                          ),
                          
                     ),
                   ),

                  SizedBox(height:20),

                   Container(
                     width: MediaQuery.of(context).size.width,
                     margin: EdgeInsets.only(left:20 , right: 20),
                     child: TextField(
                       controller: emailcontroller,
                       keyboardType:TextInputType.emailAddress,
                       decoration:InputDecoration(
                         filled: true,
                         labelText: 'Email',
                         fillColor: Colors.white,
                         labelStyle: mystyle(15),
                         border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(20)
                         ),
                         prefixIcon: Icon(Icons.email)
                          ),
                          
                     ),
                   ),

                     SizedBox(height:20),

                   Container(
                     width: MediaQuery.of(context).size.width,
                     margin: EdgeInsets.only(left:20 , right: 20),
                     child: TextField(
                       controller: passwordcontroller,
                      obscureText: true,
                       decoration:InputDecoration(
                         filled: true,
                         labelText: 'Password',
                         fillColor: Colors.white,
                         labelStyle: mystyle(15),
                         border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(20)
                         ),
                         prefixIcon: Icon(Icons.lock)
                          ),
                          
                     ),
                   ),

                   SizedBox(height:20),

                   InkWell(
                      onTap: ()=>signup(),
                      child: Container(
                       width:MediaQuery.of(context).size.width/2,
                       height:50,decoration: BoxDecoration(
                         color:Colors.white,
                         borderRadius:BorderRadius.circular(20),

                       ),


                       child: Center(child: 
                        Text("SignUp", style: mystyle(20,Colors.black, FontWeight.w700),)
                       )

                     ),
                   ),


                   SizedBox(height:30), 

                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: <Widget>[

                          Text("Already have an account?" , style: mystyle(18),),

                          SizedBox(width:10),

                         InkWell(
                           onTap: ()=>{
                             Navigator.pop(context)
                           },
                           child: Text("Login here" , style: mystyle(18 , Colors.purple , FontWeight.w700),)),
                              
                   ],)



            ],),
        )
      ),
    )
    
    );
  }
}