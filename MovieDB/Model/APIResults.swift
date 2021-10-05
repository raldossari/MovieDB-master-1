//
//  APIResults.swift
//  MovieDB
//
//  Created by Razan on 12/04/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
struct APIResults: Decodable {
    let page: Int
    let numResults: Int
    let numPages: Int
    let movies: [MovieDB]
    
    private enum CodingKeys: String, CodingKey {
        case page, numResults = "total_results", numPages = "total_pages", movies  = "results"
    }
}
