//
//  ContentView.swift
//  mood
//
//  Created by Harrison Borges on 5/24/20.
//  Copyright © 2020 hbb. All rights reserved.
//

import SwiftUI

struct MoodView: View {
	@State private var showingAlert = false
    var body: some View {
			VStack(alignment: .leading) {
				Text("How are you feeling?")
					.fontWeight(.bold)
					.font(.largeTitle)
					.padding(.top, 50)
					.padding(.leading, 20)
					.padding(.bottom, 40)

			VStack {
				MoodButton(showingAlert: $showingAlert, emoji: "☹️", title: "Not Good", score: 1)
					.buttonStyle(MoodButtonStyle())
					MoodButton(showingAlert: $showingAlert, emoji: "😕", title: "Meh", score: 2)
					.buttonStyle(MoodButtonStyle())
					MoodButton(showingAlert: $showingAlert, emoji: "😐", title: "Okay", score: 3)
					.buttonStyle(MoodButtonStyle())
					MoodButton(showingAlert: $showingAlert, emoji: "🙂", title: "Pretty Good", score: 4)
					.buttonStyle(MoodButtonStyle())
					MoodButton(showingAlert: $showingAlert, emoji: "😄", title: "Great", score: 5)
					.buttonStyle(MoodButtonStyle())
			}
		}
		.alert(isPresented: $showingAlert) {
				Alert(title: Text("An error occured. Please try again"), dismissButton: .default(Text("OK")))
		}
	}
}

struct MoodButton: View {
	@Binding var showingAlert: Bool

	var emoji: String
	var title: String
	var score: Int

	var body: some View {
		Button(action: { self.onClick() }) {
			HStack {
				Text(emoji)

				VStack(alignment: .leading) {
					Text(title)
						.fontWeight(.semibold)
				}

				Spacer()
				Text(String(self.score))
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
				self.showingAlert = true
			}
		}
	}
}

struct MoodButtonStyle: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.frame(minWidth: 0, maxWidth: .infinity)
			.padding()
			.foregroundColor(.white)
			.background(Color.blue)
			.cornerRadius(5)
			.padding(.horizontal, 20)
			.scaleEffect(configuration.isPressed ? 0.95 : 1.0)
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MoodView()
    }
}
