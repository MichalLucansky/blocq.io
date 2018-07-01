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
    
    init() {
        
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
        guard let data = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "savedOfflineData") as! Data) as? Data else { return nil }
        do {
            let products = try PropertyListDecoder().decode([CurrencyProfile].self, from: data)
            return products
        } catch {
            print("Retrieve Failed")
            return nil
        }
    }
}
