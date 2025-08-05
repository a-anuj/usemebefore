import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';


class Landing extends StatefulWidget{
  const Landing ({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LandingState();
  }
}

class _LandingState extends State<Landing>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title:Text(
            "useMeBefore",
            style: GoogleFonts.lato(
            fontSize: 27,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
            ),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        actions: [
          IconButton(
              onPressed: (){
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(
                  Icons.logout_outlined,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
          )
        ],
      ),
      body: Center(
        child: Text(
            "Added items will be listed here...",
            style:GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.normal,
              color: Colors.grey,
            ) ,
        ),
      ),
    );

  }
}