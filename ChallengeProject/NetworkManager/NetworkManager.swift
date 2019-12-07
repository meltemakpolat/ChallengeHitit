//
//  NetworkManager.swift
//  Loodos
//
//  Created by Meltem Akpolat on 26.08.2019.
//  Copyright © 2019 Meltem Akpolat. All rights reserved.
//

import UIKit

class NetworkManager: NSObject {

    // MARK: *** Helpers
    
    class func getHeader() -> [String : String] {
        
        let header : [String:String] = ["Content-Type": "application/json"]
        return header
    }
    
    class func printAndShowError(url: String, error: Error, statusCode: Int) {
        print("***ERROR***\nurl = \(url)\nstatusCode = \(statusCode)\nlocalized = \(error.localizedDescription)\nerror = \(error)\n")
        Helper.showErrorMessage(title: "Error", body: "An error occured.\ncode: \(statusCode)\nerror: \(error.localizedDescription)")
    }
    
    // MARK: *** Endpoints
    
    class func getFilms(pageNumber: Int, searchText: String,success:@escaping (_ response: NetworkModels.Films) -> Void, failure:@escaping (_ error:Error , _ statusCode:Int) -> Void) -> Void {
        
        let parameters : [String:Any] = ["type":"movie",
                                         "s":searchText,
                                         "page":"\(pageNumber)"]
        
        let url = Constants.URL.getFilmsOrDetail
        
        BaseNetworkManager.get(url: url, parameters: parameters, headers: self.getHeader(), success: { (data) in
            
            var theResponse : NetworkModels.Films
            
            do {
                let decoder = JSONDecoder()
                theResponse = try decoder.decode(NetworkModels.Films.self, from: data!)
                success(theResponse)
                
            } catch let error {
                print(error)
                failure(error, -1)
            }
            
        }) { (Error, statusCode) in
            failure(Error, statusCode)
            printAndShowError(url: url, error: Error, statusCode: statusCode)
        }
    }
    
    class func getFilmDetail(imdbID: String, success:@escaping (_ response: NetworkModels.FilmDetail) -> Void, failure:@escaping (_ error:Error , _ statusCode:Int) -> Void) -> Void {
        
        let parameters : [String:Any] = ["i":imdbID]
        
        let url = Constants.URL.getFilmsOrDetail
        
        BaseNetworkManager.get(url: url, parameters: parameters, headers: self.getHeader(), success: { (data) in
            
            var theResponse : NetworkModels.FilmDetail
            
            do {
                let decoder = JSONDecoder()
                theResponse = try decoder.decode(NetworkModels.FilmDetail.self, from: data!)
                success(theResponse)
                
            } catch let error {
                print(error)
                failure(error, -1)
            }
            
        }) { (Error, statusCode) in
            failure(Error, statusCode)
            printAndShowError(url: url, error: Error, statusCode: statusCode)
        }
    }
    
}

