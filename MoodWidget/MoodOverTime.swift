//
//  MoodOverTime.swift
//  MoodWidgetExtension
//
//  Created by Harrison Borges on 1/16/21.
//  Copyright © 2021 hbb. All rights reserved.
//

import SwiftUI
import WidgetKit

struct MoodOverTime: View {
    let model: WidgetContent

    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading) {
                Text("Mood Over Time")
                    .fontWeight(.bold)
                    .font(.title2)

                if model.points.isEmpty {
                    Text("Start logging your mood to see a graph")
                } else {
                    Path { path in
                        path.move(to: model.points[0])
                        for point in model.points[1...] {
                            path.addLine(to: point)
                        }
                    }.stroke(Color.blue, lineWidth: 3)
                }
            }
            .frame(width: geo.size.width, height: geo.size.height, alignment: .topLeading)
            .padding()
        }
    }
}

struct MoodOverTime_Previews: PreviewProvider {
    static var previews: some View {
        MoodOverTime(model: WidgetContent(points: [], date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
