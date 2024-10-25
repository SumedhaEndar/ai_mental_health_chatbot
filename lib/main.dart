import 'package:ai_mental_health_chatbot/screens/chatbot/consts.dart';
import 'package:ai_mental_health_chatbot/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

void main() {
  Gemini.init(apiKey: GEMINI_API_KEY,);
  runApp(const MaterialApp(
    home: Home(),
  ));
}
