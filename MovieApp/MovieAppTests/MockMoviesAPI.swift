//
//  MockMoviesAPI.swift
//  MovieAppTests
//
//  Created by Rupali Kesharwani on 12/09/24.
//

import Foundation
import XCTest
@testable import MovieApp

class MockMoviesAPI: MoviesAPI {
	var isGetPopularMoviesCalled = false
	var isSetAsFavouriteCalled = false
	var isRemoveAsFavouriteCalled = false
	var movieListResponse: PopularMoviesResponse?
	var movieDetailResponse: MovieDetailResponse?
	var searchMoviesResponse: SearchMoviesResponse?
	var favouriteMovies: Set<Int> = []
	var expectation: XCTestExpectation?

	func getImage(imageUrl: String, onComplete: @escaping (ImageRequestResponse) -> Void) {
		// Mock implementation
	}

	func getPopularMovies(page: Int, onComplete: @escaping (PopularMoviesResponse) -> Void) {
		isGetPopularMoviesCalled = true
		if let response = movieListResponse {
			onComplete(response)
			expectation?.fulfill()
		}
	}

	func getMovieDetail(movieId: Int, onComplete: @escaping (MovieDetailResponse) -> Void) {
		if let response = movieDetailResponse {
			onComplete(response)
			expectation?.fulfill()
		}
	}

	func searchMovies(query: String, onComplete: @escaping (SearchMoviesResponse) -> Void) {
		if let response = searchMoviesResponse {
			onComplete(response)
			expectation?.fulfill()
		}
	}

	func setAsFavourite(movieId: Int) {
		isSetAsFavouriteCalled = true
		favouriteMovies.insert(movieId)
	}

	func removeAsFavourite(movieId: Int) {
		isRemoveAsFavouriteCalled = true
		favouriteMovies.remove(movieId)
	}

	func isFavourite(movieId: Int) -> Bool {
		return favouriteMovies.contains(movieId)
	}
}
