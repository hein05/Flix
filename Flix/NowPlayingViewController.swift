//
//  NowPlayingViewController.swift
//  Flix
//
//  Created by Hein Soe on 9/7/18.
//  Copyright © 2018 Hein Soe. All rights reserved.
//

import UIKit
import AlamofireImage


internal var movies: [[String: Any]] = []

class NowPlayingViewController: UIViewController,UITableViewDataSource,UISearchBarDelegate {
    
    @IBOutlet weak var loadingAnim: UIActivityIndicatorView!
    @IBOutlet weak var TableView: UITableView!
    var refreshControl:UIRefreshControl!
    
   

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingAnim.startAnimating()
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NowPlayingViewController.didPullToRefresh(_:)), for: .valueChanged)
        TableView.insertSubview(refreshControl, at: 0)
        TableView.dataSource = self as UITableViewDataSource
        fetchMovies()
    }
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        fetchMovies()
    }
    
    
    func fetchMovies  () {

        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request =  URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            //This will run when the network request return
            
            if let error = error {
//                print(error.localizedDescription)
                self.networkAlert(fetch: self.fetchMovies)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
//                print(dataDictionary)
                let fetchedMovies = dataDictionary["results"] as! [[String: Any]]
                movies = fetchedMovies
                self.TableView.reloadData()
                self.refreshControl.endRefreshing()
                self.loadingAnim.stopAnimating()
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
//        cell.selectionStyle = .blue
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let posterPath = movie["poster_path"] as! String
        let basePosterPath = "https://image.tmdb.org/t/p/w500"
        
        if let posterURL = URL(string: basePosterPath + posterPath) {
            
            cell.posterImage.af_setImage(withURL: posterURL, placeholderImage: #imageLiteral(resourceName: "troll"), imageTransition: .crossDissolve(0.5))
        } else {
            cell.posterImage = nil
        }
        cell.titleLbl.text = title
        cell.overviewLbl.text = overview
        
        return cell
    }
 
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
