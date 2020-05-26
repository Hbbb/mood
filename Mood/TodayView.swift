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
				EmojiButton(emoji: "☹️", score: 1)
				EmojiButton(emoji: "😕", score: 2)
				EmojiButton(emoji: "😐", score: 3)
				EmojiButton(emoji: "🙂", score: 4)
				EmojiButton(emoji: "😄", score: 5)
			}
    }
}

struct EmojiButton: View {
	var emoji: String
	var score: Int

	var body: some View {
		Button(action: { self.onClick() }) {
			HStack {
				Text(emoji)
			}
		}
		.padding()
	}

	func onClick() {
		let mood = MoodReport(score: self.score, deviceID: 0)

		mood.save() { result in
			switch result {
			case .success:
				// Haptic?
				print("success")
			case .failure:
				print("Failed")
			}
		}
	}
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
    }
}
