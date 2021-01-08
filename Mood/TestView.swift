//
//  TestView.swift
//  mood
//
//  Created by Harrison Borges on 5/24/20.
//  Copyright © 2020 hbb. All rights reserved.
//

import SwiftUI

struct TodayView: View {
    var body: some View {
			HStack {
				MoodButton(emoji: "☹️", text: "Not Good", value: 1)
				MoodButton(emoji: "😕", text: "Meh", value: 2)
				MoodButton(emoji: "😐", text: "Okay", value: 3)
				MoodButton(emoji: "🙂", text: "Pretty Good", value: 4)
				MoodButton(emoji: "😄", text: "Great", value: 5)
			}
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
    }
}
