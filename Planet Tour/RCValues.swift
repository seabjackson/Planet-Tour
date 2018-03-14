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
  
  var loadingDoneCallback: (() -> ())?
  var fetchComplete = false
  
  enum ValueKey: String {
    case bigLabelColor
    case appPrimaryColor
    case navBarBackground
    case navTintColor
    case detailTitleColor
    case detailInfoColor
    case subsribeBannerText
    case subscribeBannerButton
    case subscribeVCText
    case subscribeVCButton
    case shouldWeIncludePluto
    case experimentGroup
    case planetImageScaleFactor
  }
  
  private init() {
    loadDefaultValues()
    fetchCloudValues()
  }
  
  func loadDefaultValues() {
    let appDefaults: [String: NSObject] = [
      ValueKey.appPrimaryColor.rawValue: "#FBB03B" as NSObject,
      ValueKey.bigLabelColor.rawValue: "FFFFFF66" as NSObject,
      ValueKey.detailInfoColor.rawValue: "#CCCCCC" as NSObject,
      ValueKey.detailTitleColor.rawValue: "#FFFFFF" as NSObject,
      ValueKey.experimentGroup.rawValue: "default" as NSObject,
      ValueKey.navBarBackground.rawValue: "#535E66" as NSObject,
      ValueKey.navTintColor.rawValue: "#FBB03B" as NSObject,
      ValueKey.planetImageScaleFactor.rawValue: 0.33 as NSObject,
      ValueKey.shouldWeIncludePluto.rawValue: false as NSObject,
      ValueKey.subscribeBannerButton.rawValue: "Get our newsletter!" as NSObject,
      ValueKey.subsribeBannerText.rawValue: "Like Planet Tour??" as NSObject,
      ValueKey.subscribeVCButton.rawValue: "Subscribe" as NSObject,
      ValueKey.subscribeVCText.rawValue: "Want more astronomy facts? Sign up for our newsletter" as NSObject
      ]
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
      
      self?.fetchComplete = true
      self?.loadingDoneCallback?()
    }
  }
  func bool(forKey key: ValueKey) -> Bool {
    return RemoteConfig.remoteConfig()[key.rawValue].boolValue
  }
  
  func string(forKey key: ValueKey) -> String {
    return RemoteConfig.remoteConfig()[key.rawValue].stringValue ?? ""
  }
  
  func double(forKey key: ValueKey) -> Double {
    if let numberValue = RemoteConfig.remoteConfig()[key.rawValue].numberValue {
      return numberValue.doubleValue
    } else {
      return 0.0
    }
  }
  
  func color(forKey key: ValueKey) -> UIColor {
    let colorAsHexString = RemoteConfig.remoteConfig()[key.rawValue].stringValue ?? "#FFFFFFFF"
    let convertedColor = UIColor(rgba: colorAsHexString)
    return convertedColor
  }
  
  func activateDebugMode() {
    let debugSettings = RemoteConfigSettings(developerModeEnabled: true)
    RemoteConfig.remoteConfig().configSettings = debugSettings!
  }
}

