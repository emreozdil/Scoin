//
//  SubCoins.swift
//  Sahibinden
//
//  Created by Emre Özdil on 10/12/2017.
//  Copyright © 2017 Emre Özdil. All rights reserved.
//

import UIKit
import Charts
import Alamofire
import AlamofireObjectMapper

class SubCoinsViewController: DemoBaseViewController {
    
    var history: [Ticker]?
    var bitcoinHistory: [Value]?
    
    let chartView: LineChartView = {
        let chartView = LineChartView()
        chartView.translatesAutoresizingMaskIntoConstraints = false
        return chartView
    }()
    let slider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        slider.maximumValue = 30
        slider.isContinuous = true
        slider.tintColor = UIColor.sahibinden
        slider.value = 5
        slider.addTarget(self, action: #selector(handleSlider), for: .valueChanged)
        return slider
    }()
    
    let sliderLabel: UILabel = {
        let label = UILabel()
        label.text = "5"
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.background
        
        view.addSubview(chartView)
        view.addSubview(slider)
        view.addSubview(sliderLabel)
        
        setupChartView()
        setupSlider()
        setupSliderLabel()
        
        fetchHistory()
        
        // Do any additional setup after loading the view.
        self.title = "Scoin vs Bitcoin"
        self.options = [.toggleValues,
                        .toggleFilled,
                        .toggleCircles,
                        .toggleCubic,
                        .toggleHorizontalCubic,
                        .toggleStepped,
                        .toggleHighlight,
                        .animateX,
                        .animateY,
                        .animateXY,
                        .saveToGallery,
                        .togglePinchZoom,
                        .toggleAutoScaleMinMax,
                        .toggleData]
        
        chartView.delegate = self
        
        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = true
        
        let l = chartView.legend
        l.form = .line
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.textColor = .white
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        
        let xAxis = chartView.xAxis
        xAxis.labelFont = .systemFont(ofSize: 11)
        xAxis.labelTextColor = .white
        xAxis.drawAxisLineEnabled = false
        
        let leftAxis = chartView.leftAxis
        leftAxis.labelTextColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
        leftAxis.axisMaximum = 18000
        leftAxis.axisMinimum = 8000
        leftAxis.drawGridLinesEnabled = true
        leftAxis.granularityEnabled = true
        
        let rightAxis = chartView.rightAxis
        rightAxis.labelTextColor = .red
        rightAxis.axisMaximum = 18000
        rightAxis.axisMinimum = 8000
        rightAxis.granularityEnabled = false

        
        chartView.animate(xAxisDuration: 2.5)
    }
    
