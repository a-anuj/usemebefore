import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usemebefore/widgets/Item.dart';
import 'package:usemebefore/widgets/ItemCard.dart';

class Landing extends StatefulWidget{
  const Landing ({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LandingState();
  }
}

class _LandingState extends State<Landing>{
  List<Item> foodList = [
    Item(
      title: 'Milk',
      expiryDate: '2025-08-10',
      storage: 'Fridge',
      note: 'Use within 2 days',
      imageUrl: "Pass for now"
    ),
    Item(
      title: 'Eggs',
      expiryDate: '2025-08-12',
      storage: 'Fridge',
      note: 'Boil before use',
      imageUrl: 'Pass for now'
    ),

  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title:Text(
            "useMeBefore",
            style: GoogleFonts.lato(
            fontSize: 24,
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
        child: ListView.builder(
          itemCount: foodList.length,
          itemBuilder: (context, index) {
            return ItemCard(food: foodList[index]);
          },
        )

      ),
    );

  }
}