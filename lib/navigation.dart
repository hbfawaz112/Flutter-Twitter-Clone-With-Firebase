import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/signup.dart';
import 'package:twitter_clone/utils/variables.dart';

import 'home.dart';

class NavigationPage extends StatefulWidget {
  NavigationPage({Key key}) : super(key: key);

  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {

  bool isSigned = false;
    @override
  void initState() {
  super.initState();
 // ignore: deprecated_member_use
    FirebaseAuth.instance.onAuthStateChanged.listen((useraccount) {
      if(useraccount != null){
        setState(() {
          isSigned = true;
        });
      }
      else{
        setState(() {
          isSigned = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body : isSigned == false ? Login() : HomePage(),
    );
  }
}


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

    var emailcontroller = TextEditingController();
    var passwrodcontroller = TextEditingController();

  login(){
      FirebaseAuth.instance.signInWithEmailAndPassword(email: emailcontroller.text, 
      password: passwrodcontroller.text);
      
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.lightBlue,
    body: Container(
      alignment:Alignment.center,
      child:Column(
           
           mainAxisAlignment: MainAxisAlignment.center,
        
           children: <Widget>[


            Text(
              "Welcome",
               style: mystyle(40,Colors.white,FontWeight.w700),
               ) , 

               SizedBox(height:10),


            Text(
              "Login",
               style: mystyle(25,Colors.white,FontWeight.w700),
               ) , 


               SizedBox(height:30),

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
                   controller: passwrodcontroller,
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
                  onTap: ()=>{login()},
                    child: Container(
                   width:MediaQuery.of(context).size.width/2,
                   height:50,decoration: BoxDecoration(
                     color:Colors.white,
                     borderRadius:BorderRadius.circular(20),

                   ),


                   child: Center(child: 
                    Text("Login", style: mystyle(20,Colors.black, FontWeight.w700),)
                   )

                 ),
               ),
               SizedBox(height:30), 

               Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: <Widget>[

                      Text("No Account ?" , style: mystyle(20),),

                      SizedBox(width:10),

                     InkWell(
                       onTap: ()=>{
                         Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUp()))
                       },
                       child: Text("Register" , style: mystyle(20 , Colors.purple , FontWeight.w700),)),
                          
               ],)



        ],)
    )
    
    );
  }
}