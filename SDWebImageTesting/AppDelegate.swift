//
//  AppDelegate.swift
//  SDWebImageTesting
//
//  Created by Tyson Parks on 2020-11-02.
//

import SwiftUI
import SDWebImage

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      
      // SDWebImage Configuration
      // Add HEIC support
      SDImageCodersManager.shared.addCoder(SDImageHEICCoder.shared)
    
      // Supports HTTP URL as well as Photos URL globally
//      SDImageLoadersManager.shared.loaders = [SDWebImageDownloader.shared, SDImagePhotosLoader.shared]
      // Replace default manager's loader implementation
//      SDWebImageManager.defaultImageLoader = SDImageLoadersManager.shared
        return true
    }
}
