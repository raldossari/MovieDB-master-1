//
//  MovieAPI.swift
//  MovieDB
//
//  Created by Razan on 12/04/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
class MovieAPI {
    
    
    private static let baseURL = "https://api.themoviedb.org/3/"
    private static let apiKey = "5d88184b27e82945677b274b6572beec"
    
    
    static func getLatestMovies(completion: @escaping ([MovieDB]?)->Void){
        var gitData : APIResults!
        
        guard let gitUrl = URL(string: "\(baseURL)discover/movie?api_key=\(apiKey)&language=en-US&sort_by=popularity.desc&page=1") else { return }
        URLSession.shared.dataTask(with: gitUrl) { (data, response
            , error) in
            guard let data = data else {
                print("error")
                completion(nil)
                return
            }
            do {
                let decoder = JSONDecoder()
                gitData = try decoder.decode(APIResults.self, from: data)
            } catch let err {
                print("Err", err)
            }
            DispatchQueue.main.async {
                completion(gitData.movies)
            }
            }.resume()
    }
    
    static func searchMovie(movieTitle: String, completion: @escaping ([MovieDB]?)->Void){
        var gitData : APIResults!
        
        guard let gitUrl = URL(string: "\(baseURL)search/movie?api_key=\(apiKey)&query=\(movieTitle)") else { return }
        print("\(baseURL)search/movie?api_key=\(apiKey)&query=\(movieTitle)")
        URLSession.shared.dataTask(with: gitUrl) { (data, response
            , error) in
            guard let data = data else {
                print("error")
                completion(nil)
                return
            }
            if movieTitle != ""{
            do {
                let decoder = JSONDecoder()
                gitData = try decoder.decode(APIResults.self, from: data)
                
            } catch let err {
                print("Err", err)
            }
            DispatchQueue.main.async {
                completion(gitData.movies)
            }
            }
            else{
                DispatchQueue.main.async {
                    print("error123")
                    completion(nil)
                }
            }
            }.resume()
    }
    
    static func getMovieDetails(id: String, completion: @escaping (MovieDB?)->Void){
        var gitData : MovieDB!
        guard let gitUrl = URL(string: "\(baseURL)movie/%20\(id)?api_key=\(apiKey)&language=en-US") else { return }
        URLSession.shared.dataTask(with: gitUrl) { (data, response
            , error) in
            guard let data = data else {
                print("error")
                completion(nil)
                return
            }
            do {
                let decoder = JSONDecoder()
                gitData = try decoder.decode(MovieDB.self, from: data)
                
            } catch let err {
                print("Err", err)
            }
            DispatchQueue.main.async {
                completion(gitData)
            }
            }.resume()
    }
}
