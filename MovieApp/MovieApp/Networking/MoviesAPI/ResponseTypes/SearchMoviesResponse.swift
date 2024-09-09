//
//  SearchMoviesResponse.swift
//  MovieApp
//
//  Created by Rupali Kesharwani on 09/09/24.
//

import Foundation

struct SearchMoviesResponse: APIResponse {
	let movies: [Movie]?
	var error: Error?

	init(error: any Error) {
		self.error = error
		self.movies = nil
	}

	enum CodingKeys: String, CodingKey {
		case movies = "results"
	}
}
