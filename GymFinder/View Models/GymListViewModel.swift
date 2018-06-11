//
//
//  GymFinder
//
//  Created by Wael Saad on 11/6/18.
//  Copyright © 2018 NetTrinity. All rights reserved.
//

import Foundation
import CoreLocation

struct GymListViewModel {
    var title :String? = "Gyms Near By"
    var gymsNearBy :[GymViewModel] = [GymViewModel]()
}

extension GymListViewModel {
    
    init(gymsNearBy :[GymViewModel]) {
        self.gymsNearBy = gymsNearBy
    }
}

struct GymViewModel {
    
    var name :String
    var address :String
}

extension GymViewModel {

    init(gym :Gym) {
        self.name = gym.name
        self.address = gym.address
    }
}
