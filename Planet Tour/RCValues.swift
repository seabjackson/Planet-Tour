//
//  RCValues.swift
//  Planet Tour
//
//  Created by Seab Jackson on 3/14/18.
//  Copyright © 2018 Razeware. All rights reserved.
//

import Foundation
import Firebase

class RCValues {
  
  static let sharedInstance = RCValues()
  
  enum ValueKey: String {
    case appPrimaryColor
  }
  
  private init() {
    loadDefaultValues()
    fetchCloudValues()
  }
  
  func loadDefaultValues() {
    let appDefaults: [String: NSObject] = [ValueKey.appPrimaryColor.rawValue: "#FBB03B" as NSObject]
    RemoteConfig.remoteConfig().setDefaults(appDefaults)
  }
  
  func fetchCloudValues() {
    let fetchDuration: TimeInterval = 0
    activateDebugMode()
    RemoteConfig.remoteConfig().fetch(withExpirationDuration: fetchDuration) {
      [weak self] (status, error) in
      
      guard error == nil else {
        print("Got an error feching more remote values")
        return
      }
      
      RemoteConfig.remoteConfig().activateFetched()
      print("Retrieved values from the cloud")
      
      print("Our app's primary color is \(RemoteConfig.remoteConfig().configValue(forKey: "appPrimaryColor").stringValue)")
    }
  }
  
  func activateDebugMode() {
    let debugSettings = RemoteConfigSettings(developerModeEnabled: true)
    RemoteConfig.remoteConfig().configSettings = debugSettings!
  }
}

