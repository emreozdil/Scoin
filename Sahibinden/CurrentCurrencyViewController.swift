//
//  CurrentCurrencyViewController.swift
//  Sahibinden
//
//  Created by Emre Özdil on 10/12/2017.
//  Copyright © 2017 Emre Özdil. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class CurrentCurrencyViewController: UIViewController {
    
    var ticker: Ticker?

    lazy var coinLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mainLogo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let currencyCoinLabel: UILabel = {
        let label = UILabel()
        label.text = "0.00 $"
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 52)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "23.03.2017"
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let refreshButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.sahibinden
        button.setTitle("Refresh", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTicker()
        
        view.backgroundColor = UIColor.white
        title = "Currenct Currency"
        
        view.addSubview(coinLogoImageView)
        view.addSubview(currencyCoinLabel)
        view.addSubview(dateLabel)
        view.addSubview(refreshButton)
        
        setupCoinLogoImageView()
        setupCurrencyCoinLabel()
        setupDateLabel()
        setupRefreshButton()
    }
    
    func fillData() {
        if let timeStamp: Double = (self.ticker?.date) {
            let date = Date(timeIntervalSince1970: timeStamp/1000)
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT+3") //Set timezone that you want
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm" //Specify your format that you want
            let strDate = dateFormatter.string(from: date)
            self.dateLabel.text = strDate
        }

        if let value = self.ticker?.value {
            self.currencyCoinLabel.text = "\(value) $"
        }
   
    }
    
    func fetchTicker() {
        
        Alamofire.request(URLTicker).responseObject { (response: DataResponse<Ticker>) in
            
            self.ticker = response.result.value
            self.fillData()
        }
        
    }
    
    func setupCoinLogoImageView() {
        // MARK: X, Y, Width, Height for profileImageView
        coinLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        coinLogoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: (self.navigationController?.navigationBar.frame.height)! + 32).isActive = true
        coinLogoImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        coinLogoImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func setupCurrencyCoinLabel() {
        // MARK: X, Y, Width, Height for companyTitle
        currencyCoinLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        currencyCoinLabel.topAnchor.constraint(equalTo: coinLogoImageView.bottomAnchor, constant: 32).isActive = true
        currencyCoinLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32).isActive = true
        currencyCoinLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupDateLabel() {
        // MARK: X, Y, Width, Height for companySubTitle
        dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dateLabel.topAnchor.constraint(equalTo: currencyCoinLabel.bottomAnchor, constant: 32).isActive = true
        dateLabel.widthAnchor.constraint(equalTo: currencyCoinLabel.widthAnchor).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }

    func setupRefreshButton() {
        // MARK: X, Y, Width, Height
        refreshButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        refreshButton.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 64).isActive = true
        refreshButton.widthAnchor.constraint(equalTo: currencyCoinLabel.widthAnchor).isActive = true
        refreshButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    @objc func handleRefresh() {
        fetchTicker()
    }
}

