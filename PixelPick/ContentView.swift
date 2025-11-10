import SwiftUI
import AppKit
import ServiceManagement
import Combine
import Foundation

// MARK: - Preferences
@MainActor
final class Preferences: ObservableObject {
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
        
        applyAppearance()
        setupThemeObserver()
    }
    
    deinit {
        if let observer = systemThemeObserver {
            DistributedNotificationCenter.default().removeObserver(observer)
        }
    }
    
    private func setupThemeObserver() {
        if let observer = systemThemeObserver {
            DistributedNotificationCenter.default().removeObserver(observer)
        }
        
        guard dynamicColorAdaptation else { return }
        
        systemThemeObserver = DistributedNotificationCenter.default().addObserver(
            forName: Notification.Name("AppleInterfaceThemeChangedNotification"),
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            Task { @MainActor [weak self] in
                self?.applyAppearance()
            }
        }
    }
    
    private func applyAppearance() {
        NSApp.appearance = dynamicColorAdaptation ? nil : 
            (enableDarkMode ? NSAppearance(named: .darkAqua) : NSAppearance(named: .aqua))
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
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 4) {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(.linearGradient(
                        colors: [.accentColor, .accentColor.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                
                Text("Preferences")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Customize your color picker experience")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 16)
            .padding(.bottom, 16)
            
            ScrollView {
                VStack(spacing: 12) {
                    // General Settings
                    PreferenceGroup(
                        title: "General",
                        icon: "square.grid.2x2",
                        iconColor: .blue
                    ) {
                        PreferenceToggleRow(
                            title: "Show in Menu Bar",
                            description: "Quick access from the menu bar",
                            icon: "menubar.rectangle",
                            isOn: $preferences.showInMenuBar
                        )
                        
                        Divider()
                            .padding(.leading, 36)
                        
                        PreferenceToggleRow(
                            title: "Launch at Login",
                            description: "Automatically start when you log in",
                            icon: "power",
                            isOn: $preferences.launchAtLogin
                        )
                        
                        Divider()
                            .padding(.leading, 36)
                        
                        PreferenceToggleRow(
                            title: "Stay on Top",
                            description: "Keep window above other windows",
                            icon: "pin.fill",
                            isOn: $preferences.stayOnTop
                        )
                    }
                    
                    // Behavior Settings
                    PreferenceGroup(
                        title: "Behavior",
                        icon: "hand.tap",
                        iconColor: .purple
                    ) {
                        PreferenceToggleRow(
                            title: "Auto-Open Color Sampler",
                            description: "Show color picker when app opens",
                            icon: "eyedropper",
                            isOn: $preferences.showColorSamplerOnOpen
                        )
                    }
                    
                    // Color Format Settings
                    PreferenceGroup(
                        title: "Color Format",
                        icon: "textformat",
                        iconColor: .orange
                    ) {
                        PreferenceToggleRow(
                            title: "Uppercase Hex",
                            description: "Display hex as #FF0000 instead of #ff0000",
                            icon: "textformat.size.larger",
                            isOn: $preferences.uppercaseHex
                        )
                        
                        Divider()
                            .padding(.leading, 36)
                        
                        PreferenceToggleRow(
                            title: "Legacy Syntax",
                            description: "Use older format for HSL and RGB",
                            icon: "clock.arrow.circlepath",
                            isOn: $preferences.useLegacySyntax
                        )
                    }
                    
                    // Appearance Settings
                    PreferenceGroup(
                        title: "Appearance",
                        icon: "paintbrush.fill",
                        iconColor: .pink
                    ) {
                        PreferenceToggleRow(
                            title: "Dynamic Theme",
                            description: "Follow macOS system appearance",
                            icon: "circle.lefthalf.filled",
                            isOn: $preferences.dynamicColorAdaptation
                        )
                        
                        if !preferences.dynamicColorAdaptation {
                            Divider()
                                .padding(.leading, 36)
                            
                            PreferenceToggleRow(
                                title: "Dark Mode",
                                description: "Use dark appearance",
                                icon: "moon.fill",
                                isOn: $preferences.enableDarkMode
                            )
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
        .frame(width: 480, height: 540)
        .background(Color(NSColor.windowBackgroundColor))
    }
}

// MARK: - Preference Group
struct PreferenceGroup<Content: View>: View {
    let title: String
    let icon: String
    let iconColor: Color
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 20, height: 20)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(iconColor.gradient)
                    )
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 12)
            .padding(.top, 10)
            
            VStack(spacing: 0) {
                content
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 10)
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(NSColor.controlBackgroundColor))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.primary.opacity(0.06), lineWidth: 1)
        )
    }
}

