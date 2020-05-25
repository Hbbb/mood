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
}
