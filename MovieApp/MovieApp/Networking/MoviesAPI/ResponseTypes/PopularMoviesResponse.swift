//
//  PopularMoviesResponse.swift
//  MovieApp
//
//  Created by Rupali Kesharwani on 07/09/24.
//

import Foundation

struct PopularMoviesResponse: APIResponse {
	let page: Int?
	let movies: [Movie]?
	let totalPages: Int?
	var error: Error?

	init(error: any Error) {
		self.error = error
		self.page = nil
		self.movies = nil
		self.totalPages = nil
	}

	enum CodingKeys: String, CodingKey {
		case page
		case movies = "results"
		case totalPages = "total_pages"
	}
}
