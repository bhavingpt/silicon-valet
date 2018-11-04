//
//  ProxyManager.swift
//  SiliconValetBetter
//
//  Created by Computer Science on 03/11/2018.
//  Copyright © 2018 TheReunion. All rights reserved.
//

import SmartDeviceLink
import Foundation

class ProxyManager: NSObject {
    private let appName = "Silicon Valet"
    private let appId = "1234"
    
    // Manager
    fileprivate var sdlManager: SDLManager!
    
    // Singleton
    static let sharedManager = ProxyManager()
    
    private override init() {
        super.init()
        
        // Used for USB Connection
        //let lifecycleConfiguration = SDLLifecycleConfiguration(appName: appName, fullAppId: appId)
        
        // Used for TCP/IP Connection
         let lifecycleConfiguration = SDLLifecycleConfiguration(appName: appName, fullAppId: appId, ipAddress: "10.105.129.14", port: 12345)
        
       /*let display = SDLSetDisplayLayout(predefinedLayout: .textAndSoftButtonsWithGraphic)
         sdlManager.send(request: display) { (request, response, error) in
            if response?.resultCode == .success {
                // The template has been set successfully
            }
        }*/
        // App icon image
        if let appImage = UIImage(named: "siliconValley") {
            let appIcon = SDLArtwork(image: appImage, persistent: true, as: .PNG)
            lifecycleConfiguration.appIcon = appIcon
        }
        
        lifecycleConfiguration.shortAppName = "SiliconValet"
        lifecycleConfiguration.appType = .default
        
        let configuration = SDLConfiguration(lifecycle: lifecycleConfiguration, lockScreen: .disabled(), logging: .default(), fileManager: .default())
        
        sdlManager = SDLManager(configuration: configuration, delegate: self)
    }
    
    func connect() {
        // Start watching for a connection with a SDL Core
        sdlManager.start { (success, error) in
            if success {
                // Your app has successfully connected with the SDL Core
            }
        }
    }
    
    func setTemplate() {
        let display = SDLSetDisplayLayout(predefinedLayout: .textAndSoftButtonsWithGraphic)
        sdlManager.send(request: display) { (request, response, error) in
            if response?.resultCode == .success {
                // The template has been set successfully
            }
        }
    }
    
   func SendLocationBetter(longitude: Float64, latitude: Float64) {
        
    
        
        sdlManager.start { (success, error) in
            if !success {
                print("SDL errored starting up: \(error.debugDescription)")
                return
            }
            
            if let hmiCapabilities = self.sdlManager.systemCapabilityManager.hmiCapabilities, let navigationSupported = hmiCapabilities.navigation?.boolValue {
                var isNavigationSupported = false
                isNavigationSupported = navigationSupported
            }
        }
        
        
        let sendLocation = SDLSendLocation(longitude : longitude, latitude: latitude, locationName: "Free Space", locationDescription: "Center of the United States", address: ["900 Whiting Dr", "Yankton, SD 57078"], phoneNumber: nil, image: nil)
        
        sdlManager.send(request: sendLocation) { (request, response, error) in
            guard let response = response as? SDLSendLocationResponse else { return }
            
            if let error = error {
                print("Encountered Error sending SendLocation: \(error)")
                return
            }
            
            if response.resultCode != .success {
                if response.resultCode == .invalidData {
                    print("SendLocation was rejected. The request contained invalid data.")
                } else if response.resultCode == .disallowed {
                    print("Your app is not allowed to use SendLocation")
                } else {
                    print("Some unknown error has occured!")
                }
                return
            }
            
            // Successfully sent!
        }
        
    }
}

//MARK: SDLManagerDelegate
extension ProxyManager: SDLManagerDelegate {
    func managerDidDisconnect() {
        print("Manager disconnected!")
    }
    
    func hmiLevel(_ oldLevel: SDLHMILevel, didChangeToLevel newLevel: SDLHMILevel) {
        print("Went from HMI level \(oldLevel) to HMI level \(newLevel)")
    }
}
