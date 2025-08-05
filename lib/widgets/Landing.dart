import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usemebefore/widgets/Item.dart';
import 'package:usemebefore/widgets/ItemCard.dart';
import 'package:usemebefore/widgets/AddItem.dart';

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
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title:Text(
            "useMeBefore",
            style: GoogleFonts.lato(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
            ),
        backgroundColor: Color(0xFFE3F2FD),
        actions: [
          IconButton(
              onPressed: (){
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    title: Text(
                        "Add Food Item",
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                    ),
                    content: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
                      height: 300, // fixed height or adjust as needed
                      child: AddItemForm(),
                    ),
                  ),
                );

              },
              icon: Icon(Icons.add_circle)
          ),
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