# 🎨 Color Picker

A beautiful, native macOS color picker application built with SwiftUI. Pick colors from anywhere on your screen and copy them in multiple formats (HEX, RGB, HSL).

![macOS](https://img.shields.io/badge/macOS-13.0+-blue)
![Swift](https://img.shields.io/badge/Swift-5.9+-orange)
![SwiftUI](https://img.shields.io/badge/SwiftUI-4.0+-green)
![License](https://img.shields.io/badge/license-MIT-lightgrey)

## ✨ Features

### 🎯 Core Features
- **Screen Color Picker** - Pick colors from anywhere on your screen with ⌘P
- **Interactive Color Wheel** - Visual color selection with drag and click support
- **Multiple Color Formats** - Copy colors in HEX, RGB, and HSL formats
- **Color History** - Keep track of your last 10 picked colors
- **One-Click Copy** - Quick copy buttons with visual feedback

### ⚙️ Customization
- **Menu Bar Integration** - Quick access from the menu bar
- **Launch at Login** - Start automatically when you log in
- **Stay on Top** - Keep the picker window above other apps
- **Auto-Open Picker** - Automatically show color sampler on launch
- **Format Options** - Uppercase/lowercase HEX, legacy CSS syntax support
- **Theme Support** - Dynamic theme adaptation or manual dark/light mode

## 🖼️ Screenshots

### Main Interface
Beautiful, modern interface with interactive color wheel and instant color preview.

### Preferences
Organized settings with logical grouping:
- **General** - Menu bar, launch options, window behavior
- **Behavior** - Auto-open color sampler
- **Color Format** - HEX case, syntax preferences
- **Appearance** - Theme customization

## 🚀 Getting Started

### Requirements
- macOS 13.0 (Ventura) or later
- Xcode 15.0 or later (for building from source)

### Installation

#### Download
1. Download the latest release from the [Releases](https://github.com/YOUR_USERNAME/YOUR_REPO/releases) page
2. Unzip and move to Applications folder
3. Launch Color Picker

#### Build from Source
```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/YOUR_REPO.git
cd YOUR_REPO

# Open in Xcode
open ColorPicker.xcodeproj

# Build and run
# Press ⌘R in Xcode
```

## 📖 Usage

### Picking Colors
1. **From Screen**: Click "Pick from Screen" or press `⌘P`
2. **From Wheel**: Click or drag on the color wheel
3. **From History**: Click any previously picked color

### Copying Colors
- Click the "Copy" button next to any color format
- Formats available: HEX, RGB, HSL
- Visual feedback confirms successful copy

### Keyboard Shortcuts
- `⌘P` - Pick color from screen
- `⌘,` - Open preferences

## 🎨 Color Formats

### HEX
```
#FF5733  (Uppercase)
#ff5733  (Lowercase)
```

### RGB
```
rgb(255, 87, 51)      (Modern syntax)
255, 87, 51           (Legacy syntax)
```

### HSL
```
hsl(9, 100%, 60%)     (Modern syntax)
9°, 100%, 60%         (Legacy syntax)
```

## 🛠️ Technical Details

### Built With
- **Swift** - Modern, safe programming language
- **SwiftUI** - Declarative UI framework
- **AppKit** - Native macOS integration
- **ServiceManagement** - Launch at login functionality

### Architecture
- **MVVM Pattern** - Clean separation of concerns
- **Swift Concurrency** - Modern async/await for color sampling
- **UserDefaults** - Persistent preferences storage
- **Combine** - Reactive preference updates

### Key Components
- `ContentView` - Main color picker interface
- `PreferencesView` - Settings and customization
- `ColorWheelView` - Interactive color selection canvas
- `ScreenColorPicker` - System color sampler integration
- `ColorUtils` - Color conversion utilities

## 🔧 Configuration

### Preferences Location
Preferences are stored in UserDefaults:
```swift
~/Library/Preferences/com.yourcompany.ColorPicker.plist
```

### Available Settings
```swift
showInMenuBar: Bool              // Show menu bar icon
launchAtLogin: Bool              // Launch at login
stayOnTop: Bool                  // Keep window on top
showColorSamplerOnOpen: Bool     // Auto-open picker
uppercaseHex: Bool               // HEX format case
useLegacySyntax: Bool            // CSS syntax style
enableDarkMode: Bool             // Dark mode override
dynamicColorAdaptation: Bool     // Follow system theme
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Development Setup
```bash
# Fork the repository
# Clone your fork
git clone https://github.com/YOUR_USERNAME/YOUR_REPO.git

# Create a feature branch
git checkout -b feature/amazing-feature

# Make your changes
# Commit your changes
git commit -m "Add amazing feature"

# Push to your fork
git push origin feature/amazing-feature

# Open a Pull Request
```

### Guidelines
- Follow Swift style guidelines
- Write clear commit messages
- Update documentation as needed
- Test on multiple macOS versions if possible

## 📝 Changelog

### Version 1.0.0 (Current)
- ✨ Initial release
- 🎨 Interactive color wheel
- 🖱️ Screen color picker with ⌘P shortcut
- 📋 Multiple color format support (HEX, RGB, HSL)
- 🕐 Color history (10 recent colors)
- ⚙️ Comprehensive preferences
- 🌓 Dark mode support
- 🚀 Launch at login option
- 📌 Stay on top functionality

## 🐛 Known Issues

- None currently reported

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👏 Acknowledgments

- Built with ❤️ using SwiftUI
- Inspired by the need for a native, modern macOS color picker
- Thanks to the Swift and macOS developer community

## 📧 Contact

- **Issues**: [GitHub Issues](https://github.com/YOUR_USERNAME/YOUR_REPO/issues)
- **Discussions**: [GitHub Discussions](https://github.com/YOUR_USERNAME/YOUR_REPO/discussions)

## 🔗 Links

- [Documentation](https://github.com/YOUR_USERNAME/YOUR_REPO/wiki)
- [Release Notes](https://github.com/YOUR_USERNAME/YOUR_REPO/releases)
- [Roadmap](https://github.com/YOUR_USERNAME/YOUR_REPO/projects)

---

Made with 🎨 for macOS
