//
//  SearchMovieViewController.swift
//  MovieApp
//
//  Created by Rupali Kesharwani on 09/09/24.
//

import UIKit

class SearchMovieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

	private var movies: [Movie] = []
	private var searchTimer: Timer?
	private let debounceInterval: TimeInterval = 0.5
	private var query: String?
	private let loadingIndicator = UIActivityIndicatorView(style: .medium)

	@IBOutlet var tableView: UITableView?

	override func viewDidLoad() {
		super.viewDidLoad()

		setupNavigationBar()
		setupTableView()
	}

	private func setupNavigationBar() {
		navigationController?.navigationBar.prefersLargeTitles = true
		title = "Search movies"
		loadingIndicator.hidesWhenStopped = true

		let searchBar = UISearchBar()
		searchBar.placeholder = "Search movies"
		searchBar.searchTextField.rightView = loadingIndicator
		searchBar.searchTextField.rightViewMode = .always
		searchBar.delegate = self
		navigationItem.titleView = searchBar

		let doneButton = UIBarButtonItem(
			title: "Close",
			style: .done,
			target: self,
			action: #selector(Self.onDoneButtonTapped))
		navigationItem.rightBarButtonItem = doneButton
	}

	@objc private func onDoneButtonTapped() {
		dismiss(animated: true)
	}

	private func setupTableView() {
		tableView?.dataSource = self
		tableView?.delegate = self

		MovieListTableViewCell.register(in: tableView)
		PaginationLoaderTableViewCell.register(in: tableView)
	}

	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		debounceSearch(query: searchText)
	}

	private func debounceSearch(query: String) {
		// Invalidate any existing timer
		searchTimer?.invalidate()

		// Create a new timer
		searchTimer = Timer.scheduledTimer(withTimeInterval: debounceInterval, repeats: false, block: { [weak self] _ in
			self?.query = query
			self?.performSearch(query: query, shouldShowLoader: true)
		})
	}

	// MARK: - Perform the actual search
	private func performSearch(query: String, shouldShowLoader: Bool) {

		// Remove any existing error views
		removeErrorView()

		// Show loader view
		if shouldShowLoader {
			loadingIndicator.startAnimating()
		}

		MoviesAPI.searchMovies(query: query) { [weak self] response in
			// Hide loading state
			self?.loadingIndicator.stopAnimating()

			// Handle error
			if let error = response.error {
				self?.handleError(error: error)

				return
			}

			// Set state
			self?.resetState()
			self?.movies.append(contentsOf: response.movies ?? [])

			// Reload and remove loader
			self?.tableView?.reloadData()
		}
	}

	private func handleError(error: Error) {
		if let networkError = error as? NetworkingError {
			if case .noInternet = networkError {
				showErrorView(
					title: "No Internet",
					description: "Looks like you are no longer connected to the internet. Please try again in sometime.",
					recoveryButtonTitle: "Retry",
					recoveryClosure: { [weak self] in
						self?.recoverFromError()
					})

				return
			}
		}

		let title = "Oops!"
		let description = "Looks like something went wrong with connecting to the server. Please try again in sometime"
		let recoveryButtonTitle = "Retry"

		if movies.count == 0 {
			showErrorView(
				title: title,
				description: description,
				recoveryButtonTitle: recoveryButtonTitle,
				recoveryClosure: { [weak self] in
					self?.recoverFromError()
				})
		} else {
			let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
			let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			let retryAction = UIAlertAction(title: recoveryButtonTitle, style: .default, handler: { [weak self] _ in
				self?.recoverFromError()
			})
			alert.addAction(okAction)
			alert.addAction(retryAction)
			present(alert, animated: true, completion: nil)
		}
	}

	private func recoverFromError() {
		removeErrorView()
		if let query = self.query {
			performSearch(query: query, shouldShowLoader: true)
		}
	}

	private func resetState() {
		self.movies = []
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return movies.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = MovieListTableViewCell.dequeueReusableCell(in: tableView, for: indexPath)
		cell.configure(using: movies[indexPath.row])

		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}
