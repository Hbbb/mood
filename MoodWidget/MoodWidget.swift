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
        var entries: [WidgetContent] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = WidgetContent(points: [], date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct EntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading) {
            Text("Mood Over Time")
        }
    }
}

@main
struct MoodWidget: Widget {
    let kind: String = "MoodWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            EntryView(entry: entry)
        }
        .configurationDisplayName("Mood Over Time")
        .description("See your mood over time at a glance")
        .supportedFamilies([.systemMedium])
    }
}

struct MoodWidget_Previews: PreviewProvider {
    static var previews: some View {
        EntryView(entry: WidgetContent(points: [], date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