    func setupChartView() {
        chartView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        chartView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        chartView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        chartView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8).isActive = true
    }
    
    func setupSlider() {
        slider.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: view.frame.height*0.05).isActive = true
        slider.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.frame.width*0.05).isActive = true
        slider.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        slider.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
    }
    
    func setupSliderLabel() {
        sliderLabel.topAnchor.constraint(equalTo: slider.topAnchor).isActive = true
        sliderLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -(view.frame.width*0.02)).isActive = true
        sliderLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1).isActive = true
        sliderLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
    }
    
    override func updateChartData() {
        if self.shouldHideData {
            chartView.data = nil
            return
        }
        
        self.setDataCount()
    }
    
    func setDataCount() {
        if let tickersCount = history?.count, let bitcoinCount = bitcoinHistory?.count {
            let initialScoinValue = tickersCount - Int(slider.value)
            let initialBitcoinValue = bitcoinCount - Int(slider.value)
            
            var minumumValue = 300000.0
            var maximimValue = 0.0
            for i in initialScoinValue..<tickersCount {
                if minumumValue > history![i].value! {
                    minumumValue = history![i].value!
                }
                if maximimValue < history![i].value! {
                    maximimValue = history![i].value!
                }
            }
            for i in initialBitcoinValue..<bitcoinCount {
                if minumumValue > bitcoinHistory![i].value! {
                    minumumValue = bitcoinHistory![i].value!
                }
                if maximimValue < bitcoinHistory![i].value! {
                    maximimValue = bitcoinHistory![i].value!
                }
            }
            
            chartView.leftAxis.axisMinimum = minumumValue
            chartView.leftAxis.axisMaximum = maximimValue + 500
            
            chartView.rightAxis.axisMinimum = minumumValue
            chartView.rightAxis.axisMaximum = maximimValue + 500
            
            let yVals1 = (initialScoinValue..<tickersCount).map { (i) -> ChartDataEntry in
                let val: Double = history![i].value!
                return ChartDataEntry(x: Double(i-initialScoinValue), y: val)
            }
            let yVals2 = (initialBitcoinValue..<bitcoinCount).map { (i) -> ChartDataEntry in
                let val: Double = bitcoinHistory![i].value!
                return ChartDataEntry(x: Double(i-initialBitcoinValue), y: val)
            }
//            let yVals3 = (0..<count).map { (i) -> ChartDataEntry in
//                let val = Double(arc4random_uniform(range) + 500)
//                return ChartDataEntry(x: Double(i), y: val)
//            }
            
            let set1 = LineChartDataSet(values: yVals1, label: "Scoin")
            set1.axisDependency = .left
            set1.setColor(UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1))
            set1.setCircleColor(.white)
            set1.lineWidth = 2
            set1.circleRadius = 3
            set1.fillAlpha = 65/255
            set1.fillColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
            set1.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
            set1.drawCircleHoleEnabled = false
            
            let set2 = LineChartDataSet(values: yVals2, label: "Bitcoin")
            set2.axisDependency = .right
            set2.setColor(.red)
            set2.setCircleColor(.white)
            set2.lineWidth = 2
            set2.circleRadius = 3
            set2.fillAlpha = 65/255
            set2.fillColor = .red
            set2.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
            set2.drawCircleHoleEnabled = false
            
//            let set3 = LineChartDataSet(values: yVals3, label: "DataSet 3")
//            set3.axisDependency = .right
//            set3.setColor(.yellow)
//            set3.setCircleColor(.white)
//            set3.lineWidth = 2
//            set3.circleRadius = 3
//            set3.fillAlpha = 65/255
//            set3.fillColor = UIColor.yellow.withAlphaComponent(200/255)
//            set3.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
//            set3.drawCircleHoleEnabled = false
            
//            let data = LineChartData(dataSets: [set1, set2, set3])
            let data = LineChartData(dataSets: [set1, set2])
            data.setValueTextColor(.blue)
            data.setValueFont(.systemFont(ofSize: 9))
            
            chartView.data = data
        }
    }
    
    override func optionTapped(_ option: Option) {
        switch option {
        case .toggleFilled:
            for set in chartView.data!.dataSets as! [LineChartDataSet] {
                set.drawFilledEnabled = !set.drawFilledEnabled
            }
            chartView.setNeedsDisplay()
            
        case .toggleCircles:
            for set in chartView.data!.dataSets as! [LineChartDataSet] {
                set.drawCirclesEnabled = !set.drawCirclesEnabled
            }
            chartView.setNeedsDisplay()
            
        case .toggleCubic:
            for set in chartView.data!.dataSets as! [LineChartDataSet] {
                set.mode = (set.mode == .cubicBezier) ? .linear : .cubicBezier
            }
            chartView.setNeedsDisplay()
            
        case .toggleStepped:
            for set in chartView.data!.dataSets as! [LineChartDataSet] {
                set.mode = (set.mode == .stepped) ? .linear : .stepped
            }
            chartView.setNeedsDisplay()
            
        case .toggleHorizontalCubic:
            for set in chartView.data!.dataSets as! [LineChartDataSet] {
                set.mode = (set.mode == .cubicBezier) ? .horizontalBezier : .cubicBezier
            }
            chartView.setNeedsDisplay()
            
        default:
            super.handleOption(option, forChartView: chartView)
        }
    }
    func fetchHistory() {
        
        Alamofire.request(URLHistory).responseArray { (response: DataResponse<[Ticker]>) in
            let tickerArray = response.result.value
            self.history = tickerArray
            self.updateChartData()
            print(tickerArray?.count ?? 0)
        }
        Alamofire.request(URLBitcoin).responseObject { (response: DataResponse<Bitcoin>) in
            let bitcoinResponse = response.result.value
            self.bitcoinHistory = bitcoinResponse?.values
            self.updateChartData()
        }
    }
    
    @objc func handleSlider() {
        sliderLabel.text = "\(Int(slider.value))"
        self.updateChartData()
    }
    //}
    // TODO: Declarations in extensions cannot override yet.
    //extension LineChart2ViewController {
    override func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        super.chartValueSelected(chartView, entry: entry, highlight: highlight)
        
        self.chartView.centerViewToAnimated(xValue: entry.x, yValue: entry.y,
                                            axis: self.chartView.data!.getDataSetByIndex(highlight.dataSetIndex).axisDependency,
                                            duration: 1)
        //[_chartView moveViewToAnimatedWithXValue:entry.x yValue:entry.y axis:[_chartView.data getDataSetByIndex:dataSetIndex].axisDependency duration:1.0];
        //[_chartView zoomAndCenterViewAnimatedWithScaleX:1.8 scaleY:1.8 xValue:entry.x yValue:entry.y axis:[_chartView.data getDataSetByIndex:dataSetIndex].axisDependency duration:1.0];
    }
}
