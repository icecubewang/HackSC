//
//  PickVC2.swift
//  project1
//
//  Created by Rosalie Ma on 4/12/19.
//  Copyright © 2019 Rosalie Ma. All rights reserved.
//

import Foundation

import UIKit
import CoreLocation
import Firebase
import FirebaseDatabase

class PickVC2: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var PickPic: UIImageView!
    let locationManager = CLLocationManager()
    var locValue = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    var ref: DatabaseReference?
    
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//        self.locValue.latitude = Double("")!
//        self.locValue.longitude = Double("")!
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.ref = Database.database().reference()
        self.PickPic.image = #imageLiteral(resourceName: "loading")
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        //set picked image
//        let pick_image:UIImage = load_img(position: locValue)
//        self.PickPic.image = pick_image
        
        //Only for test:
        self.PickPic.image = #imageLiteral(resourceName: "test")
        
    }
    
//    func load_img(position: CLLocationCoordinate2D) -> UIImage {
//        //TODO: query server using location and decode the image
//        //self.locValue.latitude, self.locValue.longitude
//
//        //TODO: If no image to pick
//        return
//    }
//
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locValue = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        manager.stopUpdatingLocation()
    }
    
    
    // Actions
    @IBAction func Confirm(_ sender: UIButton) {
    }
    
    //send image to next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sendPickImg" {
            let confirmImg = segue.destination as! PickVC3
            confirmImg.newImg = self.PickPic.image!
        }
    }
    
}

