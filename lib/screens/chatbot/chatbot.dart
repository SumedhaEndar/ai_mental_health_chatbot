import 'package:ai_mental_health_chatbot/shared/styled_text.dart';
import 'package:flutter/material.dart';

class Chatbot extends StatelessWidget {
  const Chatbot({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const StyledTitle('MindMate'),
          centerTitle: true,
        ),
      body: const Text("Chatbot"),
    );
  }
}
