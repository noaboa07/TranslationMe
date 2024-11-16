//
//  ContentView.swift
//  TranslateMe
//
//  Created by Noah Russell on 11/16/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            TranslationView()
                .navigationTitle("TranslationMe")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
