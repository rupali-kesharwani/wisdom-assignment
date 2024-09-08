//
//  MoviesAPI.swift
//  MovieApp
//
//  Created by Rupali Kesharwani on 07/09/24.
//

import Foundation
import UIKit


class MoviesAPI {

	private init() {
		// Avoid initilizing this class
	}

	static func getImage(imageUrl: String, onComplete: @escaping (_ response: ImageRequestResponse) -> Void) {
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

	static func getPopularMovies(page: Int, onComplete: @escaping (_ response: PopularMoviesResponse) -> Void) {
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

	static func getMovieDetail(movieId: Int, onComplete: @escaping (_ response: MovieDetailResponse) -> Void) {
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
}

class ImageRequestResponse: ImageResponse {
	var image: UIImage?
	var error: Error?
	var imageUrl: String?

	required init(image: UIImage, imageUrl: String) {
		self.image = image
		self.imageUrl = imageUrl
	}

	required init(error: Error) {
		self.error = error
	}
}
