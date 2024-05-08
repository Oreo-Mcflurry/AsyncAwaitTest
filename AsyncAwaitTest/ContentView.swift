//
//  ContentView.swift
//  AsyncAwaitTest
//
//  Created by A_Mcflurry on 5/8/24.
//

import SwiftUI

struct ContentView: View {
	@State private var image: Image = Image(systemName: "star")
	var body: some View {
		VStack {
			image
		}
		.padding()
		.onAppear {
			Task {
				self.image = try await NetworkManager.shared.callRequestAsync()
			}
		}
	}
}

#Preview {
	ContentView()
}

class NetworkManager {
	private init() { }
	static let shared = NetworkManager()

	enum CustomError: Error {
		case invalidResponse
		case unknown
		case invalidImage
  }

	private let request = URLRequest(url: URL(string: "https://picsum.photos/200/300")!)

	func callRequestAsync() async throws -> Image {
		let (data, response) = try await URLSession.shared.data(for: request)

		guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
			throw CustomError.invalidResponse
		}

//		if let image = UIImage(data: data) {
//			return image
//		} else {
//			throw CustomError.invalidImage
//		}

		guard let uiImage = UIImage(data: data) else {
			throw CustomError.invalidImage
		}

		let image = Image(uiImage: uiImage)

		return image
	}
}
