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
    
    // find closest parking
    
    
    @IBAction func didTapButton(_ sender: Any) {
        
        let latitude = [38.986352,38.986370, 38.986393,38.986407,38.986429,38.986321,38.986340,38.986368,38.986393, 38.986409,38.986274, 38.986298, 38.986319, 38.986337,38.986368, 38.986384, 38.986408, 38.986434,38.986460,38.986472,38.986253,38.986273,38.986295, 38.986320,38.986343,38.986366,38.986386,38.986401,38.986433,38.986452, 38.986203,38.986223,38.986251,38.986265,38.986292,38.986317, 38.986337,38.986359,38.986393,38.986400]

        let longitude = [-76.934686,-76.934658, -76.934636,-76.934611,-76.934601,-76.934601, -76.934583,-76.934582,-76.934565,-76.934550,-76.934482,-76.934474,-76.934455,-76.934436,-76.934437,-76.934407,-76.934398,-76.934390,-76.934376,-76.934359,-76.934426, -76.934412,-76.934395,-76.934383,-76.934366, -76.934361,-76.934342,-76.934328, -76.934312, -76.934297, -76.934311, -76.934288,  -76.934277, -76.934260, -76.934243, -76.934244,  -76.934229, -76.934209, -76.934207,  -76.934170]

        var parkingSpace : String
        var parkingStr : [String]
        parkingStr = []


        for i in 1...40 {
            parkingSpace = "Parking Space " + String(i) + " is free "
            parkingStr.append(parkingSpace)
        }


        let initCarLat = 38.987037  // Car starts in channel 1 road
        let initCarLong = -76.934053

        var minDist = 1000.000
        var lat = 0.000;
        var long = 0.00;
        var name =  "Name"
        var dist = 0.000;

        for i in 0..<40 {
            dist = abs(initCarLat - latitude[i]) + abs(initCarLong  - longitude[i]);
            if (dist < minDist && open?[i] == "empty"){
                minDist = dist
                long = longitude[i]
                lat = latitude[i]
                name = parkingStr[i]
            }
        };


        print(long)
        print(lat)
        print(name)

        if (!(lat == 0 || long == 0)){
            ProxyManager.sharedManager.SendLocationBetter(longitude: long, latitude: lat, locationName: name )
            print("Information Received")
        }
    }
}

