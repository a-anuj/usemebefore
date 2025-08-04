import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Landing extends StatelessWidget{
  const Landing({super.key});
  
  @override
  Widget build(BuildContext context) {
    return(
        Scaffold(
      body: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children : [

            Text("Welcome to the landing page!"),
            ElevatedButton(
                onPressed: (){
                  FirebaseAuth.instance.signOut();
                },
                child: Text("Logout")
            )
          ],
        )

      ),
    )
    );
  }
}