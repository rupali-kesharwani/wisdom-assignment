//
//  MovieListViewControllerTests.swift
//  MovieAppTests
//
//  Created by Rupali Kesharwani on 12/09/24.
//

import XCTest
@testable import MovieApp

final class MovieListViewControllerTests: XCTestCase {

	var mockMoviesAPI: MockMoviesAPI!
	var movieListViewController: MovieListViewController!

	override func setUp() {
		super.setUp()
		mockMoviesAPI = MockMoviesAPI()
		movieListViewController = MovieListViewController(moviesAPI: mockMoviesAPI)
	}

	override func tearDown() {
		mockMoviesAPI = nil
		movieListViewController = nil
		super.tearDown()
	}

	func testViewDidLoadCallsFetchMovies() {
		// WHEN
		movieListViewController.loadView()

		// THEN
		XCTAssertTrue(mockMoviesAPI.isGetPopularMoviesCalled, "getPopularMovies should be called when the view loads")
	}

	func testFetchMoviesAppendsMovies() {

		// TEST CONDITIONS
		let expectation = XCTestExpectation()
		let popularMoviesResponse = loadJSON(filename: "SuccessPopularMoviesResponseWithNoNextPage", type: PopularMoviesResponse.self)
		mockMoviesAPI.movieListResponse = popularMoviesResponse
		mockMoviesAPI.expectation = expectation

		// WHEN
		movieListViewController.loadView()

		// THEN
		XCTAssertEqual(
			movieListViewController
				.tableView(
					movieListViewController.tableView!,
					numberOfRowsInSection: 0),
			2, 
			"The table view should have 2 movie"
		)
		XCTAssertEqual(
			movieListViewController.testHook.getMovies().count,
			2,
			"The movie list should contain one movie"
		)

		// Wait Expectation
		wait(for: [expectation], timeout: 10)
	}

	func testHasNextPageWhenMorePagesAvailable() {
		// WHEN
		movieListViewController.testHook.setCurrentPage(page: 1)
		movieListViewController.testHook.setTotalPages(pages: 2)

		// THEN
		XCTAssertTrue(movieListViewController.testHook.getHasNextPage(), "hasNextPage should return true when more pages are available")
	}

	func testHasNextPageWhenNoMorePagesAvailable() {
		// WHEN
		movieListViewController.testHook.setCurrentPage(page: 2)
		movieListViewController.testHook.setTotalPages(pages: 2)

		// THEN
		XCTAssertFalse(movieListViewController.testHook.getHasNextPage(), "hasNextPage should return false when no more pages are available")
	}

	func testHandleErrorShowsErrorView() {
		// GIVEN
		movieListViewController.loadViewIfNeeded()

		// WHEN
		let networkError = NetworkingError.noInternet
		movieListViewController.testHook.handleError(error: networkError)

		// THEN
		let errorView = movieListViewController.view.subviews.first { $0 is ErrorView }
		XCTAssertNotNil(errorView, "ErrorView should be presented when there is no internet connection")
	}
}
