import 'package:ai_mental_health_chatbot/screens/bedtime/duration_model.dart';
import 'package:ai_mental_health_chatbot/screens/bedtime/firebase_service.dart';
import 'package:ai_mental_health_chatbot/screens/bedtime/story_model.dart';
import 'package:ai_mental_health_chatbot/shared/styled_text.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';


class Bedtime extends StatefulWidget {
  const Bedtime({super.key});

  @override
  State<Bedtime> createState() => _BedtimeState();
}

class _BedtimeState extends State<Bedtime> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  late AudioPlayer _audioPlayer;
  late Stream<DurationState> _durationStateStream;
  List<Story> _playlist = [];  // Playlist will be fetched from Firebase
  int _currentStoryIndex = 0;

  void _playStory(int index) async{
    if (_playlist.isNotEmpty) {
      final ref = _storage.ref().child(_playlist[index].url);
      String url = await ref.getDownloadURL();
      _audioPlayer.setUrl(url);
      setState(() {
        _currentStoryIndex = index;
      });
    }
  }

  void _playNextStory() {
    if (_currentStoryIndex < _playlist.length - 1) {
      _playStory(_currentStoryIndex + 1);
      _audioPlayer.play();
    }
  }

  void _playPreviousStory() {
    if (_currentStoryIndex > 0) {
      _playStory(_currentStoryIndex - 1);
      _audioPlayer.play();
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  // Load songs from Firebase Realtime Database and Storage
  Future<void> _loadStories() async {
    final firebaseService = FirebaseService();
    final fetchedStories = await firebaseService.fetchStories();
    setState(() {
      _playlist = fetchedStories;
    });
    if (_playlist.isNotEmpty) {
      _playStory(_currentStoryIndex);  // Play the first story once the playlist is loaded
    }
  }

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _loadStories();  // Load songs from Firebase

    // Combine position, buffered position, and duration into one stream
    _durationStateStream = Rx.combineLatest3<Duration, Duration, Duration?, DurationState>(
      _audioPlayer.positionStream,
      _audioPlayer.bufferedPositionStream,
      _audioPlayer.durationStream,
          (position, bufferedPosition, duration) =>
          DurationState(position, bufferedPosition, duration ?? Duration.zero),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const StyledTitle('MindMate'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/img/wallpaper.jpg'), // Add your background image here
                  fit: BoxFit.cover,
                ),
              ),
            ),
            _playlist.isEmpty
            ? const Center(child: CircularProgressIndicator())  // Show loading spinner if playlist is empty
            : Column(
                children: [
                  const SizedBox(height: 10),
                  // Song image
                  Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset(
                    'assets/img/sleeptime.jpg',  // Song image
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                  const SizedBox(height: 10),

                  // Song title
                  StyledName(
                  _playlist[_currentStoryIndex].title,  // Current song title
                ),

                  const SizedBox(height: 10),

                  // Slider for audio position
                  StreamBuilder<DurationState>(
                    stream: _durationStateStream,
                    builder: (context, snapshot) {
                      final durationState = snapshot.data;
                      final position = durationState?.position ?? Duration.zero;
                      final duration = durationState?.duration ?? Duration.zero;

                      return Column(
                        children: [
                          Slider(
                            min: 0.0,
                            max: duration.inMilliseconds.toDouble(),
                            value: position.inMilliseconds.toDouble().clamp(0.0, duration.inMilliseconds.toDouble()),
                            onChanged: (value) {
                              _audioPlayer.seek(Duration(milliseconds: value.round()));
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDuration(position),  // Current position
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Text(
                                  _formatDuration(duration),  // Total duration
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                // Play/Pause/Next/Previous button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.skip_previous),
                        iconSize: 48.0,
                        onPressed: _currentStoryIndex > 0 ? _playPreviousStory : null,  // Disable if first song
                      ),
                      StreamBuilder<PlayerState>(
                        stream: _audioPlayer.playerStateStream,
                        builder: (context, snapshot) {
                          final playerState = snapshot.data;
                          final processingState = playerState?.processingState;
                          final playing = playerState?.playing;
                          if (processingState == ProcessingState.loading || processingState == ProcessingState.buffering) {
                            return const CircularProgressIndicator();
                          } else if (playing != true) {
                            return IconButton(
                              icon: const Icon(Icons.play_arrow),
                              iconSize: 64.0,
                              onPressed: _audioPlayer.play,
                            );
                          } else if (processingState != ProcessingState.completed) {
                            return IconButton(
                              icon: const Icon(Icons.pause),
                              iconSize: 64.0,
                              onPressed: _audioPlayer.pause,
                            );
                          } else {
                            return IconButton(
                              icon: const Icon(Icons.replay),
                              iconSize: 64.0,
                              onPressed: () => _audioPlayer.seek(Duration.zero),
                            );
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_next),
                        iconSize: 48.0,
                        onPressed: _currentStoryIndex < _playlist.length - 1 ? _playNextStory : null,  // Disable if last song
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                // Playlist (below the player)
                  Expanded(
                    child: ListView.builder(
                      itemCount: _playlist.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_playlist[index].title),
                          onTap: () {
                            _playStory(index);
                          },
                          selected: index == _currentStoryIndex,
                          leading: Icon(
                            index == _currentStoryIndex ? Icons.music_note : Icons.queue_music,
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ]
      ),
    );
  }
}
