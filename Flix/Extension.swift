//
//  AlertController.swift
//  Flix
//
//  Created by Hein Soe on 9/9/18.
//  Copyright © 2018 Hein Soe. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // MARK:FETCH MOVIES EXTENSIONS
    func fetchMovies (apiStr: String,success: @escaping (_ movies: [[String: Any]]) -> () ) {
        
        let url = URL(string: apiStr)!
        let request =  URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            
        // MARK:This will run when the network request return
            if let error = error {
                print(error.localizedDescription)
                let showAlert = UIAlertController(title: "Cannot Get Movies", message: "Internet appears to be offline", preferredStyle: .alert)
                let tryAgainAction = UIAlertAction (title: "Try Again!!", style: .default) { (action) in
                    self.fetchMovies(apiStr: apiStr, success: success)
                }
                
                showAlert.addAction(tryAgainAction)
                self.present(showAlert, animated: true, completion: nil)
                
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let fetchedMovies = dataDictionary["results"] as! [[String: Any]]
                // MARK:WILL Do success here -- Movies WILL be set and table view WILL be reloaded.
                success(fetchedMovies)
            }
        }
        task.resume()
    }
    
}

