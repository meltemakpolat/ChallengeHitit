//
//  VCSplash.swift
//  Loodos
//
//  Created by Meltem Akpolat on 26.08.2019.
//  Copyright © 2019 Meltem Akpolat. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import SwiftMessages
import FirebaseRemoteConfig

class VCSplash: UIViewController {

    @IBOutlet weak var lblSplashText: UILabel!
    
    var filmListViewController : UIViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewComponents()
        checkInternetConnection()
    }
    
    func setupViewComponents() {
        
        lblSplashText.font = UIFont.customFont(size: 24, customStyle: .ExtraBold)
        lblSplashText.textColor = UIColor.primaryColor
    }
    
    //MARK: *** Check Internet Connection
    func checkInternetConnection() {
        
        if let reachabilityManager = NetworkReachabilityManager() {
            
            reachabilityManager.startListening()
            reachabilityManager.listener = { _ in
                
                if reachabilityManager.isReachable {
                    if self.filmListViewController == nil {
                        
                        self.setRemoteConfigDefault()
                        self.setRemoteConfigDefault()
                        self.fetchRemoteConfig()
                    }
                }else {
                    Helper.showWarningMessage(title: "Warning", body: "Please check your internet connection.")
                }
            }
        }
    }
    
    //MARK: *** Remote Config Methods
    func setRemoteConfigDefault() {
        let defaultText = ["labelText":"Default Text" as NSObject]
        RemoteConfig.remoteConfig().setDefaults(defaultText)
    }
    
    func fetchRemoteConfig() {
        
        let remoteConfigSettings = RemoteConfigSettings()
        remoteConfigSettings.minimumFetchInterval = 0
        
        let debugSettings = remoteConfigSettings
        RemoteConfig.remoteConfig().configSettings = debugSettings
        
        RemoteConfig.remoteConfig().fetch(withExpirationDuration: 0) { [unowned self] (status, error) in
            guard error == nil else {
                print("Got an error fetching remote values: \(String(describing: error))")
                return
            }
            
            print("Retrieved values from the cloud!")
            RemoteConfig.remoteConfig().activate()
            self.updateWithViewSplashValues()
        }
    }
    
    func updateWithViewSplashValues() {
        // Apply some remote config values here
        let labelText = RemoteConfig.remoteConfig().configValue(forKey: "labelText").stringValue ?? ""
        self.lblSplashText.text = labelText
        self.lblSplashText.sizeToFit()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            self.goToMainScreen()
        })
    }
    
    //MARK: *** Go To Main Screen
    func goToMainScreen() {
        
        filmListViewController = self.storyboard?.instantiateViewController(withIdentifier: "films") as! VCFilms
        let navController = UINavigationController(rootViewController: filmListViewController!)
        navController.modalTransitionStyle = .flipHorizontal
        navController.modalPresentationStyle = .fullScreen
        navController.navigationBar.isTranslucent = false
        self.present(navController, animated: true, completion: nil)
    }
}
