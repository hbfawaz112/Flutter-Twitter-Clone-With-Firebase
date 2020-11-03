import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/utils/variables.dart';
import 'pages/profile.dart';
import 'pages/search.dart';
import 'pages/tweets.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

int  page = 0;

    List pageopttions = [
      TweetsPage(),SearchPage(),ProfilePage()
    ];

  logout(){
    FirebaseAuth.instance.signOut();
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageopttions[page],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState((){
              page=index;
           }
          );
        },
        selectedItemColor: Colors.lightBlue,
        unselectedItemColor: Colors.black,
        currentIndex: page,
        items :[

          BottomNavigationBarItem(

            icon:Icon(Icons.home , size:32,  ) , 
            title:Text("Tweets" , style:mystyle(20)),
          ),

              BottomNavigationBarItem(

            icon:Icon(Icons.search , size:32,  ) , 
            title:Text("Search" , style:mystyle(20)),
          ),

          BottomNavigationBarItem(

            icon:Icon(Icons.person , size:32,  ) , 
            title:Text("Profile" , style:mystyle(20)),
          )
          
          

        ]
        ),
    );
  }
}