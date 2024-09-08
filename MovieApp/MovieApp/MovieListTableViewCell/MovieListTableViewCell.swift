//
//  MovieListTableViewCell.swift
//  MovieApp
//
//  Created by Rupali Kesharwani on 08/09/24.
//

import UIKit

class MovieListTableViewCell: UITableViewCell {

	static let reuseIdentifier: String = "MovieListTableViewCell"

	static func register(in tableView: UITableView?) {
		tableView?.register(UINib.init(nibName: "MovieListTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
	}

	static func dequeueReusableCell(in tableView: UITableView?, for indexPath: IndexPath) -> MovieListTableViewCell {
		guard let cell = tableView?.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? MovieListTableViewCell else {
			return MovieListTableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: reuseIdentifier)
		}

		return cell
	}

	@IBOutlet var posterImageView: UIImageView?
	@IBOutlet var titleLabel: UILabel?
	@IBOutlet var releaseOnLabel: UILabel?
	@IBOutlet var ratingLabel: UILabel?
	@IBOutlet var descriptionLabel: UILabel?


	func configure(using movie: Movie) {
		titleLabel?.text = movie.title
		releaseOnLabel?.text = movie.releaseDate
		ratingLabel?.text = "\(movie.voteAverage ?? 0)/10.0"
		descriptionLabel?.text = movie.overview
	}


}
