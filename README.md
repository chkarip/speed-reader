# Speed Reader Flutter App

A modern Flutter application for fast-paced reading using RSVP (Rapid Serial Visual Presentation) technique. This app displays text one word at a time at adjustable speeds to help improve reading speed and focus.

## Features

- **RSVP Reading**: Words are displayed one at a time in rapid succession
- **Adjustable Speed**: Choose from 200 to 1000 words per minute (WPM)
- **Reading Controls**: Play, pause, and reset functionality
- **Progress Tracking**: Visual progress bar and word counter
- **High Contrast Display**: Black background with white text for optimal readability
- **Clean Interface**: Minimalist design to reduce distractions

## Screenshots

The app features a clean, distraction-free interface with:
- Large, bold text display area
- Speed selection dropdown
- Play/Pause/Reset controls
- Progress indicator

## Getting Started

### Prerequisites

Before running this app, make sure you have Flutter installed on your system:

1. **Install Flutter SDK**:
   - Visit [Flutter Installation Guide](https://docs.flutter.dev/get-started/install)
   - For macOS: `brew install --cask flutter`
   - Add Flutter to your PATH

2. **Verify Installation**:
   ```bash
   flutter doctor
   ```

3. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

### Running the App

1. **Connect a device** or start an emulator

2. **Run the app**:
   ```bash
   flutter run
   ```

3. **For web development**:
   ```bash
   flutter run -d chrome
   ```

## How to Use

1. **Select Reading Speed**: Use the dropdown to choose your preferred words per minute (200-1000 WPM)
2. **Start Reading**: Tap the "Play" button to begin the RSVP display
3. **Pause/Resume**: Tap "Pause" to stop, then "Play" to continue from where you left off
4. **Reset**: Tap "Reset" to return to the beginning of the text
5. **Track Progress**: Watch the progress bar and word counter at the bottom

## Customization

### Adding Your Own Text

You can modify the sample text by editing the `_sampleText` variable in `lib/main.dart`, or enhance the app to load text from files or URLs.

### Adjusting Speeds

The current speed options are: 200, 300, 400, 500, 600, 800, 1000 WPM. You can modify these in the `_SpeedReaderScreenState` class.

### Styling

The app uses Material Design 3. You can customize colors, fonts, and layouts in the `build` methods.

## Project Structure

```
lib/
  └── main.dart              # Main application file with RSVP logic
assets/
  └── sample_text.txt        # Sample reading material
pubspec.yaml                 # Project dependencies and configuration
```

## Development

### Code Structure

- **SpeedReaderApp**: Main application widget
- **SpeedReaderScreen**: Main screen with RSVP functionality
- **_SpeedReaderScreenState**: Handles timer, word progression, and UI state

### Key Components

- **Timer-based Word Display**: Uses `Timer.periodic` for consistent word progression
- **State Management**: Flutter's built-in `setState` for UI updates
- **Text Processing**: Splits text into words and handles progression

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Future Enhancements

- [ ] File import functionality (PDF, TXT, EPUB)
- [ ] Reading statistics and analytics
- [ ] Multiple reading modes (sentence-by-sentence, paragraph-by-paragraph)
- [ ] Customizable fonts and themes
- [ ] Reading comprehension tests
- [ ] Cloud sync for reading progress
- [ ] Voice narration option

## License

This project is open source and available under the [MIT License](LICENSE).

## Troubleshooting

### Common Issues

1. **Flutter not found**: Make sure Flutter is properly installed and added to your PATH
2. **Dependencies not found**: Run `flutter pub get` to install dependencies
3. **Build errors**: Run `flutter clean` then `flutter pub get`

### Getting Help

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language Guide](https://dart.dev/guides)
- [Flutter Community](https://flutter.dev/community)

---

**Note**: This is a basic implementation of an RSVP speed reading app. The effectiveness of speed reading techniques varies among individuals, and this app is intended for educational and practice purposes.
