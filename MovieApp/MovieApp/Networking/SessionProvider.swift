//
//  SessionProvider.swift
//  MovieApp
//
//  Created by Rupali Kesharwani on 07/09/24.
//

import Foundation

class SessionProvider {

  // fetch Json Api
  static let dataSession: URLSession = {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 10.0
    configuration.timeoutIntervalForResource = 10.0
    configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
		configuration.waitsForConnectivity = false

    return URLSession(configuration: configuration)
  }()

  static let memoryCapacity: Int = 250 * 1024 * 1024
  static let diskCapacity: Int = 1024 * 1024 * 1024
  static let cache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: nil)

  // fetch image Api
  static let imageSession: URLSession = {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 30.0
    configuration.timeoutIntervalForResource = 30.0
    configuration.urlCache = cache
    configuration.requestCachePolicy = .returnCacheDataElseLoad

    return URLSession(configuration: configuration)
  }()
}
