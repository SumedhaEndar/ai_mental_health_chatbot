import 'package:ai_mental_health_chatbot/screens/bedtime/bedtime.dart';
import 'package:ai_mental_health_chatbot/screens/chatbot/chatbot.dart';
import 'package:ai_mental_health_chatbot/shared/styled_text.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const StyledTitle('MindMate'),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/wallpaper.jpg'), // Replace with your image path
            fit: BoxFit.cover, // Adjust how the image should fit into the container
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: const StyledName("Hello Sumedha"),
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context)=> const Chatbot()),
                        );
                      },
                      child: Card(
                        child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                const StyledLabel("AI Counselor Chatbot"),
                                const SizedBox(height: 5),
                                Image.asset('assets/img/chatbot.png', width: 80,),
                              ],
                            ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context)=> const Bedtime()),
                        );
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              const StyledLabel("Bedtime Story"),
                              const SizedBox(height: 5),
                              Image.asset('assets/img/sleep.png', width: 80,),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
