//
//  LatestMoviesViewController.swift
//  MovieDB
//
//  Created by Razan on 12/04/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import CoreData

class LatestMoviesViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var moviesList = [MovieDB]()
    var savedMovies:[Movie] = []
    var dataController:DataController!
    var fetchedResultsController: NSFetchedResultsController<Movie>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataController = getDataController()
        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        fetchRequest.sortDescriptors = []
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: dataController.viewContext,
            sectionNameKeyPath: nil,
            cacheName: "Movies")
        
        savedMovies = loadSavedMovie()!
        
        if self.loadSavedMovie() != nil && savedMovies.count != 0 {
            savedMovies = self.loadSavedMovie()!
            showSavedData()
            
        } else {
            loadLatestMovies()
        }
       
    }

    func loadLatestMovies() {
        print("loadLatestMovies")
        self.deleteMovie()
        self.savedMovies.removeAll()
        self.collectionView.reloadData()
        
        
        MovieAPI.getLatestMovies {(moviesDB) in
             print("loadLatestMovies\(moviesDB?.count)")
            
            if moviesDB != nil {
                DispatchQueue.main.async {
                    self.addCoreData(movies: moviesDB!)
                    self.savedMovies = self.loadSavedMovie()!
                    self.showSavedData()
                }
                 self.moviesList = moviesDB!
            }
            else{
                let alert = UIAlertController(title: "Alert", message: "Internet connection error", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }

        }
        
    }

    
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedMovies.count
    }
    
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCollectionCell
        let movie = self.savedMovies[(indexPath as NSIndexPath).row]
        //cell.activityIndicator.startAnimating()
        if( self.savedMovies[(indexPath as NSIndexPath).row].posterData != nil){
            cell.imageView!.image = UIImage(data: self.savedMovies[(indexPath as NSIndexPath).row].posterData!)
            cell.activityIndicator.isHidden = true
        }
            
        else{
            cell.initPhoto(savedMovies[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,didSelectItemAt indexPath: IndexPath){
         performSegue(withIdentifier: "passData", sender: savedMovies[indexPath.item])
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = collectionView.indexPathsForSelectedItems {
            guard let destiontionVc = segue.destination as? MovieDetailsViewController else {return}
        
            destiontionVc.movieId = (sender as! Movie).id!
        }
    }
    
    
    func getDataController() -> DataController {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.dataController
    }
    
    func loadSavedMovie() -> [Movie]? {
        
        do {
            
            var movieArray:[Movie] = []
            try fetchedResultsController.performFetch()
            let movieCount = try fetchedResultsController.managedObjectContext.count(for: fetchedResultsController.fetchRequest)
            
            for index in 0..<movieCount {
                movieArray.append(fetchedResultsController.object(at: IndexPath(row: index, section: 0)) )
            }
            return movieArray
            
        } catch {
            
            return nil
        }
    }
    
    func showSavedData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func deleteMovie() {
        for image in savedMovies {
            self.dataController.viewContext.delete(image)
        }
    }
    
    func addCoreData(movies:[MovieDB]!) {
        for image in movies {
            do {
                let movie = Movie(context: dataController.viewContext)
                movie.posterURL = image.posterPath
                movie.overview = image.overview
                movie.posterData = nil
                movie.id = "\(image.id!)"
                try dataController.saveContext()
                
            } catch {
                print("Add Core Data Failed")
            }
        }
    }
    
    @IBAction func onReloadMovies(_ sender: Any) {
         self.loadLatestMovies()
    }
}
