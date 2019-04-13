//
//  GalleryViewController.swift
//  project1
//
//  Created by Rosalie Ma on 4/13/19.
//  Copyright © 2019 Rosalie Ma. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController,  UICollectionViewDelegate {

    
    @IBOutlet weak var gallery: UICollectionView!
    
    let reuseIdentifier = "ImgCell"
    var userImgs:[String] = ["https://upload.wikimedia.org/wikipedia/commons/thumb/c/ce/Torres_del_Paine_y_cuernos_del_Paine%2C_montaje.jpg/284px-Torres_del_Paine_y_cuernos_del_Paine%2C_montaje.jpg"]
    //var userImgs:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        gallery.dataSource = self
        gallery.delegate = self
        //self.collectionView.reloaSections(IndexSet=0)
        
        

        // Do any additional setup after loading the view.
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
        print(self.userImgs.count)
        return self.userImgs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell

        let urlStr = self.userImgs[indexPath.row]
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
