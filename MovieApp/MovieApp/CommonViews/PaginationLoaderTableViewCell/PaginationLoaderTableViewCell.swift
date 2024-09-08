//
//  PaginationLoaderTableViewCell.swift
//  MovieApp
//
//  Created by Rupali Kesharwani on 08/09/24.
//

import UIKit

class PaginationLoaderTableViewCell: UITableViewCell {

	static let reuseIdentifier: String = "PaginationLoaderTableViewCell"

	static func register(in tableView: UITableView?) {
		tableView?.register(UINib.init(nibName: "PaginationLoaderTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
	}

	static func dequeueReusableCell(in tableView: UITableView?, for indexPath: IndexPath) -> PaginationLoaderTableViewCell {
		guard let cell = tableView?.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? PaginationLoaderTableViewCell else {
			return PaginationLoaderTableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: reuseIdentifier)
		}

		return cell
	}

	@IBOutlet var activityIndicator: UIActivityIndicatorView?

	override func prepareForReuse() {
		activityIndicator?.startAnimating()
	}
}
