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
        return (
            GeometryReader { geo in
                VStack(alignment: .leading) {
                    Text("Mood Over Time")
                        .fontWeight(.bold)
                        .font(.title2)

                    if model.moods.isEmpty {
                        Text("Start logging your mood to see a graph")
                    } else {
                        let dates = model.moods.map { $0.created!.timeIntervalSince1970 }

                        let minDate = dates.min()!
                        let maxDate = dates.max()!

                        let minX = 0
                        let maxX = geo.size.width - 40

                        let minY = 75
                        let maxY = 25

                        let yDiff = maxY - minY
                        let yScale = Float(yDiff) / Float(5 - 1)

                        let dateDiff = maxDate - minDate
                        let axisDiff = maxX - CGFloat(minX)

                        let scale = Float(axisDiff) / Float(dateDiff)

                        let sortedMoods = model.moods.sorted() { (first, last) in
                            first.created! < last.created!
                        }

                        let points: [CGPoint] = sortedMoods.map { mood in
                            let x = Float(mood.created!.timeIntervalSince1970 - minDate) * scale + Float(minX)
                            let y = Float(mood.score! - 1) * yScale + Float(minY)
                            return CGPoint(x: Double(x), y: Double(y))
                        }

                        Path { path in
                            path.move(to: points[0])
                            for point in points[1...] {
                                path.addLine(to: point)
                            }
                        }.stroke(Color.blue, lineWidth: 3)
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height, alignment: .topLeading)
                .padding()
            }
        )
    }
}

struct MoodOverTime_Previews: PreviewProvider {
    static var previews: some View {
        MoodOverTime(model: WidgetContent(moods: [], date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
