//
//  MoviesAPI.swift
//  MovieApp
//
//  Created by Rupali Kesharwani on 07/09/24.
//

import Foundation
import UIKit


protocol MoviesAPI {
	func getImage(imageUrl: String, onComplete: @escaping (_ response: ImageRequestResponse) -> Void)
	func getPopularMovies(page: Int, onComplete: @escaping (_ response: PopularMoviesResponse) -> Void)
	func getMovieDetail(movieId: Int, onComplete: @escaping (_ response: MovieDetailResponse) -> Void)
	func searchMovies(query: String, onComplete: @escaping (_ response: SearchMoviesResponse) -> Void)

	func setAsFavourite(movieId: Int)
	func removeAsFavourite(movieId: Int)
	func isFavourite(movieId: Int) -> Bool
}

class DefaultMoviesAPI: MoviesAPI {

	static let shared = DefaultMoviesAPI()

	private var favouriteMovies: Set<Int> = []

	private init() {
		loadFavouriteMovies()
	}

	func loadFavouriteMovies() {
		favouriteMovies.removeAll()
		if let intArray = UserDefaults.standard.array(forKey: "favouriteMovies") as? [Int] {
			favouriteMovies.formUnion(intArray)
		}
	}

	func getImage(imageUrl: String, onComplete: @escaping (_ response: ImageRequestResponse) -> Void) {
		guard let url = URL(string: imageUrl) else {
			onComplete(ImageRequestResponse.init(error: NetworkingError.badRequest(code: 400)))

			return
		}

		let task = SessionProvider.imageSession.dataTask(with: url) { data, response, error in
			DispatchQueue.main.async {
				onComplete(ImageRequestHandler<ImageRequestResponse>().handle(imageUrl, data, response, error))
			}
		}

		task.resume()
	}

	func getPopularMovies(page: Int, onComplete: @escaping (_ response: PopularMoviesResponse) -> Void) {
		guard let url = URL(string: "\(Server.baseUrl)/3/discover/movie") else {
			onComplete(PopularMoviesResponse(error: NetworkingError.badRequest(code: 400)))

			return
		}

		guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
			onComplete(PopularMoviesResponse(error: NetworkingError.badRequest(code: 400)))

			return
		}

		let queryItems: [URLQueryItem] = [
			URLQueryItem(name: "include_adult", value: "false"),
			URLQueryItem(name: "include_video", value: "false"),
			URLQueryItem(name: "language", value: "en-US"),
			URLQueryItem(name: "page", value: String(describing: page)),
			URLQueryItem(name: "sort_by", value: "popularity.desc"),
		]
		components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

		guard let url = components.url else {
			onComplete(PopularMoviesResponse(error: NetworkingError.badRequest(code: 400)))

			return
		}

		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		request.timeoutInterval = 30
		request.allHTTPHeaderFields = [
			"accept": "application/json",
			"Authorization": "Bearer \(Server.readAccessToken)"
		]

		let task = SessionProvider.dataSession.dataTask(with: request) { data, response, error  in
			DispatchQueue.main.async {
				onComplete(APIRequestHandler<PopularMoviesResponse>().handle(request, data, response, error))
			}
		}
		task.resume()
	}

	func getMovieDetail(movieId: Int, onComplete: @escaping (_ response: MovieDetailResponse) -> Void) {
		guard let url = URL(string: "\(Server.baseUrl)/3/movie/\(movieId)") else {
			onComplete(MovieDetailResponse(error: NetworkingError.badRequest(code: 400)))

			return
		}

		guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
			onComplete(MovieDetailResponse(error: NetworkingError.badRequest(code: 400)))

			return
		}

		let queryItems: [URLQueryItem] = [
			URLQueryItem(name: "language", value: "en-US"),
		]
		components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

		guard let url = components.url else {
			onComplete(MovieDetailResponse(error: NetworkingError.badRequest(code: 400)))

			return
		}

		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		request.timeoutInterval = 30
		request.allHTTPHeaderFields = [
			"accept": "application/json",
			"Authorization": "Bearer \(Server.readAccessToken)"
		]

		let task = SessionProvider.dataSession.dataTask(with: request) { data, response, error  in
			DispatchQueue.main.async {
				onComplete(APIRequestHandler<MovieDetailResponse>().handle(request, data, response, error))
			}
		}
		task.resume()
	}

	func searchMovies(query: String, onComplete: @escaping (_ response: SearchMoviesResponse) -> Void) {
		guard let url = URL(string: "\(Server.baseUrl)/3/search/movie") else {
			onComplete(SearchMoviesResponse(error: NetworkingError.badRequest(code: 400)))

			return
		}

		guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
			onComplete(SearchMoviesResponse(error: NetworkingError.badRequest(code: 400)))

			return
		}

		let queryItems: [URLQueryItem] = [
			URLQueryItem(name: "query", value: query),
			URLQueryItem(name: "include_adult", value: "false"),
			URLQueryItem(name: "language", value: "en-US"),
			URLQueryItem(name: "page", value: "1"),
		]
		components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

		guard let url = components.url else {
			onComplete(SearchMoviesResponse(error: NetworkingError.badRequest(code: 400)))

			return
		}

		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		request.timeoutInterval = 30
		request.allHTTPHeaderFields = [
			"accept": "application/json",
			"Authorization": "Bearer \(Server.readAccessToken)"
		]

		let task = SessionProvider.dataSession.dataTask(with: request) { data, response, error  in
			DispatchQueue.main.async {
				onComplete(APIRequestHandler<SearchMoviesResponse>().handle(request, data, response, error))
			}
		}
		task.resume()
	}

	func setAsFavourite(movieId: Int) {
		favouriteMovies.insert(movieId)

		// Save the set in UserDefaults
		let intArray = Array(favouriteMovies)
		UserDefaults.standard.set(intArray, forKey: "favouriteMovies")
	}

	func removeAsFavourite(movieId: Int) {
		favouriteMovies.remove(movieId)
		
		// Save the set in UserDefaults
		let intArray = Array(favouriteMovies)
		UserDefaults.standard.set(intArray, forKey: "favouriteMovies")
	}

	func isFavourite(movieId: Int) -> Bool {
		return favouriteMovies.contains(movieId)
	}
}

