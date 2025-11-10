//
//  PixelColorPickApp.swift
//  PixelColorPick
//
//  Created by Victor Lam on 10/21/25.
//

import SwiftUI
import AppKit

@main
struct PixelColorPickApp: App {
    @StateObject private var preferences = Preferences()
    @State private var preferencesWindow: NSWindow?
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(preferences)
                .onAppear(perform: setupWindow)
                .onChange(of: preferences.stayOnTop) { _, newValue in
                    updateWindowLevel(stayOnTop: newValue)
                }
        }
        .windowToolbarStyle(.unified)
        .defaultSize(width: 550, height: 650)
        .windowResizability(.contentSize)
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
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 100_000_000)
            guard let window = NSApp.windows.first else { return }
            updateWindowLevel(stayOnTop: preferences.stayOnTop)
            window.isRestorable = false
            window.titlebarAppearsTransparent = false
        }
    }
    
    private func updateWindowLevel(stayOnTop: Bool) {
        NSApp.windows.first?.level = stayOnTop ? .floating : .normal
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

