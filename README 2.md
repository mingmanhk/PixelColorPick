# Pixel Color Picker for macOS

[![Swift](https://img.shields.io/badge/Swift-5.7-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/platform-macOS-lightgrey.svg)](https://www.apple.com/macos)
[![macOS](https://img.shields.io/badge/macOS-12.0%2B-blue.svg)](https://www.apple.com/macos/monterey)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

A modern, lightweight, and open-source color picker for macOS, built with the power of SwiftUI. Pixel Color Picker is designed for developers, designers, and anyone who works with color.

## 🎯 Promotional Text

**"The color picker you've been waiting for."**

Transform your creative workflow with Pixel Color Picker – the fastest, most elegant way to capture, explore, and copy colors on macOS. Whether you're designing a website, creating digital art, or perfecting your brand palette, get instant access to any color on your screen with pixel-perfect precision.

✨ **Beautiful & Intuitive** – Modern SwiftUI interface that feels right at home on macOS  
⚡ **Lightning Fast** – Pick colors in milliseconds with keyboard shortcuts  
🎨 **Professional Tools** – Interactive color wheel, format conversion, and smart history  
🔒 **Privacy First** – Works completely offline, no data collection, 100% open source  

Perfect for designers, developers, artists, and anyone who takes color seriously.

## 🆕 What's New in This Version

**Version 2.0 - Major Update**

🎨 **Enhanced UI/UX**
- Redesigned main interface with app icon in header for better brand recognition
- Optimized window sizes for perfect fit without scrolling (520×780)
- Improved preferences window layout (480×720)

⚡ **Performance & Polish**
- Faster color picking with improved eyedropper tool
- Smoother color wheel interactions
- Enhanced haptic feedback for better user experience

🎯 **New Features**
- Auto-open color sampler on launch (optional)
- Dynamic theme adaptation following system appearance
- Improved color history with visual selection indicators
- Better keyboard shortcut support (⌘P for quick pick)

🔧 **Improvements**
- More reliable launch at login functionality
- Better stay-on-top window management
- Refined color format options (uppercase hex, legacy syntax)
- Enhanced copy feedback with visual confirmation

🐛 **Bug Fixes**
- Fixed color wheel precision issues
- Improved color space conversions
- Better handling of edge cases in format conversion

## 📸 Screenshots

<p align="center">
  <img src="resources/PixelColorPicker.png" alt="Pixel Color Picker Main Interface" width="600"/>
  <br/>
  <em>Main Interface - Interactive color wheel and instant format conversion</em>
</p>

<p align="center">
  <img src="resources/Preference.png" alt="Preferences Window" width="600"/>
  <br/>
  <em>Preferences - Customize your color picking experience</em>
</p>

<p align="center">
  <img src="resources/Pixel Color Pick.png" alt="Available on the Mac App Store" width="600"/>
  <br/>
  <em>Available on the Mac App Store</em>
</p>

---

## ✨ Features

Pixel Color Picker is packed with features to make your color workflow faster and more enjoyable:

### 🎨 Color Selection
- **Interactive Color Wheel:** A beautiful and responsive HSV color wheel lets you explore the color spectrum with ease
- **Screen-Wide Eyedropper:** Pick any color from anywhere on your screen with a powerful magnifying loupe for pixel-perfect precision
- **Color History:** Your 10 most recent colors are automatically saved, so you can always find your way back

### 📋 Format Support
- **Multiple Formats:** HEX, RGB, and HSL color formats
- **Instant Copy:** Copy color codes to your clipboard with a single click
- **Format Options:** 
  - Toggle between uppercase/lowercase HEX values (#FF0000 vs #ff0000)
  - Choose between modern and legacy syntax for RGB/HSL

### ⚙️ Customization
- **Menu Bar Access:** Quick access from the menu bar for convenience
- **Launch at Login:** Automatically start when you log in
- **Stay on Top:** Keep the picker window above other windows
- **Auto-Open Eyedropper:** Optionally show color sampler when app opens
- **Theme Options:** 
  - Dynamic theme that follows system appearance
  - Manual dark/light mode selection

### 🍎 Native macOS Integration
- **SwiftUI Design:** Modern, native interface built with SwiftUI
- **Keyboard Shortcuts:** ⌘P to quickly pick colors from screen
- **Haptic Feedback:** Subtle tactile responses for better UX
- **Full Dark Mode:** Seamlessly integrates with macOS appearance

---

## 🚀 Getting Started

### Prerequisites

- macOS 12.0 (Monterey) or later
- Xcode 13.0 or later (for building from source)

### Installation

#### Option 1: Mac App Store (Recommended)
Download directly from the [Mac App Store](https://apps.apple.com/app/pixel-color-picker) for the easiest installation and automatic updates.

#### Option 2: Build from Source

1. **Clone the repository:**
   ```bash
   git clone https://github.com/mingmanhk/PixelColorPick.git
   cd PixelColorPick
   ```

2. **Open in Xcode:**
   ```bash
   open PixelColorPick.xcodeproj
   ```

3. **Build and Run:**
   - Select your target Mac from the scheme selector
   - Press `⌘R` to build and run
   - Or go to **Product** → **Build** (⌘B)

4. **Create Release Build (Optional):**
   - Go to **Product** → **Archive**
   - Export the app from the Organizer window
   - Copy to your Applications folder

---

## 📖 Usage

### Quick Start

1. **Launch the app** from your Applications folder or menu bar
2. **Click the eyedropper button** (or press ⌘P) to pick a color from anywhere on screen
3. **Use the color wheel** to fine-tune your selection
4. **Click "Copy"** next to any format (HEX, RGB, HSL) to copy to clipboard

### Keyboard Shortcuts

- `⌘P` - Open screen color picker
- `⌘,` - Open Preferences
- `⌘Q` - Quit application

### Tips & Tricks

- 💡 **Pin to Menu Bar:** Enable "Show in Menu Bar" in preferences for quick access
- 💡 **Stay Focused:** Use "Stay on Top" mode when working with design tools
- 💡 **Quick History:** Click any color in history to instantly select it
- 💡 **Format Toggle:** Switch between uppercase/lowercase hex in preferences
- 💡 **Theme Sync:** Enable "Dynamic Theme" to follow your system appearance

---

## 🛠️ Technology Stack

- **Language:** Swift 5.7+
- **Framework:** SwiftUI
- **APIs Used:**
  - `NSColorSampler` - Screen color picking
  - `ServiceManagement` - Launch at login functionality
  - `Combine` - Reactive state management
  - `Canvas` - High-performance color wheel rendering
  - `UserDefaults` - Preferences persistence

---

## 🤝 Contributing

We welcome contributions from the community! Here's how you can help:

### Ways to Contribute

1. **Report Bugs:** Open an issue describing the problem
2. **Suggest Features:** Share your ideas in the issues section
3. **Submit Pull Requests:** Fix bugs or add features
4. **Improve Documentation:** Help make the docs better
5. **Share:** Tell others about Pixel Color Picker

### Development Setup

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes
4. Test thoroughly
5. Commit: `git commit -m 'Add amazing feature'`
6. Push: `git push origin feature/amazing-feature`
7. Open a Pull Request

### Code Style

- Follow Swift naming conventions
- Use SwiftUI best practices
- Add comments for complex logic
- Keep functions focused and concise
- Write descriptive commit messages

---

## 🐛 Known Issues

- Color wheel may experience minor lag on Macs with integrated graphics
- Some third-party app windows may not allow color picking due to sandboxing restrictions

If you encounter any issues, please [open an issue](https://github.com/mingmanhk/PixelColorPick/issues) with:
- macOS version
- App version
- Steps to reproduce
- Expected vs actual behavior

---

## 📋 Roadmap

### Upcoming Features
- [ ] Color palette management and export
- [ ] Gradient creator tool
- [ ] Color contrast checker (WCAG compliance)
- [ ] Color scheme generator
- [ ] Export color collections to popular formats (CSS, Swift, JSON)
- [ ] Touch Bar support for MacBook Pro
- [ ] iCloud sync for color history
- [ ] Custom keyboard shortcuts

### Under Consideration
- [ ] Color blindness simulation
- [ ] Color naming with closest match
- [ ] Integration with design tools (Figma, Sketch)
- [ ] iOS companion app

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2025 Victor Lam

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction...
```

---

## 👏 Acknowledgments

- Built with ❤️ using SwiftUI
- Icons from [SF Symbols](https://developer.apple.com/sf-symbols/)
- Inspired by the creative community's need for better color tools
- Special thanks to all contributors and users for their feedback

---

## 📬 Contact & Support

- **GitHub Issues:** [Report bugs or request features](https://github.com/mingmanhk/PixelColorPick/issues)
- **GitHub Discussions:** [Ask questions and share ideas](https://github.com/mingmanhk/PixelColorPick/discussions)
- **Email:** [Your support email]
- **Twitter/X:** [@YourHandle] (optional)

---

## ⭐ Show Your Support

If you find Pixel Color Picker useful, please consider:

- ⭐ **Starring this repository**
- 🐦 **Sharing on social media**
- 📝 **Writing a review on the App Store**
- 💬 **Telling your friends and colleagues**
- ☕ **[Buy me a coffee](https://buymeacoffee.com/yourhandle)** (optional)

Every bit of support helps keep this project alive and growing!

---

<p align="center">
  Made with 🎨 by <a href="https://github.com/mingmanhk">Victor Lam</a>
  <br/>
  <br/>
  <a href="https://apps.apple.com/app/pixel-color-picker">Download on the Mac App Store</a>
</p>
