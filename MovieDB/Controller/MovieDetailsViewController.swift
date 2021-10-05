//
//  MovieDetailsViewController.swift
//  MovieDB
//
//  Created by Razan on 12/04/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var movieTitle: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var movieDescription: UITextView!
    
    var movieId: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        movieTitle.isEditable = false
        movieDescription.isEditable = false
        getMovie(movieId: movieId)
    
    }
    
    func getMovie(movieId: String) {
        self.showLoadingState(isLoading: true)
        MovieAPI.getMovieDetails(id: movieId) {(movie) in
            if movie != nil {
                if let poster = movie!.posterPath {
                    let url = URL(string: "https://image.tmdb.org/t/p/w500\(poster)")
                    let data = try? Data(contentsOf: url!)
                    
                    if let imageData = data {
                        self.poster.image = UIImage(data: imageData)
                    }
                }
                if let movieTitle = movie!.title as String? {
                    self.movieTitle.text = movie!.title
                }
                
                if let movieOverview = movie!.overview as String? {
                    self.movieDescription.text = movie!.overview
                }
                
                self.showLoadingState(isLoading: false)
            }
                
            else{
                let alert = UIAlertController(title: "Alert", message: "Internet connection error", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func showLoadingState(isLoading: Bool) {
        activityIndicator.isHidden = !isLoading
        
        if isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}
