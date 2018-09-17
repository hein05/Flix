//
//  ViewController.swift
//  Flix
//
//  Created by Hein Soe on 9/10/18.
//  Copyright © 2018 Hein Soe. All rights reserved.
//

import UIKit
import AFNetworking

class CollectionViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate,UISearchBarDelegate {
   // MARK:PROPERTIES START
    var fromSearch:Bool = false 
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var loadingAnim: UIActivityIndicatorView!
    
    var refreshControl:UIRefreshControl!
    
    var selectedIndex:Int?

    var heroapiStr: String = "https://api.themoviedb.org/3/movie/363088/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US&page=1"
    
    var movies:[[String: Any]]!
    var filteredMovie:[[String: Any]]?
    // MARK:PROPERTIES END
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingAnim.startAnimating()
        
        self.searchBar.delegate = self
        
        collectionView.delegate = self
        collectionView.dataSource = self as UICollectionViewDataSource
        collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
        
        // Dynamic Cell resizing.
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellPerLine: CGFloat = 2
        let interItemSpacingTotal = layout.minimumInteritemSpacing * (cellPerLine - 1)
        let w = (self.view.frame.size.width / cellPerLine - interItemSpacingTotal/cellPerLine)
        layout.itemSize = CGSize(width: w, height: w * 3/2)
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(CollectionViewController.didPullToRefresh(_:)), for: .valueChanged)
        collectionView.insertSubview(refreshControl, at: 0)

        fetchMovies(apiStr: heroapiStr) { (fetchedMovies) in
            self.movies = fetchedMovies
            self.set_and_refresh()
            self.filteredMovie = self.movies
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if fromSearch {
            self.searchBar.becomeFirstResponder()
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.navigationController?.navigationBar.barStyle = .blackTranslucent
        } else {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
        
    }
    
    // MARK:CUSTOM FUNCTONS
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        //        fetchMovies()
        fetchMovies(apiStr: heroapiStr) { (fetchedMovies) in
            self.movies = fetchedMovies
            self.set_and_refresh()
        }
    }
    
    private func set_and_refresh () {
        self.collectionView.reloadData()
        self.refreshControl.endRefreshing()
        self.loadingAnim.stopAnimating()
    }
    
    // MARK:COLLECTIONVIEW DELEGATE IMPLEMENTATION
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var totalRow = 0
        if let movies = filteredMovie {
            totalRow = movies.count
        }
        return totalRow
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCollectionCell

        if let movie = filteredMovie?[indexPath.row] {
            let posterPath = movie["poster_path"] as! String
            //        let basePosterPath = "https://image.tmdb.org/t/p/w500"
            let smallPosterPath = "https://image.tmdb.org/t/p/w45"
            let largePosterPath = "https://image.tmdb.org/t/p/w500"
            imageLoad(smallImgURL: smallPosterPath + posterPath, largeImgURL: largePosterPath + posterPath, img: cell.posterImage)
        }
//        if let posterURL = URL(string: basePosterPath + posterPath) {
//
//            cell.posterImage.af_setImage(withURL: posterURL, placeholderImage: #imageLiteral(resourceName: "troll"), imageTransition: .crossDissolve(0.5))
//        }
//        else {
//            cell.posterImage = nil
//        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
    }
    
    // MARK:SEGUE TO DETAIL_VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailFromCollectionVC" {
            
            if let index = selectedIndex {
                let destinVC = segue.destination as! DetailCellViewController
                destinVC.movieDetail = self.filteredMovie?[index]
            }
        }
    }
    
    // MARK: IMAGE LOADING FUNCTION AFNetworking FRAMEWORK
    func imageLoad (smallImgURL: String, largeImgURL: String, img:UIImageView) {
        let smallImgReq = URLRequest(url: URL(string: smallImgURL)!)
        let largeImgReq = URLRequest(url: URL(string: largeImgURL)!)
        
        img.setImageWith(smallImgReq, placeholderImage: #imageLiteral(resourceName: "troll"),
                         success: { (smallImgReq, smallImgResponse, smallImg) -> Void in
                            img.alpha = 0.0
                            img.image = smallImg
                            
                            UIView.animate(withDuration: 0.3, animations: {()-> Void in
                                img.alpha = 1.0
                            }, completion: { (success) -> Void in
                                img.setImageWith(largeImgReq, placeholderImage: smallImg,
                                                 success: { (largeImgReq, largeImgResponse, largeImg) in
                                                    img.image = largeImg
                                }, failure: { (request, response, error) in
                                    
                                })
                            })
        }) { (request, response, error) -> Void in
        }
    }
    // MARK: SEARCH BAR ANIMATION
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        
        let appearing = UIViewPropertyAnimator(duration: 0.8, curve: .easeOut) {
            self.searchBar.alpha = 1.0
        }
        let disappearing = UIViewPropertyAnimator(duration: 0.8, curve: .easeOut) {
            self.searchBar.alpha = 0.0
        }
        
        if translation.y > 0 {
            //            going up__Reappearing
            if self.searchBar.alpha < 1.0 {
                disappearing.stopAnimation(true)
            }
            appearing.startAnimation()
            
        } else {
            //            going down__Disappearing
            if self.searchBar.alpha > 0.0 {
                appearing.stopAnimation(true)
                
            }
            disappearing.startAnimation()
        }
    }
    
    // MARK:SEARCHBAR IMPLEMENTATION
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredMovie = searchText.isEmpty ? self.movies : self.movies.filter({ (eachMovie) -> Bool in
            let movieTitle = eachMovie["title"] as! String
            return movieTitle.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
        collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
