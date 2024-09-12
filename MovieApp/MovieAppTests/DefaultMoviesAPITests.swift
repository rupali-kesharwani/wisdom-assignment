//
//  MovieAppTests.swift
//  MovieAppTests
//
//  Created by Rupali Kesharwani on 07/09/24.
//

import XCTest
@testable import MovieApp

class DefaultMoviesAPITests: XCTestCase {

	var moviesAPI: DefaultMoviesAPI!

	override func setUp() {
		super.setUp()
		// Clear UserDefaults before each test
		UserDefaults.standard.removeObject(forKey: "favouriteMovies")
		moviesAPI = DefaultMoviesAPI.shared
	}

	override func tearDown() {
		moviesAPI = nil
		super.tearDown()
	}

	func testSetAsFavourite() {
		let movieId = 101
		moviesAPI.setAsFavourite(movieId: movieId)

		XCTAssertTrue(moviesAPI.isFavourite(movieId: movieId), "Movie should be marked as favourite")
	}

	func testRemoveAsFavourite() {
		let movieId = 102
		moviesAPI.setAsFavourite(movieId: movieId)
		moviesAPI.removeAsFavourite(movieId: movieId)

		XCTAssertFalse(moviesAPI.isFavourite(movieId: movieId), "Movie should not be marked as favourite")
	}

	func testIsFavourite() {
		let movieId = 103
		XCTAssertFalse(moviesAPI.isFavourite(movieId: movieId), "Movie should not be marked as favourite by default")

		moviesAPI.setAsFavourite(movieId: movieId)
		XCTAssertTrue(moviesAPI.isFavourite(movieId: movieId), "Movie should be marked as favourite after adding")
	}

	func testLoadFavouriteMovies() {
		let movieId = 104
		moviesAPI.setAsFavourite(movieId: movieId)

		// Recreate the DefaultMoviesAPI instance to simulate app restart
		UserDefaults.standard.set([movieId], forKey: "favouriteMovies")
		moviesAPI = DefaultMoviesAPI.shared

		XCTAssertTrue(moviesAPI.isFavourite(movieId: movieId), "Movie should be loaded as favourite after loading from UserDefaults")
	}
}
