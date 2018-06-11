//
//  ViewExtensions.swift
//  GymFinder
//
//  Created by Wael Saad on 11/6/18.
//  Copyright © 2018 NetTrinity. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    // Generic Alert function
    func displayAlert(_ title: String, message: String, okBlock :(() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (alertAction) in
            guard let okBlck = okBlock else
            {
                return
            }
            okBlck()
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
