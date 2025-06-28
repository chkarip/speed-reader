/// Speed Reader Flutter App
/// 
/// A dual-mode speed reading application featuring:
/// - RSVP (Rapid Serial Visual Presentation) word-by-word display
/// - Horizontal scrolling ticker mode
/// - Adjustable reading speeds and word groupings
/// - Speed multipliers for enhanced control
import 'package:flutter/material.dart';
import 'dart:async';
import 'horizontal_scroller.dart';

void main() {
  runApp(const SpeedReaderApp());
}

class SpeedReaderApp extends StatelessWidget {
  const SpeedReaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Speed Reader',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const SpeedReaderScreen(),
    );
  }
}

class SpeedReaderScreen extends StatefulWidget {
  const SpeedReaderScreen({super.key});

  @override
  State<SpeedReaderScreen> createState() => _SpeedReaderScreenState();
}

class _SpeedReaderScreenState extends State<SpeedReaderScreen> {
  Timer? _timer;
  int _currentWordIndex = 0;
  List<String> _words = [];
  bool _isPlaying = false;
  int _wordsPerMinute = 300;
  double _speedMultiplier = 1.0;
  int _wordsPerGroup = 1;
  String _currentWord = '';
  bool _isScrollingMode = false;
  
  String _fullText = '';

  final String _sampleText = '''
  Maya had always been fascinated by the old lighthouse on the cliff. Every evening, she would walk along the rocky shore and watch its beam sweep across the dark ocean. Tonight was different though. As she approached the lighthouse, she noticed something strange - the light was flickering in an unusual pattern. Three short flashes, followed by three long ones, then three short again. It was Morse code, she realized with excitement. Someone was trying to send a message. Her heart raced as she pulled out her phone to record the pattern. The lighthouse had been abandoned for decades, or so everyone believed. Who could be up there? And what were they trying to say? As the fog began to roll in from the sea, Maya made a decision that would change everything. She was going to climb that lighthouse tonight, no matter what secrets it might hold. The rusty gate creaked as she pushed it open, and the wooden stairs groaned under her feet. Each step brought her closer to solving the mystery that had captivated the small coastal town for years.
  ''';

  @override
  void initState() {
    super.initState();
    _loadText();
  }

  void _loadText() {
    _words = _sampleText
        .replaceAll('\n', ' ')
        .split(' ')
        .where((word) => word.isNotEmpty)
        .toList();
    
    // Prepare full text for scrolling mode
    _fullText = _words.join(' ');
    
    if (_words.isNotEmpty) {
      _updateCurrentWordDisplay();
    }
  }

  String _getWordGroup(int startIndex) {
    if (startIndex >= _words.length) return '';
    
    int endIndex = startIndex + _wordsPerGroup - 1;
    if (endIndex >= _words.length) endIndex = _words.length - 1;
    
    List<String> wordGroup = [];
    for (int i = startIndex; i <= endIndex; i++) {
      wordGroup.add(_words[i]);
    }
    
    return wordGroup.join(' ');
  }
  
  void _updateCurrentWordDisplay() {
    _currentWord = _getWordGroup(_currentWordIndex);
  }

  void _startReading() {
    if (_words.isEmpty) return;

    setState(() {
      _isPlaying = true;
    });

    if (!_isScrollingMode) {
      _startWordByWordMode();
    }
    // For scrolling mode, the HorizontalScroller widget handles its own animation
  }

  void _startWordByWordMode() {
    final interval = Duration(milliseconds: (60000 / _wordsPerMinute / _speedMultiplier).round());
    
    _timer = Timer.periodic(interval, (timer) {
      if (_currentWordIndex >= _words.length) {
        _stopReading();
        return;
      }

      setState(() {
        _updateCurrentWordDisplay();
        _currentWordIndex += _wordsPerGroup;
      });
    });
  }

