//
//  MovieListViewController.swift
//  MovieApp
//
//  Created by Rupali Kesharwani on 08/09/24.
//

import UIKit

class MovieListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	private let refreshControl = UIRefreshControl()

	private var currentPage: Int?
	private var totalPages: Int?
	private var movies: [Movie] = []
	private var hasNextPage: Bool {
		return (currentPage ?? 0) < (totalPages ?? 0)
	}

	@IBOutlet var tableView: UITableView?

	override func viewDidLoad() {
		super.viewDidLoad()

		setupNavigationBar()
		setupTableView()
		fetchMovies()
	}

	private func setupNavigationBar() {
		self.title = "Popular Movies"
		self.navigationController?.navigationBar.prefersLargeTitles = true
		let searchButton = UIBarButtonItem(
			image: UIImage(systemName: "magnifyingglass"),
			style: .plain,
			target: self,
			action: #selector(Self.onSearchButtonTapped))
		navigationItem.rightBarButtonItem = searchButton
	}

	@objc private func onSearchButtonTapped() {

	}

	private func setupTableView() {
		tableView?.dataSource = self
		tableView?.delegate = self

		refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
		tableView?.refreshControl = refreshControl

		MovieListTableViewCell.register(in: tableView)
		PaginationLoaderTableViewCell.register(in: tableView)
	}

	@objc private func refreshData(_ sender: Any) {
		fetchMovies(shouldShowLoader: false)
	}

	private func fetchMovies(page: Int = 1, shouldShowLoader: Bool = true) {
		// Remove any existing error views
		removeErrorView()

		// Show loader view
		if shouldShowLoader {
			showLoader()
		}

		MoviesAPI.getPopularMovies(page: page) { [weak self] response in

			// Hide loading state
			self?.hideLoader()
			if self?.refreshControl.isRefreshing == true {
				self?.refreshControl.endRefreshing()
			}

			// Handle error
			if let error = response.error {
				self?.handleError(error: error)

				return
			}

			// Reset in case of pull down to refresh
			if page == 1 {
				self?.resetState()
			}

			// Set state
			self?.currentPage = response.page
			self?.totalPages = response.totalPages
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
			let okAction = UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
				self?.refreshControl.endRefreshing()
			})
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
		fetchMovies()
	}

	private func resetState() {
		self.movies = []
		self.currentPage = nil
		self.totalPages = nil
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if hasNextPage {
			return movies.count + 1
		}

		return movies.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if hasNextPage && indexPath.row == movies.count {
			return PaginationLoaderTableViewCell.dequeueReusableCell(in: tableView, for: indexPath)
		}

		let cell = MovieListTableViewCell.dequeueReusableCell(in: tableView, for: indexPath)
		cell.configure(using: movies[indexPath.row])

		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}

	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if cell is PaginationLoaderTableViewCell {

			// Delay for 1 sec to show the pagination loader
			DispatchQueue.main.asyncAfter(deadline: .now().advanced(by: .seconds(1)), execute: { [weak self] in
				self?.fetchMovies(page: (self?.currentPage ?? 0) + 1, shouldShowLoader: false)
			})
		}
	}
}
