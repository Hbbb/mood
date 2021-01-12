//
//  MoodWidget.swift
//  MoodWidget
//
//  Created by Harrison Borges on 1/9/21.
//  Copyright © 2021 hbb. All rights reserved.
//

import WidgetKit
import SwiftUI

import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

struct WidgetContent: TimelineEntry {
    let points: [CGPoint]
    let date: Date
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> WidgetContent {
        WidgetContent(points: [], date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (WidgetContent) -> ()) {
        let entry = WidgetContent(points: [], date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        getMoodEntries() { moods in
            let dates = moods.map { $0.created!.timeIntervalSince1970 }
            let minDate = dates.min()!
            let maxDate = dates.max()!
                        
            let minX = 20
            let maxX = 400

            let dateDiff = maxDate - minDate
            let axisDiff = maxX - minX

            let scale = Float(axisDiff) / Float(dateDiff)

            let points: [CGPoint] = moods.map { mood in
                let x = Float(mood.created!.timeIntervalSince1970 - minDate) * scale + Float(minX)
                return CGPoint(x: Double(x), y: 50.0)
            }

            let timeline = Timeline(entries: [WidgetContent(points: points, date: Date())], policy: .atEnd)
            completion(timeline)
        }
    }
    
    func getMoodEntries(completion: @escaping ([MoodReport]) -> ()) {
        var mood = MoodReport(score: 1, userID: "test")
        mood.created = Date()
        
        FirebaseApp.configure()
        let db = Firestore.firestore()
        
        let user = User()
        user.id = "884E5129-6073-4597-92E0-52C6ECE5139C"
//        guard let user = UserDefaultsController.currentUser() else {
//            fatalError()
//            return
//        }

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

struct EntryView: View {
    let model: WidgetContent

    var body: some View {
        VStack(alignment: .leading) {
            Text("Mood Over Time")
                .fontWeight(.bold)
                .font(.title2)
                .padding([.leading, .top], 15)
            
            if !model.points.isEmpty {
                Path { path in
                    path.move(to: model.points[0])
                    for point in model.points[1...] {
                        path.addLine(to: point)
                    }
                }.stroke(Color.blue, lineWidth: 3)
            }
        }
    }
}

@main
struct MoodWidget: Widget {
    let kind: String = "MoodWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            EntryView(model: entry)
        }
        .configurationDisplayName("Mood Over Time")
        .description("See your mood over time at a glance")
        .supportedFamilies([.systemMedium])
    }
}

struct MoodWidget_Previews: PreviewProvider {
    static var previews: some View {
        EntryView(model: WidgetContent(points: [], date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
