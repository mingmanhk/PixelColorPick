//
//  PixelPickApp.swift
//  PixelPick
//
//  Created by Victor Lam on 10/21/25.
//

import SwiftUI
import Foundation
import AppKit
import Combine
import ServiceManagement

@main
struct PixelPickApp: App {
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
        .defaultSize(width: 420, height: 480)
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
