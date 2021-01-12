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
        FirebaseApp.configure()

        let db = Firestore.firestore()
        guard let user = UserDefaultsController.currentUser() else {
            return
        }
        
        guard let userID = user.id else {
            return
        }
        
        let coll = db.collection("users/\(userID)/moods")
        var moods: [MoodReport] = []
        
        coll.getDocuments() { query, err in
            if let err = err {
                print(err)
                return
            }
            
            if let query = query {
                for doc in query.documents {
                    let result = Result {
                      try doc.data(as: MoodReport.self)
                    }

                    switch result {
                    case .success(let mood):
                        if let mood = mood {
                            moods.append(mood)
                        } else {
                            print("Document does not exist")
                        }
                    case .failure(let error):
                        print("Error decoding city: \(error)")
                    }
                }
            }
    
            completion(moods)
        }
    }
}
