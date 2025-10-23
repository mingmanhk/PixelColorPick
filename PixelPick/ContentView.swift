import SwiftUI
import Foundation
import AppKit
import Combine
import ServiceManagement

// MARK: - Preferences
class Preferences: ObservableObject {
    @Published var showInMenuBar: Bool {
        didSet { UserDefaults.standard.set(showInMenuBar, forKey: "showInMenuBar") }
    }
    
    @Published var launchAtLogin: Bool {
        didSet { 
            UserDefaults.standard.set(launchAtLogin, forKey: "launchAtLogin")
            setLaunchAtLogin(enabled: launchAtLogin)
        }
    }
    
    @Published var stayOnTop: Bool {
        didSet { UserDefaults.standard.set(stayOnTop, forKey: "stayOnTop") }
    }
    
    @Published var showColorSamplerOnOpen: Bool {
        didSet { UserDefaults.standard.set(showColorSamplerOnOpen, forKey: "showColorSamplerOnOpen") }
    }
    
    @Published var uppercaseHex: Bool {
        didSet { UserDefaults.standard.set(uppercaseHex, forKey: "uppercaseHex") }
    }
    
    @Published var useLegacySyntax: Bool {
        didSet { UserDefaults.standard.set(useLegacySyntax, forKey: "useLegacySyntax") }
    }
    
    @Published var enableDarkMode: Bool {
        didSet { 
            UserDefaults.standard.set(enableDarkMode, forKey: "enableDarkMode")
            applyAppearance()
        }
    }
    
    @Published var dynamicColorAdaptation: Bool {
        didSet { 
            UserDefaults.standard.set(dynamicColorAdaptation, forKey: "dynamicColorAdaptation")
            setupThemeObserver()
        }
    }
    
    private var systemThemeObserver: NSObjectProtocol?
    
    init() {
        self.showInMenuBar = UserDefaults.standard.bool(forKey: "showInMenuBar")
        self.launchAtLogin = UserDefaults.standard.bool(forKey: "launchAtLogin")
        self.stayOnTop = UserDefaults.standard.bool(forKey: "stayOnTop")
        self.showColorSamplerOnOpen = UserDefaults.standard.bool(forKey: "showColorSamplerOnOpen")
        self.uppercaseHex = UserDefaults.standard.bool(forKey: "uppercaseHex")
        self.useLegacySyntax = UserDefaults.standard.bool(forKey: "useLegacySyntax")
        self.enableDarkMode = UserDefaults.standard.bool(forKey: "enableDarkMode")
        self.dynamicColorAdaptation = UserDefaults.standard.bool(forKey: "dynamicColorAdaptation")
        
        // Apply appearance on init
        applyAppearance()
        setupThemeObserver()
    }
    
    deinit {
        if let observer = systemThemeObserver {
            DistributedNotificationCenter.default().removeObserver(observer)
        }
    }
    
    private func setupThemeObserver() {
        // Remove existing observer
        if let observer = systemThemeObserver {
            DistributedNotificationCenter.default().removeObserver(observer)
        }
        
        // Only set up observer if dynamic adaptation is enabled
        if dynamicColorAdaptation {
            systemThemeObserver = DistributedNotificationCenter.default().addObserver(
                forName: Notification.Name("AppleInterfaceThemeChangedNotification"),
                object: nil,
                queue: .main
            ) { _ in
                self.applyAppearance()
            }
        }
    }
    
    private func applyAppearance() {
        DispatchQueue.main.async {
            if self.dynamicColorAdaptation {
                // Follow system theme
                NSApp.appearance = nil
            } else {
                // Use manual setting
                NSApp.appearance = self.enableDarkMode ? NSAppearance(named: .darkAqua) : NSAppearance(named: .aqua)
            }
        }
    }
    
    private func setLaunchAtLogin(enabled: Bool) {
        do {
            if enabled {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
        } catch {
            print("Failed to \(enabled ? "enable" : "disable") launch at login: \(error)")
        }
    }
}

// MARK: - Preferences Window
struct PreferencesView: View {
    @ObservedObject var preferences: Preferences
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Preferences")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 12) {
                Toggle("Show in menu bar", isOn: $preferences.showInMenuBar)
                    .help("Display the app icon in the menu bar for quick access")
                
