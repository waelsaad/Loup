//
//
//  GymFinder
//
//  Created by Wael Saad on 11/6/18.
//  Copyright © 2018 NetTrinity. All rights reserved.
//

import Foundation


class Gym {
    var name: String
    var address: String
    
    init(name :String, address: String) {
        self.name = name
        self.address = address
    }

    init?(dictionary :JSONDictionary) {

        guard
            let name = dictionary["name"] as? String,
            let address = dictionary["address"] as? String
        else {
                return nil
        }

        self.name = name
        self.address = address
    }
}
