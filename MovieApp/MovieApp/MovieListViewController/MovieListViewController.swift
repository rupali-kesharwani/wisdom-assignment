//
//  MovieListViewController.swift
//  MovieApp
//
//  Created by Rupali Kesharwani on 08/09/24.
//

import UIKit

class MovieListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	var movies: [Movie]?

	@IBOutlet var tableView: UITableView?

	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupTableView()
		MoviesAPI.getPopularMovies(page: 1) { [weak self] response in
			self?.movies = response.movies
			self?.tableView?.reloadData()
		}
	}

	private func setupTableView() {
		tableView?.dataSource = self
		tableView?.delegate = self
		MovieListTableViewCell.register(in: tableView)
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return movies != nil ? 1 : 0
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return movies?.count ?? 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = MovieListTableViewCell.dequeueReusableCell(in: tableView, for: indexPath)
		if let movie = movies?[indexPath.row] {
			cell.configure(using: movie)
		}

		return cell
	}
}