                Toggle("Launch at login", isOn: $preferences.launchAtLogin)
                    .help("Automatically start the app when you log in")
                
                Toggle("Stay on top", isOn: $preferences.stayOnTop)
                    .help("Keep the color picker window above other windows")
                
                Toggle("Show color sampler when opening window", isOn: $preferences.showColorSamplerOnOpen)
                    .help("Automatically activate the color picker when the app opens")
                
                Toggle("Uppercase Hex color", isOn: $preferences.uppercaseHex)
                    .help("Display hex colors in uppercase (e.g., #FF0000 instead of #ff0000)")
                
                Toggle("Use legacy syntax for HSL and RGB", isOn: $preferences.useLegacySyntax)
                    .help("Use older color syntax format")
                
                Toggle("Enable dark mode", isOn: $preferences.enableDarkMode)
                    .help("Switch the app to dark appearance")
                    .disabled(preferences.dynamicColorAdaptation)
                
                Toggle("Dynamic colors adapt to the macOS theme", isOn: $preferences.dynamicColorAdaptation)
                    .help("Automatically follow the macOS system appearance (light/dark mode)")
            }
            
            Spacer()
        }
        .padding(20)
        .frame(width: 400, height: 300)
    }
}

// MARK: - Color Utilities
struct ColorUtils {
    static func hexFromColor(_ color: NSColor, preferences: Preferences) -> String {
        let srgb = color.usingColorSpace(.sRGB) ?? color
        let components = srgb.cgColor.components ?? [0, 0, 0, 1]
        let r = Int(components[0] * 255)
        let g = Int(components[1] * 255)
        let b = Int(components[2] * 255)
        let format = preferences.uppercaseHex ? "#%02X%02X%02X" : "#%02x%02x%02x"
        return String(format: format, r, g, b)
    }
    
    static func rgbFromColor(_ color: NSColor, preferences: Preferences) -> String {
        let srgb = color.usingColorSpace(.sRGB) ?? color
        let components = srgb.cgColor.components ?? [0, 0, 0, 1]
        let r = Int(components[0] * 255)
        let g = Int(components[1] * 255)
        let b = Int(components[2] * 255)
        
        if preferences.useLegacySyntax {
            return "\(r), \(g), \(b)"
        } else {
            return "rgb(\(r), \(g), \(b))"
        }
    }
    
    static func hslFromColor(_ color: NSColor, preferences: Preferences) -> String {
        let srgb = color.usingColorSpace(.sRGB) ?? color
        let components = srgb.cgColor.components ?? [0, 0, 0, 1]
        let (h, s, l) = rgbToHsl(r: components[0], g: components[1], b: components[2])
        
        if preferences.useLegacySyntax {
            return "\(Int(h))°, \(Int(s * 100))%, \(Int(l * 100))%"
        } else {
            return "hsl(\(Int(h)), \(Int(s * 100))%, \(Int(l * 100))%)"
        }
    }
    
    // Legacy methods for backward compatibility
    static func hexFromColor(_ color: NSColor) -> String {
        let srgb = color.usingColorSpace(.sRGB) ?? color
        let components = srgb.cgColor.components ?? [0, 0, 0, 1]
        let r = Int(components[0] * 255)
        let g = Int(components[1] * 255)
        let b = Int(components[2] * 255)
        return String(format: "#%02X%02X%02X", r, g, b)
    }
    
    static func rgbFromColor(_ color: NSColor) -> String {
        let srgb = color.usingColorSpace(.sRGB) ?? color
        let components = srgb.cgColor.components ?? [0, 0, 0, 1]
        let r = Int(components[0] * 255)
        let g = Int(components[1] * 255)
        let b = Int(components[2] * 255)
        return "rgb(\(r), \(g), \(b))"
    }
    
    static func hslFromColor(_ color: NSColor) -> String {
        let srgb = color.usingColorSpace(.sRGB) ?? color
        let components = srgb.cgColor.components ?? [0, 0, 0, 1]
        let (h, s, l) = rgbToHsl(r: components[0], g: components[1], b: components[2])
        return "hsl(\(Int(h)), \(Int(s * 100))%, \(Int(l * 100))%)"
    }
    
