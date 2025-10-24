# PixelPick

A modern, compact color picker app for macOS built with SwiftUI.

## Features

- **Interactive Color Wheel** - Smooth HSV color wheel with visual selector
- **Screen Color Picker** - Sample colors from anywhere on your screen
- **Multiple Formats** - Copy colors as HEX, RGB, or HSL with one click
- **Color History** - Access your last 10 picked colors
- **Customizable** - Menu bar access, launch at login, stay on top, and more
- **Native macOS** - Supports light/dark mode and system appearance

## Installation

**Requirements:** macOS 12.0+ (Monterey or later)

1. Clone the repository:
   ```bash
   git clone https://github.com/mingmanhk/PixelPick.git
   ```
2. Open `PixelPick.xcodeproj` in Xcode
3. Build and run (⌘+R)

## Usage

- **Color Wheel**: Click and drag to select colors
- **Screen Picker**: Click "Pick Color" to sample from screen
- **Copy Colors**: Click HEX, RGB, or HSL buttons to copy values
- **Preferences**: Press `⌘+,` to customize settings

## Technical Details

Built with SwiftUI and native macOS frameworks:
- SwiftUI for modern UI
- AppKit for macOS integration  
- Swift Concurrency for smooth performance
- ServiceManagement for login items

## License

MIT License - see [LICENSE](LICENSE) file for details.
