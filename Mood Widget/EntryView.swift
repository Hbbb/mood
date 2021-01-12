//
//  EntryView.swift
//  Mood WidgetExtension
//
//  Created by Harrison Borges on 1/9/21.
//  Copyright © 2021 hbb. All rights reserved.
//

import SwiftUI

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

