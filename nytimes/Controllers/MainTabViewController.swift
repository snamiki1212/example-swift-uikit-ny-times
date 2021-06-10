//
//  MainTabViewController.swift
//  nytimes
//
//  Created by shunnamiki on 2021/06/10.
//

import UIKit

class MainTabViewController: UITabBarController {
    
    let homeVC: UINavigationController = {
        let vc: HomeCollectionViewController = {
            let layout = UICollectionViewLayout()
            let vc = HomeCollectionViewController(collectionViewLayout: layout)
            let image = UIImage(systemName: "folder")
            vc.tabBarItem =  UITabBarItem(title: "Home", image: image, tag: 1)
            return vc
        }()
        let nav = UINavigationController(rootViewController: vc)
        return nav
    }()

    let searchVC: UINavigationController = {
        let vc: SearchCollectionViewController = {
            let layout = UICollectionViewLayout()
            let vc = SearchCollectionViewController(collectionViewLayout: layout)
            let image = UIImage(systemName: "magnifyingglass")
            vc.tabBarItem =  UITabBarItem(title: "Search", image: image, tag: 2)
            return vc
        }()
        let nav = UINavigationController(rootViewController: vc)
        return nav
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [
            homeVC,
            searchVC,
        ]
    }
}
