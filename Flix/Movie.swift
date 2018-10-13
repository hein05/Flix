//
//  Movie.swift
//  Flix
//
//  Created by Hein Soe on 10/11/18.
//  Copyright © 2018 Hein Soe. All rights reserved.
//
import UIKit

class Movie {
    
    var title: String
    var overview:String
    var posterPath:String
    var posterUrl: URL?
    var backdropUrl: URL?
    var backdropPath:String
    var releaseDate:String
    var movieID:Int
    
    init(dictionary: [String: Any]) {
        title = dictionary["title"] as? String ?? "No title"
        overview = dictionary["overview"] as! String
        posterPath = dictionary["poster_path"] as! String
        let basePosterPath = "https://image.tmdb.org/t/p/w500"
        posterUrl = URL(string: basePosterPath + posterPath)
        
        backdropPath = dictionary["backdrop_path"] as! String
        backdropUrl = URL(string: basePosterPath + backdropPath)
        releaseDate = dictionary["release_date"] as! String
        movieID = dictionary["id"] as! Int
    }
    
    class func movies(dictionaries: [[String: Any]]) -> [Movie] {
        var movies: [Movie] = []
        for dictionary in dictionaries {
            let movie = Movie(dictionary: dictionary)
            movies.append(movie)
        }
        
        return movies
    }
    
}
