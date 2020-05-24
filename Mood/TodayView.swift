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
			HStack(alignment: .top) {
				MoodButton(emoji: "☹️", text: "", value: 1)
				MoodButton(emoji: "😕", text: "", value: 2)
				MoodButton(emoji: "😐", text: "", value: 3)
				MoodButton(emoji: "🙂", text: "", value: 4)
				MoodButton(emoji: "😄", text: "", value: 5)
			}
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
    }
}
