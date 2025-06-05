<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

# Speed Reader Flutter App - Copilot Instructions

This is a Flutter mobile application project for fast-paced reading using RSVP (Rapid Serial Visual Presentation) technique.

## Project Overview
- **Framework**: Flutter/Dart
- **Purpose**: Speed reading app that displays words rapidly one at a time
- **Target Platforms**: iOS, Android, Web

## Key Features
- RSVP (Rapid Serial Visual Presentation) word display
- Adjustable reading speed (WPM - Words Per Minute)
- Play/Pause/Reset controls
- Progress tracking
- Clean, focused UI with high contrast text display

## Architecture Guidelines
- Use StatefulWidget for interactive components
- Implement Timer-based word progression
- Material Design 3 styling
- Responsive layout for different screen sizes

## Code Style Preferences
- Use descriptive variable names with underscores (e.g., `_currentWordIndex`)
- Private methods and variables should start with underscore
- Use const constructors where possible
- Follow Flutter/Dart naming conventions
- Add proper dispose methods for Timers and resources

## UI/UX Guidelines
- High contrast display (white text on black background) for reading area
- Large, bold fonts for word display
- Intuitive controls with clear icons
- Progress indicators for user feedback
- Material Design components and styling
