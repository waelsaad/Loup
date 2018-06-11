//
//
//  GymFinder
//
//  Created by Wael Saad on 11/6/18.
//  Copyright © 2018 NetTrinity. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class GymDetailTableViewController : UIViewController  {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var gym: GymViewModel!
    var location: CLLocation?
    
    private var headerView: TableSectionHeader!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblName.text = gym.name
        lblAddress.text = gym.address

        displayHeader()
        
        displayLocationOnMap()
    }
    
    
    func getCoordinate( addressString : String,
                        completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
            
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
    
    func displayLocationOnMap() {

        getCoordinate(addressString: gym.address, completionHandler: { (placemarks, error) in
            if error == nil {
                
                //Setting Region
                let center = CLLocationCoordinate2D(latitude: placemarks.latitude, longitude: placemarks.longitude)
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

                self.mapView.setRegion(region, animated: true)
                
                //Adding Pin
                let pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(placemarks.latitude, placemarks.longitude)
                let objectAnnotation = MKPointAnnotation()
                objectAnnotation.coordinate = pinLocation
                objectAnnotation.title = "Gym Location"
                self.mapView.addAnnotation(objectAnnotation)
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.enableAllOrientation = false
    }
    
    private func displayHeader () {
        headerView = (Bundle.main.loadNibNamed("TableSectionHeader", owner: self, options: nil)![0] as? TableSectionHeader)!
        headerView.lblHeading1.text = "Gym"
        headerView.lblHeading2.text = "Details"
        headerView.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height + self.navigationController!.navigationBar.frame.height, width: (self.view.frame.width), height: (headerView.frame.height))
        self.view.addSubview(headerView)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        if(screenWidth > screenHeight){
            headerView.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height + self.navigationController!.navigationBar.frame.height + 33, width: (self.view.frame.width), height: (headerView.frame.height))
        }
        else{
            headerView.frame = CGRect(x: 0, y: self.navigationController!.navigationBar.frame.height - 11, width: (self.view.frame.height), height: (headerView.frame.height))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