// MARK: - Preference Toggle Row
struct PreferenceToggleRow: View {
    let title: String
    let description: String
    let icon: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.callout)
                    .fontWeight(.medium)
                
                Text(description)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .toggleStyle(.switch)
                .labelsHidden()
                .controlSize(.small)
        }
        .padding(.vertical, 6)
    }
}

// MARK: - Color Utilities
struct ColorUtils {
    static func hexFromColor(_ color: NSColor, preferences: Preferences) -> String {
        guard let srgb = color.usingColorSpace(.sRGB),
              let components = srgb.cgColor.components,
              components.count >= 3 else {
            return "#000000"
        }
        let r = Int(components[0] * 255)
        let g = Int(components[1] * 255)
        let b = Int(components[2] * 255)
        let format = preferences.uppercaseHex ? "#%02X%02X%02X" : "#%02x%02x%02x"
        return String(format: format, r, g, b)
    }
    
    static func rgbFromColor(_ color: NSColor, preferences: Preferences) -> String {
        guard let srgb = color.usingColorSpace(.sRGB),
              let components = srgb.cgColor.components,
              components.count >= 3 else {
            return preferences.useLegacySyntax ? "0, 0, 0" : "rgb(0, 0, 0)"
        }
        let r = Int(components[0] * 255)
        let g = Int(components[1] * 255)
        let b = Int(components[2] * 255)
        
        return preferences.useLegacySyntax ? "\(r), \(g), \(b)" : "rgb(\(r), \(g), \(b))"
    }
    
    static func hslFromColor(_ color: NSColor, preferences: Preferences) -> String {
        guard let srgb = color.usingColorSpace(.sRGB),
              let components = srgb.cgColor.components,
              components.count >= 3 else {
            return preferences.useLegacySyntax ? "0°, 0%, 0%" : "hsl(0, 0%, 0%)"
        }
        let (h, s, l) = rgbToHsl(r: components[0], g: components[1], b: components[2])
        
        return preferences.useLegacySyntax ? 
            "\(Int(h))°, \(Int(s * 100))%, \(Int(l * 100))%" : 
            "hsl(\(Int(h)), \(Int(s * 100))%, \(Int(l * 100))%)"
    }
    
    private static func rgbToHsl(r: CGFloat, g: CGFloat, b: CGFloat) -> (CGFloat, CGFloat, CGFloat) {
        let maxVal = max(r, g, b)
        let minVal = min(r, g, b)
        let l = (maxVal + minVal) / 2
        
        guard maxVal != minVal else { return (0, 0, l) }
        
        let delta = maxVal - minVal
        let s = l > 0.5 ? delta / (2 - maxVal - minVal) : delta / (maxVal + minVal)
        
        var h: CGFloat = 0
        switch maxVal {
        case r:
            h = (g - b) / delta + (g < b ? 6 : 0)
        case g:
            h = (b - r) / delta + 2
        case b:
            h = (r - g) / delta + 4
        default:
            break
        }
        h /= 6
        
        return (h * 360, s, l)
    }
}

// MARK: - Screen Color Picker
@MainActor
final class ScreenColorPicker: ObservableObject {
    @Published private(set) var colorHistory: [NSColor] = []
    private let maxHistoryCount = 10
    private let colorSampler = NSColorSampler()
    
    func pickColorFromScreen() async -> NSColor? {
        guard let color = await colorSampler.sample() else { return nil }
        addToHistory(color)
        return color
    }
    
    private func addToHistory(_ color: NSColor) {
        let newColorHex = color.hexString
        
        // Remove duplicate if exists
        colorHistory.removeAll { $0.hexString == newColorHex }
        
        // Add to beginning
        colorHistory.insert(color, at: 0)
        
        // Trim to max count
        if colorHistory.count > maxHistoryCount {
            colorHistory.removeLast()
        }
    }
}

