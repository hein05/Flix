//
//  ViewController.swift
//  Flix
//
//  Created by Hein Soe on 9/10/18.
//  Copyright © 2018 Hein Soe. All rights reserved.
//

import UIKit
import AFNetworking

class SearchViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var filteredMovie:[[String: Any]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        searchBar.becomeFirstResponder()
        collectionView.dataSource = self as UICollectionViewDataSource
        filteredMovie = movies
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredMovie.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCollectionCell

        let movie = filteredMovie[indexPath.row]
        let posterPath = movie["poster_path"] as! String
//        let basePosterPath = "https://image.tmdb.org/t/p/w500"
        let smallPosterPath = "https://image.tmdb.org/t/p/w45"
        let largePosterPath = "https://image.tmdb.org/t/p/original"
        imageLoad(smallImgURL: smallPosterPath + posterPath, largeImgURL: largePosterPath + posterPath, img: cell.posterImage)
//        if let posterURL = URL(string: basePosterPath + posterPath) {
//
//            cell.posterImage.af_setImage(withURL: posterURL, placeholderImage: #imageLiteral(resourceName: "troll"), imageTransition: .crossDissolve(0.5))
//        }
//        else {
//            cell.posterImage = nil
//        }
        return cell
    }
    
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
        filteredMovie = searchText.isEmpty ? movies : movies.filter({ (eachMovie) -> Bool in
                let movieTitle = eachMovie["title"] as! String
                return movieTitle.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
        collectionView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
