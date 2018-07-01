//
//  DetailViewController.swift
//  Blocq.io
//
//  Created by Michal Lučanský on 29.6.18.
//  Copyright © 2018 Blocq.io. All rights reserved.
//

import UIKit
import Kingfisher
import Charts

class DetailViewController: UITableViewController {
    
    @IBOutlet weak var chartView: LineChartView!
    
    @IBOutlet weak var lastUpdateVAlue: UILabel!
    @IBOutlet weak var tbcPriceValue: UILabel!
    @IBOutlet weak var tatalSupplyValue: UILabel!
    @IBOutlet weak var availaleSupplyValue: UILabel!
    @IBOutlet weak var marketCapitalValue: UILabel!
    @IBOutlet weak var dayVolumeValue: UILabel!
    @IBOutlet weak var rankValue: UILabel!
    @IBOutlet weak var weakValueChange: UILabel!
    @IBOutlet weak var dayValueChange: UILabel!
    @IBOutlet weak var hourValueChange: UILabel!
    @IBOutlet weak var valueChangeView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var titleView: UIView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    var detailData: CurrencyProfile?
    var testSaved: [CurrencyProfile]?
    private var graphData: [GraphData]?
    
    private var color = [true:UIColor.red, false:UIColor.green]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.barTintColor = Color.mainBlue
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        setUpPriceView(view: priceView)
        setUpValueChangeView(view: valueChangeView)
        setUpInfoView(view: infoView)
        nameLabel.text = (detailData?.name)! + "(\(detailData?.symbol ?? ""))"
        let url = URL(string: (detailData?.imageUrl)!)
        imageView.kf.setImage(with:url!)
        navigationItem.titleView = titleView
    }
    
   

    private func setColor(value: Double) -> UIColor {
        if value < 0 {
            return UIColor.red
        }
        return UIColor.green
    }
    
    private func createDropShadow(view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 1
    }
    
    private func setUpPriceView(view: UIView){
        createDropShadow(view: view)
        priceLabel.text = (detailData?.target)! + "\(detailData?.price ?? 0.0)"
    }
    
    private func setUpValueChangeView(view:UIView){
        createDropShadow(view: view)
        hourValueChange.textColor = setColor(value: (detailData?.percentChange1h)!)
        dayValueChange.textColor = setColor(value: (detailData?.percentChange24h)!)
        weakValueChange.textColor = setColor(value: (detailData?.percentChange7d)!)
        hourValueChange.text = "\((detailData?.percentChange1h)!) %"
        dayValueChange.text = "\((detailData?.percentChange24h)!) %"
        weakValueChange.text = "\((detailData?.percentChange7d)!) %"
    }
    
    private func setUpInfoView(view:UIView){
        createDropShadow(view: view)
        
        let date = Date(timeIntervalSince1970: Double((detailData?.lastUpdate)!))
        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "HH:mm dd-MM-yyyy" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        
        
        rankValue.text = "\(detailData?.rank ?? 0)"
        dayVolumeValue.text = (detailData?.target)! + "\(detailData?.dayVolume ?? 0.0)"
        marketCapitalValue.text = (detailData?.target)! + "\(detailData?.marketCap ?? 0)"
        availaleSupplyValue.text = (detailData?.target)! + "\(detailData?.availableSupply ?? 0)"
        tatalSupplyValue.text = (detailData?.target)! + "\(detailData?.totalSupply ?? 0)"
        tbcPriceValue.text = "\(detailData?.priceBtc ?? 0.0)"
        lastUpdateVAlue.text =  "Last update: " + strDate
    }

    func setUpViewModel(currency: CurrencyProfile) {
        self.detailData = currency
        ApiManager.instance.getHistory(name: currency.name!) { (data, error) in
            guard error == nil else {return}
             var graph = [ChartDataEntry(x: 0, y: 0)]
             var graphDataSet = [ChartDataEntry]()
            for i in data! {
                let data = ChartDataEntry(x: Double(i.row_number!), y: i.price!)
                graphDataSet.append(data)
            }
  
            let dataSet = LineChartDataSet(values: graphDataSet, label: nil)
            dataSet.drawCirclesEnabled = false
            dataSet.colors = [UIColor.red]
            dataSet.fillColor = UIColor.red
            dataSet.drawFilledEnabled = true
            let chartData = LineChartData(dataSet: dataSet)
            chartData.setDrawValues(false)
            
            self.chartView.leftAxis.drawGridLinesEnabled = false
            self.chartView.xAxis.drawGridLinesEnabled = false
            self.chartView.xAxis.granularityEnabled = true
            self.chartView.xAxis.drawLabelsEnabled = false
            self.chartView.scaleYEnabled = true
            self.chartView.scaleYEnabled = true
            self.chartView.scaleXEnabled = true
            self.chartView.drawMarkers = false
            self.chartView.setScaleEnabled(true)
            self.chartView.data = chartData
        }
    }

}
