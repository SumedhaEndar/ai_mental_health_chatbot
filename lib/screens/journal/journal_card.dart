import 'package:ai_mental_health_chatbot/screens/journal/models/journal_model.dart';
import 'package:flutter/material.dart';

class JournalCard extends StatelessWidget {
  const JournalCard({
    super.key,
    required this.selectedJournal,
    required this.selectedDay,
  });

  final Journal? selectedJournal;
  final DateTime? selectedDay;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  selectedDay != null
                      ? selectedDay!.toLocal().toString().split(' ')[0]
                      : 'No date selected',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                child: Divider(
                  thickness: 1,
                ),
              ),
              selectedJournal != null
              ? Text(
                selectedJournal!.content,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w400),
              )
              : const Text(
                'No journal entry for this day.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              if (selectedJournal != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    'Rate: ${selectedJournal!.rate}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
            ],
        ),
      ),
    );
  }
}