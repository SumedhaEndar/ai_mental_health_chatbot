import 'package:ai_mental_health_chatbot/screens/chatbot/consts.dart';
import 'package:ai_mental_health_chatbot/screens/home/home.dart';
import 'package:ai_mental_health_chatbot/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

import 'package:flutter/services.dart';

// Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  // Lock the app in portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Gemini.init(apiKey: GEMINI_API_KEY,);

  runApp( const MaterialApp(
    home: Login(),
  ));
}
