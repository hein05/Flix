//
//  NowPlayingViewController.swift
//  Flix
//
//  Created by Hein Soe on 9/7/18.
//  Copyright © 2018 Hein Soe. All rights reserved.
//

import UIKit
import AlamofireImage

class NowPlayingViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    // MARK:PROPERTIES START
    @IBOutlet weak var loadingAnim: UIActivityIndicatorView!
    @IBOutlet weak var TableView: UITableView!
    var refreshControl:UIRefreshControl!
    
    @IBOutlet weak var leftRight: UISegmentedControl!
    
    
    private var apiNowPlayingString: String = "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
    private var apiTopRatedString: String  = "https://api.themoviedb.org/3/movie/top_rated?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US&page=1"
    
    private var movies: [[String: Any]] = []
    // MARK:PROPERTIES END
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableView.delegate = self
        TableView.insertSubview(refreshControl, at: 0)
        TableView.dataSource = self as UITableViewDataSource
        
        self.loadingAnim.startAnimating()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NowPlayingViewController.didPullToRefresh(_:)), for: .valueChanged)
        
        self.leftRightDetect()
    }
    
    // MARK: CUSTOM FUNCTIONS
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        self.leftRightDetect()
    }

    private func set_and_refresh () {
        self.TableView.reloadData()
        self.refreshControl.endRefreshing()
        self.loadingAnim.stopAnimating()
    }
    
    // MARK: TABLEVIEW DELEGATE IMPLEMENTATION
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinVC = self.navigationController?.visibleViewController as! DetailCellViewController
        destinVC.movieDetail = self.movies[indexPath.row]
    }
    
    // MARK:SEGMENT CHANGES PRESENT DIFFERENT API ENDPOINT (NOWPLAYING VS TOP RATED)
    @IBAction func changePresentation(_ sender: Any) {
        self.leftRightDetect()
    }
    
    private func leftRightDetect () {
        if leftRight.selectedSegmentIndex == 0 {
            self.navigationItem.title = "Now Playing"
            fetchMovies(apiStr: apiNowPlayingString) { (fetchedMovies) in
                self.movies = fetchedMovies
                self.set_and_refresh()
            }
        } else {
            self.navigationItem.title = "Top Rated"
            fetchMovies(apiStr: apiTopRatedString) { (fetchedMovies) in
                self.movies = fetchedMovies
                self.set_and_refresh()
            }
        }
    }
    
    // MARK: SEGUE TO SEARCH_VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "search" {
            let destinVC = segue.destination as! CollectionViewController
            if leftRight.selectedSegmentIndex == 0 {
                destinVC.heroapiStr = self.apiNowPlayingString
            } else {
                destinVC.heroapiStr = self.apiTopRatedString
            }
            
            destinVC.navigationItem.title = "Search"
            destinVC.fromSearch = true
            destinVC.navigationController?.navigationItem.title = "Search"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
