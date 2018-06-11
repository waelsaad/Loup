//
//
//  GymFinder
//
//  Created by Wael Saad on 11/6/18.
//  Copyright © 2018 NetTrinity. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation

enum Result<T>{
    case response(T)
    case error(error: Error)
}

protocol NotificationName {
    var name: Notification.Name { get }
}

extension RawRepresentable where RawValue == String, Self: NotificationName {
    var name: Notification.Name {
        get {
            return Notification.Name(self.rawValue)
        }
    }
}

enum Notifications: String, NotificationName {
    case ResponseReceived
}

typealias JSONDictionary = [String:Any]

class Webservice {
    
    func getGymsByCoordinates(url :URL, latitude: CLLocationDegrees, longitude: CLLocationDegrees, completionHandler :@escaping ([Gym]) -> ()) {

        var gyms = [Gym]()

        var request = URLRequest(url: url)

        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let coordinates = "{\n  \"latitude\":" + latitude.description + ",\n  \"longitude\":" + longitude.description + "\n}"
        
        print(latitude.description)
        print(longitude.description)
        
        request.httpBody = coordinates.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, response, error in

        if let response = response, let data = data {

            print(response)
            print(String(data: data, encoding: .utf8)!)

            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            let dictionary = json as! [[String:Any]]
            gyms = dictionary.flatMap { dictionary in return Gym(dictionary : dictionary) }
        } else {
            print(error!)
        }

        DispatchQueue.main.async {
            completionHandler(gyms)
        }

        }.resume()
    }
}