  void _stopReading() {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
    });
  }

  void _resetReading() {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
      _currentWordIndex = 0;
      _updateCurrentWordDisplay();
    });
  }

  void _changeSpeed(int newWpm) {
    setState(() {
      _wordsPerMinute = newWpm;
    });
    
    if (_isPlaying) {
      _stopReading();
      _startReading();
    }
  }

  void _changeWordsPerGroup(int newWordsPerGroup) {
    setState(() {
      _wordsPerGroup = newWordsPerGroup;
      _updateCurrentWordDisplay();
    });
    
    if (_isPlaying) {
      _stopReading();
      _startReading();
    }
  }
  
  void _changeSpeedMultiplier(double newSpeedMultiplier) {
    setState(() {
      _speedMultiplier = newSpeedMultiplier;
    });
    
    if (_isPlaying) {
      _stopReading();
      _startReading();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speed Reader'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Speed control
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Speed: '),
                DropdownButton<int>(
                  value: _wordsPerMinute,
                  items: [100, 200, 300, 400, 500, 600, 800, 1000]
                      .map((wpm) => DropdownMenuItem(
                            value: wpm,
                            child: Text('$wpm WPM'),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) _changeSpeed(value);
                  },
                ),
              ],
            ),
          ),

          // Words per group row (only for RSVP mode)
          if (!_isScrollingMode)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Words per group: '),
                  Row(
                    children: [1, 2, 3, 4].map((count) => 
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ElevatedButton(
                          onPressed: () => _changeWordsPerGroup(count),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _wordsPerGroup == count 
                                ? Theme.of(context).primaryColor 
                                : null,
                            foregroundColor: _wordsPerGroup == count 
                                ? Colors.white 
                                : null,
                            minimumSize: const Size(40, 36),
                          ),
                          child: Text('$count'),
                        ),
                      )
                    ).toList(),
                  ),
                ],
              ),
            ),
          
          // Speed multiplier row
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Speed multiplier: '),
                Row(
                  children: [1.0, 1.5, 2.0, 3.0].map((multiplier) => 
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ElevatedButton(
                        onPressed: () => _changeSpeedMultiplier(multiplier),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _speedMultiplier == multiplier 
                              ? Theme.of(context).primaryColor 
                              : null,
                          foregroundColor: _speedMultiplier == multiplier 
                              ? Colors.white 
                              : null,
                          minimumSize: const Size(40, 36),
                        ),
                        child: Text('${multiplier}x'),
                      ),
                    )
                  ).toList(),
                ),
              ],
            ),
          ),

          // Display mode toggle
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Display Mode: '),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isScrollingMode = false;
                      if (_isPlaying) {
                        _stopReading();
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !_isScrollingMode 
                        ? Theme.of(context).primaryColor 
                        : null,
                    foregroundColor: !_isScrollingMode 
                        ? Colors.white 
                        : null,
                  ),
                  child: const Text('Word by Word'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isScrollingMode = true;
                      if (_isPlaying) {
                        _stopReading();
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isScrollingMode 
                        ? Theme.of(context).primaryColor 
                        : null,
                    foregroundColor: _isScrollingMode 
                        ? Colors.white 
                        : null,
                  ),
                  child: const Text('Scrolling Ticker'),
                ),
              ],
            ),
          ),

          // Word display area
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(16),
              child: _isScrollingMode ? 
                // Use the new HorizontalScroller widget
                HorizontalScroller(
                  text: _fullText,
                  wpm: _wordsPerMinute,
                  speedMultiplier: _speedMultiplier,
                  isPlaying: _isPlaying,
                ) :
                // Word by word display
                Center(
                  child: Text(
                    _currentWord,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ),
          ),

          // Progress indicator (only shown in word-by-word mode)
          if (!_isScrollingMode)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: _words.isEmpty ? 0 : _currentWordIndex / _words.length,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Word ${_currentWordIndex + 1} of ${_words.length}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),

          // Control buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _isPlaying ? _stopReading : _startReading,
                  icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                  label: Text(_isPlaying ? 'Pause' : 'Play'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isPlaying ? Colors.orange : Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _resetReading,
                  icon: const Icon(Icons.restart_alt),
                  label: const Text('Reset'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