    static func rgbToHsl(r: CGFloat, g: CGFloat, b: CGFloat) -> (CGFloat, CGFloat, CGFloat) {
        let max = max(r, g, b)
        let min = min(r, g, b)
        let l = (max + min) / 2
        
        if max == min {
            return (0, 0, l)
        }
        
        let s = l > 0.5 ? (max - min) / (2 - max - min) : (max - min) / (max + min)
        
        var h: CGFloat = 0
        switch max {
        case r:
            h = (g - b) / (max - min) + (g < b ? 6 : 0)
        case g:
            h = (b - r) / (max - min) + 2
        case b:
            h = (r - g) / (max - min) + 4
        default:
            break
        }
        h = h / 6
        
        return (h * 360, s, l)
    }
}

// MARK: - Screen Color Picker
class ScreenColorPicker: ObservableObject {
    @Published var colorHistory: [NSColor] = []
    private let maxHistoryCount = 10
    
    init() {
        // Initialize with default pure white colors
        colorHistory = Array(repeating: NSColor.white, count: maxHistoryCount)
    }
    
    @MainActor
    func pickColorFromScreen() async -> NSColor? {
        let colorSampler = NSColorSampler()
        if let color = await colorSampler.sample() {
            addToHistory(color)
            return color
        }
        return nil
    }
    
    private func addToHistory(_ color: NSColor) {
        // Remove if color already exists in history
        colorHistory.removeAll { existingColor in
            ColorUtils.hexFromColor(existingColor) == ColorUtils.hexFromColor(color)
        }
        
        // Add to beginning of history
        colorHistory.insert(color, at: 0)
        
        // Keep only last 10 colors
        if colorHistory.count > maxHistoryCount {
            colorHistory.removeLast()
        }
    }
}

// MARK: - Size Preference Key
struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

// MARK: - Color Wheel View
struct ColorWheelView: View {
    @Binding var selectedColor: NSColor
    @State private var wheelSize: CGSize = .zero
    
    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let radius = min(size.width, size.height) / 2 - 15
            
            // Draw smooth color wheel using gradients
            for angle in stride(from: 0, through: 360, by: 0.5) {
                let startRad = CGFloat(angle) * .pi / 180
                let endRad = CGFloat(angle + 0.5) * .pi / 180
                
                // Create radial gradient from center to edge
                for radialStep in stride(from: 0, through: 1, by: 0.02) {
                    let nextRadialStep = min(radialStep + 0.02, 1)
                    
                    let hue = CGFloat(angle) / 360
                    
                    // Inner circle
                    let innerRadius = radius * radialStep
                    let innerX1 = center.x + Foundation.cos(startRad) * innerRadius
                    let innerY1 = center.y + Foundation.sin(startRad) * innerRadius
                    let innerX2 = center.x + Foundation.cos(endRad) * innerRadius
                    let innerY2 = center.y + Foundation.sin(endRad) * innerRadius
                    
                    // Outer circle
                    let outerRadius = radius * nextRadialStep
                    let outerX1 = center.x + Foundation.cos(startRad) * outerRadius
                    let outerY1 = center.y + Foundation.sin(startRad) * outerRadius
                    
                    var path = Path()
                    path.move(to: CGPoint(x: innerX1, y: innerY1))
                    path.addLine(to: CGPoint(x: outerX1, y: outerY1))
                    path.addArc(center: center, radius: outerRadius, startAngle: Angle(radians: startRad), endAngle: Angle(radians: endRad), clockwise: false)
                    path.addLine(to: CGPoint(x: innerX2, y: innerY2))
                    path.addArc(center: center, radius: innerRadius, startAngle: Angle(radians: endRad), endAngle: Angle(radians: startRad), clockwise: true)
                    path.closeSubpath()
                    
                    let color = NSColor(hue: hue, saturation: radialStep, brightness: 1, alpha: 1)
                    context.fill(path, with: .color(Color(color)))
                }
            }
            
            // Draw selector indicator
            var colorComponents = selectedColor.cgColor.components ?? [0, 0, 0, 1]
            if colorComponents.count < 3 {
                colorComponents = [0, 0, 0, 1]
            }
            
