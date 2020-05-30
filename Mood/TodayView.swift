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
		let deviceID = UIDevice.current.identifierForVendor!.uuidString
		let mood = MoodReport(score: self.score, deviceID: deviceID)
		let generator = UINotificationFeedbackGenerator()
		generator.prepare()

		mood.save() { result in
			switch result {
			case .success:
				generator.notificationOccurred(.success)
			case .failure:
				generator.notificationOccurred(.error)
			}
		}
	}
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
    }
}
