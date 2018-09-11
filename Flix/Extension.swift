//
//  AlertController.swift
//  Flix
//
//  Created by Hein Soe on 9/9/18.
//  Copyright © 2018 Hein Soe. All rights reserved.
//

import UIKit
import AFNetworking

extension UIViewController {
    
    func networkAlert(fetch: @escaping ()->()) {
        let showAlert = UIAlertController(title: "Cannot Get Movies", message: "Internet appears to be offline", preferredStyle: .alert)
        let tryAgainAction = UIAlertAction (title: "Try Again!!", style: .default) { (action) in
            fetch()
        }
        
        showAlert.addAction(tryAgainAction)
        self.present(showAlert, animated: true, completion: nil)
    }
}

