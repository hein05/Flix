//
//  SingleCellViewController.swift
//  Flix
//
//  Created by Hein Soe on 9/10/18.
//  Copyright © 2018 Hein Soe. All rights reserved.
//

import UIKit
import AlamofireImage

class DetailCellViewController: UIViewController {
    // MARK:PROPERTIES START
    @IBOutlet weak var coverImg: UIImageView!
    @IBOutlet weak var posterImg: UIImageView!

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
   
    @IBOutlet weak var detailTxt: UITextView!
    
//    var movieDetail:[String:Any]?
    var movieDetail:Movie?
    // MARK:PROPERTIES END
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isUserInteractionEnabled = true
        coverImg.isUserInteractionEnabled = true
//        if let movieDetail = movieDetail {
//            let title = movieDetail["title"] as! String
//            let overview = movieDetail["overview"] as! String
//            let posterPath = movieDetail["poster_path"] as! String
//            let backdropPath = movieDetail["backdrop_path"] as! String
//            let releaseDate = movieDetail["release_date"] as! String
//            let basePosterPath = "https://image.tmdb.org/t/p/w500"
//
//            self.dateLbl.text = releaseDate
//            self.titleLbl.text = title
//            self.detailTxt.text = overview
//
//            guard let posterURL = URL(string: basePosterPath + posterPath), let backdropURL = URL(string: basePosterPath + backdropPath) else {
//                return
//            }
//            self.posterImg.af_setImage(withURL: posterURL, placeholderImage: #imageLiteral(resourceName: "troll"), imageTransition: .crossDissolve(0.5))
//            self.coverImg.af_setImage(withURL: backdropURL, placeholderImage: #imageLiteral(resourceName: "troll"), imageTransition: .crossDissolve(0.5))
//        }
        
        if let movieDetail = movieDetail {
            self.dateLbl.text = movieDetail.releaseDate
            self.titleLbl.text = movieDetail.title
            self.detailTxt.text = movieDetail.overview
            
            if let posterUrl = movieDetail.posterUrl {
                self.posterImg.af_setImage(withURL: posterUrl, placeholderImage: #imageLiteral(resourceName: "troll"), imageTransition: .crossDissolve(0.5))
            }
            
            if let backdropUrl = movieDetail.backdropUrl {
                self.coverImg.af_setImage(withURL: backdropUrl, placeholderImage: #imageLiteral(resourceName: "troll"), imageTransition: .crossDissolve(0.5))
            }
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.barStyle = .black
    }
    // MARK:IMAGE TAPPED GESTURE
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "trailer", sender: self)
    }
    // MARK:SEGUE TO WEB_VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "trailer" {
            let destinVC = segue.destination as! WebViewController
            destinVC.movieID = movieDetail?.movieID
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
