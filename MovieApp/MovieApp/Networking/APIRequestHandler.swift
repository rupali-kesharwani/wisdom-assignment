//
//  ApiRequestHandler.swift
//  MovieApp
//
//  Created by Rupali Kesharwani on 07/09/24.
//

import Foundation

protocol APIResponse: Codable {
	init(error: Error)
}

class APIRequestHandler<T: APIResponse> {
	func handle(
		_ request: URLRequest?,
		_ data: Data?,
		_ response: URLResponse?,
		_ error: Error?
	) -> T {
		if let error = error {
			return T(error:
								NetworkingError.unknown(error: error))
		}

		guard let httpResponse = response as?
						HTTPURLResponse else {
			return T(error:
								NetworkingError.invalidResponse)
		}

		guard httpResponse.statusCode != 0 else {
			return T(error: NetworkingError.noInternet)
		}

		// Redirection error
		if (300...399).contains(httpResponse
			.statusCode) {
			return T(error: NetworkingError.redirectionError)
		}

		// Client error
		if (400...499).contains(httpResponse.statusCode) {
			return T(error: NetworkingError.badRequest(code: httpResponse.statusCode))
		}

		guard let data = data else {
			return T(error: NetworkingError.invalidResponse)
		}

		do {
			return try JSONDecoder().decode(T.self, from: data)
		} catch {
			return T(error: NetworkingError.responseSerializationError(error: error))
		}
	}
}
