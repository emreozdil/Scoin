//
//  HistoryViewController.swift
//  Sahibinden
//
//  Created by Emre Özdil on 10/12/2017.
//  Copyright © 2017 Emre Özdil. All rights reserved.
//

import UIKit
import Charts
import Alamofire
import AlamofireObjectMapper

class HistoryViewController: DemoBaseViewController {
    
    var history: [Ticker]?
    
    let chartView: LineChartView = {
        let chartView = LineChartView()
        chartView.translatesAutoresizingMaskIntoConstraints = false
        return chartView
    }()
    let slider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        slider.maximumValue = 1174
        slider.isContinuous = true
        slider.tintColor = UIColor.sahibinden
        slider.value = 30
        slider.addTarget(self, action: #selector(handleSlider), for: .valueChanged)
        return slider
    }()
    
    let sliderLabel: UILabel = {
        let label = UILabel()
        label.text = "30"
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        title = "Scoin"
        
        view.addSubview(chartView)
        view.addSubview(slider)
        view.addSubview(sliderLabel)
        
        setupChartView()
        setupSlider()
        setupSliderLabel()
        
        fetchHistory()
        
        chartView.delegate = self
        
        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = true
        
        // x-axis limit line
        let llXAxis = ChartLimitLine(limit: 10, label: "Index 10")
        llXAxis.lineWidth = 4
        llXAxis.lineDashLengths = [10, 10, 0]
        llXAxis.labelPosition = .rightBottom
        llXAxis.valueFont = .systemFont(ofSize: 10)
        
        chartView.xAxis.gridLineDashLengths = [10, 10]
        chartView.xAxis.gridLineDashPhase = 0
        
        let ll1 = ChartLimitLine(limit: 17300, label: "Upper Limit")
        ll1.lineWidth = 4
        ll1.lineDashLengths = [5, 5]
        ll1.labelPosition = .rightTop
        ll1.valueFont = .systemFont(ofSize: 10)
        
        let ll2 = ChartLimitLine(limit: 100, label: "Lower Limit")
        ll2.lineWidth = 4
        ll2.lineDashLengths = [5,5]
        ll2.labelPosition = .rightBottom
        ll2.valueFont = .systemFont(ofSize: 10)
        
        let leftAxis = chartView.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.addLimitLine(ll1)
        leftAxis.addLimitLine(ll2)
        leftAxis.axisMaximum = 17500
        leftAxis.axisMinimum = 0
        leftAxis.gridLineDashLengths = [5, 5]
        leftAxis.drawLimitLinesBehindDataEnabled = true
        
        chartView.rightAxis.enabled = false
        let marker = BalloonMarker(color: UIColor(white: 180/255, alpha: 1),
                                   font: .systemFont(ofSize: 12),
                                   textColor: .white,
                                   insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        marker.chartView = chartView
        marker.minimumSize = CGSize(width: 80, height: 40)
        chartView.marker = marker
        
        chartView.legend.form = .line
        
//        sliderX.value = 45.0
//        sliderY.value = 100.0
        
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
        
//        self.setDataCount(Int(sliderX.value), range: UInt32(sliderY.value))
        self.setDataCount(Int(10), range: UInt32(100))
    }
    
    func setDataCount(_ count: Int, range: UInt32) {
        if let tickersCount = history?.count {
            let initialValue = tickersCount - Int(slider.value)
            
            
            var minumumValue = 300000.0
            for i in initialValue..<tickersCount {
                if minumumValue > history![i].value! {
                    minumumValue = history![i].value!
                }
            }
            
            chartView.leftAxis.axisMinimum = minumumValue
            let values = (initialValue..<tickersCount).map { (i) -> ChartDataEntry in
                let val: Double = history![i].value!
                return ChartDataEntry(x: Double(i), y: val, icon: #imageLiteral(resourceName: "icon"))
            }
            let set1 = LineChartDataSet(values: values, label: "Sahibinden Coin")
            set1.drawIconsEnabled = false
            
            set1.lineDashLengths = [5, 2.5]
            set1.highlightLineDashLengths = [5, 2.5]
            set1.setColor(.black)
            set1.setCircleColor(.black)
            set1.lineWidth = 1
            set1.circleRadius = 3
            set1.drawCircleHoleEnabled = false
            set1.valueFont = .systemFont(ofSize: 9)
            set1.formLineDashLengths = [5, 2.5]
            set1.formLineWidth = 1
            set1.formLineWidth = 15
            
            let gradientColors = [ChartColorTemplates.colorFromString("#00ff0000").cgColor,
                                  ChartColorTemplates.colorFromString("#ffff0000").cgColor]
            let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
            
            set1.fillAlpha = 1
            set1.fill = Fill(linearGradient: gradient, angle: 90) //.linearGradient(gradient, angle: 90)
            set1.drawFilledEnabled = true
            
            let data = LineChartData(dataSet: set1)
            
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
    }
    
    @objc func handleSlider() {
        sliderLabel.text = "\(Int(slider.value))"
        self.updateChartData()
    }
}
