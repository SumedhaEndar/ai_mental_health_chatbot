import 'package:ai_mental_health_chatbot/screens/chatbot/consts.dart';
import 'package:ai_mental_health_chatbot/shared/styled_text.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});
  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  final Gemini gemini = Gemini.instance;

  ChatUser currentUser = ChatUser(id: '0', firstName: 'User');
  ChatUser geminiUser = ChatUser(id: '1', firstName: 'MindMate');

  List<ChatMessage> messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const StyledTitle('MindMate'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              'assets/img/wallpaper.jpg'), // Set the background image
          fit: BoxFit.cover, // Cover the entire screen
        ),
      ),
      child: DashChat(
        currentUser: currentUser,
        onSend: _sendMessage,
        messages: messages,
      ),
    );
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });

    try {
      String question = chatMessage.text;

      // Start receiving streamed responses from Gemini
      gemini.streamGenerateContent(question).listen((event) {
        // Process response text, clean unwanted characters, limit length, and humanize
        String responseText = _cleanResponse(event.content?.parts?.fold(
                "", (previous, current) => "$previous ${current.text}") ??
            "Sorry, I couldn't process that.");

        responseText = _limitResponseLength(responseText);
        responseText =
            _humanizeResponse(responseText); // Make it more human-like

        // Check if Gemini is already responding
        if (messages.isNotEmpty && messages.first.user == geminiUser) {
          // Update the existing message with more response data
          setState(() {
            messages[0].text +=
                responseText; // Append response to existing text
          });
        } else {
          // Create a new message from Gemini
          ChatMessage responseMessage = ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: responseText,
          );
          setState(() {
            messages = [responseMessage, ...messages];
          });
        }
      });
    } catch (e) {
      print(e); // Handle errors
    }
  }

  // Function to clean response text
  String _cleanResponse(String response) {
    // Remove any unwanted markdown-like formatting characters like *, _, etc.
    return response.replaceAll(RegExp(r'[^\w\s,.?!]'), '').trim();
  }

  // Function to limit response length
  String _limitResponseLength(String response, {int maxLength = 500}) {
    if (response.length > maxLength) {
      return response.substring(0, maxLength) +
          '...'; // Truncate long responses
    }
    return response;
  }

  // Function to humanize response text
  String _humanizeResponse(String response) {
    // Make it sound more conversational and natural
    response = response.replaceAll("I am", "I'm");
    response = response.replaceAll("you are", "you're");

    // Replace insensitive phrasing
    response = response.replaceAll(RegExp(r'many resources available to you'),
        'I’m here to help. Let me know how I can support you.');

    // Add more empathetic responses based on the content
    if (response.contains("I'm sorry")) {
      response = "Oh, I’m sorry to hear that. " + response;
    } else if (response.contains("It's okay")) {
      response = "It’s totally okay to feel like that. " + response;
    }

    // Add line breaks between sentences for readability
    response = response.replaceAll(RegExp(r'\.\s+'), '.\n\n');

    return response;
  }
}
