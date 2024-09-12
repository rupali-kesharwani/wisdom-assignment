//
//  XCTest+Extension.swift
//  MovieAppTests
//
//  Created by Rupali Kesharwani on 12/09/24.
//

import XCTest

extension XCTest {
	func loadJSON<T: Codable>(filename: String, type: T.Type) -> T? {
		// Locate the JSON file in the test bundle

		guard let path = BundleLocator.bundle.path(forResource: filename, ofType: "json") else {
			XCTFail("Missing file: \(filename).json")
			return nil
		}
		
		do {
			// Load the JSON data from the file
			let data = try Data(contentsOf: URL(fileURLWithPath: path))

			// Decode the data into the specified Codable model
			let decodedData = try JSONDecoder().decode(T.self, from: data)
			return decodedData
		} catch {
			XCTFail("Failed to decode \(filename).json: \(error.localizedDescription)")
			return nil
		}
	}
}
