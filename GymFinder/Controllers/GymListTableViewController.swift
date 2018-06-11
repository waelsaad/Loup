//
//
//  GymFinder
//
//  Created by Wael Saad on 11/6/18.
//  Copyright © 2018 NetTrinity. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class GymListTableViewController : UITableViewController  {
    
    var currentLocation: CLLocation!
    var cllocationManager = CLLocationManager()
    
    private var viewModel :GymListViewModel = GymListViewModel()  {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var didSelect: (GymViewModel) -> () = { _ in }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.viewModel.title

        self.cllocationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            cllocationManager.delegate = self
            cllocationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.displayHeader), name: Notifications.ResponseReceived.name, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.enableAllOrientation = true
    }
    
    @objc private func displayHeader () {
        let headerView = (Bundle.main.loadNibNamed("TableSectionHeader", owner: self, options: nil)![0] as? TableSectionHeader)
        tableView.tableHeaderView = headerView
        headerView?.lblHeading1.text = "Welcome"
        headerView?.lblHeading2.text = "Wael"
    }
    
    private func fetchGymsNearBy(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let url = URL(string: APPURL.base_url)!
        Webservice().getGymsByCoordinates(url: url, latitude: latitude, longitude: longitude) { gymList in
            print(gymList)
            let gymsNearBy = gymList.map { gym in
                return GymViewModel(gym :gym)
            }
            self.viewModel = GymListViewModel(gymsNearBy :gymsNearBy)
            NotificationCenter.default.post(name: Notifications.ResponseReceived.name, object: self)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gymViewModel = self.viewModel.gymsNearBy[indexPath.row]
        didSelect(gymViewModel)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GymDetailTableViewController") as! GymDetailTableViewController
        vc.gym = gymViewModel
        vc.location = currentLocation
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.gymsNearBy.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! GymCell
        let gymViewModel = self.viewModel.gymsNearBy[indexPath.row]
        cell.configure(name: gymViewModel.name, address: gymViewModel.address)
        cell.backgroundColor = (indexPath.row % 2 == 0) ? UIColor.lightGray : UIColor.white
        return cell
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.enableAllOrientation = false
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension GymListTableViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            currentLocation = cllocationManager.location
            //print(currentLocation.coordinate.latitude)
            //print(currentLocation.coordinate.longitude)
            fetchGymsNearBy(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        }
    }
}
