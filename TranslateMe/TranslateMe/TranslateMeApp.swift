//
//  TranslateMeApp.swift
//  TranslateMe
//
//  Created by Noah Russell on 11/16/24.
//

import SwiftUI
import FirebaseCore // <-- Import Firebase

@main
struct TranslateMeApp: App {

    init() { // <-- Add an init
        FirebaseApp.configure() // <-- Configure Firebase app
    }

    var body: some Scene {
         WindowGroup {
             ContentView()
                 .onAppear {
                     AuthManager.shared.signInAnonymously { result in
                         switch result {
                         case .success:
                             print("Authentication successful")
                         case .failure(let error):
                             print("Authentication failed: \(error.localizedDescription)")
                         }
                     }
                 }
         }
     }
 }
