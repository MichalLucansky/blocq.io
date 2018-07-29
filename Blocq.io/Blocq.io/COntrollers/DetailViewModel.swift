//
//  DetailViewModel.swift
//  Blocq.io
//
//  Created by Michal Lučanský on 1.7.18.
//  Copyright © 2018 Blocq.io. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

class DetailViewModel {
    
    var currencyDetailProperty = MutableProperty<CurrencyProfile?>(nil)
    private var chartDataProperty = MutableProperty<[GraphData]?>(nil)
    var chartData = Signal<[GraphData]?, NoError>.empty
    
    
    init() {
        chartData = chartDataProperty.signal
    }
    
    func viewDidLoad(){
       
    }
    
    func loadData(currecyData: CurrencyProfile) {
        currencyDetailProperty.value = currecyData
    }
    
    func loadChartData() {
        guard let name = currencyDetailProperty.value?.name else {return}
        ApiManager.instance.getHistory(name: name) { (data, error) in
            guard error == nil else {
              UserMessage.error.show(message: error?.localizedDescription ?? "")
                return}
            self.chartDataProperty.value = data
        }
    }
}
