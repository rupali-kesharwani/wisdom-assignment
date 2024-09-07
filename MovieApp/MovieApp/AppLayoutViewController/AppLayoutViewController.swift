//
//  AppLayoutViewController.swift
//  MovieApp
//
//  Created by Rupali Kesharwani on 07/09/24.
//

import UIKit

class AppLayoutViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		MoviesAPI.getPopularMovies(page: 1) { response in
			print(response)
		}

		MoviesAPI.getMovieDetail(movieId: 826510) { response in
			print(response)
		}

	}
}
