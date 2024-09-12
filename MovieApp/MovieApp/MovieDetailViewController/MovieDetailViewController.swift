//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by Rupali Kesharwani on 10/09/24.
//

import UIKit

class MovieDetailViewController: UIViewController {

	private let moviesAPI: MoviesAPI
	private var movieId: Int?
	private var movie: MovieDetail?

	@IBOutlet var stackView: UIStackView?
	@IBOutlet var posterImageView: UIImageView?
	@IBOutlet var favouriteButton: UIButton?
	@IBOutlet var descriptionLabel: UILabel?
	@IBOutlet var releaseDateLabel: UILabel?
	@IBOutlet var genresLabel: UILabel?
	@IBOutlet var languagesLabel: UILabel?
	@IBOutlet var runtimeLabel: UILabel?
	@IBOutlet var ratingLabel: UILabel?

	init(movieId: Int?, moviesAPI: MoviesAPI = DefaultMoviesAPI.shared) {
		self.movieId = movieId
		self.moviesAPI = moviesAPI

		super.init(nibName: "MovieDetailViewController", bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		navigationController?.navigationBar.prefersLargeTitles = true
		fetchMovieDetail(movieId: self.movieId)

		setupCustomSpacing(spacing: 30, in: stackView, after: [favouriteButton])
		setupCustomSpacing(spacing: 16, in: stackView, after: [
			descriptionLabel,
			releaseDateLabel,
			genresLabel,
			languagesLabel,
			runtimeLabel
		])
	}

	func setupCustomSpacing(spacing: CGFloat, in stackView: UIStackView?, after subViews: [UIView?]) {
		guard let stackView = stackView else { return }

		for subView in subViews.compactMap({ $0 }) {
			stackView.setCustomSpacing(spacing, after: subView)
		}
	}

	func fetchMovieDetail(movieId: Int?) {
		guard let movieId = movieId else {
			return
		}

		showLoader()
		moviesAPI.getMovieDetail(movieId: movieId) { [weak self] response in
			self?.hideLoader()

			if let error = response.error {
				self?.handleError(error: error)

				return
			}

			self?.movie = response.movie
			self?.reloadData()
		}
	}

	private func reloadData() {
		title = movie?.title
		descriptionLabel?.text = movie?.overview
		releaseDateLabel?.text = movie?.releaseDate
		genresLabel?.text = movie?.genres?.compactMap({ $0.name }).joined(separator: ", ")
		languagesLabel?.text = movie?.spokenLanguages?.compactMap({ $0.name }).joined(separator: ", ")
		runtimeLabel?.text = "\(movie?.runtime ?? 0) mins"
		ratingLabel?.text = "\(movie?.voteAverage ?? 0)/10.0"
		favouriteButton?.setTitle(moviesAPI.isFavourite(movieId: movie?.id ?? -1) ? "Remove from favourites" : "Add to favourites", for: .normal)

		moviesAPI.getImage(imageUrl: movie?.posterUrl ?? "") { [weak self] response in
			self?.posterImageView?.image = response.image
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

		showErrorView(
				title: title,
				description: description,
				recoveryButtonTitle: recoveryButtonTitle,
				recoveryClosure: { [weak self] in
					self?.recoverFromError()
				})

	}

	private func recoverFromError() {
		removeErrorView()
		fetchMovieDetail(movieId: movieId)
	}

	private func resetState() {
		movie = nil
	}

	@IBAction func onFavouriteButtonTapped() {
		if moviesAPI.isFavourite(movieId: movie?.id ?? -1) {
			moviesAPI.removeAsFavourite(movieId: movie?.id ?? -1)
		} else {
			moviesAPI.setAsFavourite(movieId: movieId ?? -1)
		}

		reloadData()

		NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FavouritesCollectionUpdated"), object: nil)
	}
}
