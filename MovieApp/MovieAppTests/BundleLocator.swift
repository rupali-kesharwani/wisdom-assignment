//
//  BundleLocator.swift
//  MovieAppTests
//
//  Created by Rupali Kesharwani on 12/09/24.
//

import Foundation

final class BundleLocator {

	// The bundle for the current class
	static let bundle: Bundle = {
		return Bundle(for: BundleLocator.self)
	}()
}
