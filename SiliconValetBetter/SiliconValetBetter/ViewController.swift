//
//  ViewController.swift
//  SiliconValetBetter
//
//  Created by Computer Science on 03/11/2018.
//  Copyright © 2018 TheReunion. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    public let longitude  = -90.380967
    public let latitude   = 42.877737
    @IBAction func didTapButton(_ sender: Any) {
        ProxyManager.sharedManager.SendLocationBetter(longitude:longitude, latitude: latitude)
        print("Information Received")
    }
    
}

