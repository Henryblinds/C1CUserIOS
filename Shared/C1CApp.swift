//
//  C1CApp.swift
//  Shared


import SwiftUI
import Firebase

@main
struct C1CApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
    
        WindowGroup {
            MainScreen()
        }
    }
}
