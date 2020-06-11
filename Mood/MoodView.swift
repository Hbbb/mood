//
//  ContentView.swift
//  mood
//
//  Created by Harrison Borges on 5/24/20.
//  Copyright © 2020 hbb. All rights reserved.
//

import SwiftUI

struct MoodView: View {
	let greatColor = Color(red: 0.16, green: 0.68, blue: 0.38)
	let goodColor = Color(red: 0.16, green: 0.50, blue: 0.72)
	let okayColor = Color(red: 0.90, green: 0.50, blue: 0.13)
	let mehColor = Color(red: 0.61, green: 0.35, blue: 0.71)
	let notGoodColor = Color(red: 0.50, green: 0.55, blue: 0.55)

	@State private var showingAlert = false
    var body: some View {
			VStack {
				Text("How are you feeling?")
					.fontWeight(.bold)
					.font(.largeTitle)
					.padding(.bottom, 30)

			VStack {
				MoodButton(showingAlert: $showingAlert, emoji: "😄", title: "Great", score: 5)
					.buttonStyle(MoodButtonStyle(color: greatColor))
				MoodButton(showingAlert: $showingAlert, emoji: "🙂", title: "Pretty Good", score: 4)
					.buttonStyle(MoodButtonStyle(color: goodColor))
				MoodButton(showingAlert: $showingAlert, emoji: "😐", title: "Okay", score: 3)
					.buttonStyle(MoodButtonStyle(color: okayColor))
				MoodButton(showingAlert: $showingAlert, emoji: "😕", title: "Meh", score: 2)
					.buttonStyle(MoodButtonStyle(color: mehColor))
				MoodButton(showingAlert: $showingAlert, emoji: "☹️", title: "Not Good", score: 1)
					.buttonStyle(MoodButtonStyle(color: notGoodColor))
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
			VStack {
				Text(emoji)
				.padding(.bottom, 10)
				Text(title)
					.fontWeight(.semibold)
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
				self.showingAlert = true
			}
		}
	}
}

struct MoodButtonStyle: ButtonStyle {
	var color: Color

	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.frame(minWidth: 0, maxWidth: .infinity)
			.padding(.top, 10)
			.padding(.bottom, 10)
			.foregroundColor(.white)
			.background(color)
			.cornerRadius(5)
			.padding(.horizontal, 10)
			.scaleEffect(configuration.isPressed ? 0.95 : 1.0)
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MoodView()
    }
}
