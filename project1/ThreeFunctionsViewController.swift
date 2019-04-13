//
//  ThreeFunctionsViewController.swift
//  project1
//
//  Created by Feilan Wang on 13/4/19.
//  Copyright © 2019 Rosalie Ma. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import CoreLocation

class ThreeFunctionsViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    let storage = Storage.storage()
    var ref: DatabaseReference?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.ref = Database.database().reference()

        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    @IBAction func CameraButton(_ sender: Any) {
        let vc = CameraViewController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        
        // print out the image size as a test
        print(image.size)
        
        let imageData: Data = image.pngData()!
        //let imageStr = imageData.base64EncodedString()
        
        //print("image: \(imageStr)")
        
        //Get user's current location
        //guard let locValue: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
        let locValue: CLLocationCoordinate2D = locationManager.location!.coordinate
        let latitude = "\(locValue.latitude)".replacingOccurrences(of: ".", with: "_")
        let longitude = "\(locValue.longitude)".replacingOccurrences(of: ".", with: "_")
        
        
        // Trying storage in data memory with Firebase Memory
        let storageRef = storage.reference()
        let data = imageData
        // Create a reference to the file you want to upload
        let randomString = self.randomString(length: 20)
        let riversRef = storageRef.child("images/\(randomString).jpg")
        
        // Create file metadata including the content type
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        

        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = riversRef.putData(data, metadata: metadata) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }

            // You can also access to download URL after upload.
            riversRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
                print("url： " + downloadURL.absoluteString)
                //Save in firebase key-value
                self.ref?.child("Location").child(latitude + longitude).childByAutoId().setValue(downloadURL.absoluteString)
                
                let user_name = UserDefaults.standard.object(forKey: "Username") as! String
                self.ref?.child("UserImageList").child(user_name).childByAutoId().setValue(downloadURL.absoluteString)
                
                self.performSegue(withIdentifier: "ManualToAfterCamera",
                                  sender: self)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func randomString(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
