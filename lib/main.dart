import 'package:flutter/material.dart';
import 'dart:async';

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
  String _currentWord = '';

  final String _sampleText = '''
  Speed reading is a collection of reading methods which attempt to increase rates of reading without greatly reducing comprehension or retention. Methods include chunking and eliminating subvocalization. The many available speed reading training programs may utilize books, videos, software, and seminars. There is little scientific evidence regarding speed reading, and as a result its value is controversial. Cognitive neuroscientist Stanislas Dehaene says that claims of reading up to 1,000 words per minute "must be viewed with skepticism".
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
    if (_words.isNotEmpty) {
      _currentWord = _words[0];
    }
  }

  void _startReading() {
    if (_words.isEmpty) return;

    setState(() {
      _isPlaying = true;
    });

    final interval = Duration(milliseconds: (60000 / _wordsPerMinute).round());
    
    _timer = Timer.periodic(interval, (timer) {
      if (_currentWordIndex >= _words.length) {
        _stopReading();
        return;
      }

      setState(() {
        _currentWord = _words[_currentWordIndex];
        _currentWordIndex++;
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
      _currentWord = _words.isNotEmpty ? _words[0] : '';
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
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Speed: '),
                DropdownButton<int>(
                  value: _wordsPerMinute,
                  items: [200, 300, 400, 500, 600, 800, 1000]
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

          // Word display area
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(16),
              child: Center(
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

          // Progress indicator
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
