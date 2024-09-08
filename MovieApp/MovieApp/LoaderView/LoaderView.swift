//
//  LoaderView.swift
//  MovieApp
//
//  Created by Rupali Kesharwani on 08/09/24.
//

import UIKit

class LoaderView: UIView {
	static func getLoaderView() -> LoaderView? {
		let view = UINib(nibName: "LoaderView", bundle: nil).instantiate(withOwner: LoaderView.self, options: nil).first as? LoaderView
		view?.translatesAutoresizingMaskIntoConstraints = false

		return view
	}
}

extension UIViewController {
	func showLoader() {
		guard let loaderView = LoaderView.getLoaderView() else { return }
		
		self.view.addSubview(loaderView)
		NSLayoutConstraint.activate([
			loaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			loaderView.topAnchor.constraint(equalTo: view.topAnchor),
			loaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			loaderView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
		view.bringSubviewToFront(loaderView)
	}

	func hideLoader() {
		for view in view.subviews {
			if view is LoaderView {
				UIView.animate(withDuration: 0.25) {
					view.layer.opacity = 0
				} completion: { _ in
					view.removeFromSuperview()
				}

				return
			}
		}
	}
}
