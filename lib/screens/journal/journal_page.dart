import 'package:ai_mental_health_chatbot/screens/journal/gemini/gemini_services.dart';
import 'package:ai_mental_health_chatbot/screens/journal/models/journal_model.dart';
import 'package:ai_mental_health_chatbot/screens/journal/services/database_helper.dart';
import 'package:ai_mental_health_chatbot/shared/styled_text.dart';
import 'package:flutter/material.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({
    super.key,
    required this.selectedDate
  });

  final DateTime selectedDate;

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  // Controller for user input
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const StyledTitle('MindMate'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Journal for: ${widget.selectedDate.toLocal().toString().split(' ')[0]}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Add your journal input fields here
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Reflect on Today',
                  border: OutlineInputBorder(),
                ),
                maxLines: 20,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: SizedBox(
                height: 45,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(

                  onPressed: _saveJournal,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: const BorderSide(color: Colors.white, width: 0.75),
                    ),
                  ),
                  child: const Text('Save', style: TextStyle(fontSize: 25),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to save the journal to the database
  void _saveJournal() async {
    // Validate that content is not empty
    if (_contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please write something in your journal.'),
        ),
      );
      return;
    }

    // Apply the gemini_services textGenTextOnlyPrompt here and save it to rate
    int rating;
    try {
      // Attempt to get the rating
      rating = await textGenTextOnlyPrompt(_contentController.text);
    } catch (e) {
      // print('Error fetching rating from Gemini API: $e');
      rating = 5; // Use a default rating if something goes wrong
    }

    // Create a new Journal object with the default rate of 5
    final journal = Journal(
      id: widget.selectedDate.toLocal().toString().split(' ')[0], // Use the date as the ID
      content: _contentController.text, // User input from TextField
      rate: rating, // Default rate value
    );

    // Save the journal to the database
    await DatabaseHelper.addJournal(journal);

    // Show confirmation and pop the screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Journal saved successfully!'),
      ),
    );

    Navigator.pop(context); // Go back to the previous screen
  }
}
