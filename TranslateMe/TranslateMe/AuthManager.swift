//
//  AuthManager.swift
//  TranslateMe
//
//  Created by Noah Russell on 11/16/24.
//

import FirebaseAuth

class AuthManager {
    static let shared = AuthManager()

    func signInAnonymously(completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signInAnonymously { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else {
                print("User signed in with UID: \(authResult?.user.uid ?? "Unknown")")
                completion(.success(()))
            }
        }
    }
}
