//
//  Mood.swift
//  Mood
//
//  Created by Harrison Borges on 5/25/20.
//  Copyright © 2020 hbb. All rights reserved.
//

import Foundation
import Firebase

struct Mood: Codable {
	let score: Int?
	let userID: String?
    var created: Date?

	init(score: Int, userID: String) {
		self.score = score
		self.userID = userID
        self.created = nil
	}

    enum CodingKeys: String, CodingKey {
        case score
        case userID
        case created
    }

	func save(result: @escaping (Error?) -> Void) {
        collection().addDocument(data: [
            "userID": userID!,
            "score": score!,
            "created": FieldValue.serverTimestamp(),
        ], completion: result)
    }
    
    func moods(result: @escaping (Optional<QuerySnapshot>, Optional<Error>) -> ()) {
        collection().getDocuments(completion: result)
    }
    
    func collection() -> CollectionReference {
        let db = Firestore.firestore()
        return db.collection("users/\(userID!)/moods")
    }
}
