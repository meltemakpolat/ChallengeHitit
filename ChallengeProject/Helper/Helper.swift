//
//  Helper.swift
//  Loodos
//
//  Created by Meltem Akpolat on 26.08.2019.
//  Copyright © 2019 Meltem Akpolat. All rights reserved.
//

import UIKit
import SwiftMessages
import Firebase

class Helper: NSObject {

    private static let messageDuration : TimeInterval = 3
    
    class func showErrorMessage(title: String , body: String) -> Void {
        
        var config = SwiftMessages.Config()
        config.duration = .seconds(seconds: messageDuration)
        config.presentationContext = .window(windowLevel:UIWindow.Level(rawValue: 0))
        
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(.error)
        view.configureDropShadow()
        view.configureContent(title: title, body: body)
        view.button?.isHidden = true
        view.backgroundView.backgroundColor = UIColor.primaryColor
        
        SwiftMessages.show(config: config, view: view)
    }
    
    class func showWarningMessage(title: String , body: String) -> Void {
        
        var config = SwiftMessages.Config()
        config.duration = .seconds(seconds: messageDuration)
        config.presentationContext = .window(windowLevel:UIWindow.Level(rawValue: 0))
        
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(.warning)
        view.configureDropShadow()
        view.configureContent(title: title, body: body)
        view.button?.isHidden = true
        view.backgroundView.backgroundColor = UIColor.customColorOrange
        
        SwiftMessages.show(config: config, view: view)
    }
    
    class func showSuccessMessage(title: String , body: String) -> Void {
        
        var config = SwiftMessages.Config()
        config.duration = .seconds(seconds: messageDuration)
        config.presentationContext = .window(windowLevel:UIWindow.Level(rawValue: 0))
        
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(.success)
        view.configureDropShadow()
        view.configureContent(title: title, body: body)
        view.button?.isHidden = true
        view.backgroundView.backgroundColor = UIColor.customColorGreen
        
        SwiftMessages.show(config: config, view: view)
    }
    
    class func regulateFilmDetailText(filmDetailResponse: NetworkModels.FilmDetail) -> NSMutableAttributedString {
        
        let attrFilmDetailText = NSMutableAttributedString(string: "")
        
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor : UIColor.white,
            .foregroundColor : UIColor.primaryColor,
            .strokeWidth : -2.0,
            .font : UIFont.boldSystemFont(ofSize: 20)
        ]
        
        let textAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor : UIColor.textColorOnSecondary,
            .font : UIFont.boldSystemFont(ofSize: 16)
        ]
        
        //Set Titles
        let arrayTitles = ["Title:  ", "Year:  ", "Rated:  ", "Released:  ", "Runtime:  ", "Genre:  ", "Director:  ", "Writer:  ", "Actors:  ", "Plot:   ", "Language:  ", "Country:  ", "Awards:  ", "IMDB Ratings:  ", "IMDB Votes:  "]
        
        //Set Values
        let arrayValues = ["\(filmDetailResponse.title ?? "")\n\n", "\(filmDetailResponse.year ?? "")\n\n", "\(filmDetailResponse.rated ?? "")\n\n", "\(filmDetailResponse.released ?? "")\n\n", "\(filmDetailResponse.runtime ?? "")\n\n", "\(filmDetailResponse.genre ?? "")\n\n", "\(filmDetailResponse.director ?? "")\n\n", "\(filmDetailResponse.writer ?? "")\n\n", "\(filmDetailResponse.actors ?? "")\n\n", "\(filmDetailResponse.plot ?? "")\n\n", "\(filmDetailResponse.language ?? "")\n\n", "\(filmDetailResponse.country ?? "")\n\n", "\(filmDetailResponse.awards ?? "")\n\n", "\(filmDetailResponse.imdbRating ?? "")\n\n", "\(filmDetailResponse.imdbVotes ?? "")\n\n"]
        
        
        // Firebase Log Event
        var parametersForFirebase : [String:Any] = [:]
        
        for i in 0 ..< arrayValues.count {
            
            let title = arrayTitles[i]
            let value = arrayValues[i]
            
            let filmNameTitle = NSAttributedString(string: title, attributes: titleAttributes )
            let filmName = NSAttributedString(string: value, attributes: textAttributes)
            attrFilmDetailText.append(filmNameTitle)
            attrFilmDetailText.append(filmName)
            
            // Firebase Log Event
            let onlyTitle = title.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ":", with: "")
            let onlyValue = value.replacingOccurrences(of: "\n", with: "")
            parametersForFirebase[onlyTitle] = onlyValue
        }
        
        Helper.sendFirebaseEvent(name: Constants.FirebaseEventName.filmDetails, parameters: parametersForFirebase)
        
        return attrFilmDetailText
    }
    
    class func sendFirebaseEvent(name: String, parameters: [String:Any]?) {
        Analytics.logEvent(name, parameters: parameters)
    }
}

// MARK: *** Close Keyboard
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: *** UIColor with HexColor Extension
extension UIColor {
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

// MARK: *** Customize Application Font

extension UIFont {
    
    static let fontName = "OpenSans" //Font files under the Resources
    
    enum FontStyle : String {
        
        case Bold = "Bold"
        case BoldItalic = "BoldItalic"
        case ExtraBold = "ExtraBold"
        case ExtraBoldItalic = "ExtraBoldItalic"
        case Italic = "Italic"
        case Light = "Light"
        case LightItalic = "LightItalic"
        case Regular = "Regular"
        case Semibold = "SemiBold"
        case SemiboldItalic = "SemiboldItalic"
    }
    
    class func customFont(size : Int , customStyle : FontStyle) -> UIFont! {
        return UIFont(name: "\(fontName)-\(customStyle.rawValue)", size: CGFloat(size))
    }
    
}

// MARK: *** Application Colors

extension UIColor {
    
    //Main Colors
    class var primaryColor: UIColor {
        return UIColor.init(hexString: "#6E0A16")
    }
    
    class var secondaryColor: UIColor {
        return UIColor.init(hexString: "#12111E")
    }
    
    // Text Colors
    class var textColorOnPrimary: UIColor {
        return UIColor.init(hexString: "#FFFFFF")
    }
    
    class var textColorOnSecondary: UIColor {
        return UIColor.init(hexString: "#111111")
    }
    
    //Custom Colors
    class var customColorGreen: UIColor {
        return UIColor.init(hexString: "#048C3D")
    }
    
    class var customColorRed: UIColor {
        return UIColor.init(hexString: "#C0284E")
    }
    
    class var customColorOrange: UIColor {
        return UIColor.init(hexString: "#F7680F")
    }
    
}
