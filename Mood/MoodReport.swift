//
//  MoodReport.swift
//  Mood
//
//  Created by Harrison Borges on 5/25/20.
//  Copyright © 2020 hbb. All rights reserved.
//

import Foundation

struct MoodReport: Codable {
	var score: Int
	var deviceID: Int
	var dateTime: Date

	init(score: Int, deviceID: Int) {
		self.score = score
		self.deviceID = deviceID
		self.dateTime = Date()
	}

	func save(result: @escaping (Result<String, Error>) -> Void) {
		let url = URL(string: "https://httpstat.us/422")
		guard let requestUrl = url else { fatalError() }

		var request = URLRequest(url: requestUrl)
		request.httpMethod = "POST"

		request.setValue("application/json", forHTTPHeaderField: "Accept")
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")

		let json = try! JSONEncoder().encode(self)

		request.httpBody = json

		let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
			if let error = error {
				return result(.failure(error))
			}

			guard let response = response as? HTTPURLResponse else {
				let error = NSError(domain: "decoding response", code: 0, userInfo: nil)
				return result(.failure(error))
			}

			guard response.statusCode == 201 else {
				let error = NSError(domain: "save mood", code: 0, userInfo: nil)
				return result(.failure(error))
			}

			return result(.success("Success"))
		}

		task.resume()
	}
}
