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
        leading: Builder(
            builder: (context){
              return IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: (){
                    Scaffold.of(context).openDrawer();
                  },
              );
            }
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(189, 204, 225, 1),
                ),
              child: Column(
                children: [
                  Flexible(
                    flex: 2, // Adjust flex to control space distribution
                    child: Image.asset('assets/img/care.png'),
                  ),
                  const Flexible(
                    flex: 1,
                    child: StyledTitle('MindMate'), // This assumes StyledTitle is a text widget
                  ),

                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.adb),
              title: const StyledLabel('AI Counselor'),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context)=> const Chatbot()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.bed),
              title: const StyledLabel('Bedtime Story'),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context)=> const Bedtime()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const StyledLabel('Logout'),
              onTap: (){
                // logout logic
              },
            )
          ],
        ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
                                const StyledLabel("AI Counselor"),
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
