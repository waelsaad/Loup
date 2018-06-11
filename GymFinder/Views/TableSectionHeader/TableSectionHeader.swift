//
//
//  GymFinder
//
//  Created by Wael Saad on 11/6/18.
//  Copyright © 2018 NetTrinity. All rights reserved.
//

import UIKit
import Foundation

class TableSectionHeader: UITableViewHeaderFooterView {
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblHeading1: UILabel!
    @IBOutlet weak var lblHeading2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgLogo.translatesAutoresizingMaskIntoConstraints     = false
        
        // Autolayout using VFL and Constraints
        let viewsDict = ["imgLogo" : imgLogo] as [String : UIView]
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[imgLogo(43)]", metrics: nil, views: viewsDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[imgLogo(114)]", metrics: nil, views: viewsDict))
        self.addConstraint(NSLayoutConstraint(item: imgLogo, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -10))
    }
}

