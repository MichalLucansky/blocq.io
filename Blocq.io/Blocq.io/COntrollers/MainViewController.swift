//
// MainViewController.swift
//  Blocq.io
//
//  Created by Michal Lučanský on 26.6.18.
//  Copyright © 2018 Blocq.io. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class MainViewController: UIViewController, UIGestureRecognizerDelegate {
    
  
    @IBOutlet weak var navigationVIew: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var hideViewConstraint: NSLayoutConstraint!
    
    private let favouritesDefaults = UserDefaults.standard
    
    let viewModel = MainViewModel()
    var currencies: [CurrencyProfile]?
    var filteredArray = [CurrencyProfile]()
    var favourites = [String]()
    var isShowingFavourites = false
    var isFavourites = false
    var shouldShowSearchResults = false
    var emptySearch = false
    var customSearchController: CustomSearchController!
  
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
//
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.5
        longPressGesture.delegate = self
        self.tableView.addGestureRecognizer(longPressGesture)
        if let ggg = favouritesDefaults.value(forKey: "Favourites") as? [String] {
            favourites = ggg
        }
        
        bindViewModel()
    }
    
   @objc func handleLongPress(longPressGesture:UILongPressGestureRecognizer) {
        let p = longPressGesture.location(in: self.tableView)
    var currencyName = ""
    guard let indexPath = self.tableView.indexPathForRow(at: p) else {return}
    if shouldShowSearchResults {
        currencyName = filteredArray[indexPath.row].symbol!
    } else {
        currencyName = currencies![indexPath.row].symbol!
    }
    
    favourites.append(currencyName)
        if (longPressGesture.state == UIGestureRecognizerState.began) {
            favourites.append(currencyName)
            let set = Set(favourites)
            let final = Array(set)
            favouritesDefaults.set(final, forKey: "Favourites")
            favouritesDefaults.synchronize()
            print("Long press on row, at \(indexPath.row)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: self, action: nil)
        viewModel.viewDidLoad()
    }
    
    func bindViewModel() {
        viewModel.currenciesData.observeValues { [weak self] currenciesProfiles in
            guard let data = currenciesProfiles else {return}
            self?.currencies = data
            self?.tableView.reloadData()
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
       
        if searchText == "" {
            emptySearch = true
            shouldShowSearchResults = false
        } else {
            emptySearch = false
            shouldShowSearchResults = true
        }
        
        filteredArray = (currencies?.filter({( currency : CurrencyProfile) -> Bool in
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
        } else if isFavourites {
            let temp = favouritesDefaults.value(forKey: "Favourites") as? [String]
            let favouritesArray = currencies?.filter{(temp?.contains($0.symbol!))!}
            data = favouritesArray!
        } else {
            data = currencies!
        }
        performSegue(withIdentifier: "detailSegue", sender: data[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        var data: [CurrencyProfile]
        if shouldShowSearchResults {
            data = filteredArray
        } else {
            data = currencies!
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
//            return favourites.count
            let xxx = favouritesDefaults.value(forKey: "Favourites") as? [String]
            return xxx?.count ?? 0
        }
        
        if emptySearch && !shouldShowSearchResults{
            return currencies?.count ?? 0
        }
        
        if shouldShowSearchResults {
            return filteredArray.count
        }

        return currencies?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isFavourites {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CurrecncyCellId") as? CurrencyProfileCell
            let temp = favouritesDefaults.value(forKey: "Favourites") as? [String]
            let favouritesArray = currencies?.filter{(temp?.contains($0.symbol!))!}
            cell?.configure(currency: favouritesArray![indexPath.row])
            return cell ?? UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrecncyCellId") as? CurrencyProfileCell
        
        if shouldShowSearchResults {
            if filteredArray.isEmpty {
                cell?.configure(currency: currencies![indexPath.row])
            } else {
                 cell?.configure(currency: filteredArray[indexPath.row])
            }
           
        } else {
        cell?.configure(currency: currencies![indexPath.row])
        }
        return cell ?? UITableViewCell()
    }
}

