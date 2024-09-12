//
//  ViewController.swift
//  MovieApp
//
//  Created by Rupali Kesharwani on 07/09/24.
//

import UIKit

class SplashViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		moveToAppLayoutPostDeadline(3)
	}

	func moveToAppLayoutPostDeadline(_ deadlineSeconds: Int) {
		DispatchQueue.main.asyncAfter(
			deadline: .now().advanced(by: .seconds(deadlineSeconds)),
			execute: {
				let movieListViewController = MovieListViewController()
				let navigationController = UINavigationController(rootViewController: movieListViewController)
				AppDelegate.keyWindow?.rootViewController = navigationController
				AppDelegate.keyWindow?.makeKeyAndVisible()
			})
	}
}