// MARK: - NSColor Extension for Performance
private extension NSColor {
    var hexString: String {
        guard let srgb = usingColorSpace(.sRGB),
              let components = srgb.cgColor.components,
              components.count >= 3 else {
            return "#000000"
        }
        let r = Int(components[0] * 255)
        let g = Int(components[1] * 255)
        let b = Int(components[2] * 255)
        return String(format: "#%02X%02X%02X", r, g, b)
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
            
            // Draw color wheel with optimized rendering
            for angle in stride(from: 0, through: 360, by: 2) {
                let startRad = CGFloat(angle) * .pi / 180
                let endRad = CGFloat(angle + 2) * .pi / 180
                let hue = CGFloat(angle) / 360
                
                for radialStep in stride(from: 0, through: 1, by: 0.1) {
                    let nextRadialStep = min(radialStep + 0.1, 1)
                    let innerRadius = radius * radialStep
                    let outerRadius = radius * nextRadialStep
                    
                    var path = Path()
                    path.addArc(center: center, radius: innerRadius, startAngle: Angle(radians: startRad), endAngle: Angle(radians: endRad), clockwise: false)
                    path.addLine(to: CGPoint(
                        x: center.x + CGFloat(cos(endRad)) * outerRadius,
                        y: center.y + CGFloat(sin(endRad)) * outerRadius
                    ))
                    path.addArc(center: center, radius: outerRadius, startAngle: Angle(radians: endRad), endAngle: Angle(radians: startRad), clockwise: true)
                    path.closeSubpath()
                    
                    let color = NSColor(hue: hue, saturation: radialStep, brightness: 1, alpha: 1)
                    context.fill(path, with: .color(Color(color)))
                }
            }
            
            // Draw selector indicator
            guard let srgb = selectedColor.usingColorSpace(.sRGB) else { return }
            var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 0
            srgb.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
            
            let selectorRad = hue * 2 * .pi
            let selectorDistance = saturation * radius
            let selectorX = center.x + CGFloat(cos(selectorRad)) * selectorDistance
            let selectorY = center.y + CGFloat(sin(selectorRad)) * selectorDistance
            
            // Draw selector circle
            let selectorPath = Circle()
                .path(in: CGRect(x: selectorX - 8, y: selectorY - 8, width: 16, height: 16))
            context.stroke(selectorPath, with: .color(.white), lineWidth: 3)
            context.stroke(Circle().path(in: CGRect(x: selectorX - 6, y: selectorY - 6, width: 12, height: 12)), 
                         with: .color(.black), lineWidth: 1)
        }
        .frame(height: 280)
        .background(Color(.controlBackgroundColor))
        .cornerRadius(12)
        .background(
            GeometryReader { geometry in
                Color.clear.preference(key: SizePreferenceKey.self, value: geometry.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self) { wheelSize = $0 }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { updateColor(from: $0.location) }
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
        
        selectedColor = NSColor(
            hue: angle / 360,
            saturation: min(distance / radius, 1),
            brightness: 1,
            alpha: 1
        )
    }
}


struct ContentView: View {
    @State private var selectedColor = NSColor(hue: 0, saturation: 1, brightness: 1, alpha: 1)
    @StateObject private var colorPicker = ScreenColorPicker()
    @EnvironmentObject private var preferences: Preferences
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Header Section
            headerSection
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color(NSColor.controlBackgroundColor).opacity(0.5))
            
