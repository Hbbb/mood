//
//  Mood_Widget.swift
//  Mood Widget
//
//  Created by Harrison Borges on 1/9/21.
//  Copyright © 2021 hbb. All rights reserved.
//

import WidgetKit
import SwiftUI

import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> WidgetContent {
        print("hi hi")
        return WidgetContent(points: [], date: Date())
    }
    
    // This is what shows up in the widget gallery view, when you're adding a widget
    func getSnapshot(in context: Context, completion: @escaping (WidgetContent) -> ()) {
        let entry = WidgetContent(points: [], date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entries: [WidgetContent] = []
        
         getMoodEntries() { moods in
             let minX = 20
             let maxX = 400
            
             let dates = moods.map { $0.created!.timeIntervalSince1970 }
             let minDate = dates.min()
             let maxDate = dates.max()
            
             let dateDiff = maxDate! - minDate!
             let xDiff = maxX - minX
            
             let scale = Float(xDiff) / Float(dateDiff)
            
             let points: [CGPoint] = moods.map { mood in
                 let x = Float(mood.created!.timeIntervalSince1970) * scale
                 return CGPoint(x: Double(x), y: 50.0)
             }
            
             // Generate a timeline consisting of five entries an hour apart, starting from the current date.
             let currentDate = Date()
             for hourOffset in 0 ..< 5 {
                 let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
                 let entry = WidgetContent(points: points, date: entryDate)
//                 entries.append(entry)
             }

             let timeline = Timeline(entries: entries, policy: .atEnd)
             completion(timeline)
         }
    }
    
    func getMoodEntries(completion: @escaping ([MoodReport]) -> ()) {
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

struct WidgetContent: TimelineEntry {
    let points: [CGPoint]
    let date: Date
}

@main
struct MoodWidget: Widget {
    let kind: String = "Mood_Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            EntryView(model: entry)
        }
        .configurationDisplayName("Mood Over Time")
        .description("See your mood reports graphed over times")
        .supportedFamilies([.systemMedium])
    }
}

//class PreviewDataLoader {
//    class func load() -> [MoodReport] {
//        FirebaseApp.configure()
//
//        let db = Firestore.firestore()
//        let coll = db.collection("users/884E5129-6073-4597-92E0-52C6ECE5139C/moods")
//        var moods: [MoodReport] = []
//
//        coll.getDocuments() { query, err in
//            if let err = err {
//                print(err)
//                return
//            }
//
//            if let query = query {
//                for doc in query.documents {
//                    let result = Result {
//                      try doc.data(as: MoodReport.self)
//                    }
//
//                    switch result {
//                    case .success(let mood):
//                        if let mood = mood {
//                            moods.append(mood)
//                        } else {
//                            print("Document does not exist")
//                        }
//                    case .failure(let error):
//                        print("Error decoding city: \(error)")
//                    }
//                }
//            }
//        }
//
//        return moods
//    }
//}

struct Mood_Widget_Previews: PreviewProvider {
    static var previews: some View {
        EntryView(model: WidgetContent(points: [
            CGPoint(x: 10, y: 50),
            CGPoint(x: 30, y: 30),
            CGPoint(x: 50, y: 80),
            CGPoint(x: 70, y: 50),
            CGPoint(x: 110, y: 10),
        ], date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
