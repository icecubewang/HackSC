//
//  PickVC3.swift
//  project1
//
//  Created by Rosalie Ma on 4/12/19.
//  Copyright © 2019 Rosalie Ma. All rights reserved.
//

import Foundation
import UIKit

class PickVC3: UIViewController {
    
    @IBOutlet weak var ImgView: UIImageView!
    var newImg:UIImage = #imageLiteral(resourceName: "loading")
    
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ImgView.image = newImg
        
    }
    
    @IBAction func ShareFB(_ sender: UIButton) {
    }
    
    @IBAction func ShareButton(_ sender: UIButton) {
    }
    
    
}
