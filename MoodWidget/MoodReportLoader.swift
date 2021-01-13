//
//  MoodReportLoader.swift
//  MoodWidgetExtension
//
//  Created by Harrison Borges on 1/10/21.
//  Copyright © 2021 hbb. All rights reserved.
//

import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

struct MoodReportLoader {
    static func getMoodEntries(completion: @escaping ([MoodReport]) -> ()) {
        var mood = MoodReport(score: 1, userID: "test")
        mood.created = Date()
        
        FirebaseApp.configure()
        let db = Firestore.firestore()
        
        let user = UserDefaultsController.currentUser()
//        user.id = "884E5129-6073-4597-92E0-52C6ECE5139C"

        guard let userID = user.id else {
            fatalError()
        }

        let coll = db.collection("users/\(userID)/moods")
        var moods: [MoodReport] = []
        
        coll.getDocuments() { query, err in
            if let err = err {
                fatalError("\(err)")
            }
            
            guard let query = query else { fatalError("query wasn't what we thought it was") }

            for doc in query.documents {
                let result = Result {
                  try doc.data(as: MoodReport.self)
                }

                switch result {
                case .success(let mood):
                    if let mood = mood {
                        moods.append(mood)
                    } else {
                        fatalError("Document does not exist")
                    }
                case .failure(let error):
                    fatalError("\(error)")
                }
            }
            completion(moods)
        }
    }
}
