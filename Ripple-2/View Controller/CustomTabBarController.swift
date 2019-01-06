//
//  CustomTabBarController.swift
//  Ripple-2
//
//  Created by Tim Ng on 1/6/19.
//  Copyright © 2019 timothyng. All rights reserved.
//

import UIKit
import CoreData

class CustomTabBarController: UITabBarController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = UIColor.primaryOrange
        
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(title: "Give", image: UIImage(named: "heart-selected"), selectedImage: UIImage(named: "heart-selected"))
        
        let quoteVC = QuoteViewController()
        quoteVC.tabBarItem = UITabBarItem(title: "Quotes", image: UIImage(named: "quote"), selectedImage: UIImage(named: "quote"))
        
        let activityVC = ActivityViewController()
        activityVC.tabBarItem = UITabBarItem(title: "Activity", image: UIImage(named: "activity-happy"), selectedImage: UIImage(named: "activity-happy"))
        
        let tabBarList = [homeVC, quoteVC, activityVC]
        viewControllers = tabBarList
        
    }
}
