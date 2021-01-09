//
//  DictionaryConvertible.swift
//  Mood
//
//  Created by Harrison Borges on 1/8/21.
//  Copyright © 2021 hbb. All rights reserved.
//

import Foundation

enum DictionaryConversionError: Error
{
    case Casting
}

protocol DictionaryConvertible: Codable
{
    func toDictionary() throws -> [String: Any]
    init(with dictionary: [String: Any]) throws
}

extension DictionaryConvertible
{
    func toDictionary() throws -> [String: Any]
    {
        let data = try JSONEncoder().encode(self)
        let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        
        if let dictionary = dictionary as? [String: Any]
        {
            return dictionary
        }
        else
        {
            throw DictionaryConversionError.Casting
        }
    }
    
    init(with dictionary: [String: Any]) throws
    {
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        self = try JSONDecoder().decode(Self.self, from: data)
    }
}
