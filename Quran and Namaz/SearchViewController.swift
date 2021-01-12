//
//  SearchViewController.swift
//  Quran and Namaz
//
//  Created by Anas khurshid on 06/01/2021.
//  Copyright © 2021 Anas khurshid. All rights reserved.
//

import UIKit

public struct JStoreUser: Codable {
    let name: String
    let lng: String
    let lat: String
    let country: String
}

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate, CustomSearchControllerDelegate {
    
    @IBOutlet weak var tblSearchResults: UITableView!
    
    @IBOutlet weak var searchContainer: UIView!
    
    var countryCode: String!
    var dataArray = [String]()
    var filteredArray = [String]()
    
    var shouldShowSearchResults = false
    
    var searchController: UISearchController!
    var customSearchController: CustomSearchController!
    
    var callBack:((String)->())?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults {
            return filteredArray.count
        }
        else {
            return dataArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCell", for: indexPath)
        
        if shouldShowSearchResults {
            cell.textLabel?.text = filteredArray[indexPath.row]
        }
        else {
            cell.textLabel?.text = dataArray[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedString: String!
        
        if shouldShowSearchResults {
            selectedString = filteredArray[indexPath.row]
            
        }
        else {
            selectedString = dataArray[indexPath.row]
        }
        
        callBack?(selectedString)
        self.dismiss(animated: true) {
            
        }
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text else {
            return
        }
        
        // Filter the data array and get only those countries that match the search text.
        filteredArray = dataArray.filter({ (country) -> Bool in
            let countryText:NSString = country as NSString
            
            return (countryText.range(of: searchString, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
        })
        
        // Reload the tableview.
        self.tblSearchResults.reloadData()
    }
    
    func didStartSearching() {
        shouldShowSearchResults = true
        self.tblSearchResults.reloadData()
    }

    
    func didTapOnSearchButton() {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            self.tblSearchResults.reloadData()
        }
    }
    
    func didTapOnCancelButton() {
        shouldShowSearchResults = false
        self.tblSearchResults.reloadData()
    }
    
    func didChangeSearchText(searchText: String) {
        filteredArray = dataArray.filter({ (country) -> Bool in
            let countryText: NSString = country as NSString
            
            return (countryText.range(of: searchText, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
        })
        
        // Reload the tableview.
        self.tblSearchResults.reloadData()
    }
    
    // MARK: UISearchBarDelegate functions
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        self.tblSearchResults.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchController.searchBar.resignFirstResponder()
    }

    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        self.tblSearchResults.reloadData()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            self.tblSearchResults.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    
    func configureSearchController() {
        // Initialize and perform a minimum configuration to the search controller.
        searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.delegate = self
        
        searchController.searchBar.sizeToFit()
        searchContainer.addSubview(searchController.searchBar)
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblSearchResults.delegate = self
        tblSearchResults.dataSource = self

        loadListOfCountries()
        configureSearchController()
        // Do any additional setup after loading the view.
    }
    
    func loadListOfCountries() {
            
        var citiesArray: [String]! = []
        
        let url = Bundle.main.url(forResource: "citiesMap", withExtension: "json")!
        do {
            let jsonData = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: jsonData) as! [String:Any]

            let currencies = json[self.countryCode] as! NSArray
            
            for item in currencies { // loop through data items
                let obj = item as! NSDictionary
                let name = obj.value(forKey: "name") as? String
                
                if (name != nil) {
                    citiesArray.append(name!)
                }
            }
            
            dataArray = citiesArray
            tblSearchResults.reloadData()

        }
        catch {
            print(error)
        }
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
