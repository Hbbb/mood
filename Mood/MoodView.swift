//
//  ContentView.swift
//  mood
//
//  Created by Harrison Borges on 5/24/20.
//  Copyright © 2020 hbb. All rights reserved.
//

import SwiftUI

struct MoodView: View {
    var body: some View {
			VStack {
				Text("How are you feeling?")
					.fontWeight(.bold)
					.font(.largeTitle)
					.padding(.bottom, 40)

			VStack {
				MoodButton(emoji: "☹️", text: "Not Good", value: 1)
					.buttonStyle(MoodButtonStyle())
				MoodButton(emoji: "😕", text: "Meh", value: 2)
					.buttonStyle(MoodButtonStyle())
				MoodButton(emoji: "😐", text: "Okay", value: 3)
					.buttonStyle(MoodButtonStyle())
				MoodButton(emoji: "🙂", text: "Pretty Good", value: 4)
					.buttonStyle(MoodButtonStyle())
				MoodButton(emoji: "😄", text: "Great", value: 5)
					.buttonStyle(MoodButtonStyle())
			}
		}
	}
}

struct MoodButton: View {
	var emoji: String
	var text: String
	var value: Int

	var body: some View {
		Button(action: { print(self.value) }) {
			HStack {
				Text(emoji)

				if text.count > 0 {
					Text(text)
						.fontWeight(.semibold)
				}
			}
		}
		.padding()
	}
}

struct MoodButtonStyle: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.frame(minWidth: 0, maxWidth: .infinity)
			.padding()
			.foregroundColor(.white)
			.background(Color.blue)
			.cornerRadius(10)
			.padding(.horizontal, 20)
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MoodView()
    }
}
