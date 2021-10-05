//
//  MovieDB.swift
//  MovieDB
//
//  Created by Razan on 12/04/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
class MovieDB: Decodable  {
    let id:Int!
    let posterPath: String?
    var videoPath: String?
    let backdrop: String?
    let title: String
    var releaseDate: String
    var rating: Double
    let overview: String
    
    private enum CodingKeys: String, CodingKey {
        case id, posterPath = "poster_path", videoPath, backdrop = "backdrop_path", title, releaseDate = "release_date", rating = "vote_average", overview
    }
}
