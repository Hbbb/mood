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
    
    static func currentUser() -> User?
    {
        if let dictionary = UserDefaults.standard.object(forKey: self.CurrentUserKey) as? [String: Any]
        {
            do
            {
                return try User(with: dictionary)
            }
            catch
            {
                // TODO: Handle this better
                assertionFailure()
                
                return nil
            }
        }
        
        return nil
    }
    
    static func setCurrentUser(_ user: User?)
    {
        do
        {
            let dictionary = try user?.toDictionary()
            
            UserDefaults.standard.set(dictionary, forKey: self.CurrentUserKey)
        }
        catch
        {
            // TODO: Handle this better
            
            assertionFailure()
        }
    }
}
