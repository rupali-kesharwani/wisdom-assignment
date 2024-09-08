//
//  ImageRequestHandler.swift
//  MovieApp
//
//  Created by Rupali Kesharwani on 07/09/24.
//

import SwiftUI

protocol ImageResponse {
	init(image: UIImage, imageUrl: String)
	init(error: Error)
}

class ImageRequestHandler<T: ImageResponse> {
	func handle(
		_ imageUrl: String,
		_ data: Data?,
		_ response: URLResponse?,
		_ error: Error?
	) -> T {

		if let error = error {
			return T(error: NetworkingError.unknown(error: error))
		}

		guard let httpResponse = response as? HTTPURLResponse else {
			return T(error: NetworkingError.invalidResponse)
		}

		guard httpResponse.statusCode != 0 else {
			return T(error: NetworkingError.noInternet)
		}

		if (300...399).contains(httpResponse.statusCode) {
			return T(error: NetworkingError.redirectionError)
		}

		if (400...499).contains(httpResponse.statusCode) {
			return T(error: NetworkingError.badRequest(code: httpResponse.statusCode))
		}

		if (500...599).contains(httpResponse.statusCode) {
			return T(error: NetworkingError.internalServerError(code: httpResponse.statusCode))
		}

		guard let data = data else {
			return T(error: NetworkingError.invalidResponse)
		}

		if let image = UIImage(data: data) {
			return T(image: image, imageUrl: imageUrl)
		}

		return T(error: NetworkingError.invalidResponse)
	}
}
