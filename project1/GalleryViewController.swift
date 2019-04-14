//
//  GalleryViewController.swift
//  project1
//
//  Created by Rosalie Ma on 4/13/19.
//  Copyright © 2019 Rosalie Ma. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class GalleryViewController: UIViewController,  UICollectionViewDelegate {

    
    @IBOutlet weak var gallery: UICollectionView!
    
    var ref: DatabaseReference?
    var databaseHandle: DatabaseHandle?
    
    let reuseIdentifier = "ImgCell"
    var userImgs:[String] = []
    //var userImgs:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        gallery.dataSource = self
        gallery.delegate = self
        ref = Database.database().reference()
        //self.collectionView.reloaSections(IndexSet=0)
        
        self.getURL()
        

        // Do any additional setup after loading the view.
    }
    
    func getURL() {
        //get a list of URLs(strings) from server
        //self.userImgs =
        var urlList: [String] = [String]()
        let username = UserDefaults.standard.object(forKey: "Username") as! String
        databaseHandle = ref?.child("UserImageList").child(username).observe(.childAdded, with: { (snapshot) in
            let newurl = snapshot.value as? String
            if let aimage = newurl{
                self.userImgs.append(aimage)
                self.gallery.reloadData()
            }
            print ("usrImgs")
            print (self.userImgs)
        })
        
        //self.collectionView.reloadData()

        
        
    }
    
    func downloadImage(str: String) -> UIImage {
        let url = URL(string: str)
        print("Download Started")
        let data = try? Data(contentsOf: url!)
        print("Download Finished")
        let img = UIImage(data: data!)
        return img!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "Detail"){
            let cell = sender as! CollectionViewCell
            var destination = segue.destination as! PickVC3
            destination.newImg = cell.Img.image!
            
        }
    }

}

extension GalleryViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //for test:
        //return 5
        print("How many images?")
        print(self.userImgs.count)
        return self.userImgs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell

        let urlStr = self.userImgs[indexPath.row]
        print("urlstr")
        print(urlStr)
        cell.backgroundColor = .white

        cell.Img.image = downloadImage(str: urlStr)

        return cell
    }

}

//extension ViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print(indexPath.item + 1)
//    }
//}
