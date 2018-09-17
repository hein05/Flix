//
//  WebViewController.swift
//  Flix
//
//  Created by Hein Soe on 9/16/18.
//  Copyright © 2018 Hein Soe. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
// MARK:PROPERTY START
    @IBOutlet weak var activityAnim: UIActivityIndicatorView!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var key:String?
    var movieID:Int?
    private var apiVideo:String?
    private var video:[[String:Any]] = []
// MARK:PROPERTY STOP
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityAnim.startAnimating()
        if let movieID = movieID {
            apiVideo = "https://api.themoviedb.org/3/movie/\(movieID)/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US"
            fetchMovies(apiStr: apiVideo!) { (fetchedMovies) in
                self.video = fetchedMovies
                // MARK: SEARCH KEY-VALUE PAIR WITH TRAILER TYPE
                for index in self.video {
                    if index["type"] as! String == "Trailer" {
                        self.key = index["key"] as? String
                        if let key = self.key {
                            let url = URL(string: "https://www.youtube.com/watch?v=" + key)
                            let request = URLRequest(url: url!)
                            self.webView.load(request)
                            self.activityAnim.stopAnimating()
                        }
                        break
                    }
                }
                if self.key == nil {
                    self.trailerAlert()
                    let url = URL(string: "https://www.youtube.com")
                    let request = URLRequest(url: url!)
                    self.webView.load(request)
                    self.activityAnim.stopAnimating()
                }
            }
        }
    }
    
    // MARK:TRAILER API NOT FOUND ALERT
    func trailerAlert () {
        let showAlert = UIAlertController(title: "Trailer Not Found", message: "Links seems to be disappeared, Please search Youtube", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        
        showAlert.addAction(dismissAction)
        self.present(showAlert, animated: true, completion: nil)
    }
    
    // MARK:DISMISS VIEW
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   


}
