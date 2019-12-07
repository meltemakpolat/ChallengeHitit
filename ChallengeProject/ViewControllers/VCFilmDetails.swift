//
//  VCFilmDetails.swift
//  Loodos
//
//  Created by Meltem Akpolat on 26.08.2019.
//  Copyright © 2019 Meltem Akpolat. All rights reserved.
//

import UIKit
import Kingfisher

class VCFilmDetails: VCBaseController {

    @IBOutlet weak var imgFilmDetail: UIImageView!
    @IBOutlet weak var tvFilmDetails: UITextView!
    
    var navTitle = ""
    var imdbID = ""
    var posterUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewComponents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getFilmDetail()
    }
    
    func setupViewComponents() {
        
        self.setupNavigationBar(titleName: navTitle)
        
        imgFilmDetail.kf.setImage(with: URL(string: posterUrl), placeholder: UIImage(named: ""), options: nil, progressBlock: nil, completionHandler: nil)
    }
    
    //MARK: *** Custom Methods
    func getFilmDetail() {
        
        self.showIndicator()
        
        NetworkManager.getFilmDetail(imdbID: imdbID, success: { (filmDetailResponse) in
            self.hideIndicator()
            
            if let response = filmDetailResponse.response {
                
                if response == "True" {
                    
                    self.tvFilmDetails.attributedText = Helper.regulateFilmDetailText(filmDetailResponse: filmDetailResponse)
                    
                }else {
                    Helper.showWarningMessage(title: "Warning", body: "The movie detail not be found.")
                }
            }
            
        }) { (error, statusCode) in
            self.hideIndicator()
        }
    }
    
}
