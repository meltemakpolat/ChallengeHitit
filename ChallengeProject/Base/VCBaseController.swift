//
//  VCBaseController.swift
//  Loodos
//
//  Created by Meltem Akpolat on 26.08.2019.
//  Copyright © 2019 Meltem Akpolat. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class VCBaseController: UIViewController {

    var indicator : NVActivityIndicatorView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        let padding = UIScreen.main.bounds.size.width / 2.3
        indicator = NVActivityIndicatorView(frame: self.view.frame, type: NVActivityIndicatorType.circleStrokeSpin, color: UIColor.primaryColor, padding:padding)
        
        self.view.backgroundColor = UIColor.secondaryColor
    }
    
    // MARK: *** Show or Hide Indicator
    
    func showIndicator() {
        
        if self.tabBarController != nil {
            self.tabBarController!.view.addSubview(indicator!)
            
        }else if self.navigationController != nil {
            self.navigationController!.view.addSubview(indicator!)
            
        }else {
            self.view.addSubview(indicator!)
        }
        
        indicator!.startAnimating()
    }
    
    func hideIndicator() {
        indicator!.stopAnimating()
        indicator!.removeFromSuperview()
    }
    
    
    // MARK: *** Setup Navigation Controller
    func setupNavigationBar(titleName: String) {
        
        if self.navigationController != nil {
            
            self.navigationController!.navigationBar.barTintColor = UIColor.primaryColor
            self.navigationController!.navigationBar.tintColor = UIColor.textColorOnPrimary
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            
            let titleLabel = UILabel()
            titleLabel.text = titleName
            titleLabel.font = UIFont.customFont(size: 20, customStyle: .Semibold)
            titleLabel.textColor = UIColor.textColorOnPrimary
            titleLabel.sizeToFit()
            self.navigationItem.titleView = titleLabel
            
        }
    }
    
}
