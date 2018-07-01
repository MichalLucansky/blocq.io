//
// MainViewController.swift
//  Blocq.io
//
//  Created by Michal Lučanský on 26.6.18.
//  Copyright © 2018 Blocq.io. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
  
    @IBOutlet weak var navigationVIew: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var hideViewConstraint: NSLayoutConstraint!
    var xxx: [CurrencyProfile]?
    var filteredArray = [CurrencyProfile]()
    var favourites = [String]()
    var isFavourites = false
    var shouldShowSearchResults = false
    var customSearchController: CustomSearchController!
    var nextURL = ""
    

    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationVIew.backgroundColor = Color.mainBlue
        self.view.backgroundColor = Color.mainBlue
        favoriteButton.isHighlighted = true
        searchView.backgroundColor = Color.mainBlue
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        navigationItem.titleView?.tintColor = UIColor.white
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: self, action: nil)
        if let nieco = retrieveCurrencies() {
            self.xxx = nieco
        }
        
        ApiManager.instance.getCurrencyList { (currencies, error) in
            guard error == nil else {return}
            let archivedData = self.archiveCurrencies(currencies: (currencies?.data)!)
            self.saveData(key: "savedOfflineData", archive: archivedData)
            self.xxx = currencies?.data
            self.nextURL = (currencies?.links.next)!
            self.tableView.reloadData()
        }
    }
    
    private func saveData(key:String, archive: Data) {
            let defaults = UserDefaults.standard
            defaults.set(archive, forKey: key)
            defaults.synchronize()
    }

    private func archiveCurrencies(currencies:[CurrencyProfile]) -> Data {
        var returnValue = Data()
            do {
                let data = try PropertyListEncoder().encode(currencies)
                let success = NSKeyedArchiver.archivedData(withRootObject: data)
                returnValue = success
            } catch {
                print("Save Failed")
            }
   
        return returnValue
    }
    
    func retrieveCurrencies() -> [CurrencyProfile]? {
        guard let data = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "savedOfflineData") as! Data) as? Data else { return nil }
        do {
            let products = try PropertyListDecoder().decode([CurrencyProfile].self, from: data)
            return products
        } catch {
            print("Retrieve Failed")
            return nil
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
        if scrollView.contentOffset.y <= 44 {
                self.hideViewConstraint.constant = -scrollView.contentOffset.y
        }
        
    }

    func configureCustomSearchController() {
        customSearchController = CustomSearchController(searchResultsController: self, searchBarFrame: CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(tableView.frame.size.width), height: CGFloat(44.0)), searchBarFont: UIFont(name: "Futura", size: 16.0)!, searchBarTextColor: UIColor.white, searchBarTintColor: Color.mainBlue)
        
        customSearchController.customSearchBar.placeholder = "Search"
        customSearchController.customSearchBar.backgroundImage = UIImage()
        customSearchController.customSearchBar.tintColor = UIColor.white
        customSearchController.customDelegate = self
        searchView.addSubview(customSearchController.customSearchBar)
    }

    @IBAction func settings(_ sender: UIButton) {
    }
    
    @IBAction func search(_ sender: UIButton) {
        configureCustomSearchController()
        
    }
    
    @IBAction func showFavourites(_ sender: UIButton) {
        allButton.isHighlighted = true
        isFavourites = true
        tableView.reloadData()
        
    }
    @IBAction func allCurrencies(_ sender: UIButton) {
        favoriteButton.isHighlighted = true
        isFavourites = false
         tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue"{
            if let destinationVC = segue.destination as? DetailViewController {
                guard let profile = sender as? CurrencyProfile else {return}
                destinationVC.setUpViewModel(currency: profile)
            }
        }
    }
    
}

extension MainViewController: UISearchBarDelegate {
    
}

extension MainViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        shouldShowSearchResults = true
        tableView.reloadData()
    }
}

extension MainViewController: CustomSearchControllerDelegate {
    func didStartSearching() {
        shouldShowSearchResults = true
    }
    
    func didTapOnSearchButton() {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            tableView.reloadData()
        }
    }
    
    func didTapOnCancelButton() {
        shouldShowSearchResults = false
        filteredArray = [CurrencyProfile]()
        customSearchController.isActive = false
                        customSearchController.customSearchBar.removeFromSuperview()
        tableView.reloadData()
    }
    
    func didChangeSearchText(searchText: String) {
        filteredArray = (xxx?.filter({( currency : CurrencyProfile) -> Bool in
            return (currency.name?.lowercased().contains(searchText.lowercased()))!
        }))!
        tableView.reloadData()
    }
    
    
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var data: [CurrencyProfile]
        if shouldShowSearchResults {
            data = filteredArray
        } else {
            data = xxx!
        }
        performSegue(withIdentifier: "detailSegue", sender: data[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        var data: [CurrencyProfile]
        if shouldShowSearchResults {
            data = filteredArray
        } else {
            data = xxx!
        }
        performSegue(withIdentifier: "detailSegue", sender: data[indexPath.row])
    }
}

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFavourites {
            return favourites.count
        }
        
        if shouldShowSearchResults {
            return filteredArray.count
        }
            return xxx?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isFavourites {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CurrecncyCellId")
            return cell ?? UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrecncyCellId") as? CurrencyProfileCell
        
        if shouldShowSearchResults {
            cell?.configure(currency: filteredArray[indexPath.row])
        } else {
        cell?.configure(currency: xxx![indexPath.row])
        }
        return cell ?? UITableViewCell()
    }
}

