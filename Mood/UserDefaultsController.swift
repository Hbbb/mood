//
//  UserDefaultsController.swift
//  Mood
//
//  Created by Harrison Borges on 1/8/21.
//  Copyright © 2021 hbb. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class UserDefaultsController {
    private static let CurrentUserKey = "current_user"
    private static let SuiteName = "com.honey.mood"
    
    static func currentUser() -> User {
        if let dictionary = UserDefaults(suiteName: self.SuiteName)!.object(forKey: self.CurrentUserKey) as? [String: Any] {
            do {
                return try User(with: dictionary)
            }
            catch {
                fatalError("failed to read current user")
            }
        }
        
        let user = User()
        user.id = UUID().uuidString
        
        let db = Firestore.firestore()
        let userDoc = db.collection("users").document(user.id!)
        
        do {
            let data = try user.toDictionary()
            userDoc.setData(data) { err in
                if let err = err {
                    fatalError("Error writing document: \(err)")
                }
            }
        } catch {
            fatalError("current_user failed to save")
        }
    
        return user
    }
    
    static func setCurrentUser(_ user: User?) {
        do {
            let dictionary = try user?.toDictionary()
            UserDefaults(suiteName: self.SuiteName)!.set(dictionary, forKey: self.CurrentUserKey)
        }
        catch {
            fatalError("failed to set current user")
        }
    }
}
