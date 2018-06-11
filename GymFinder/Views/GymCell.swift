//
//
//  GymFinder
//
//  Created by Wael Saad on 11/6/18.
//  Copyright © 2018 NetTrinity. All rights reserved.
//

import UIKit
import Foundation

class GymCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    public func configure(name: String?, address: String) {
        
        accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        lblName.text = name
        lblAddress.text = address

        lblName.sizeToFit()
        lblAddress.sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
