//
//  MovieDetailResponse.swift
//  MovieApp
//
//  Created by Rupali Kesharwani on 07/09/24.
//

import Foundation

struct MovieDetailResponse: APIResponse {
	let movie: MovieDetail?
	var error: Error?

	init(error: any Error) {
		self.error = error
		self.movie = nil
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		self.movie = try? container.decode(MovieDetail.self)
		self.error = nil
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(movie)
	}

	enum CodingKeys: String, CodingKey {
		case movie
	}
}
