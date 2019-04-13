//
//  PickVC2.swift
//  project1
//
//  Created by Rosalie Ma on 4/12/19.
//  Copyright © 2019 Rosalie Ma. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import FirebaseDatabase

class PickVC2: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var PickPic: UIImageView!
    let locationManager = CLLocationManager()
    var locValue = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    var ref: DatabaseReference?
    var databaseHandle: DatabaseHandle?
    //override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        //super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//        self.locValue.latitude = Double("")!
//        self.locValue.longitude = Double("")!
    //}
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
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
        load_img(position: locValue)
        
    }
    
    func load_img(position: CLLocationCoordinate2D) {
        //TODO: query server using location and decode the image
        let lat = "\(locValue.latitude)".replacingOccurrences(of: ".", with: "_")
        let long = "\(locValue.longitude)".replacingOccurrences(of: ".", with: "_")
        let str_loc = lat + long
        var  clost_loc = "nil"
        //TODO: If no image to pick
        // Look through the locations on Firebase to find the closest
        ref?.child("Location").observeSingleEvent(of: .value, with: { (locsnapshot) in
            // Get user value
            //print(locsnapshot)
            let locdict = locsnapshot.value as! NSDictionary
            //print(locdict as Any)
            //print("keys")

            let  lockeys=locdict.allKeys
            var  distance = CLLocationDistance(-1)
            
            for location in lockeys{
                //print(location)
                
                var locconv = location as! String
                var fullsplit = locconv.characters.split{$0 == "-"}.map(String.init)
                let lat_tt = Double(fullsplit[0].replacingOccurrences(of: "_", with: "."))
                let long_tt = Double(fullsplit[1].replacingOccurrences(of: "_", with: "."))
                //print(lat_tt as Any)
                //print(long_tt as Any)
                
                

                let coordinate₀ = CLLocation(latitude: self.locValue.latitude, longitude: self.locValue.longitude)
                let coordinate₁ = CLLocation(latitude: lat_tt!, longitude: long_tt!)
                
                let distanceInMeters = coordinate₀.distance(from: coordinate₁)
                //print("distanceInMeters")
                //print(distanceInMeters)// result is in meters
                //print("distance")
               // print(distance)
                if distance == -1{
                    distance=distanceInMeters
                    clost_loc=location as! String
                    //print ("clost_loc initial")
                    //print (clost_loc)
                }
                else if Double(distanceInMeters)<distance {
                    distance=distanceInMeters
                    clost_loc=location as! String
                    //print ("clost_loc FInal")
                    //print (clost_loc)
                }
//                newm=
//                if 0 < distance {
//                    distance = new_min
//                    clost_loc = location}
            }
            //print(locdict.allKeys)
            // Random image url generated from Firebase given a longitude, latitude.
            // ...
        
            self.ref?.child("Location").child(clost_loc).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let imagedict = snapshot.value as? NSDictionary
                
                //print("val pic 1")
                //print(imagedict!["Picture1"]!)
                let index  = Int.random(in: 0 ..< imagedict!.allKeys.count)
                let randout = Array(imagedict!)[index].value
                print(randout)
                
                // Random image url generated from Firebase given a longitude, latitude.
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }

        
        
        }) { (error) in
            print(error.localizedDescription)
        }

        //print ("clost_loc")
        //print (clost_loc)
        // Given a location clost_loc, find a random image on Firebase.

        //return data()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locValue = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        manager.stopUpdatingLocation()
    }

    
    
    // Actions
    @IBAction func Confirm(_ sender: UIButton) {
    }
//
//    //send image to next view controller
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "sendPickImg" {
//            let confirmImg = segue.destination as! PickVC3
//            confirmImg.newImg = self.PickPic.image!
//        }
//    }
    
}