            let srgb = selectedColor.usingColorSpace(.sRGB) ?? selectedColor
            var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 0
            srgb.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
            
            let selectorAngle = hue * 360
            let selectorRad = CGFloat(selectorAngle) * .pi / 180
            let selectorDistance = saturation * radius
            let selectorX = center.x + cos(Double(selectorRad)) * Double(selectorDistance)
            let selectorY = center.y + sin(Double(selectorRad)) * Double(selectorDistance)
            
            // Draw selector circle
            var selectorPath = Path()
            selectorPath.addEllipse(in: CGRect(x: selectorX - 8, y: selectorY - 8, width: 16, height: 16))
            context.stroke(selectorPath, with: .color(.white), lineWidth: 3)
            
            var innerSelectorPath = Path()
            innerSelectorPath.addEllipse(in: CGRect(x: selectorX - 6, y: selectorY - 6, width: 12, height: 12))
            context.stroke(innerSelectorPath, with: .color(.black), lineWidth: 1)
        }
        .frame(height: 280) // Reduced from 350 to match ContentView constraint
        .background(Color(.controlBackgroundColor))
        .cornerRadius(12)
        .background(
            GeometryReader { geometry in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometry.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self) { size in
            wheelSize = size
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    updateColor(from: value.location)
                }
        )
    }
    
    private func updateColor(from point: CGPoint) {
        let center = CGPoint(x: wheelSize.width / 2, y: wheelSize.height / 2)
        let dx = point.x - center.x
        let dy = point.y - center.y
        
        let distance = sqrt(dx * dx + dy * dy)
        let radius = min(wheelSize.width, wheelSize.height) / 2 - 15
        
        guard distance >= 0, radius > 0 else { return }
        
        var angle = atan2(dy, dx) * 180 / .pi
        if angle < 0 { angle += 360 }
        
        let hue = angle / 360
        let saturation = min(distance / radius, 1)
        let brightness = CGFloat(1)
        
        selectedColor = NSColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
}

// MARK: - Main App
struct ColorPickerApp: App {
    @StateObject private var preferences = Preferences()
    @State private var preferencesWindow: NSWindow?
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(preferences)
                .onAppear {
                    setupWindow()
                }
                .onChange(of: preferences.stayOnTop) { _, newValue in
                    updateWindowLevel(stayOnTop: newValue)
                }
        }
        .windowToolbarStyle(.unified)
        .commands {
            CommandGroup(replacing: .appSettings) {
                Button("Preferences...") {
                    showPreferences()
                }
                .keyboardShortcut(",", modifiers: .command)
            }
        }
    }
    
    private func setupWindow() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let window = NSApp.windows.first {
                // Apply stay on top preference
                updateWindowLevel(stayOnTop: preferences.stayOnTop)
                
                // Set window properties
                window.isRestorable = false
                window.titlebarAppearsTransparent = false
            }
        }
    }
    
    private func updateWindowLevel(stayOnTop: Bool) {
        if let window = NSApp.windows.first {
            window.level = stayOnTop ? .floating : .normal
        }
    }
    
    private func showPreferences() {
        if preferencesWindow == nil {
            let preferencesView = PreferencesView(preferences: preferences)
            let hostingController = NSHostingController(rootView: preferencesView)
            
            preferencesWindow = NSWindow(contentViewController: hostingController)
            preferencesWindow?.title = "Preferences"
            preferencesWindow?.styleMask = [.titled, .closable]
            preferencesWindow?.isRestorable = false
            preferencesWindow?.center()
        }
        
        preferencesWindow?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}

struct ContentView: View {
    @State private var selectedColor = NSColor(hue: 0, saturation: 1, brightness: 1, alpha: 1)
    @State private var copiedFormat: String?
    @StateObject private var colorPicker = ScreenColorPicker()
    @EnvironmentObject private var preferences: Preferences
    