            ScrollView {
                VStack(spacing: 16) {
                    // MARK: - Color Selection Section
                    GroupBox {
                        colorSelectionSection
                    } label: {
                        Label("Color Selection", systemImage: "paintpalette")
                            .font(.headline)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    
                    // MARK: - Color Values Section
                    GroupBox {
                        colorValuesSection
                    } label: {
                        Label("Color Values", systemImage: "number")
                            .font(.headline)
                    }
                    .padding(.horizontal, 20)
                    
                    // MARK: - History Section
                    if !colorPicker.colorHistory.isEmpty {
                        GroupBox {
                            colorHistorySection
                        } label: {
                            Label("Recent Colors", systemImage: "clock")
                                .font(.headline)
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer(minLength: 12)
                }
            }
        }
        .frame(width: 520, height: 600)
        .navigationTitle("Color Picker")
        .task {
            guard preferences.showColorSamplerOnOpen else { return }
            try? await Task.sleep(nanoseconds: 500_000_000)
            if let pickedColor = await colorPicker.pickColorFromScreen() {
                selectedColor = pickedColor
            }
        }
    }
    
    // MARK: - Header Section View
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Color Picker")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Select and copy colors in multiple formats")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: {
                Task {
                    if let pickedColor = await colorPicker.pickColorFromScreen() {
                        selectedColor = pickedColor
                    }
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "eyedropper.halffull")
                        .font(.title3)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("⌘P")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .help("Pick a color from anywhere on your screen")
            .keyboardShortcut("p", modifiers: .command)
        }
    }
    
    // MARK: - Color Selection Section View
    private var colorSelectionSection: some View {
        HStack(alignment: .top, spacing: 16) {
            // Current color preview
            VStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(selectedColor))
                    .frame(width: 120, height: 120)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.primary.opacity(0.15), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 3)
                
                VStack(spacing: 2) {
                    Text("Current Color")
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    
                    Text(ColorUtils.hexFromColor(selectedColor, preferences: preferences))
                        .font(.system(.caption2, design: .monospaced))
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
            
            Divider()
            
            // Color wheel selector
            VStack(spacing: 6) {
                ColorWheelView(selectedColor: $selectedColor)
                    .frame(width: 240, height: 240)
                
                Text("Click or drag to select a color")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 12)
    }
    
    // MARK: - Color Values Section View
    private var colorValuesSection: some View {
        VStack(spacing: 8) {
            ColorFormatRow(
                label: "HEX",
                icon: "number",
                value: ColorUtils.hexFromColor(selectedColor, preferences: preferences)
            )
            
            Divider()
            
            ColorFormatRow(
                label: "RGB",
                icon: "circle.hexagongrid",
                value: ColorUtils.rgbFromColor(selectedColor, preferences: preferences)
            )
            
            Divider()
            
            ColorFormatRow(
                label: "HSL",
                icon: "paintbrush.pointed",
                value: ColorUtils.hslFromColor(selectedColor, preferences: preferences)
            )
        }
        .padding(.vertical, 10)
    }
    
    // MARK: - Color History Section View
    private var colorHistorySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Click any color to select it")
                .font(.caption2)
                .foregroundColor(.secondary)
            
            let selectedHex = ColorUtils.hexFromColor(selectedColor, preferences: preferences)
            
            LazyVGrid(columns: [
                GridItem(.adaptive(minimum: 55, maximum: 70), spacing: 10)
            ], spacing: 10) {
                ForEach(Array(colorPicker.colorHistory.enumerated()), id: \.offset) { _, historyColor in
                    let historyHex = ColorUtils.hexFromColor(historyColor, preferences: preferences)
                    let isSelected = selectedHex == historyHex
                    
                    Button(action: {
                        selectedColor = historyColor
                    }) {
                        VStack(spacing: 4) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(historyColor))
                                .frame(height: 50)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(isSelected ? Color.accentColor : Color.primary.opacity(0.15),
                                               lineWidth: isSelected ? 2.5 : 1)
                                )
                                .shadow(color: Color.black.opacity(0.08), radius: 2, x: 0, y: 1)
                            
                            Text(historyHex)
                                .font(.system(size: 9, design: .monospaced))
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                    }
                    .buttonStyle(.plain)
                    .help("Select color: \(historyHex)")
                }
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Color Format Row
struct ColorFormatRow: View {
    let label: String
    let icon: String
    let value: String
    @State private var copied = false
    
    var body: some View {
        HStack(spacing: 12) {
            // Format label with icon
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .foregroundColor(.accentColor)
                    .frame(width: 18)
                    .font(.system(size: 14))
                
                Text(label)
                    .font(.system(.callout, design: .rounded))
                    .fontWeight(.semibold)
                    .frame(width: 40, alignment: .leading)
            }
            .frame(width: 75, alignment: .leading)
            
            // Value display
            Text(value)
                .font(.system(.callout, design: .monospaced))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(Color(NSColor.textBackgroundColor))
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                )
            
            // Copy button
            Button(action: {
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString(value, forType: .string)
                copied = true
                
                // Haptic feedback
                NSHapticFeedbackManager.defaultPerformer.perform(.alignment, performanceTime: .default)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    copied = false
                }
            }) {
                HStack(spacing: 4) {
                    Image(systemName: copied ? "checkmark.circle.fill" : "doc.on.doc.fill")
                        .font(.system(size: 12))
                    Text(copied ? "Copied" : "Copy")
                        .font(.caption2)
                        .fontWeight(.medium)
                }
                .foregroundColor(copied ? .green : .accentColor)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .fill(copied ? Color.green.opacity(0.1) : Color.accentColor.opacity(0.1))
                )
            }
            .buttonStyle(.plain)
            .help("Copy \(label) value to clipboard")
        }
        .padding(.horizontal, 2)
    }
}

#Preview {
    ContentView()
        .environmentObject(Preferences())
}
