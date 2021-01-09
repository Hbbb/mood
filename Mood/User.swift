//
//  User.swift
//  Mood
//
//  Created by Harrison Borges on 1/8/21.
//  Copyright © 2021 hbb. All rights reserved.
//

import UIKit

class User: Codable, DictionaryConvertible {
    var id: String?
    var name: String?
    var token: String?
    var imageURL: String?
}
