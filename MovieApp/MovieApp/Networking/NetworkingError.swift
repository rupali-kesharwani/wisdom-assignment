//
//  NetworkingError.swift
//  MovieApp
//
//  Created by Rupali Kesharwani on 07/09/24.
//

import Foundation

enum NetworkingError: Error {
  case invalidCredentials
  case invalidUrl
	case invalidRequestParams
  case invalidResponse
  case noInternet
  case redirectionError
  case responseSerializationError(error: Error?)
  case badRequest(code: Int)
  case internalServerError(code: Int)
  case unknown(error: Error?)
}
