//
//  ErrorView.swift
//  MovieApp
//
//  Created by Rupali Kesharwani on 08/09/24.
//

import UIKit

class ErrorView: UIView {

	static func getErrorView(
		title: String?,
		description: String?,
		recoveryButtonTitle: String?,
		recoveryClosure: @escaping () -> Void
	) -> ErrorView? {
		let view = UINib(nibName: "ErrorView", bundle: nil)
			.instantiate(withOwner: ErrorView.self, options: nil)
			.first as? ErrorView

		view?.translatesAutoresizingMaskIntoConstraints = false
		
		view?.setErrorState(
			title: title,
			description: description,
			recoveryButtonTitle: recoveryButtonTitle,
			recoveryClosure: recoveryClosure
		)
		
		return view
	}

	@IBOutlet var stackView: UIStackView?
	@IBOutlet var titleLabel: UILabel?
	@IBOutlet var descriptionLabel: UILabel?
	@IBOutlet var recoveryButton: UIButton?

	private var recoveryClosure: (() -> Void)?

	func setErrorState(
		title: String?,
		description: String?,
		recoveryButtonTitle: String?,
		recoveryClosure: (() -> Void)?
	) {
		setErrorTitle(title)
		setErrorDescription(description, title)
		setErrorRecoveryButton(recoveryButtonTitle, description, title, recoveryClosure)
	}

	private func setErrorTitle(_ title: String?) {
		if let title = title {
			titleLabel?.text = title
		} else {
			if let titleLabel = self.titleLabel {
				stackView?.removeArrangedSubview(titleLabel)
				titleLabel.removeFromSuperview()
			}
		}
	}

	private func setErrorDescription(_ description: String?, _ title: String?) {
		if let description = description {
			descriptionLabel?.text = description

			if let titleLabel = titleLabel, title != nil {
				stackView?.setCustomSpacing(16, after: titleLabel)
			}
		} else {
			if let descriptionLabel = self.descriptionLabel {
				stackView?.removeArrangedSubview(descriptionLabel)
				descriptionLabel.removeFromSuperview()
			}
		}
	}

	private func setErrorRecoveryButton(_ recoveryButtonTitle: String?, _ description: String?, _ title: String?, _ recoveryClosure: (() -> Void)?) {
		if let recoveryButtonTitle = recoveryButtonTitle {
			recoveryButton?.setTitle(recoveryButtonTitle, for: .normal)

			if let descriptionLabel = descriptionLabel, description != nil {
				stackView?.setCustomSpacing(24, after: descriptionLabel)
			} else if let titleLabel = titleLabel, title != nil {
				stackView?.setCustomSpacing(18, after: titleLabel)
			}
		} else {
			if let recoveryButton = self.recoveryButton {
				stackView?.removeArrangedSubview(recoveryButton)
				recoveryButton.removeFromSuperview()
			}
		}

		self.recoveryClosure = recoveryClosure
	}

	@IBAction func onRecoveryButtonTapped() {
		recoveryClosure?()
	}
}

extension UIViewController {
	func showErrorView(
		title: String?,
		description: String?,
		recoveryButtonTitle: String?,
		recoveryClosure: @escaping () -> Void
	) {
		guard let errorView = ErrorView.getErrorView(
			title: title,
			description: description,
			recoveryButtonTitle: recoveryButtonTitle,
			recoveryClosure: recoveryClosure
		) else { return }

		self.view.addSubview(errorView)
		NSLayoutConstraint.activate([
			errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			errorView.topAnchor.constraint(equalTo: view.topAnchor),
			errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
		view.bringSubviewToFront(errorView)
	}

	func removeErrorView() {
		for view in view.subviews {
			if view is ErrorView {
				view.removeFromSuperview()
				return
			}
		}
	}
}
