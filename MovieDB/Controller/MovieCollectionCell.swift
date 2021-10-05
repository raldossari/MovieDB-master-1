//
//  MovieCollectionCell.swift
//  MovieDB
//
//  Created by Razan on 14/04/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import UIKit

class MovieCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    func initPhoto(_ movie: Movie) {
        
        if movie.posterData != nil {
            DispatchQueue.main.async {
                self.imageView!.image = UIImage(data: movie.posterData! as Data)
                self.activityIndicator.stopAnimating()
            }
            
        } else {
            downloadImage(movie)
        }
    }
    
    func downloadImage(_ movie: Movie!) {
        URLSession.shared.dataTask(with: URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterURL!)")!) { (data, response, error) in
            if error == nil {
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data! as Data)
                    self.activityIndicator.stopAnimating()
                    self.saveImage(movie: movie, posterDate: data! as NSData)
                }
            }
            }
            
            .resume()
    }
    
    func saveImage(movie: Movie, posterDate: NSData) {
        do {
            print("Saving Movie posterDate Success")
            movie.posterData = posterDate as Data
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let dataController = delegate.dataController
            try dataController.saveContext()
        } catch {
            print("Saving Movie posterDate Failed")
        }
    }
    
}

