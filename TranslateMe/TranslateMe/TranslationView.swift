//
//  TranslationView.swift
//  TranslateMe
//
//  Created by Noah Russell on 11/16/24.
//

import SwiftUI
import AVFoundation

struct TranslationView: View {
    @State private var inputText: String = ""
    @State private var translatedText: String = ""
    @State private var history: [Translation] = []
    @State private var errorMessage: String?
    @State private var showingClearConfirmation = false
    @State private var isLoading: Bool = false
    @State private var sourceLanguage: String = "en"
    @State private var targetLanguage: String = "es"
    
    let supportedLanguages = [
        ("en", "English"),
        ("es", "Spanish"),
        ("fr", "French"),
        ("de", "German"),
        ("it", "Italian"),
        ("pt", "Portuguese"),
        ("ru", "Russian"),
        ("zh", "Chinese")
    ]
    
    let speechSynthesizer = AVSpeechSynthesizer()
    
    var body: some View {
        VStack(spacing: 20) {
            // Language Selection
            HStack {
                Picker("From Language", selection: $sourceLanguage) {
                    ForEach(supportedLanguages, id: \.0) { language in
                        Text(language.1) // Displaying full language name
                            .tag(language.0)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .frame(width: 200)
                .labelsHidden() // Hides the default label

                Picker("To Language", selection: $targetLanguage) {
                    ForEach(supportedLanguages, id: \.0) { language in
                        Text(language.1) // Displaying full language name
                            .tag(language.0)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .frame(width: 200)
                .labelsHidden() // Hides the default label
            }
            .padding()

            // Text field for entering the translation input
            TextField("Enter text to translate", text: $inputText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Translate button
            Button(action: translateText) {
                Text("Translate")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(inputText.isEmpty)

            // Display translated text
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .padding()
            } else {
                HStack {
                    Text("Translated: \(translatedText)")
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .transition(.opacity)
                        .animation(.easeInOut, value: translatedText)
                    
                    Button(action: readTextOutLoud) {
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                    .padding(.leading, 10)
                }
            }

            Divider()

            // Title for translation history
            Text("Translation History")
                .font(.headline)
                .padding(.top)

            // Scrollable history of translations
            ScrollView {
                ForEach(history) { translation in
                    VStack(alignment: .leading) {
                        Text("Input: \(translation.input)")
                        Text("Translation: \(translation.translation)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("Timestamp: \(translation.timestamp, formatter: dateFormatter)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 5)
                }
            }

            Spacer()

            // Clear all translations button
            Button(action: {
                showingClearConfirmation = true
            }) {
                Text("Clear All Translations")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.top)
            .disabled(history.isEmpty)
            .alert(isPresented: $showingClearConfirmation) {
                Alert(
                    title: Text("Are you sure?"),
                    message: Text("This will clear all your translation history."),
                    primaryButton: .destructive(Text("Clear")) {
                        clearAllTranslations()
                    },
                    secondaryButton: .cancel()
                )
            }

            // Error message display
            if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding()
        .onAppear(perform: fetchHistory)
    }

    private func translateText() {
        isLoading = true
        NetworkingManager.translate(input: inputText, from: sourceLanguage, to: targetLanguage) { result in
            switch result {
            case .success(let translation):
                translatedText = translation

                // Save the translation to Firestore
                FirestoreManager().saveTranslation(input: inputText, translation: translatedText) { error in
                    if let error = error {
                        errorMessage = error.localizedDescription
                    } else {
                        fetchHistory() // Refresh the history after saving
                    }
                }
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }

    private func fetchHistory() {
        FirestoreManager().fetchTranslationHistory { translations, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else if let translations = translations {
                history = translations.sorted { $0.timestamp ?? Date() > $1.timestamp ?? Date() }
            }
        }
    }

    private func clearAllTranslations() {
        FirestoreManager().clearAllTranslations { error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                history = [] // Clear the local history
            }
        }
    }

    private func readTextOutLoud() {
        let utterance = AVSpeechUtterance(string: translatedText)
        utterance.voice = AVSpeechSynthesisVoice(language: targetLanguage)
        speechSynthesizer.speak(utterance)
    }
}

// DateFormatter to format timestamp display
let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()
