//
//  VCFilms.swift
//  Loodos
//
//  Created by Meltem Akpolat on 26.08.2019.
//  Copyright © 2019 Meltem Akpolat. All rights reserved.
//

import UIKit
import Kingfisher

class VCFilms: VCBaseController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableViewFilms: UITableView!
    
    var arrayFilmList : [NetworkModels.Films.Search] = []
    var pageNumber = 1
    var isGetFilms = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewComponents()
    }
    
    func setupViewComponents() {
        
        self.setupNavigationBar(titleName: "Films")
        
        searchBar.tintColor = UIColor.primaryColor
        searchBar.barTintColor = UIColor.primaryColor
        searchBar.searchTextField.backgroundColor = UIColor.white
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.textColorOnPrimary], for: .normal)
        searchBar.isTranslucent = false
        searchBar.placeholder = "Find Movies.."
    
        self.tableViewFilms.separatorColor = UIColor.clear
        self.tableViewFilms.tableFooterView = UIView()
    }
    
    //MARK: *** SearchBar Delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if (searchBar.text ?? "").count > 0 {
            
            arrayFilmList.removeAll()
            tableViewFilms.reloadData()
            tableViewFilms.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: false)
            
            pageNumber = 1
            isGetFilms = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.getFilms()
            })
            
        }else {
            
            Helper.showWarningMessage(title: "Warning", body: "Please enter film title for searching!")
            
        }
        
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarCancelButtonClicked")
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    
    //MARK: *** TableView Datasource and Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayFilmList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "filmsCell", for: indexPath) as! TVCFilmCell
        
        let film = arrayFilmList[indexPath.row]
        
        cell.imgFilm.clipsToBounds = true
        cell.imgFilm.layer.cornerRadius = 10
        
        cell.imgFilm.kf.setImage(with: URL(string: film.poster ?? ""), placeholder: UIImage(named: "imgPlaceholder"), options: nil, progressBlock: nil, completionHandler: nil)
        
        cell.lblFilmTitle.font = UIFont.customFont(size: 18, customStyle: .Semibold)
        cell.lblFilmTitle.textColor = UIColor.darkText
        cell.lblFilmTitle.text = "\(film.title ?? "")"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let film = arrayFilmList[indexPath.row]
        
        let filmDetail = self.storyboard?.instantiateViewController(withIdentifier: "filmDetail") as! VCFilmDetails
        filmDetail.navTitle = film.title ?? ""
        filmDetail.imdbID = film.imdbId ?? ""
        filmDetail.posterUrl = film.poster ?? ""
        self.navigationController?.pushViewController(filmDetail, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        
        if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex {
            
            if (isGetFilms) {
                isGetFilms = !isGetFilms
                getFilms()
            }
        }
    }
    
    //MARK: *** Custom Methods
    func getFilms() {
        
        self.showIndicator()
        
        NetworkManager.getFilms(pageNumber: pageNumber, searchText: searchBar.text ?? "", success: { (filmResponse) in
            self.hideIndicator()
            
            if let response = filmResponse.response {
                
                if response == "True" {
                    
                    if let films = filmResponse.search {
                        
                        if films.count > 0 {
                            self.arrayFilmList.append(contentsOf: films)
                            self.tableViewFilms.reloadData()
                            self.tableViewFilms.separatorColor = UIColor.textColorOnSecondary
                            
                            self.isGetFilms = true
                            self.pageNumber = self.pageNumber + 1
                        }
                    }
                    
                }else {
                    
                    if self.arrayFilmList.count == 0 {
                        Helper.showWarningMessage(title: "Warning", body: "The movie you were looking for could not be found.")
                        self.tableViewFilms.separatorColor = UIColor.clear
                    }
                }
            }
            
        }) { (error, statusCode) in
            self.hideIndicator()
            self.isGetFilms = true
        }
    }
}
