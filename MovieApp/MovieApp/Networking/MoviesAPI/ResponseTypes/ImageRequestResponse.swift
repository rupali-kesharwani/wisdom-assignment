//
//  ImageRequestResponse.swift
//  MovieApp
//
//  Created by Rupali Kesharwani on 09/09/24.
//

import UIKit

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
