//
//  ViewController.swift
//  SiliconValetBetter
//
//  Created by Computer Science on 03/11/2018.
//  Copyright © 2018 TheReunion. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ViewController: UIViewController {

    var ref: DatabaseReference!
    var open: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        ref!.observe(DataEventType.value, with: { (snapshot) in
            let x = snapshot.value as! [String:[String]]
            self.open =  x["values"]
            print("UPDATED")
            print(self.open)
        })

        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
//    var latLongDOTS = [(latitude:38.986352, longitude:-76.934686), (latitude:38.986370,longitude:-76.934658),(latitude:38.986393,longitude:-76.934642),(latitude:38.986407,longitude:-76.934627),(latitude:38.986429,longitude:-76.934608),(latitude:38.986321,longitude:-76.934601),(latitude:38.986340,longitude:-76.934583),(latitude:38.986368,longitude:-76.934582),(latitude:38.986393,longitude:-76.934565),(latitude:38.986409,longitude:-76.934550),(latitude:38.986274,longitude:-76.934482),(latitude:38.986298,longitude:-76.934474),(latitude:38.986319,longitude:-76.934455),(latitude:38.986337,longitude:-76.934436),(latitude:38.986368,longitude:-76.934437),(latitude:38.986384,longitude:-76.934407),(latitude:38.986408,longitude:-76.934398),(latitude:38.986434,longitude:-76.934390),(latitude:38.986460,longitude:-76.934376),(latitude:38.986472,longitude:-76.934359),(latitude:38.986253,longitude:-76.934426),(38.986273,longitude:-76.934412),(latitude:38.986295,-76.934395),(latitude:38.986320,-76.934383),(latitude:38.986343,76.934366),(latitude:38.986366,-76.934361),(latitude:38.986386,-76.934342),(latitude:38.986401,-76.934328),(latitude:38.986433,-76.934312),(latitude:38.986452,-76.934297),(latitude:38.986203,-76.934311),(latitude:38.986223,-76.934288),(latitude:38.986251,-76.934277),(latitude:38.986265,-76.934260),(latitude:38.986292,-76.934243)]
    
    
  var latitude = 0.000
  var  longitude = 0.000
    
    // find closest parking
    
    
//    var inputArray = [String]()
    
    @IBAction func didTapButton(_ sender: Any) {
//        for i in 0..<40 {
//            if (inputArray[i] == "empty"){
//                
//                break;
////            }
//        };

        ProxyManager.sharedManager.SendLocationBetter(longitude:longitude, latitude: latitude)
        print("Information Received")
    }
    
}

