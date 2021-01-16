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
    let moods: [Mood]
    let date: Date
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> WidgetContent {
        WidgetContent(moods: [], date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (WidgetContent) -> ()) {
        let entry = WidgetContent(moods: [], date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        MoodReportLoader.getMoodEntries() { moods in
            let timeline = Timeline(entries: [WidgetContent(moods: moods, date: Date())], policy: .atEnd)
            completion(timeline)
        }
    }
}

@main
struct MoodWidget: Widget {
    let kind: String = "MoodWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MoodOverTime(model: entry)
        }
        .configurationDisplayName("Mood Over Time")
        .description("See your mood over time at a glance")
        .supportedFamilies([.systemMedium])
    }
}
