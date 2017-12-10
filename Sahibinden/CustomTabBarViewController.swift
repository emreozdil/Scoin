//
//  CustomTabBarViewController.swift
//  Sahibinden
//
//  Created by Emre Özdil on 10/12/2017.
//  Copyright © 2017 Emre Özdil. All rights reserved.
//

import UIKit

class CustomTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup our custom view controllers
        let currentCurrencyViewController = CurrentCurrencyViewController()
        let currentCurrencyNavController = UINavigationController(rootViewController: currentCurrencyViewController)
        currentCurrencyNavController.tabBarItem = UITabBarItem(title: "Scoin", image: #imageLiteral(resourceName: "money") , tag: 1)
        
        
        viewControllers = [currentCurrencyNavController, createDummyNavControllerWithTitle("History", imageName: "money"), createDummyNavControllerWithTitle("Sub Coins", imageName: "money")]
        
    }
    
    private func createDummyNavControllerWithTitle(_ title: String, imageName: String) -> UINavigationController {
        let viewController = UIViewController()
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        return navController
    }
    
}
