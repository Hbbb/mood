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
				MoodButton(showingAlert: $showingAlert, emoji: "☹️", text: "Not Good", score: 1)
					.buttonStyle(MoodButtonStyle())
				MoodButton(showingAlert: $showingAlert, emoji: "😕", text: "Meh", score: 2)
					.buttonStyle(MoodButtonStyle())
				MoodButton(showingAlert: $showingAlert, emoji: "😐", text: "Okay", score: 3)
					.buttonStyle(MoodButtonStyle())
				MoodButton(showingAlert: $showingAlert, emoji: "🙂", text: "Pretty Good", score: 4)
					.buttonStyle(MoodButtonStyle())
				MoodButton(showingAlert: $showingAlert, emoji: "😄", text: "Great", score: 5)
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
	var text: String
	var score: Int

	var body: some View {
		Button(action: { self.onClick() }) {
			HStack {
				Text(emoji)

				Text(text)
					.fontWeight(.semibold)
			}
		}
		.padding()
	}

	func onClick() {
		let url = URL(string: "https://httpstat.us/201")
		guard let requestUrl = url else { fatalError() }

		var request = URLRequest(url: requestUrl)
		request.httpMethod = "POST"

		request.setValue("application/json", forHTTPHeaderField: "Accept")
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")

		let mood = MoodReport(score: self.score, deviceID: 0)
		let json = try! JSONEncoder().encode(mood)

		request.httpBody = json

		let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
			if let error = error {
				self.showingAlert = true
				print(error)
				return
			}

			if let response = response as? HTTPURLResponse {
				if response.statusCode != 201 {
					self.showingAlert = true
					return
				}
			}
		}

		task.resume()
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
			.scaleEffect(configuration.isPressed ? 0.99 : 1.0)
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MoodView()
    }
}
