//
//  FirestoreManager.swift
//  TranslateMe
//
//  Created by Noah Russell on 11/16/24.
//

import FirebaseFirestore
import FirebaseAuth
import Foundation

class FirestoreManager {
    private let db = Firestore.firestore()
    
    func saveTranslation(input: String, translation: String, completion: @escaping (Error?) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(NSError(domain: "FirestoreManager", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"]))
            return
        }
        
        let docData: [String: Any] = [
            "input": input,
            "translation": translation,
            "timestamp": FieldValue.serverTimestamp(),
            "userID": userID
        ]
        
        db.collection("translationHistory")
            .addDocument(data: docData) { error in
                completion(error)
            }
    }
    
    func fetchTranslationHistory(completion: @escaping ([Translation]?, Error?) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(nil, NSError(domain: "FirestoreManager", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"]))
            return
        }
        
        db.collection("translationHistory")
            .whereField("userID", isEqualTo: userID)
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(nil, error)
                } else {
                    let translations = snapshot?.documents.compactMap { doc -> Translation? in
                        let data = doc.data()
                        return Translation(input: data["input"] as? String ?? "",
                                           translation: data["translation"] as? String ?? "",
                                           timestamp: data["timestamp"] as? Date)
                    }
                    completion(translations, nil)
                }
            }
    }
        
        func clearAllTranslations(completion: @escaping (Error?) -> Void) {
            guard let userID = Auth.auth().currentUser?.uid else {
                completion(NSError(domain: "FirestoreManager", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"]))
                return
            }
            
            db.collection("translationHistory")
                .whereField("userID", isEqualTo: userID)
                .getDocuments { snapshot, error in
                    if let error = error {
                        completion(error)
                        return
                    }
                    
                    guard let documents = snapshot?.documents else {
                        completion(nil)
                        return
                    }
                    
                    let batch = self.db.batch()
                    
                    for document in documents {
                        batch.deleteDocument(document.reference)
                    }
                    
                    batch.commit { error in
                        completion(error)
                    }
                }
        }
    }


