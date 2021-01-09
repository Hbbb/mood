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
        guard let user = UserDefaultsController.currentUser() else {
//            self.showingAlert = true
            return
        }
        
        guard let userID = user.id else {
//            self.showingAlert = true
            return
        }
        
        let mood = MoodReport(score: self.score, userID: userID)
		let generator = UINotificationFeedbackGenerator()
		generator.prepare()

        mood.save() { err in
            if let err = err {
                print(err)
                generator.notificationOccurred(.error)
            } else {
                print("it worked!")
                generator.notificationOccurred(.success)
            }
        }
	}
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
    }
}
