//
//  SettingsViewController.swift
//  Blocq.io
//
//  Created by Michal Lučanský on 27.6.18.
//  Copyright © 2018 Blocq.io. All rights reserved.
//

import UIKit

protocol RefreshSettings {
    func refresh()
}

enum SettingsType{
    case currency
    case timeInterval
}

class SettingsViewController: UITableViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    var settingsTimeInterval = UserDefaults.standard
    var settingscurrency = UserDefaults.standard
    var delegate: RefreshSettings?

    override func viewDidLoad() {
        super.viewDidLoad()
        let timeConversion = ["lastHour":"Hour","lastDay":"Day","lastWeek":"Weak"]
        let timeInterval = UserDefaults.standard
        let currency = UserDefaults.standard
//        let currencyParameter = currency.value(forKey: "settingscurrency") as? String
//        let timeParameter = timeInterval.value(forKey: "settingsTimeInterval") as? String
        if let time = timeInterval.value(forKey: "settingsTimeInterval") as? String{
            self.timeLabel.text = timeConversion[time]
        }
        if let currency = currency.value(forKey: "settingscurrency") as? String {
            self.currencyLabel.text = currency
        }
        //timeParameter
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.barTintColor = Color.mainBlue
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = "Settings"
        tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            changeSettingsAlert(settings: .currency)
        }
        if indexPath.row == 1 {
            changeSettingsAlert(settings: .timeInterval)
        }
    }
    
    func changeSettingsAlert(settings: SettingsType){
        let title: String
        let hour = UIAlertAction(title: "Hour", style: .default) { [weak self](action:UIAlertAction) in
            self?.settingsTimeInterval.set("lastHour", forKey: "settingsTimeInterval")
            self?.settingsTimeInterval.synchronize()
            self?.timeLabel.text = "Hour"
            self?.tableView.reloadData()
            self?.delegate?.refresh()
        }
        let day = UIAlertAction(title: "Day", style: .default) { [weak self] (action:UIAlertAction) in
            self?.settingsTimeInterval.set("lastDay", forKey: "settingsTimeInterval")
            self?.settingsTimeInterval.synchronize()
            self?.timeLabel.text = "Day"
            self?.tableView.reloadData()
            self?.delegate?.refresh()
        }
        let weak = UIAlertAction(title: "Weak", style: .default) { [weak self] (action:UIAlertAction) in
            self?.settingsTimeInterval.set("lastWeek", forKey: "settingsTimeInterval")
            self?.settingsTimeInterval.synchronize()
            self?.timeLabel.text = "Weak"
            self?.tableView.reloadData()
            self?.delegate?.refresh()
        }
        let usd = UIAlertAction(title: "USD", style: .default) { [weak self] (action:UIAlertAction) in
            self?.settingscurrency.set("USD", forKey: "settingscurrency")
            self?.settingscurrency.synchronize()
            self?.currencyLabel.text = "USD"
            self?.tableView.reloadData()
            self?.delegate?.refresh()
        }
        let eur = UIAlertAction(title: "EUR", style: .default) { [weak self] (action:UIAlertAction) in
            self?.settingscurrency.set("EUR", forKey: "settingscurrency")
            self?.settingscurrency.synchronize()
            self?.currencyLabel.text = "EUR"
            self?.tableView.reloadData()
            self?.delegate?.refresh()
        }
        let czk = UIAlertAction(title: "CZK", style: .default) { [weak self] (action:UIAlertAction) in
            self?.settingscurrency.set("CZK", forKey: "settingscurrency")
            self?.settingscurrency.synchronize()
            self?.currencyLabel.text = "CZK"
            self?.tableView.reloadData()
            self?.delegate?.refresh()
            
        }
        let pln = UIAlertAction(title: "PLN", style: .default) { [weak self] (action:UIAlertAction) in
            self?.settingscurrency.set("PLN", forKey: "settingscurrency")
            self?.settingscurrency.synchronize()
            self?.currencyLabel.text = "PLN"
            self?.tableView.reloadData()
            self?.delegate?.refresh()
        }
        let huf = UIAlertAction(title: "HUF", style: .default) { [weak self] (action:UIAlertAction) in
            self?.settingscurrency.set("HUF", forKey: "settingscurrency")
            self?.settingscurrency.synchronize()
            self?.currencyLabel.text = "HUF"
            self?.tableView.reloadData()
            self?.delegate?.refresh()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        switch settings {
        case .currency:
            title = "Preferred currency"
        case .timeInterval:
            title = "Display percentage change"
        }
        
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        if settings == .timeInterval {
            alertController.addAction(hour)
            alertController.addAction(day)
            alertController.addAction(weak)
            alertController.addAction(cancel)
        } else if settings == .currency {
            alertController.addAction(eur)
            alertController.addAction(usd)
            alertController.addAction(czk)
            alertController.addAction(pln)
            alertController.addAction(huf)
            alertController.addAction(cancel)
        }
        self.present(alertController, animated: true, completion: nil)
    }
}
