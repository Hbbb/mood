//
//  MoodWidget.swift
//  MoodWidget
//
//  Created by Harrison Borges on 1/9/21.
//  Copyright © 2021 hbb. All rights reserved.
//

import WidgetKit
import SwiftUI

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
        MoodReportLoader.getMoodEntries() { moods in
            let dates = moods.map { $0.created!.timeIntervalSince1970 }
            let minDate = dates.min()!
            let maxDate = dates.max()!
                        
            let minX = 20
            let maxX = 340
            
            let minY = 75
            let maxY = 25
            
            let yDiff = maxY - minY
            let yScale = Float(yDiff) / Float(5 - 1)

            let dateDiff = maxDate - minDate
            let axisDiff = maxX - minX

            let scale = Float(axisDiff) / Float(dateDiff)
            
            let sortedMoods = moods.sorted() { (first, last) in
                first.created! < last.created!
            }
            
            let points: [CGPoint] = sortedMoods.map { mood in
                let x = Float(mood.created!.timeIntervalSince1970 - minDate) * scale + Float(minX)
                let y = Float(mood.score! - 1) * yScale + Float(minY)
                return CGPoint(x: Double(x), y: Double(y))
            }

            let timeline = Timeline(entries: [WidgetContent(points: points, date: Date())], policy: .atEnd)
            completion(timeline)
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