    var body: some View {
        VStack(spacing: 16) {
            Text("System Color Picker")
                .font(.title2)
                .padding(.top, 16)
            
            ColorWheelView(selectedColor: $selectedColor)
                .frame(height: 280) // Reduced from 350
            
            // Color format buttons - more compact
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    VStack(spacing: 6) {
                        CopyButton(
                            label: "Hex", 
                            color: selectedColor, 
                            format: { ColorUtils.hexFromColor($0, preferences: preferences) }
                        )
                        TextField("", text: .constant(ColorUtils.hexFromColor(selectedColor, preferences: preferences)))
                            .textFieldStyle(.roundedBorder)
                            .font(.system(.caption, design: .monospaced))
                            .multilineTextAlignment(.center)
                    }
                    
                    VStack(spacing: 6) {
                        CopyButton(
                            label: "RGB", 
                            color: selectedColor, 
                            format: { ColorUtils.rgbFromColor($0, preferences: preferences) }
                        )
                        TextField("", text: .constant(ColorUtils.rgbFromColor(selectedColor, preferences: preferences)))
                            .textFieldStyle(.roundedBorder)
                            .font(.system(.caption, design: .monospaced))
                            .multilineTextAlignment(.center)
                    }
                    
                    VStack(spacing: 6) {
                        CopyButton(
                            label: "HSL", 
                            color: selectedColor, 
                            format: { ColorUtils.hslFromColor($0, preferences: preferences) }
                        )
                        TextField("", text: .constant(ColorUtils.hslFromColor(selectedColor, preferences: preferences)))
                            .textFieldStyle(.roundedBorder)
                            .font(.system(.caption, design: .monospaced))
                            .multilineTextAlignment(.center)
                    }
                }
            }
            
            // Bottom section: Eyedropper, Selected Color, and History
            HStack(spacing: 12) {
                // Eyedropper button - more compact
                Button(action: {
                    Task {
                        if let pickedColor = await colorPicker.pickColorFromScreen() {
                            selectedColor = pickedColor
                        }
                    }
                }) {
                    VStack(spacing: 2) {
                        Image(systemName: "eyedropper")
                            .font(.title3)
                        Text("Pick Color")
                            .font(.caption2)
                    }
                    .foregroundColor(.primary)
                }
                .buttonStyle(.plain)
                .help("Pick color from screen")
                
                // Selected color preview (moved here between pick color and recent colors)
                VStack(spacing: 4) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(selectedColor))
                        .frame(width: 50, height: 50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.primary.opacity(0.2), lineWidth: 1)
                        )
                    
                    Text("Selected")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                // Color history - more compact
                if !colorPicker.colorHistory.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Recent Colors")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 6) {
                            ForEach(Array(colorPicker.colorHistory.enumerated()), id: \.offset) { index, historyColor in
                                Button(action: {
                                    selectedColor = historyColor
                                }) {
                                    RoundedRectangle(cornerRadius: 3)
                                        .fill(Color(historyColor))
                                        .frame(width: 24, height: 24) // Reduced from 30x30
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 3)
                                                .stroke(Color.primary.opacity(0.2), lineWidth: 0.5)
                                        )
                                }
                                .buttonStyle(.plain)
                                .help(ColorUtils.hexFromColor(historyColor, preferences: preferences))
                            }
                        }
                    }
                }
                
                Spacer()
            }
            
            Spacer(minLength: 8)
        }
        .padding(.horizontal, 20) // Reduced from 30
        .padding(.vertical, 12)   // Reduced from 30
        .frame(minWidth: 420, minHeight: 480) // Reduced from 500x600
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    if let url = URL(string: "https://buymeacoffee.com/mingmanhk") {
                        NSWorkspace.shared.open(url)
                    }
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "cup.and.saucer.fill")
                        Text("Donate")
                    }
                    .foregroundColor(.orange)
                }
                .buttonStyle(.borderless)
                .help("Buy me a coffee ☕")
            }
        }
        .task {
            if preferences.showColorSamplerOnOpen {
                try? await Task.sleep(nanoseconds: 500_000_000)
                if let pickedColor = await colorPicker.pickColorFromScreen() {
                    selectedColor = pickedColor
                }
            }
        }
    }
}

struct CopyButton: View {
    let label: String
    let color: NSColor
    let format: (NSColor) -> String
    @State private var copied = false
    
    var body: some View {
        Button(action: {
            let text = format(color)
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(text, forType: .string)
            copied = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                copied = false
            }
        }) {
            Text(copied ? "✓ Copied" : label)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
    }
}

#Preview {
    ContentView()
}
