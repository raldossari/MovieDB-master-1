//
//  SearchMovieViewController.swift
//  MovieDB
//
//  Created by Razan on 12/04/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class SearchMovieViewController: UIViewController, UITableViewDataSource , UITableViewDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var moviesList = [MovieDB]()
    override func viewDidLoad() {
        super.viewDidLoad()
        searchField.delegate = self
        activityIndicator.isHidden = true
        self.moviesList.removeAll()
        self.tableView.reloadData()
        
    }
    
    fileprivate func displayAlert(msg: String) {
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func searchMovie(searchTitle: String) {
         activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        MovieAPI.searchMovie(movieTitle: searchTitle) {(movies) in
            if movies != nil {
                if movies!.count == 0{
                    print("razan bbbb \(movies!.count)")
                    let alert = UIAlertController(title: "Alert", message: "There are not Movies", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                self.moviesList = movies!
                self.tableView.reloadData()
                self.activityIndicator.startAnimating()
                
            }
            else{
                
                if searchTitle != ""{
                     DispatchQueue.main.async {
                    self.displayAlert(msg: "Internet connection error")
                    }
                }
                else{
                     DispatchQueue.main.async {
                    self.displayAlert(msg: "Please enter the title of the movie")
                    }
                }
                
            }
    }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "movieCell")as! MovieCell
        let movie = self.moviesList[(indexPath as NSIndexPath).row]

        if let poster = movie.posterPath {
            let url = URL(string: "https://image.tmdb.org/t/p/w500\(poster)")
            let data = try? Data(contentsOf: url!)
            
            if let imageData = data {
                cell.imageView!.image = UIImage(data: imageData)
            }
        }
        
        if let movieTitle = movie.title as String? {
            cell.textLabel?.text = movieTitle
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "passData", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            guard let destiontionVc = segue.destination as? MovieDetailsViewController else {return}
            let selectedRow = indexPath.row
            destiontionVc.movieId = "\(moviesList[selectedRow].id!)"
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        if textField == searchField {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            searchMovie(searchTitle: textField
                .text!)
        }
        return true
    }
}
