//
//  MovieListViewController.swift
//  MovieApp
//
//  Created by Rupali Kesharwani on 08/09/24.
//

import UIKit

class MovieListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	var currentPage: Int?
	var totalPages: Int?
	var movies: [Movie] = []

	private let refreshControl = UIRefreshControl()

	var hasNextPage: Bool {
		return (currentPage ?? 0) < (totalPages ?? 0)
	}

	@IBOutlet var tableView: UITableView?

	override func viewDidLoad() {
		super.viewDidLoad()

		setupTableView()
		fetchMovies()
	}

	func fetchMovies(page: Int = 1, shouldShowLoader: Bool = true) {
		if shouldShowLoader {
			showLoader()
		}

		MoviesAPI.getPopularMovies(page: page) { [weak self] response in
			if page == 1 {
				self?.resetState()
			}

			self?.currentPage = response.page
			self?.totalPages = response.totalPages
			self?.movies.append(contentsOf: response.movies ?? [])
			self?.tableView?.reloadData()

			self?.hideLoader()
		}
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
		refreshControl.endRefreshing()
		fetchMovies(shouldShowLoader: false)
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
			fetchMovies(page: (currentPage ?? 0) + 1, shouldShowLoader: false)
		}
	}
}
