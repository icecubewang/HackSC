//
//  Gallery.swift
//  project1
//
//  Created by Rosalie Ma on 4/13/19.
//  Copyright © 2019 Rosalie Ma. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class Gallery: UICollectionViewController {
        
    
    let reuseIdentifier = "ImgCell"
    let sectionInsets = UIEdgeInsets(top: 50.0,
                                     left: 20.0,
                                     bottom: 50.0,
                                     right: 20.0)
    var userImgs:[String] = ["https://upload.wikimedia.org/wikipedia/commons/thumb/c/ce/Torres_del_Paine_y_cuernos_del_Paine%2C_montaje.jpg/284px-Torres_del_Paine_y_cuernos_del_Paine%2C_montaje.jpg"]

    //var userImgs:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
                
    }
    
    func getURL() -> () {
        //get a list of URLs(strings) from server
        //self.userImgs =
        
    }
    
    func downloadImage(str: String) -> UIImage {
        let url = URL(string: str)
        print("Download Started")
        let data = try? Data(contentsOf: url!)
        print("Download Finished")
        let img = UIImage(data: data!)
        return img!
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //for test:
        //return 5
        return userImgs.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        
        let urlStr = self.userImgs[indexPath.row]
        print(urlStr)
        cell.backgroundColor = .white
        
        cell.Img.image = downloadImage(str: urlStr)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "Detail"){
            let cell = sender as! CollectionViewCell
            var destination = segue.destination as! PickVC3
            destination.newImg = cell.Img.image!
            
        }
    }

    
}
