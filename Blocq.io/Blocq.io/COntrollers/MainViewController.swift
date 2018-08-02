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
    
  
    @IBOutlet weak var emptyStateLabel: UILabel!
    @IBOutlet weak var emptyStateView: UIView!
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
        tableView.tableFooterView = UIView()
        navigationVIew.backgroundColor = Color.mainBlue
        self.view.backgroundColor = Color.mainBlue
//        favoriteButton.isHighlighted = true
        favoriteButton.setTitleColor(.lightGray, for: .normal)
        allButton.setTitleColor(.white, for: .normal)
        searchView.backgroundColor = Color.mainBlue
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        navigationItem.titleView?.tintColor = UIColor.white
//
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.5
        longPressGesture.delegate = self
        self.tableView.addGestureRecognizer(longPressGesture)
        if let ggg = favouritesDefaults.value(forKey: "Favourites") as? [String] {
            print(ggg)
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
    } else if isFavourites{
        if let ggg = favouritesDefaults.value(forKey: "Favourites") as? [String] {
            favourites = ggg
            let favouritesArray = currencies?.filter{(favourites.contains($0.symbol!))}
            currencyName = favouritesArray![indexPath.row].symbol!
        }
    } else {
         currencyName = currencies![indexPath.row].symbol!
    }
        if (longPressGesture.state == UIGestureRecognizerState.began) {
            
            if isFavourites {
                let new = favourites.filter{$0 != currencyName}
                let set = Set(new)
                var final = Array(set)
                if final.isEmpty {
                    final.removeAll()
                }
                favouritesDefaults.set(final, forKey: "Favourites")
                favouritesDefaults.synchronize()
                favourites = []
            } else {
                favourites.append(currencyName)
                let set = Set(favourites)
                let final = Array(set)
                favouritesDefaults.set(final, forKey: "Favourites")
                favouritesDefaults.synchronize()
            }
        }
     tableView.reloadData()
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
        
        customSearchController.customSearchBar.placeholder = NSLocalizedString("Search", comment: "")//"Search".localized
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
//        allButton.isHighlighted = true
        favoriteButton.setTitleColor(.white, for: .normal)
        allButton.setTitleColor(.lightGray, for: .normal)
        
        isFavourites = true
        tableView.reloadData()
        
    }
    @IBAction func allCurrencies(_ sender: UIButton) {
//        favoriteButton.isHighlighted = true
        favoriteButton.setTitleColor(.lightGray, for: .normal)
        allButton.setTitleColor(.white, for: .normal)
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
        
        if isFavourites {
            
            guard let temp = favouritesDefaults.value(forKey: "Favourites") as? [String] else {return}
            let favouritesArray = currencies?.filter{(temp.contains($0.symbol!))}
            filteredArray = (favouritesArray?.filter({( currency : CurrencyProfile) -> Bool in
                return (currency.name?.lowercased().contains(searchText.lowercased()))!
            }))!
            print(filteredArray)
        } else {
            filteredArray = (currencies?.filter({( currency : CurrencyProfile) -> Bool in
                return (currency.name?.lowercased().contains(searchText.lowercased()))!
            }))!
        }
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
        emptyStateLabel.text = "NoSearchResults".localized
        if isFavourites {
            emptyStateLabel.text = "NoFavourites".localized
            if shouldShowSearchResults {
                return filteredArray.count
            }
            guard let xxx = favouritesDefaults.value(forKey: "Favourites") as? [String] else {emptyStateView.isHidden = false
                return 0
            }
            
            emptyStateView.isHidden = !xxx.isEmpty 
            return xxx.count
        }
        
        if emptySearch && !shouldShowSearchResults{
             emptyStateView.isHidden = (!(currencies?.isEmpty)!)
            return currencies?.count ?? 0
        }
        
        if shouldShowSearchResults {
            emptyStateView.isHidden = (!(filteredArray.isEmpty))
            return filteredArray.count
        }
        
        if currencies == nil {
            emptyStateView.isHidden = false
        }
        emptyStateView.isHidden = (!((currencies?.isEmpty) ?? false))
        return currencies?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isFavourites {
            if shouldShowSearchResults{
                let cell = tableView.dequeueReusableCell(withIdentifier: "CurrecncyCellId") as? CurrencyProfileCell
                cell?.configure(currency: filteredArray[indexPath.row])
                return cell ?? UITableViewCell()
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CurrecncyCellId") as? CurrencyProfileCell
                let temp = favouritesDefaults.value(forKey: "Favourites") as? [String]
                let favouritesArray = currencies?.filter{(temp?.contains($0.symbol!))!}

                cell?.configure(currency: favouritesArray![indexPath.row])
                return cell ?? UITableViewCell()
            }
           
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

