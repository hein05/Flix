//
//  MovieApiManager.swift
//  Flix
//
//  Created by Hein Soe on 10/13/18.
//  Copyright © 2018 Hein Soe. All rights reserved.
//

import UIKit

class MovieApiManager {
    
    static let baseUrl = "https://api.themoviedb.org/3/movie/"
    static let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    var session: URLSession
    
    init() {
        session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    }
    
    func nowPlayingMovies(apiKey:String,completion: @escaping ([Movie]?, Error?) -> ()) {
//        let url = URL(string: MovieApiManager.baseUrl + "now_playing?api_key=\(MovieApiManager.apiKey)")!
        let url = URL(string: MovieApiManager.baseUrl + apiKey)!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                if let movieDictionaries = dataDictionary["results"] as? [[String: Any]] {
                    
                    let movies = Movie.movies(dictionaries: movieDictionaries)
                    completion(movies, nil)
                }
            } else {
                completion(nil, error)
            }
        }
        task.resume()
    }
}
