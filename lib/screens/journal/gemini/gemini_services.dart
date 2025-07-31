import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';


// Define the model and text generation function
Future<int> textGenTextOnlyPrompt(String inputPrompt) async {
  // Initialize the generative model with the specified Gemini version
  final model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: "Replace with your API Key", // Sumedha Gemini API Key
  );

  // Define your prompt
  final prompt = "$inputPrompt\n\nFrom the content above rate the emotion from 1 to 10, where the lower the more negative, the higher the more positive. Just give me the rating without any explanation.";

  try {
    // Generate content using the prompt
    final response = await model.generateContent([Content.text(prompt)]);
    final rating = int.parse(response.text!.trim());
    return rating;
  }
  catch (error) {
    // print('Error generating text: $error');
    return 5;
  }
}
