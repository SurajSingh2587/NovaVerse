# 🌌 NovaVerse

**Stream Anywhere, Everywhere**

NovaVerse is a lightweight, mobile-first streaming application built with Flutter/Dart. Inspired by OBS, it provides an intuitive interface for live streaming and recording directly from your mobile device.

![Flutter](https://img.shields.io/badge/Flutter-3.24.0-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.5.0-0175C2?logo=dart)
![License](https://img.shields.io/badge/License-MIT-green)

## ✨ Features

### 📹 Stream Controls
- **Go Live** - Start streaming to your favorite platforms with one tap
- **Recording** - Record locally in MP4, MKV, or MOV formats
- **Camera Toggle** - Switch between front and back cameras
- **Microphone Control** - Mute/unmute with volume control
- **Screen Share** - Share your screen content

### 🎬 Scene Management
- Create and manage multiple scenes (like OBS)
- Pre-built templates: Just Chatting, Gaming, BRB, Starting Soon, etc.
- Custom scene colors for easy identification
- Quick scene switching during streams

### 📦 Source Management  
- **Camera Source** - Capture from device cameras
- **Screen Capture** - Share your screen
- **Image Overlay** - Add static images
- **Text Overlay** - Add customizable text
- **Audio Input** - Microphone and system audio
- **Browser Source** - Embed web content
- **Video Playback** - Play video files
- Drag, resize, and layer sources
- Visibility and mute toggles per source

### 🎚️ Audio Mixer
- Real-time volume control for microphone and system audio
- Visual audio level meters
- Mute toggles

### 📊 Stream Statistics
- Live viewer count
- Current bitrate display
- FPS monitoring
- Dropped frames counter
- Stream health indicator

### ⚙️ Settings
- **Platform Presets**: YouTube, Twitch, Facebook, Instagram, TikTok, Custom RTMP
- **Video Quality**: 480p, 720p, 1080p, 1440p presets
- **Bitrate Control**: 1000-12000 kbps
- **Frame Rate**: 24, 30, 60 fps
- **Encoder Options**: H.264, H.265, VP9
- **Audio Settings**: Bitrate, noise suppression, echo cancellation
- **Recording Options**: Format selection, split recording
- **Advanced**: Hardware acceleration, low latency mode, keyframe interval

### 🎨 Premium UI/UX
- Modern dark theme with cyber aesthetic
- Smooth animations and transitions
- Glassmorphism effects
- Animated splash screen with particles
- Portrait and landscape layouts
- Haptic feedback

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.24.0 or higher
- Dart 3.5.0 or higher
- Android Studio or VS Code with Flutter extensions
- Android device/emulator (API 21+) or iOS device/simulator

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/novaverse.git
   cd novaverse
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Building for Release

**Android APK:**
```bash
flutter build apk --release
```

**Android App Bundle:**
```bash
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
```

## 📁 Project Structure

```
lib/
├── main.dart                          # App entry point
├── core/
│   ├── theme/
│   │   └── app_theme.dart             # Theme, colors, decorations
│   └── providers/
│       ├── stream_provider.dart       # Stream state management
│       ├── scene_provider.dart        # Scene & source management
│       └── settings_provider.dart     # App settings
└── features/
    ├── splash/
    │   └── splash_screen.dart         # Animated splash screen
    ├── home/
    │   └── home_screen.dart           # Main navigation
    ├── dashboard/
    │   ├── dashboard_screen.dart      # Stream dashboard
    │   └── widgets/
    │       ├── stream_controls.dart   # Go live, record buttons
    │       ├── audio_mixer.dart       # Volume controls
    │       ├── stream_stats.dart      # Live statistics
    │       └── quick_actions.dart     # Quick action buttons
    ├── preview/
    │   └── preview_widget.dart        # Camera preview
    ├── scenes/
    │   ├── scenes_screen.dart         # Scene management
    │   └── widgets/
    │       ├── scene_card.dart        # Scene list item
    │       └── add_scene_dialog.dart  # Create scene dialog
    ├── sources/
    │   ├── sources_screen.dart        # Source management
    │   └── widgets/
    │       ├── source_tile.dart       # Source list item
    │       └── add_source_dialog.dart # Add source dialog
    └── settings/
        ├── settings_screen.dart       # Settings page
        └── widgets/
            ├── settings_section.dart  # Settings group widget
            └── platform_selector.dart # Platform selection
```

## 📦 Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| camera | ^0.11.0 | Camera access |
| permission_handler | ^11.3.1 | Runtime permissions |
| provider | ^6.1.2 | State management |
| shared_preferences | ^2.3.2 | Local storage |
| flutter_colorpicker | ^1.1.0 | Color selection |
| video_player | ^2.9.1 | Video playback |
| path_provider | ^2.1.4 | File paths |
| uuid | ^4.5.1 | Unique IDs |
| audioplayers | ^6.1.0 | Audio playback |
| wakelock_plus | ^1.2.8 | Screen wake lock |
| google_fonts | ^6.2.1 | Custom fonts |
| flutter_animate | ^4.5.0 | Animations |
| shimmer | ^3.0.0 | Loading effects |

## 🔮 Roadmap

- [ ] RTMP streaming implementation
- [ ] Camera preview with actual video
- [ ] Source transform controls (resize, move)
- [ ] Custom overlays and alerts
- [ ] Chat integration
- [ ] Multi-platform streaming
- [ ] Stream recording to device
- [ ] Cloud backup for settings
- [ ] Widget overlays (goals, chat, alerts)
- [ ] Landscape optimization

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📧 Contact

Your Name - [@yourtwitter](https://twitter.com/yourtwitter)

Project Link: [https://github.com/yourusername/novaverse](https://github.com/yourusername/novaverse)

---

<p align="center">
  Made with ❤️ using Flutter
</p>
