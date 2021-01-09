//
//  MoodReport.swift
//  Mood
//
//  Created by Harrison Borges on 5/25/20.
//  Copyright © 2020 hbb. All rights reserved.
//

import Foundation
import Firebase

struct MoodReport: Codable {
	var score: Int
	var userID: String

	init(score: Int, userID: String) {
		self.score = score
		self.userID = userID
	}

	func save(result: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("users/\(userID)/moods").addDocument(data: [
            "userID": userID,
            "score": score,
            "created": FieldValue.serverTimestamp(),
        ], completion: result)
    }
}
