/// A widget that displays text scrolling horizontally like a news ticker.
/// The scroll speed is based on the provided WPM (Words Per Minute) and speed multiplier.
import 'package:flutter/material.dart';

class HorizontalScroller extends StatefulWidget {
  final String text;
  final int wpm;
  final double speedMultiplier;
  final bool isPlaying;

  const HorizontalScroller({
    super.key,
    required this.text,
    required this.wpm,
    required this.speedMultiplier,
    required this.isPlaying,
  });

  @override
  State<HorizontalScroller> createState() => _HorizontalScrollerState();
}

class _HorizontalScrollerState extends State<HorizontalScroller> with SingleTickerProviderStateMixin {
  late final AnimationController _scrollController;
  late final Animation<double> _scrollAnimation;
  final ScrollController _textScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController = AnimationController(
      duration: const Duration(seconds: 20), // Default, will be updated
      vsync: this,
    );

    _scrollAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scrollController, curve: Curves.linear),
    )..addListener(() {
      // This listener will help drive the manual scroll
      if (_textScrollController.hasClients && mounted) {
        final maxScroll = _textScrollController.position.maxScrollExtent;
        if (maxScroll > 0) {
          final currentScroll = _scrollAnimation.value * maxScroll;
          _textScrollController.jumpTo(currentScroll);
        }
      }
    });

    _updateAnimation();
  }

  @override
  void didUpdateWidget(HorizontalScroller oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying ||
        widget.wpm != oldWidget.wpm ||
        widget.speedMultiplier != oldWidget.speedMultiplier) {
      _updateAnimation();
    }
  }

  void _updateAnimation() {
    if (widget.text.isEmpty) return;

    // Calculate duration based on reading speed
    // Average word length is ~5 characters, so WPM * 5 = characters per minute
    final totalChars = widget.text.length;
    final charsPerSecond = (widget.wpm * 5) / 60 * widget.speedMultiplier;
    final durationSeconds = (totalChars / charsPerSecond).clamp(10.0, 300.0);

    _scrollController.duration = Duration(seconds: durationSeconds.round());

    if (widget.isPlaying) {
      _scrollController.repeat();
    } else {
      _scrollController.stop();
    }
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    _textScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use repeated text to ensure smooth scrolling
    final scrollingText = List.filled(3, widget.text).join('    •    ');

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 60,
          child: SingleChildScrollView(
            controller: _textScrollController,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                scrollingText,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Progress bar showing scroll progress
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            children: [
              LinearProgressIndicator(
                value: _scrollAnimation.value,
                backgroundColor: Colors.grey[800],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColorLight,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Progress: ${(_scrollAnimation.value * 100).toStringAsFixed(1)}%',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
