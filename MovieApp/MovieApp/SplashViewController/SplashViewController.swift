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
				let appLayoutViewController = AppLayoutViewController(nibName: "AppLayoutViewController", bundle: nil)
				AppDelegate.keyWindow?.rootViewController = appLayoutViewController
				AppDelegate.keyWindow?.makeKeyAndVisible()
			})
	}
}

struct codeF : Codable {

}
