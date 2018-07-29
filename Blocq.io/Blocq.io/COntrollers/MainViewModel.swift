//
//  MainViewModel.swift
//  Blocq.io
//
//  Created by Michal Lučanský on 1.7.18.
//  Copyright © 2018 Blocq.io. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

class MainViewModel {
    
    private var currenciesDataProperty = MutableProperty<[CurrencyProfile]?>(nil)
    var currenciesData = Signal<[CurrencyProfile]?, NoError>.empty
    
    init() {
        currenciesData = currenciesDataProperty.signal
    }
    
    func viewDidLoad(){
        
        if let offLineCurrenciesData = retrieveCurrencies(){
            currenciesDataProperty.value =  offLineCurrenciesData
        }
        
        ApiManager.instance.getCurrencyList { [weak self] (currencies, error) in
            guard error == nil, let data = currencies?.data else {
            UserMessage.error.show(message: error?.localizedDescription ?? "")
                return}
            let archivedData = self?.archiveCurrencies(currencies: data)
            self?.saveData(key: "savedOfflineData", archive: archivedData ?? Data())
            self?.currenciesDataProperty.value = data
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
    
    private func retrieveCurrencies() -> [CurrencyProfile]? {
        guard let savedData = UserDefaults.standard.object(forKey: "savedOfflineData") as? Data ,let data = NSKeyedUnarchiver.unarchiveObject(with: savedData) as? Data else { return nil }
        do {
            let products = try PropertyListDecoder().decode([CurrencyProfile].self, from: data)
            return products
        } catch {
            print("Retrieve Failed")
            return nil
        }
    }
}
