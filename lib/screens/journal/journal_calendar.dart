import 'package:ai_mental_health_chatbot/screens/journal/journal_card.dart';
import 'package:ai_mental_health_chatbot/screens/journal/journal_page.dart';
import 'package:ai_mental_health_chatbot/screens/journal/models/journal_model.dart';
import 'package:ai_mental_health_chatbot/screens/journal/services/database_helper.dart';
import 'package:ai_mental_health_chatbot/shared/styled_text.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class JournalCalendar extends StatefulWidget {
  const JournalCalendar({super.key});

  @override
  State<JournalCalendar> createState() => _JournalCalendarState();
}

class _JournalCalendarState extends State<JournalCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Journal? _selectedJournal;
  Map<String, int> _journalRatings = {};

  @override
  void initState(){
    super.initState();
    _fetchAllJournalRatings();
    _fetchJournalForSelectedDay(_focusedDay);
  }

  // Fetch all journal ratings to color the calendar days
  Future<void> _fetchAllJournalRatings() async {
    final journals = await DatabaseHelper.getAllJournals();
    setState(() {
      _journalRatings = {
        for (var journal in journals ?? [])
          journal.id: journal.rate, // Map date string to rate
      };
    });
  }

  Future<void> _fetchJournalForSelectedDay(DateTime day) async {
    final String id = day.toLocal().toString().split(' ')[0]; // Format date as ID
    final journal = await DatabaseHelper.getJournalById(id);
    setState(() {
      _selectedJournal = journal; // Update the selected journal
    });
  }

  // Determine the color based on the journal's rating
  Color _getColorForRating(int rating) {
    if (rating >= 9) return Colors.green;
    if (rating >= 7) return Colors.lightGreen;
    if (rating >= 5) return Colors.yellow.shade700;
    if (rating >= 3) return Colors.red;
    return Colors.red.shade700;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const StyledTitle('MindMate'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  _fetchJournalForSelectedDay(selectedDay);
                },
                calendarFormat: CalendarFormat.month,
                startingDayOfWeek: StartingDayOfWeek.monday,
                availableGestures: AvailableGestures.all,
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                calendarBuilders: CalendarBuilders(
                  selectedBuilder: (context, day, focusedDay) {
                    String dayId = day.toLocal().toString().split(' ')[0];
                    if (_journalRatings.containsKey(dayId)) {
                      int rating = _journalRatings[dayId]!;
                      return Container(
                        decoration: BoxDecoration(
                          color: _getColorForRating(rating),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${day.day}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }
                    return null; // Default styling for days without journals
                  },
                  defaultBuilder: (context, day, focusedDay) {
                    String dayId = day.toLocal().toString().split(' ')[0];
                    if (_journalRatings.containsKey(dayId)) {
                      int rating = _journalRatings[dayId]!;
                      return Container(
                        decoration: BoxDecoration(
                          color: _getColorForRating(rating),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${day.day}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }
                    return null; // Default styling for days without journals
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            JournalCard(selectedJournal: _selectedJournal, selectedDay: _selectedDay),
          ],
        ),
      ),
      // Add the floating action button for adding a journal entry
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_selectedDay != null) {
            // Navigate to the Journal Entry Page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => JournalPage(selectedDate: _selectedDay!),
              ),
            ).then((_){
              _fetchJournalForSelectedDay(_selectedDay!);
              _fetchAllJournalRatings();
            });
          } else {
            // Show a message if no day is selected
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please select a day first.'),
              ),
            );
          }
        },
        tooltip: 'Add Journal',
        child: const Icon(Icons.add),
      ),
    );
  }
}
