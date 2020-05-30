//
//  Configuration.swift
//  Mood
//
//  Created by Harrison Borges on 5/29/20.
//  Copyright © 2020 hbb. All rights reserved.
//


// Taken from https://nshipster.com/xcconfig/

import Foundation

enum Config {
	enum Error: Swift.Error {
		case missingKey, invalidValue
	}

	static func value<T>(for key: String) throws -> T where T: LosslessStringConvertible {
		guard let object = Bundle.main.object(forInfoDictionaryKey: key) else {
			throw Error.missingKey
		}

		switch object {
		case let value as T:
			return value
		case let string as String:
			guard let value = T(string) else { fallthrough }
			return value
		default:
			throw Error.invalidValue
		}
	}
}

enum API {
	static var endpoint: URL {
		return try! URL(string: "https://" + Config.value(for: "API_ENDPOINT"))!
	}
}
