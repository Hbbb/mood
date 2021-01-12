//
//  UserDefaultsController.swift
//  Mood
//
//  Created by Harrison Borges on 1/8/21.
//  Copyright © 2021 hbb. All rights reserved.
//

import UIKit

class UserDefaultsController {
    private static let CurrentUserKey = "current_user"
    private static let SuiteName = "com.honey.mood"
    
    static func currentUser() -> User? {
        if let dictionary = UserDefaults(suiteName: self.SuiteName)!.object(forKey: self.CurrentUserKey) as? [String: Any] {
            do {
                return try User(with: dictionary)
            }
            catch {
                fatalError("failed to read current user")
            }
        }
        
        return nil
    }
    
    static func setCurrentUser(_ user: User?) {
        do {
            let dictionary = try user?.toDictionary()
            UserDefaults(suiteName: self.SuiteName)!.set(dictionary, forKey: self.CurrentUserKey)
        }
        catch {
            // TODO: Handle this better
            
            fatalError("failed to set current user")
        }
    }
}
