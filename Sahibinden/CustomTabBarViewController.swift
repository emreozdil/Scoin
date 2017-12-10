//
//  CustomTabBarViewController.swift
//  Sahibinden
//
//  Created by Emre Özdil on 10/12/2017.
//  Copyright © 2017 Emre Özdil. All rights reserved.
//

import UIKit

let URLHistory = "https://devakademi.sahibinden.com/history"
let URLTicker = "https://devakademi.sahibinden.com/ticker"
let URLBitcoin = "https://blockchain.info/charts/market-price?timespan=30days&format=json"

class CustomTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup our custom view controllers
        let currentCurrencyViewController = CurrentCurrencyViewController()
        let currentCurrencyNavController = UINavigationController(rootViewController: currentCurrencyViewController)
        currentCurrencyNavController.tabBarItem = UITabBarItem(title: "Scoin", image: #imageLiteral(resourceName: "money") , tag: 1)
        
        let historyViewController = HistoryViewController()
        let historyNavController = UINavigationController(rootViewController: historyViewController)
        historyNavController.tabBarItem = UITabBarItem(title: "History", image: #imageLiteral(resourceName: "money") , tag: 1)
        
        let subCoinsViewController = SubCoinsViewController()
        let subCoinsNavController = UINavigationController(rootViewController: subCoinsViewController)
        subCoinsNavController.tabBarItem = UITabBarItem(title: "Sub Coins", image: #imageLiteral(resourceName: "money") , tag: 1)
        
        viewControllers = [currentCurrencyNavController, historyNavController, subCoinsNavController]
        
    }
    
    private func createDummyNavControllerWithTitle(_ title: String, imageName: String) -> UINavigationController {
        let viewController = UIViewController()
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        return navController
    }
    
}
